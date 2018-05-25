function handles = PPODcontroller(handles)

[NUIS NPMIDDS NPDDS NAMIDDS NDIDDS] = signalCounter(handles);

NTC = eval(get(handles.numTransientCycles,'string'));
NCC = eval(get(handles.numCollectedCycles,'string'));
NPC = eval(get(handles.numProcessingCycles,'string'));
N = NTC + NCC + NPC;

if strcmp(handles.globalinfo.aiConfig,'force')
    FsensorCrosstalk = handles.calibrationinfo.FsensorCrosstalk;
    lbf2N = handles.calibrationinfo.lbf2N;
    lbfin2Nm = handles.calibrationinfo.lbfin2Nm;
end

SPC = handles.signalinfo.samplesPerCycle;
T = handles.signalinfo.T;
samplingFreq = handles.signalinfo.samplingFreq;
f1 = 1/T;
fps = handles.camerainfo.fps;

%get matrix converting L to W to frame
T_W2pmi = handles.calibrationinfo.T_W2pmi;
T_di2ami = handles.calibrationinfo.T_di2ami;

%volts per m/s^2 calibration
V_per_ms2 = handles.calibrationinfo.V_per_ms2;

%specify how many samples to collect upon trigger
handles.daqinfo.ai.SamplesPerTrigger = NCC*SPC;

F_ui = handles.controllerinfo.F_ui;
F_ui_all = handles.controllerinfo.F_ui_all;
G_ui2Pdd_all = handles.controllerinfo.G_ui2Pdd_all;
G_ui2didd_all = handles.controllerinfo.G_ui2didd_all;

switch handles.globalinfo.mode
    case {'PddControl','diddControl','diddAddFreqs'}
        uiHarmonics = handles.controllerinfo.uiHarmonics;
    case {'uiControl','uiAddFreqs'}
        uiHarmonics = 1;
    otherwise
        error('no matching case')
end

%create G_ui2Pdd and G_ui2didd from requested frequencies in G_ui2Pdd_all
%and G_ui2didd_all
uiHarmonicMax = max(uiHarmonics);
G_ui2Pdd = zeros(NPDDS,NUIS,uiHarmonicMax,uiHarmonicMax);
G_ui2didd = zeros(NDIDDS,NUIS,uiHarmonicMax,uiHarmonicMax);

switch handles.globalinfo.mode
    case {'PddControl','diddControl','diddAddFreqs'}
        inFreqs = F_ui;
        for inFreq = inFreqs
            inFreqInd = inFreq/f1;
            inFreqInd_all = find(inFreq == F_ui_all);
            if ~isempty(inFreqInd_all)
                if get(handles.useNonlinearHarmonicTerms,'value')
                    outFreqs = inFreq:inFreq:max(inFreqs);
                else
                    outFreqs = inFreq;
                end
                for outFreq = outFreqs
                    outFreqInd = outFreq/inFreq;
                    outFreqInd_all = outFreqInd;
                    if ismember(outFreq,inFreqs)
                        %fill in nonzero elements of G
                        G_ui2Pdd(:,:,inFreqInd,outFreqInd) = G_ui2Pdd_all(:,:,inFreqInd_all,outFreqInd_all);
                        G_ui2didd(:,:,inFreqInd,outFreqInd) = G_ui2didd_all(:,:,inFreqInd_all,outFreqInd_all);
                    end
                end
            else
                warndlg(['Harmonic data for n = ',num2str(inFreqInd),' (f = ',num2str(inFreq),' Hz) does not exist.'])
                return
            end
        end
        
    case {'uiControl','uiAddFreqs'}
end

controllerUpdatesPerPlot = 1;

%get PddDesCyc and uiCyc signals
PddDesCyc = handles.signalinfo.PddDesCyc;
diddDesCyc = handles.signalinfo.diddDesCyc;
uiCyc = handles.signalinfo.uiCyc;

PddDesNCC = repmat(PddDesCyc,[NCC,1]);
diddDesNCC = repmat(diddDesCyc,[NCC,1]);
uiNCC = repmat(uiCyc,[NCC,1]);

%fft NCC cycles of desired plate motion signals
PddDesNCC_fft = fft(PddDesNCC);
diddDesNCC_fft = fft(diddDesNCC);

%fft NCC cycles of uiCyc
uiNCC_fft = fft(uiNCC);

%make sure u_fft is zero for frequencies above maxharmonic*basefreq
NCH = numel(uiHarmonics);
fftInds = zeros(1,2*NCH);
for i = 1:NCH
    harmonic = uiHarmonics(i);
    fftInds(i) = NCC*harmonic+1;
    fftInds(end-i+1) = NCC*(SPC-harmonic)+1;
end
uiNCC_fft(~ismember(1:NCC*SPC,fftInds),:) = 0;


%NEED TO UPDATE THIS***************************************
%**********************************************************

