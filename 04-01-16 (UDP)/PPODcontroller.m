function handles = PPODcontroller(handles)

[NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles);

NTC = eval(get(handles.numTransientCycles,'string'));
NCC = eval(get(handles.numCollectedCycles,'string'));
NPC = eval(get(handles.numProcessingCycles,'string'));
N = NTC + NCC + NPC;

if strcmp(handles.globalinfo.aiConfig,'force')
    FsensorCrosstalk = handles.calibrationinfo.FsensorCrosstalk;
    lbf2N = handles.calibrationinfo.lbf2N;
    lbfin2Nm = handles.calibrationinfo.lbfin2Nm;
    V2m_LS = handles.calibrationinfo.V2m_LS;
end

SPC = handles.signalinfo.samplesPerCycle;
T = handles.signalinfo.T;
samplingFreq = handles.signalinfo.samplingFreq;
f1 = double(sym(1/T));
fps = handles.camerainfo.fps;

%pre-emptively add cycles to allow for enough processing time if graphics
%are being updated
NPCold = NPC;
cycPerUpdateMinTimePlot = 1.75;
cycPerUpdateMinTimeNoPlot = .25;
if get(handles.updatePlots,'value') && ~strcmp(handles.globalinfo.mode,'uiControl')
    if N*T < cycPerUpdateMinTimePlot
        N = round(cycPerUpdateMinTimePlot/T);
        NPC = N - NTC - NCC;
        handles.controllerinfo.numProcessingCycles = NPC;
        set(handles.numProcessingCycles,'string',num2str(NPC))
        handles.controllerinfo.numProcessingCycles = N;
        set(handles.cyclesPerUpdate,'string',num2str(N))
        set(handles.timePerUpdate,'string',num2str(N*T))
    end
else
    if N*T < cycPerUpdateMinTimeNoPlot
        N = round(cycPerUpdateMinTimeNoPlot/T);
        NPC = N - NTC - NCC;
        handles.controllerinfo.numProcessingCycles = NPC;
        set(handles.numProcessingCycles,'string',num2str(NPC))
        handles.controllerinfo.numProcessingCycles = N;
        set(handles.cyclesPerUpdate,'string',num2str(N))
        set(handles.timePerUpdate,'string',num2str(N*T))
    end
end

%frame transformations
T_W2pmi = handles.calibrationinfo.T_W2pmi;
T_di2ami = handles.calibrationinfo.T_di2ami;
T_F2W = handles.calibrationinfo.T_F2W;
T_LS2W = handles.calibrationinfo.T_LS2W;

%volts per m/s^2 calibration
V_per_ms2 = handles.calibrationinfo.V_per_ms2;

%specify how many samples to collect upon trigger
%handles.daqinfo.ai.SamplesPerTrigger = NCC*SPC;

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

%determine if initial control signals must change
uiInitialMode = get(get(handles.uiInitialModeSelector,'selectedobject'),'tag');
switch uiInitialMode
    case 'uiInitial_guess'
        for n = uiHarmonics
            fftInd1 = NCC*n+1;
            fftInd2 = NCC*(SPC-n)+1;
            
            switch handles.globalinfo.mode
                case 'PddControl'
                    uiNCC_fft(fftInd1,:) = (squeeze(G_ui2Pdd(:,:,n,1))\PddDesNCC_fft(fftInd1,:).').';
                    uiNCC_fft(fftInd2,:) = conj(uiNCC_fft(fftInd1,:));
                case {'diddControl','diddAddFreqs'}
                    uiNCC_fft(fftInd1,:) = (squeeze(G_ui2didd(:,:,n,1))\diddDesNCC_fft(fftInd1,:).').';
                    uiNCC_fft(fftInd2,:) = conj(uiNCC_fft(fftInd1,:));
            end
            
            %reset uiCyc (1 cycle)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
        end
        
    case 'uiInitial_zero'
        uiCyc = 0*uiCyc;
        uiNCC = 0*uiNCC;
        uiNCC_fft = 0*uiNCC_fft;
    case 'uiInitial_previous'
    case 'uiInitial_user'
        
    otherwise
        error('selection does not match any case')
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
switch handles.globalinfo.aoConfig
    case 'camera'
        %create trigger signal for camera (goes low for 1ms at the beginning of
        %each cycle)
        camTrigN = 5 + zeros(SPC*N,1);
        camTrigN(1:10)=0;
%         samplesPerCamTrig = samplingFreq/fps;
%         samplesPerMillisec = round(1/T*SPC*1e-3);
%         
%         camTrigInd1 = samplesPerCamTrig;
%         camTrigInd2 = samplesPerCamTrig + samplesPerMillisec;
%         camTrigFlag = 0;
%         camTrigInd1_nomod = camTrigInd1;
%         while camTrigInd1_nomod <= SPC*N
%             if camTrigFlag
%                 camTrigN(1:camTrigIndLeftover) = 0;
%             end
%             if camTrigInd2 > SPC*N
%                 camTrigFlag = 1;
%                 camTrigIndLeftover = mod(camTrigInd2,SPC);
%                 camTrigN(camTrigInd1:end) = 0;
%             else
%                 camTrigN(camTrigInd1:camTrigInd2) = 0;
%                 camTrigFlag = 0;
%             end
%             camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
%             camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,SPC*N)+1;
%             camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,SPC*N)+1;

 %       end
    case 'standard'
        camTrigN = [];
    otherwise
        error('selection does not match any case')
