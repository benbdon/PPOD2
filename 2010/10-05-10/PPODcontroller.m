function handles = PPODcontroller(handles)

plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
actuatorAccSignals = handles.globalinfo.actuatorAccSignals;

if get(handles.run,'value')
    mode = 'run';
end
if get(handles.addFreqResponseData,'value')
    mode = 'addFreqResponseData';
end
if get(handles.addFlexureFreqResponseData,'value')
    mode = 'addFlexureFreqResponseData';
end

switch mode
    case 'run'
        maxUpdate = eval(get(handles.maxUpdate,'string'));
    case 'addFreqResponseData'
        maxUpdate = 1;
    case 'addFlexureFreqResponseData'
        maxUpdate = eval(get(handles.maxUpdatePerFreq,'string'));
end

NTC = eval(get(handles.numTransientCycles,'string'));
NCC = eval(get(handles.numCollectedCycles,'string'));
NPC = eval(get(handles.numProcessingCycles,'string'));
N = NTC + NCC + NPC;

samplesPerCycle = handles.signalinfo.samplesPerCycle;
T = handles.signalinfo.T;
samplingFreq = handles.signalinfo.samplingFreq;
f1 = sym(1/T);
fps = handles.camerainfo.fps;

secondsPerUpdate = N*T;

%get matrix converting L to W to frame
A = handles.calibrationinfo.A;

%volts per m/s^2 calibration
V_per_ms2 = handles.calibrationinfo.V_per_ms2;

%specify how many samples to collect upon trigger
handles.daqinfo.ai.SamplesPerTrigger = NCC*samplesPerCycle;

controlledHarmonics = handles.controllerinfo.controlledHarmonics;
F_all = handles.controllerinfo.F_all;
G_u2acc_all = handles.controllerinfo.G_u2acc_all;

%create G_u2acc (should be done outside this function)
harmonicsPerFreq = str2double(get(handles.harmonicsPerFreq,'string'));
G_u2acc = zeros(6,6,max(controlledHarmonics),max(controlledHarmonics));
if ~get(handles.addFreqResponseData,'value')
    for in = controlledHarmonics
        f = f1*in;
        indIn = find(f == F_all);
        if ~isempty(indIn)
            indOut = 1;
            for out = in:in:harmonicsPerFreq*in
                if ismember(out,controlledHarmonics)
                    G_u2acc(:,:,in,out) = G_u2acc_all(:,:,indIn,indOut);
                    indOut = indOut + 1;
                end
            end
        else
            warndlg(['Harmonic data for n = ',num2str(in),' (f = ',num2str(f),' does not exist.'])
            return
        end
    end
end

controllerUpdatesPerPlot = 1;

%get adesCyc and uCyc signals
adesCyc = handles.signalinfo.adesCyc;
uCyc = handles.signalinfo.uCyc;

%fft NCC cycles of desired plate motion signals
adesNCC_fft = fft(repmat(adesCyc,[NCC,1]));

%fft NCC cycles of uCyc
uNCC_fft = fft(repmat(uCyc,[NCC,1]));

%make sure u_fft is zero for frequencies above maxharmonic*basefreq
controlledHarmonics = handles.controllerinfo.controlledHarmonics;
NCH = numel(controlledHarmonics);
fftInds = zeros(1,2*NCH);
for i = 1:NCH
    harmonic = controlledHarmonics(i);
    fftInds(i) = NCC*harmonic+1;
    fftInds(end-i+1) = NCC*(samplesPerCycle-harmonic)+1;
end
uNCC_fft(~ismember(1:NCC*samplesPerCycle,fftInds),:) = 0;

%determine if initial control signals must change
tag = get(get(handles.initialcontrol,'selectedobject'),'tag');
switch tag
    case 'guess'
        for n = controlledHarmonics
            fftInd1 = NCC*n+1;
            fftInd2 = NCC*(samplesPerCycle-n)+1;
            %NEED TO UPDAT THIS CODE***************************************
            %****************************************************
            uNCC_fft(fftInd1,:) = (squeeze(G_u2acc(:,:,1,n))\adesNCC_fft(fftInd1,:).').';
            uNCC_fft(fftInd2,:) = conj(uNCC_fft(fftInd1,:));
            %*****************************************************
            %***************************************************
            
            %reset uCyc (1 cycle)
            uNCC = ifft(uNCC_fft);
            uCyc = uNCC(1:samplesPerCycle,:);
        end

    case 'zero'
        uCyc = 0*uCyc;
        uNCC_fft = 0*uNCC_fft;
    case 'previous'
    case 'userSpecified'        
end


%create N cycles of uCyc.
uN = repmat(uCyc ,[N,1]);

%create clock ao signal with trigger just before cycle NTC
clock = 0*uN(:,1);
clock(NTC*samplesPerCycle) = 5;


%INITIALIZES TRIGGER SIGNAL FOR CAMERA**********************************
%***********************************************************************
%create trigger signal for camera (goes low for 1ms at the beginning of
%each cycle)
camTrigN = 5 + zeros(samplesPerCycle*N,1);
samplesPerCamTrig = samplingFreq/fps;
samplesPerMillisec = round(1/T*samplesPerCycle*1e-3);

camTrigInd1 = samplesPerCamTrig;
camTrigInd2 = samplesPerCamTrig + samplesPerMillisec;
camTrigFlag = 0;
camTrigInd1_nomod = camTrigInd1;
while camTrigInd1_nomod <= samplesPerCycle*N
    if camTrigFlag
        camTrigN(1:camTrigIndLeftover) = 0;
    end
    if camTrigInd2 > samplesPerCycle*N
        camTrigFlag = 1;
        camTrigIndLeftover = mod(camTrigInd2,samplesPerCycle);
        camTrigN(camTrigInd1:end) = 0;
    else
        camTrigN(camTrigInd1:camTrigInd2) = 0;
        camTrigFlag = 0;
    end
    camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
    camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,samplesPerCycle*N)+1;
    camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,samplesPerCycle*N)+1;