%determine if initial control signals must change
uiInitialMode = get(get(handles.uiInitialMode,'selectedobject'),'tag');
switch uiInitialMode
    case 'uiInitial_guess'
        for n = uiHarmonics
            fftInd1 = NCC*n+1;
            fftInd2 = NCC*(SPC-n)+1;
            %NEED TO UPDAT THIS CODE***************************************
            %****************************************************
            switch handles.globalinfo.mode
                case 'PddControl'
                    uiNCC_fft(fftInd1,:) = (squeeze(G_ui2Pdd(:,:,1,n))\PddDesNCC_fft(fftInd1,:).').';
                    uiNCC_fft(fftInd2,:) = conj(uiNCC_fft(fftInd1,:));
                case {'diddControl','diddAddFreqs'}
                    uiNCC_fft(fftInd1,:) = (squeeze(G_ui2didd(:,:,1,n))\diddDesNCC_fft(fftInd1,:).').';
                    uiNCC_fft(fftInd2,:) = conj(uiNCC_fft(fftInd1,:));
            end
            %*****************************************************
            %***************************************************
            
            %reset uiCyc (1 cycle)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
        end
        
    case 'uiInitial_zero'
        uiCyc = 0*uiCyc;
        uiNCC_fft = 0*uiNCC_fft;
    case 'uiInitial_previous'
    case 'uiInitial_user'
end
%**********************************************************
%**********************************************************



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

maxUpdate = 1;
err = Inf;
while currentUpdate < maxUpdate
    
    %determine whether or not to break from control loop depending on
    %current mode
    switch handles.globalinfo.mode
        case {'PddControl','diddControl','uiControl'}
            if ~get(handles.run,'value');
                break
            end
        case 'uiAddFreqs'
            if ~get(handles.uiAddFreqs,'value');
                break
            end
        case 'diddAddFreqs'
            if ~get(handles.diddAddFreqs,'value');
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
%         'AI'
%         get(handles.daqinfo.ai,'running')
%         get(handles.daqinfo.ai,'SamplesAcquired')
%         'AO'
%         get(handles.daqinfo.ao,'running')
%         get(handles.daqinfo.ao,'samplesavailable')
        
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
                        set(handles.desSignals_Pdd,'enable','on')
                        set(handles.desSignals_didd,'enable','on')
                        set(handles.desSignals_ui,'enable','on')
                        return
                    otherwise
                        start(handles.daqinfo.ao)
                end
            end
        end
    end
    
    %import NCC cycles of analog input signals.  columns of aidata
    %correspond to ai_channel_names
    aidata_raw = getdata(handles.daqinfo.ai);
    meanaidata_raw = mean(aidata_raw);
    aidata = aidata_raw - repmat(meanaidata_raw,[size(aidata_raw,1),1]);
    
    %put aidata into signal matrices
    %read in local plate acclerations (accelerometers mounted to
    %plate)
    pmiddNCC = 1/V_per_ms2*aidata(:,1:NPMIDDS);
    %convert local plate accelerations into plate acceleration
    %(i.e., accleration of P frame with respect to W frame)
    PddNCC = (T_W2pmi\pmiddNCC')';
    %FFT plate acceleration
    PddNCC_fft = fft(PddNCC);
    
    %read in local actuator accelerations (accelerometers mounted
    %to actuators)
    amiddNCC = 1/V_per_ms2*aidata(:,NPMIDDS+1:NPMIDDS+NAMIDDS);
    %convert to accelerations along each actuator shaft
    diddNCC = (T_di2ami\amiddNCC')';
    %fft actuator shaft accelerations
    diddNCC_fft = fft(diddNCC);
    
    if strcmp(handles.globalinfo.aiConfig,'force')
        %read in all 12 raw force signals
        fRawNCC = aidata(:,NPMIDDS+NAMIDDS+1:end);
        %recover 6 force signals
        fNCC = (fRawNCC(:,1:6) - fRawNCC(:,7:12))*FsensorCrosstalk;
        fNCC(:,1:3) = lbf2N*fNCC(:,1:3);
        fNCC(:,4:6) = lbfin2Nm*fNCC(:,4:6);
    end
    
    %put signal info back into handles
    handles.signalinfo.PddCyc = PddNCC(1:SPC,:);
    handles.signalinfo.pmiddCyc = pmiddNCC(1:SPC,:);
    handles.signalinfo.amiddCyc = amiddNCC(1:SPC,:);
    handles.signalinfo.diddCyc = diddNCC(1:SPC,:);
    handles.signalinfo.uiCyc = uiNCC(1:SPC,:);
    if strcmp(handles.globalinfo.aiConfig,'force')
        handles.signalinfo.fCyc = fNCC(1:SPC,:);
    end
    
    %plot data in GUI
    if mod(currentUpdate,controllerUpdatesPerPlot) == 0 && get(handles.updatePlots,'value')
        PlotControlSignals(handles)
        PlotAccSignals(handles)
        if strcmp(handles.globalinfo.aiConfig,'force')
            PlotForceSignals(handles)
        end
    end
    
    %update desired signals and gain, then compute new control signals
    k = str2double(get(handles.k,'string'));
    switch handles.globalinfo.mode
        case 'PddControl'
            for i = 1:length(handles.signalinfo.PddDesChar)
                PddDesChariOld = handles.signalinfo.PddDesChar{i};
                PddDesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(PddDesChariOld, PddDesChariNew)
                    [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);
                    PddDesNCC = repmat(handles.signalinfo.PddDesCyc,[NCC,1]);
                    PddDesNCC_fft = fft(PddDesNCC);
                end
            end
            %error in Pdd
            eNCC_fft = PddDesNCC_fft - PddNCC_fft;
            eNCC = PddDesNCC - PddNCC;
            err = eNCC(1:SPC).^2;
            
            %transfer function for this case
            G = G_ui2Pdd;
            
        case {'diddControl','diddAddFreqs'}
            for i = 1:length(handles.signalinfo.PddDesChar)
                diddDesChariOld = handles.signalinfo.diddDesChar{i};
                diddDesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(diddDesChariOld, diddDesChariNew)
                    [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);
                    diddDesNCC = repmat(handles.signalinfo.diddDesCyc,[NCC,1]);
                    diddDesNCC_fft = fft(diddDesNCC);
                end
            end
            %error in didd
            eNCC_fft = diddDesNCC_fft - diddNCC_fft;
            eNCC = diddDesNCC - diddNCC;
            err = eNCC(1:SPC).^2;
            
            %transfer function for this case
            G = G_ui2didd;
            
        case {'uiControl','uiAddFreqs'}
            for i = 1:length(handles.signalinfo.PddDesChar)
                uiDesChariOld = handles.signalinfo.uiDesChar{i};
                uiDesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(uiDesChariOld, uiDesChariNew)
                    [handles.signalinfo.uiDesChar, handles.signalinfo.uiCyc] = desCycUpdater(handles);
                    uiNCC = repmat(handles.signalinfo.uiCyc,[NCC,1]);
                    uiNCC_fft = fft(uiNCC);
                end
            end
            %error in ui
            eNCC_fft = 0*uiNCC_fft;
            eNCC = 0*uiNCC;
            err = eNCC(1:SPC).^2;
    end
    
    %compute control signals (if necessary)
    switch handles.globalinfo.mode
        case {'PddControl','diddControl','diddAddFreqs'}
            deltauiNCC_fft = zeros(size(uiNCC_fft));
            inFreqs = F_ui;
            for inFreq = inFreqs
                inFreqInd = inFreq/f1;
                fftInd1 = NCC*inFreqInd+1;
                
                eNCC_fft_nonlinear = zeros(NUIS,1);
                for outFreqInd = 1:inFreqInd-1
                    eNCC_fft_nonlinear = eNCC_fft_nonlinear + G(:,:,outFreqInd,inFreqInd)*deltauiNCC_fft(fftInd1,:).';
                end
                deltauiNCC_fft(fftInd1,:) = G(:,:,inFreqInd,1)\(eNCC_fft(fftInd1,:).' - eNCC_fft_nonlinear);
                
                fftInd2 = length(eNCC_fft)-NCC*inFreqInd+1;
                deltauiNCC_fft(fftInd2,:) = conj(deltauiNCC_fft(fftInd1,:));
            end
            uiNCC_fft = uiNCC_fft + k*deltauiNCC_fft;
            
            %get uiCyc (1 cycle) and u_ao (N cycles)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
        case {'uiControl','uiAddFreqs'}
    end
    
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
    
%     %put signal info back into handles
%     handles.signalinfo.PddCyc = PddNCC(1:SPC,:);
%     handles.signalinfo.pmiddCyc = pmiddNCC(1:SPC,:);
%     handles.signalinfo.amiddCyc = amiddNCC(1:SPC,:);
%     handles.signalinfo.diddCyc = diddNCC(1:SPC,:);
%     handles.signalinfo.uiCyc = uiNCC(1:SPC,:);
%     if strcmp(handles.globalinfo.aiConfig,'force')
%         handles.signalinfo.fCyc = fNCC(1:SPC,:);
%     end
    
    
%     %plot data in GUI
%     if mod(currentUpdate,controllerUpdatesPerPlot) == 0 && get(handles.updatePlots,'value')
%         PlotControlSignals(handles)
%         PlotAccSignals(handles)
%         if strcmp(handles.globalinfo.aiConfig,'force')
%             PlotForceSignals(handles)
%         end
%     end
    currentUpdate = currentUpdate + 1;
    
    switch handles.globalinfo.mode
        case {'PddControl','diddControl','uiControl'}
            maxUpdate = eval(get(handles.maxUpdate,'string'));
        case 'diddAddFreqs'
            maxUpdate = eval(get(handles.maxUpdateAddFreqs,'string'));
    end

    set(handles.currentUpdate,'string',num2str(currentUpdate))
    set(handles.currentError,'string',num2str(err,4))
    
end

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)

set(handles.run,'value',0,'string','Run')