end

%**************************************************************************
%**************************************************************************
%selected saved signal from savedsignal listbox
savedSignalVal = get(handles.savedSignalsListbox,'value');

%put u_ao_init and clock_init into the queue
size(clock)
size(uiN)
size(camTrigN)

queueOutputData(handles.daqinfo.s,[clock, uiN, camTrigN])
%start analog intput device (set to log during trigger event and then stops
%once data has been logged) & start analog output device (sends out data immediately)
a = handles.daqinfo.s.startForeground;

currentUpdate = 0;
set(handles.currentUpdate,'string',num2str(currentUpdate))

maxUpdate = 1;
err = Inf;

while currentUpdate < maxUpdate

    if( currentUpdate >= 5)
        absError = str2double(get(handles.currentError,'String'));
        udpMessage = sprintf('%f',absError);
        fprintf(handles.udp, udpMessage);
    end

    
    switch handles.globalinfo.mode
        case {'PddControl','diddControl','uiControl'}
            set(handles.currentUpdate,'string',num2str(currentUpdate))
            if ~get(handles.run,'value');
                break
            end
        case 'uiAddFreqs'
            if ~get(handles.uiAddFreqs,'value');
                break
            end
        case 'diddAddFreqs'
            set(handles.currentUpdatediddAddFreqs,'string',num2str(currentUpdate))
            if ~get(handles.diddAddFreqs,'value');
                NPC = NPCold;
                N = NTC + NCC + NPC;
                handles.controllerinfo.numProcessingCycles = NPC;
                set(handles.numProcessingCycles,'string',num2str(NPC))
                handles.controllerinfo.numProcessingCycles = N;
                set(handles.cyclesPerUpdate,'string',num2str(N))
                set(handles.timePerUpdate,'string',num2str(N*T))
                break
            end
            errorTol = eval(get(handles.diddErrorTol,'string'));
            if err < errorTol
                NPC = NPCold;
                N = NTC + NCC + NPC;
                handles.controllerinfo.numProcessingCycles = NPC;
                set(handles.numProcessingCycles,'string',num2str(NPC))
                handles.controllerinfo.numProcessingCycles = N;
                set(handles.cyclesPerUpdate,'string',num2str(N))
                set(handles.timePerUpdate,'string',num2str(N*T))
                break
            end
        case 'PddAddFreqs'
            set(handles.currentUpdatePddAddFreqs,'string',num2str(currentUpdate))
            if ~get(handles.PddAddFreqs,'value');
                break
            end
            errorTol = eval(get(handles.PddErrorTol,'string'));
            if err < errorTol
                break
            end
    end
    
    %wait for data to be collected from analog input (the device stops once
    %the data is logged)
    pause(.1)

    while get(handles.daqinfo.ai,'SamplesAcquired') < SPC*NCC && (get(handles.run,'value') || get(handles.uiAddFreqs,'value') || get(handles.diddAddFreqs,'value') || get(handles.PddAddFreqs,'value'))
        
        if strcmp(get(handles.daqinfo.ai,'running'),'On') && get(handles.daqinfo.ao,'samplesavailable') < SPC*N
            queueOutputData(handles.s, [clock, uiN, camTrigN])
            if strcmp(get(handles.daqinfo.ao,'Running'), 'Off') 
                disp(['update ',num2str(currentUpdate),': ao turned off--increase N'])
                start(handles.daqinfo.ao)
            end
            if strcmp(get(handles.daqinfo.ao,'Running'), 'Off')
                button = questdlg('Analog output card ran out of samples in queue.  Number of processing cycles should be increased.  Do you wish to continue operating?');
                switch button
                    case {'No','Cancel'}
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
    
    if strcmp(handles.globalinfo.mode,'PddControl') && ~get(handles.run,'value')
        break
    end
    while strcmp(get(handles.daqinfo.ao,'running'),'off')
    end
    aidata_raw = getdata(handles.daqinfo.ai);

    meanaidata_raw = mean(aidata_raw);
    aidata_meanoffset = aidata_raw - repmat(meanaidata_raw,[size(aidata_raw,1),1]);

    %put aidata into signal matrices
    %read in local plate acclerations (accelerometers mounted to plate)
    pmiddNCC = 1/V_per_ms2*aidata_meanoffset(:,1:NPMIDDS);
    %convert local plate accelerations into plate acceleration
    %(i.e., accleration of P frame with respect to W frame)
    PddNCC = (T_W2pmi\pmiddNCC')';
    %FFT plate acceleration
    PddNCC_fft = fft(PddNCC);
    
    %read in local actuator accelerations (accelerometers mounted
    %to actuators)
    amiddNCC = 1/V_per_ms2*aidata_meanoffset(:,NPMIDDS+1:NPMIDDS+NAMIDDS);
    %convert to accelerations along each actuator shaft
    diddNCC = (T_di2ami\amiddNCC')';
    %fft actuator shaft accelerations
    diddNCC_fft = fft(diddNCC);
    
    if strcmp(handles.globalinfo.aiConfig,'force')
        %read in all 12 raw force signals
        fRawNCC = aidata_raw(:,NPMIDDS+NAMIDDS+1:NPMIDDS+NAMIDDS+NRFS);
        %recover 6 force signals
        fNCC = (fRawNCC(:,1:6) - fRawNCC(:,7:12))*FsensorCrosstalk;
        fNCC(:,1:3) = lbf2N*fNCC(:,1:3);
        fNCC(:,4:6) = lbfin2Nm*fNCC(:,4:6);
        
        %transform wrench from force sensor frame to frame centered at one end of flexure
        fNCC = (T_F2W*fNCC')';
        
        diNCC = T_LS2W*aidata_raw(:,NPMIDDS+NAMIDDS+NRFS+1:NPMIDDS+NAMIDDS+NRFS+NDIS)*V2m_LS - .045;
    end
    
    %put signal info back into handles
    handles.signalinfo.PddCyc = PddNCC(1:SPC,:);
    handles.signalinfo.pmiddCyc = pmiddNCC(1:SPC,:);
    handles.signalinfo.amiddCyc = amiddNCC(1:SPC,:);
    handles.signalinfo.diddCyc = diddNCC(1:SPC,:);
    handles.signalinfo.uiCyc = uiNCC(1:SPC,:);
    if strcmp(handles.globalinfo.aiConfig,'force')
        handles.signalinfo.fCyc = fNCC(1:SPC,:);
        handles.signalinfo.diCyc = diNCC(1:SPC);
    end
    
    %plot data in GUI
    if mod(currentUpdate,controllerUpdatesPerPlot) == 0 && get(handles.updatePlots,'value')
        PlotControlSignals(handles)
        PlotAccSignals(handles)
        
        if strcmp(handles.globalinfo.aiConfig,'force')
            PlotForceSignals(handles)
            PlotLaserSignals(handles)
        end
    end
    
    %SEE IF USER SET TO AUTOMATICALLY CHANGE FIELDS    
    savedfieldnames = get(handles.savedSignalsListbox,'String');
    if get(handles.squareSequence,'value')
        fields = {'Sink','TransX','TransNegY','TransNegX','TransY','TransX','TransNegY'};
        numupdates = [8,2,2,8,8,8,2];%num updates for each field
        updateindices = [0 cumsum(numupdates(1:end-1))];
        updatespercycle = sum(numupdates);
        for kk = 1:length(fields)
            if rem(currentUpdate,updatespercycle) == updateindices(kk)
                full_field_name=strcat(fields{kk},'.mat');
                set(handles.savedSignalsListbox,'Value',find(strncmp(full_field_name,savedfieldnames,length(full_field_name))))
                [X,Y,Vx Vy] = getfieldvectors(fields{kk});
                quiver(handles.fieldAxes,X,Y,Vx,Vy,0)
                axis(handles.fieldAxes,'equal')
                set(handles.fieldAxes,'xlim',[-10 10],'ylim',[-10 10],'xtick',0,'ytick',0)
            end
        end
    end
    if get(handles.sinkSourceSequence,'value')
        fields = {'Sink','Source','Whirlpool','Centrifuge'};
        numupdates = [6,3,5,3];%num updates for each field
      updateindices = [0 cumsum(numupdates(1:end-1))];
        updatespercycle = sum(numupdates);
        for kk = 1:length(fields)
            if rem(currentUpdate,updatespercycle) == updateindices(kk)
                full_field_name=strcat(fields{kk},'.mat');
                set(handles.savedSignalsListbox,'Value',find(strncmp(full_field_name,savedfieldnames,length(full_field_name))))
                [X,Y,Vx Vy] = getfieldvectors(fields{kk});
                quiver(handles.fieldAxes,X,Y,Vx,Vy,0)
                axis(handles.fieldAxes,'equal')
                set(handles.fieldAxes,'xlim',[-10 10],'ylim',[-10 10],'xtick',0,'ytick',0)
            end
        end
    end
    if get(handles.samplerSequence,'value')
        fields = {'Sink','Source','Circle','LineSinkX','Sink','TransNegY','SqueezeTransY','TransNegX','Sink','TransX','Circle'};
        numupdates = [10,6,10,6,6,5,3,4,4,4,20];%num updates for each field
        updateindices = [0 cumsum(numupdates(1:end-1))];
        updatespercycle = sum(numupdates);
        for kk = 1:length(fields)
            if rem(currentUpdate,updatespercycle) == updateindices(kk)
                full_field_name=strcat(fields{kk},'.mat');
                set(handles.savedSignalsListbox,'Value',find(strncmp(full_field_name,savedfieldnames,length(full_field_name))))
                [X,Y,Vx Vy] = getfieldvectors(fields{kk});
                quiver(handles.fieldAxes,X,Y,Vx,Vy,0)
                axis(handles.fieldAxes,'equal')
                set(handles.fieldAxes,'xlim',[-10 10],'ylim',[-10 10],'xtick',0,'ytick',0)
            end
        end
    end
    
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
            PddDesMax = max(max(handles.signalinfo.PddDesCyc));
            err = sum(sum(eNCC(1:SPC,:).^2))/(samplingFreq*T*PddDesMax^2);
            
            %deal with user selecting a saved signal from listbox
            if get(handles.savedSignalsListbox,'value') ~= savedSignalVal
                
                savedSignalVal = get(handles.savedSignalsListbox,'value');
                hh = loadSavedSignals(handles);
                
                uiCyc = hh.signalinfo.uiCyc;
                uiNCC = repmat(uiCyc,[NCC,1]);
                uiNCC_fft = fft(uiNCC);
                
                eNCC_fft = 0*(PddDesNCC_fft - PddNCC_fft);
                eNCC = 0*(PddDesNCC - PddNCC);
                PddDesMax = max(max(handles.signalinfo.PddDesCyc));
                err = sum(sum(eNCC(1:SPC,:).^2))/(samplingFreq*T*PddDesMax^2);
                
                %empty out queue of old data by just running it down
                while get(handles.daqinfo.ao,'samplesavailable') > 0
                end
            end
            
            
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
            diddDesMax = max(max(handles.signalinfo.diddDesCyc));
            err = sum(sum(eNCC(1:SPC,:).^2))/(samplingFreq*T*diddDesMax^2);
            
            %transfer function for this case
            G = G_ui2didd;
            
        case {'uiControl','uiAddFreqs'}
            for i = 1:length(handles.signalinfo.PddDesChar)
                uiDesChariOld = handles.signalinfo.uiDesChar{i};
                uiDesChariNew = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
                if ~strcmp(uiDesChariOld, uiDesChariNew)
                    [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
                    handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
                    uiNCC = repmat(handles.signalinfo.uiCyc,[NCC,1]);
                    uiNCC_fft = fft(uiNCC);
                end
            end
            %error in ui
            eNCC_fft = 0*uiNCC_fft;
            eNCC = 0*uiNCC;
            err = 0;
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
            %update control (but not if user has selected a new plate
            %motion)

            %currentUpdate
            %encc = eNCC_fft(1:6,:)
            %deltancc = deltauiNCC_fft(1:6,:)
            
            uiNCC_fft = uiNCC_fft + k*deltauiNCC_fft;

            
            %get uiCyc (1 cycle)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
        case {'uiControl','uiAddFreqs'}
            %get uiCyc (1 cycle)
            uiNCC = ifft(uiNCC_fft);
            uiCyc = uiNCC(1:SPC,:);
    end
    
    %check to make sure that uiCyc does not exceed saturation voltage.  on
    %indices where it does, replace those voltages with +/-saturation
    %voltage
    signuiCyc = sign(uiCyc);
    handles.controllerinfo.uMax = str2double(get(handles.uMax,'string'));
    uMax = handles.controllerinfo.uMax*ones(size(uiCyc));
    ind = find(abs(uiCyc) > uMax);
    uiCyc(ind) = signuiCyc(ind).*uMax(ind);
    if ~isempty(ind)
        max(uiCyc)
        uiCyc = 0*uiCyc;
        warndlg('Saturation voltage exceeded.  Controller shut down.')
        break
    end
    
    %make N cycles of uiCyc to send to analog out.
    NTC = eval(get(handles.numTransientCycles,'string'));
    NPC = eval(get(handles.numProcessingCycles,'string'));
    N = NTC + NCC + NPC;
    uiN = repmat(uiCyc,[N,1]);
    
    %update clock
    clock = 0*uiN(:,1);
    clock(NTC*SPC) = 5;
    
    %update camera trigger signal
    if strcmp(handles.globalinfo.aoConfig,'camera')
        camTrigN = 5 + zeros(SPC*N,1);
        camTrigN(1:10)=0;
%         camTrigInd1_nomod = camTrigInd1;
%         while camTrigInd1_nomod <= SPC*N
%             if camTrigFlag
%                 camTrigN(1:camTrigIndLeftover) = 0;
%             end
%             if camTrigInd1 > camTrigInd2
%                 camTrigFlag = 1;
%                 camTrigIndLeftover = mod(camTrigInd2,SPC);
%                 camTrigN(camTrigInd1:end) = 0;
%             else
%                 camTrigN(camTrigInd1:camTrigInd2) = 0;
%                 camTrigFlag = 0;
%             end
%             camTrigInd1_nomod = camTrigInd1 + samplesPerCamTrig;
%             camTrigInd1 = mod(camTrigInd1+samplesPerCamTrig-1,SPC*N)+1;
%             camTrigInd2 = mod(camTrigInd2+samplesPerCamTrig-1,SPC*N)+1;
     %   end
    else
        camTrigN = [];
    end
    %**********************************************************************
    %**********************************************************************
    %put new output signals into queue
    queueOutputData(handles.s, [clock, uiN, camTrigN])
    if strcmp(get(handles.daqinfo.ao,'Running'), 'Off')
        disp(['update ',num2str(currentUpdate),': ao turned off--increase N (end of loop)'])
        while get(handles.daqinfo.ao,'samplesavailable') < SPC
            queueOutputData(handles.s, [clock, uiN, camTrigN])
        end
        start(handles.daqinfo.ao)
    end
    
    %restart analog input device
    start(handles.daqinfo.ai)
    
    currentUpdate = currentUpdate + 1;
    
    switch handles.globalinfo.mode
        case {'PddControl','diddControl','uiControl'}
            maxUpdate = eval(get(handles.maxUpdate,'string'));
        case 'diddAddFreqs'
            maxUpdate = eval(get(handles.maxUpdatediddAddFreqs,'string'));
        case 'PddAddFreqs'
            maxUpdate = eval(get(handles.maxUpdatePddaoAddFreqs,'string'));
    end
    
    set(handles.currentError,'string',num2str(err,4))

end

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)

set(handles.run,'value',0,'string','Run')