end

%**************************************************************************
%**************************************************************************

%put u_ao_init and clock_init into the queue
putdata(handles.daqinfo.ao, [clock, uN, camTrigN])

%start analog intput device (set to log during trigger event and then stops
%once data has been logged)
start(handles.daqinfo.ai)

%start analog output device (sends out data immediately)
start(handles.daqinfo.ao)

currentUpdate = 0;
set(handles.currentUpdate,'string',num2str(currentUpdate))

while currentUpdate < maxUpdate
    if ~get(handles.run,'value') && strcmp(mode,'run')
        break
    end
    
    %make sure there are still samples left in queue for ao to output. if
    %there are no more samples then the ao device will be "off" and must be restarted.
%     while get(handles.daqinfo.ao,'samplesavailable') < samplesPerCycle*(NCC+NPC)
%         5555555555555555555555555
%         putdata(handles.daqinfo.ao, [clock, uN, camTrigN])
%         if strcmp(get(handles.daqinfo.ao,'Running'), 'Off')
%             button = questdlg('Analog output card ran out of samples in queue.  Number of processing cycles should be increased.  Do you wish to continue operating?');
%             switch button
%                 case 'No'
%                     stop(handles.daqinfo.ai)
%                     set(handles.run,'value',0,'string','Run')
%                     return
%                 otherwise
%                     start(handles.daqinfo.ao)
%             end
%         end
%     end
    
    %wait for data to be collected from analog input (the device stops once
    %the data is logged)
    pause(.0001)
    while get(handles.daqinfo.ai,'SamplesAcquired') < samplesPerCycle*NCC
        if strcmp(get(handles.daqinfo.ai,'running'),'On') && get(handles.daqinfo.ao,'samplesavailable') < samplesPerCycle*N
            putdata(handles.daqinfo.ao, [clock, uN, camTrigN])
            if strcmp(get(handles.daqinfo.ao,'Running'), 'Off')
                button = questdlg('Analog output card ran out of samples in queue.  Number of processing cycles should be increased.  Do you wish to continue operating?');
            switch button
                case 'No'
                    stop(handles.daqinfo.ai)
                    set(handles.run,'value',0,'string','Run')
                    set(handles.samplingFreq,'enable','on')
                    set(handles.numCollectedCycles,'enable','on')
                    set(handles.T,'enable','on')
                    set(handles.actuatorAccelerations,'enable','on')
                    set(handles.actuatorVoltages,'enable','on')
                    return
                otherwise
                    start(handles.daqinfo.ao)
            end
            end
        end
    end
    %wait(handles.daqinfo.ai,2*secondsPerUpdate) %HARD CODED WAIT TIME--MODIFY???
