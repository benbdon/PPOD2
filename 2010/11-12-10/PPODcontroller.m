function handles = PPODcontroller(handles)

pmiddSignals = handles.globalinfo.pmiddSignals;
PddSignals = handles.globalinfo.PddSignals;
amiddSignals = handles.globalinfo.amiddSignals;
diddSignals = handles.globalinfo.diddSignals;
uSignals = handles.globalinfo.uSignals;
rawForceSignals = handles.globalinfo.rawForceSignals;

[NCS NPMIS NPS NAMIS NDIS NRFS NFS] = signalCounter(handles);

switch handles.globalinfo.mode
    case {'Pddcontrol','diddControl','uiControl'}
        maxUpdate = eval(get(handles.maxUpdate,'string'));
    case 'uiFreqResponse'
        maxUpdate = 1;
    case 'diddFreqResponse'
        maxUpdate = eval(get(handles.maxUpdatePerFreq,'string'));
        FsensorCrosstalk = handles.calibrationinfo.FsensorCrosstalk;
        lbf2N = handles.calibrationinfo.lbf2N;
        lbfin2Nm = handles.calibrationinfo.lbfin2Nm;
        err = NaN;
end

NTC = eval(get(handles.numTransientCycles,'string'));
NCC = eval(get(handles.numCollectedCycles,'string'));
NPC = eval(get(handles.numProcessingCycles,'string'));
N = NTC + NCC + NPC;

SPC = handles.signalinfo.samplesPerCycle;
T = handles.signalinfo.T;
samplingFreq = handles.signalinfo.samplingFreq;
f1 = sym(1/T);
fps = handles.camerainfo.fps;

%get matrix converting L to W to frame
T_W2pmi = handles.calibrationinfo.T_W2pmi;
T_di2ami = handles.calibrationinfo.T_di2ami;

%volts per m/s^2 calibration
V_per_ms2 = handles.calibrationinfo.V_per_ms2;

%specify how many samples to collect upon trigger
handles.daqinfo.ai.SamplesPerTrigger = NCC*SPC;

controlledHarmonics = handles.controllerinfo.controlledHarmonics;
F_ui_all = handles.controllerinfo.F_ui_all;
G_ui2Pdd_all = handles.controllerinfo.G_ui2Pdd_all;
G_ui2didd_all = handles.controllerinfo.G_ui2didd_all;

%create G_ui2Pdd (should be done outside this function)
harmonicsPerFreq = str2double(get(handles.harmonicsPerFreq,'string'));
G_ui2Pdd = zeros(NPAS,NCS,max(controlledHarmonics),max(controlledHarmonics));
G_ui2didd = zeros(NAAS,NCS,max(controlledHarmonics),max(controlledHarmonics));
if ~get(handles.addFreqResponseData,'value')
    for in = controlledHarmonics
        f = f1*in;
        indIn = find(f == F_all);
        if ~isempty(indIn)
            indOut = 1;
            for out = in:in:harmonicsPerFreq*in
                if ismember(out,controlledHarmonics)
                    G_ui2didd(:,:,in,out) = G_ui2didd_all(:,:,indIn,indOut);
                    G_ui2Pdd(:,:,in,out) = G_ui2Pdd_all(:,:,indIn,indOut);
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

%get PddDesCyc and uiCyc signals
PddDesCyc = handles.signalinfo.PddDesCyc;
uiCyc = handles.signalinfo.uiCyc;

%fft NCC cycles of desired plate motion signals
PddDesNCC_fft = fft(repmat(PddDesCyc,[NCC,1]));

%fft NCC cycles of uiCyc
uiNCC_fft = fft(repmat(uiCyc,[NCC,1]));

%make sure u_fft is zero for frequencies above maxharmonic*basefreq
controlledHarmonics = handles.controllerinfo.controlledHarmonics;
NCH = numel(controlledHarmonics);
fftInds = zeros(1,2*NCH);
for i = 1:NCH
    harmonic = controlledHarmonics(i);
    fftInds(i) = NCC*harmonic+1;
    fftInds(end-i+1) = NCC*(SPC-harmonic)+1;