%     catch ME
%         disp(ME)
%         putdata(handles.daqinfo.ao, [clock, uN, camTrigN])
%         start(handles.daqinfo.ao)
%         wait(handles.daqinfo.ai,2*secondsPerUpdate)
%     end
    
    
    %import NCC cycles of accelerometer signals.  columns of aidata
    %correspond to ai_channel_names (i.e., sp1, sp2, sp3, sp4, pl1x, pl1y,
    %pl2x, pl2y)
    aidata_raw = getdata(handles.daqinfo.ai);
    meanaidata_raw = mean(aidata_raw);
    aidata = 1/V_per_ms2*(aidata_raw - repmat(meanaidata_raw,[size(aidata_raw,1),1]));
    
    %put aidata into signal matrices
    NPALS = numel(plateAccLocalSignals);
    NAAS = numel(actuatorAccSignals);
    aLocalNCC = aidata(:,1:NPALS);
    dddNCC = aidata(:,NPALS+1:NPALS+NAAS);
    
    %convert raw acceleration signals in local frames into plate
    %acceleration in W frame
    aNCC =(A\aLocalNCC')';
    
    %fft y_ai
    aNCC_fft = fft(aNCC);
    
    %update desired signals
    desSignals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
    switch desSignals
        case 'plateAccelerations'
            for i = 1:length(handles.signalinfo.adesChar)
                adesChariOld = handles.signalinfo.adesChar{i};
                adesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(adesChariOld, adesChariNew)
                    [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);
                    adesNCC_fft = fft(repmat(handles.signalinfo.adesCyc,[NCC,1]));
                end
            end
            
        case 'actuatorAccelerations'
            
        case 'actuatorVoltages'
            for i = 1:length(handles.signalinfo.udesChar)
                udesChariOld = handles.signalinfo.udesChar{i};
                udesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(udesChariOld, udesChariNew) && ~get(handles.addFreqResponseData,'value')
                    [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);
                    uNCC_fft = fft(repmat(handles.signalinfo.uCyc,[NCC,1]));
                end
            end
    end
    
    %compute error
    eNCC_fft = adesNCC_fft - aNCC_fft;
    
    %controller
    desSignals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
    if strcmp(desSignals,'plateAccelerations')
        k = str2double(get(handles.k,'string'));
        
        %update ffts of control signals.
        deltauNCC_fft = zeros(size(uNCC_fft));
        for in = controlledHarmonics
            fftInd1 = NCC*in+1;
            if in == min(controlledHarmonics)
                deltauNCC_fft(fftInd1,:) = G_u2acc(:,:,in,in)\(eNCC_fft(fftInd1,:).');
            else
                eNCC_fft_nonlinear = zeros(6,1);
                for out = 1:in-1
                    fftInd = NCC*out+1;
                    eNCC_fft_nonlinear = eNCC_fft_nonlinear + G_u2acc(:,:,out,in)*deltauNCC_fft(fftInd,:).';
                    %disp(['in = ',num2str(out),'; out = ',num2str(in),'; Gu2acc(in,out) = ',mat2str(G_u2acc(:,:,out,in))])
                end
                deltauNCC_fft(fftInd1,:) = G_u2acc(:,:,in,in)\(eNCC_fft(fftInd1,:).' - eNCC_fft_nonlinear);
            end
            
            fftInd2 = length(eNCC_fft)-NCC*in+1;
            deltauNCC_fft(fftInd2,:) = conj(deltauNCC_fft(fftInd1,:));
        end
        uNCC_fft = uNCC_fft + k*deltauNCC_fft;
    end
    
    %get uCyc (1 cycle) and u_ao (N cycles)
    uNCC = ifft(uNCC_fft);
    uCyc = uNCC(1:samplesPerCycle,:);
    
    %check to make sure that uCyc does not exceed saturation voltage.  on
    %indices where it does, replace those voltages with +/-saturation
    %voltage
    signuCyc = sign(uCyc);
    handles.controllerinfo.uMax = str2double(get(handles.uMax,'string'));
    uMax = handles.controllerinfo.uMax*ones(size(uCyc));
    ind = find(abs(uCyc) > uMax);
    uCyc(ind) = signuCyc(ind).*uMax(ind);
    
    %make N cycles of uCyc to send to analog out.
    NTC = eval(get(handles.numTransientCycles,'string'));
    NPC = eval(get(handles.numProcessingCycles,'string'));
    N = NTC + NCC + NPC;
    uN = repmat(uCyc,[N,1]);
    
    %update clock
    clock = 0*uN(:,1);
    clock(NTC*samplesPerCycle) = 5;
    
    %update camera trigger signal
    camTrigN = 5 + zeros(samplesPerCycle*N,1);
    camTrigInd1_nomod = camTrigInd1;
    while camTrigInd1_nomod <= samplesPerCycle*N
        if camTrigFlag
            camTrigN(1:camTrigIndLeftover) = 0;
        end
        if camTrigInd1 > camTrigInd2
            camTrigFlag = 1;
            camTrigIndLeftover = mod(camTrigInd2,samplesPerCycle);
            camTrigN(camTrigInd1:end) = 0;
        else
            camTrigN(camTrigInd1:camTrigInd2) = 0;
            camTrigFlag = 0;
        end
        camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
        camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,samplesPerCycle*N)+1;
        camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,samplesPerCycle*N)+1;
    end
    %**********************************************************************
    %**********************************************************************
    %put new u_ao into queue
    putdata(handles.daqinfo.ao, [clock, uN, camTrigN])
    
    %restart analog input device
    start(handles.daqinfo.ai)
    
    %put signals back into handles
    handles.signalinfo.aCyc = aNCC(1:samplesPerCycle,:);
    handles.signalinfo.aLocalCyc = aLocalNCC(1:samplesPerCycle,:);
    handles.signalinfo.uCyc = uCyc;
    handles.signalinfo.dddCyc = dddNCC(1:samplesPerCycle,:);
    
    %plot data in GUI
    if mod(currentUpdate,controllerUpdatesPerPlot) == 0 && get(handles.updatePlots,'value')
        PlotControlSignals(handles)
        PlotAccSignals(handles)
    end
    currentUpdate = currentUpdate + 1;
    handles.globalinfo.currentUpdate = currentUpdate;
    set(handles.currentUpdate,'string',num2str(currentUpdate))
    
end

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)

set(handles.run,'value',0,'string','Run')