end
uiNCC_fft(~ismember(1:NCC*SPC,fftInds),:) = 0;

%determine if initial control signals must change
tag = get(get(handles.initialcontrol,'selectedobject'),'tag');
switch tag
    case 'guess'
        for n = controlledHarmonics
            fftInd1 = NCC*n+1;
            fftInd2 = NCC*(SPC-n)+1;
            %NEED TO UPDAT THIS CODE***************************************
            %****************************************************
            uiNCC_fft(fftInd1,:) = (squeeze(G_ui2Pdd(:,:,1,n))\PddDesNCC_fft(fftInd1,:).').';
            uiNCC_fft(fftInd2,:) = conj(uiNCC_fft(fftInd1,:));
            %*****************************************************
            %***************************************************
            
            %reset uiCyc (1 cycle)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
        end
        
    case 'zero'
        uiCyc = 0*uiCyc;
        uiNCC_fft = 0*uiNCC_fft;
    case 'previous'
    case 'userSpecified'
end

%create N cycles of uiCyc.
uiN = repmat(uiCyc ,[N,1]);

%create clock ao signal with trigger just before cycle NTC
clock = 0*uiN(:,1);
clock(NTC*SPC) = 5;

%INITIALIZES TRIGGER SIGNAL FOR CAMERA**********************************
%***********************************************************************
%create trigger signal for camera (goes low for 1ms at the beginning of
%each cycle)
camTrigN = 5 + zeros(SPC*N,1);
samplesPerCamTrig = samplingFreq/fps;
samplesPerMillisec = round(1/T*SPC*1e-3);

camTrigInd1 = samplesPerCamTrig;
camTrigInd2 = samplesPerCamTrig + samplesPerMillisec;
camTrigFlag = 0;
camTrigInd1_nomod = camTrigInd1;
while camTrigInd1_nomod <= SPC*N
    if camTrigFlag
        camTrigN(1:camTrigIndLeftover) = 0;
    end
    if camTrigInd2 > SPC*N
        camTrigFlag = 1;
        camTrigIndLeftover = mod(camTrigInd2,SPC);
        camTrigN(camTrigInd1:end) = 0;
    else
        camTrigN(camTrigInd1:camTrigInd2) = 0;
        camTrigFlag = 0;
    end
    camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
    camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,SPC*N)+1;
    camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,SPC*N)+1;
end

%**************************************************************************
%**************************************************************************

%put u_ao_init and clock_init into the queue
putdata(handles.daqinfo.ao, [clock, uiN, camTrigN])

%start analog intput device (set to log during trigger event and then stops
%once data has been logged)
start(handles.daqinfo.ai)

%start analog output device (sends out data immediately)
start(handles.daqinfo.ao)

currentUpdate = 0;
set(handles.currentUpdate,'string',num2str(currentUpdate))

while currentUpdate < maxUpdate
    switch runmode
        case {'controlPlateAccelerations','controlActuatorAccelerations','controlActuatorVoltages'}
            if ~get(handles.run,'value');
                break
            end
        case 'addFreqResponseData'
            if ~get(handles.addFreqResponseData,'value');
                break
            end
        case 'addFreqResponseDataForce'
            if ~get(handles.addFlexureFreqResponseData,'value');
                break
            end
            errorTol = eval(get(handles.errorTol,'string'));
            if err < errorTol
                break
            end
    end
    
    %wait for data to be collected from analog input (the device stops once
    %the data is logged)
    pause(.0001)
    while get(handles.daqinfo.ai,'SamplesAcquired') < SPC*NCC
        if strcmp(get(handles.daqinfo.ai,'running'),'On') && get(handles.daqinfo.ao,'samplesavailable') < SPC*N
            putdata(handles.daqinfo.ao, [clock, uiN, camTrigN])
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
    
    %import NCC cycles of accelerometer signals.  columns of aidata
    %correspond to ai_channel_names (i.e., sp1, sp2, sp3, sp4, pl1x, pl1y,
    %pl2x, pl2y)
    aidata_raw = getdata(handles.daqinfo.ai);
    meanaidata_raw = mean(aidata_raw);
    aidata = aidata_raw - repmat(meanaidata_raw,[size(aidata_raw,1),1]);
    
    %put aidata into signal matrices
    switch runmode
        case {'controlPlateAccelerations','controlActuatorAccelerations','controlActuatorVoltages'}
            
            %%%%%%%HERE%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %**************************************
            
            %read in local plate acclerations (accelerometers mounted to
            %plate)
            pmiddNCC = 1/V_per_ms2*aidata(:,1:NPALS);
            %convert local plate accelerations into plate acceleration
            %(i.e., accleration of P frame with respect to W frame)
            PddNCC = (T_P2pmi\pmiddNCC')';
            %FFT plate acceleration
            PddNCC_fft = fft(PddNCC);
            
            %read in local actuator accelerations (accelerometers mounted
            %to actuators)
            amiNCC = 1/V_per_ms2*aidata(:,NPALS+1:NPALS+NAALS);
            %convert to Ai frame
            aiNCC = (T_ai2ami\amiNCC')';
            dddNCC = aiNCC(:,3:3:end);%accelerations along shaft (z-axis of each Ai frame)
            
            %convert raw acceleration signals in local frames into plate
            %acceleration in W frame
            aNCC =(T_P2pmi\aLocalNCC')';
            
            %fft accelerations
            aNCC_fft = fft(aNCC);
        case 'addFreqResponseData'
            %read in local plate (i.e., fixed end) acceleration signals
            pmiNCC = 1/V_per_ms2*aidata(:,1:NPALS);
            %convert to Ai frame
            piNCC = (T_pi2pmi\pmiNCC')';
            pNCC = piNCC;
            
            %read in local actuator acceleration signals
            amiNCC = 1/V_per_ms2*aidata(:,NPALS+1:NPALS+NAALS);
            %convert to Ai frame
            aiNCC = (T_ai2ami\amiNCC')';
            dddNCC = aiNCC(:,3:3:end);%accelerations along shaft (z-axis of each Ai frame)
            
        case 'addFreqResponseDataForce'
            %read in local plate (i.e., fixed end) acceleration signals
            pmiNCC = 1/V_per_ms2*aidata(:,1:NPALS);
            %convert to Ai frame
            piNCC = (T_pi2pmi\pmiNCC')';
            pNCC = piNCC;
            
            %read in local actuator acceleration signals
            amiNCC = 1/V_per_ms2*aidata(:,NPALS+1:NPALS+NAALS);
            %convert to Ai frame
            aiNCC = (T_ai2ami\amiNCC')';
            dddNCC = aiNCC(:,3:3:end);%accelerations along shaft (z-axis of each Ai frame)
            
            %read in all 12 raw force signals
            f12RawNCC = aidata(:,NPALS+NAALS+1:NPALS+NAALS+NFS);
            %recover 6 force signals
            fNCC = (f12RawNCC(:,1:6) - f12RawNCC(:,7:12))*FsensorCrosstalk;
            fNCC(:,1:3) = lbf2N*fNCC(:,1:3);
            fNCC(:,4:6) = lbfin2Nm*fNCC(:,4:6);
            
            %fft signals
            dddNCC_fft = fft(dddNCC);
    end
    
    %update desired signals
    desSignals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
    switch desSignals
        case 'plateAccelerations'
            for i = 1:length(handles.signalinfo.PddDesChar)
                PddDesChariOld = handles.signalinfo.PddDesChar{i};
                PddDesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(PddDesChariOld, PddDesChariNew)
                    [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);
                    PddDesNCC_fft = fft(repmat(handles.signalinfo.PddDesCyc,[NCC,1]));
                end
            end
            
            %compute error
            eNCC_fft = PddDesNCC_fft - aNCC_fft;
            
            %controller
            k = str2double(get(handles.k,'string'));
            
            %update ffts of control signals.
            deltauiNCC_fft = zeros(size(uiNCC_fft));
            for in = controlledHarmonics
                fftInd1 = NCC*in+1;
                if in == min(controlledHarmonics)
                    deltauiNCC_fft(fftInd1,:) = G_ui2Pdd(:,:,in,in)\(eNCC_fft(fftInd1,:).');
                else
                    eNCC_fft_nonlinear = zeros(NCS,1);
                    for out = 1:in-1
                        fftInd = NCC*out+1;
                        eNCC_fft_nonlinear = eNCC_fft_nonlinear + G_ui2Pdd(:,:,out,in)*deltauiNCC_fft(fftInd,:).';
                        %disp(['in = ',num2str(out),'; out = ',num2str(in),'; Gui2Pdd(in,out) = ',mat2str(G_ui2Pdd(:,:,out,in))])
                    end
                    deltauiNCC_fft(fftInd1,:) = G_ui2Pdd(:,:,in,in)\(eNCC_fft(fftInd1,:).' - eNCC_fft_nonlinear);
                end
                
                fftInd2 = length(eNCC_fft)-NCC*in+1;
                deltauiNCC_fft(fftInd2,:) = conj(deltauiNCC_fft(fftInd1,:));
            end
            uiNCC_fft = uiNCC_fft + k*deltauiNCC_fft;
            
        case 'actuatorAccelerations'
            for i = 1:size(handles.signalinfo.ddddesCyc,2)
                ddddesChariOld = handles.signalinfo.ddddesChar{i};
                ddddesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(ddddesChariOld, ddddesChariNew)
                    [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);
                    ddddesNCC_fft = fft(repmat(handles.signalinfo.ddddesCyc(:,NAAS),[NCC,1]));
                end
            end
            
            %compute error
            eNCC_fft = ddddesNCC_fft - dddNCC_fft;
            
            %controller
            k = str2double(get(handles.k,'string'));
            
            %update ffts of control signals.
            deltauiNCC_fft = zeros(size(uiNCC_fft));
            for in = controlledHarmonics
                fftInd1 = NCC*in+1;
                if in == min(controlledHarmonics)
                    deltauiNCC_fft(fftInd1,:) = G_ui2didd(:,:,in,in)\(eNCC_fft(fftInd1,:).');
                else
                    eNCC_fft_nonlinear = zeros(NCS,1);
                    for out = 1:in-1
                        fftInd = NCC*out+1;
                        eNCC_fft_nonlinear = eNCC_fft_nonlinear + G_ui2didd(:,:,out,in)*deltauiNCC_fft(fftInd,:).';
                    end
                    deltauiNCC_fft(fftInd1,:) = G_ui2didd(:,:,in,in)\(eNCC_fft(fftInd1,:).' - eNCC_fft_nonlinear);
                end
                
                fftInd2 = length(eNCC_fft)-NCC*in+1;
                deltauiNCC_fft(fftInd2,:) = conj(deltauiNCC_fft(fftInd1,:));
            end
            uiNCC_fft = uiNCC_fft + k*deltauiNCC_fft;
            
        case 'actuatorVoltages'
            for i = 1:length(handles.signalinfo.udesChar)
                udesChariOld = handles.signalinfo.udesChar{i};
                udesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(udesChariOld, udesChariNew) && ~get(handles.addFreqResponseData,'value')
                    [handles.signalinfo.udesChar, handles.signalinfo.uiCyc] = desCycUpdater(handles);
                    uiNCC_fft = fft(repmat(handles.signalinfo.uiCyc,[NCC,1]));
                end
            end
    end
    
    %get uiCyc (1 cycle) and u_ao (N cycles)
    uiNCC = ifft(uiNCC_fft);
    uiCyc = uiNCC(1:SPC,:);
    
    %check to make sure that uiCyc does not exceed saturation voltage.  on
    %indices where it does, replace those voltages with +/-saturation
    %voltage
    signuiCyc = sign(uiCyc);
    handles.controllerinfo.uMax = str2double(get(handles.uMax,'string'));
    uMax = handles.controllerinfo.uMax*ones(size(uiCyc));
    ind = find(abs(uiCyc) > uMax);
    uiCyc(ind) = signuiCyc(ind).*uMax(ind);
    
    %make N cycles of uiCyc to send to analog out.
    NTC = eval(get(handles.numTransientCycles,'string'));
    NPC = eval(get(handles.numProcessingCycles,'string'));
    N = NTC + NCC + NPC;
    uiN = repmat(uiCyc,[N,1]);
    
    %update clock
    clock = 0*uiN(:,1);
    clock(NTC*SPC) = 5;
    
    %update camera trigger signal
    camTrigN = 5 + zeros(SPC*N,1);
    camTrigInd1_nomod = camTrigInd1;
    while camTrigInd1_nomod <= SPC*N
        if camTrigFlag
            camTrigN(1:camTrigIndLeftover) = 0;
        end
        if camTrigInd1 > camTrigInd2
            camTrigFlag = 1;
            camTrigIndLeftover = mod(camTrigInd2,SPC);
            camTrigN(camTrigInd1:end) = 0;
        else
            camTrigN(camTrigInd1:camTrigInd2) = 0;
            camTrigFlag = 0;
        end
        camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
        camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,SPC*N)+1;
        camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,SPC*N)+1;
    end
    %**********************************************************************
    %**********************************************************************
    %put new u_ao into queue
    putdata(handles.daqinfo.ao, [clock, uiN, camTrigN])
    
    %restart analog input device
    start(handles.daqinfo.ai)
    
    switch runmode
        case 'standard'
            %put signals back into handles
            handles.signalinfo.aCyc = aNCC(1:SPC,:);
            handles.signalinfo.aLocalCyc = aLocalNCC(1:SPC,:);
            handles.signalinfo.uiCyc = uiCyc;
            handles.signalinfo.dddCyc = dddNCC(1:SPC,:);
            
            %error
            eCycSquared = (handles.signalinfo.aCyc - handles.signalinfo.PddDesCyc).^2;
            if ~get(handles.actuatorVoltages,'value')
                err = .5e5*sum(sum(eCycSquared)./(T*samplingFreq*[1 1 1 10 10 10]).^2);
            else
                err = 0; %error has no meaning in this case
            end
        case 'addFreqResponseData'
            handles.signalinfo.aCyc = aNCC(1:SPC,:);
            handles.signalinfo.aLocalCyc = aLocalNCC(1:SPC,:);
            handles.signalinfo.uiCyc = uiCyc;
            handles.signalinfo.dddCyc = dddNCC(1:SPC,:);
            
            %error (error is not relevant in this run mode)
            err = 0;
        case 'addFreqResponseDataForce'
            handles.signalinfo.aCyc = pNCC(1:SPC,:);
            handles.signalinfo.aLocalCyc = pmiNCC(1:SPC,:);
            handles.signalinfo.uiCyc = uiCyc;
            handles.signalinfo.dddCyc = dddNCC(1:SPC,:);
            
            %error (error is not relevant in this run mode)
            err = 0;
        case 'addFlexureFreqResponseData'
            %put signals back into handles
            handles.signalinfo.dddCyc = dddNCC(1:SPC,:);
            handles.signalinfo.uiCyc = uiCyc;
            handles.signalinfo.fCyc = fNCC(1:SPC,:);
            
            %error
            eCycSquared = (handles.signalinfo.dddCyc - handles.signalinfo.ddddesCyc).^2;
            err = .5e5*sum(sum(eCycSquared)./(T*samplingFreq).^2);
    end
    
    %plot data in GUI
    if mod(currentUpdate,controllerUpdatesPerPlot) == 0 && get(handles.updatePlots,'value')
        PlotControlSignals(handles)
        PlotAccSignals(handles)
        if strcmp(runmode,'addFlexureFreqResponseData')
            PlotForceSignals(handles)
        end
    end
    currentUpdate = currentUpdate + 1;
    set(handles.currentUpdate,'string',num2str(currentUpdate))
    set(handles.currentError,'string',num2str(err,4))
    
end

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)

set(handles.run,'value',0,'string','Run')


