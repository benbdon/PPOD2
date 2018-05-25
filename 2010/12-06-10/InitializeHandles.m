function handles = InitializeHandles(handles)

aiConfig = get(get(handles.analogInputModeSelector,'selectedObject'),'tag');
aoConfig = get(get(handles.analogOutputModeSelector,'selectedObject'),'tag');
desSignals = get(get(handles.desSignalsSelector,'selectedObject'),'tag');

%*********************************************************************
%DEFINE HANDLES STRUCTURE
%*********************************************************************
switch aiConfig
    case 'standardModeAI'
        %globalinfo
        handles.globalinfo.aiConfig = 'standard';%can be 'standard' or 'force'
        switch aoConfig
            case 'standardModeAO'
                handles.globalinfo.aoConfig = 'standard';%can be 'standard' or 'camera'
            case 'cameraModeAO'
                handles.globalinfo.aoConfig = 'camera';%can be 'standard' or 'camera'
            otherwise
                error('selection does not match any case')
        end
        switch desSignals
            case 'desSignals_Pdd'
                handles.globalinfo.mode = 'PddControl';%can be 'PddControl','diddControl','uiControl','uiAddFreqs','diddAddFreqs','PddAddFreqs'
            case 'desSignals_didd'
                handles.globalinfo.mode = 'diddControl';
            case 'desSignals_ui'
                handles.globalinfo.mode = 'uiControl';
            otherwise
                error('selection does not match any case')
        end
        handles.globalinfo.uiSignals = {'u1','u2','u3','u4','u5','u6'};%control signals (pre-amplified voltages)
        handles.globalinfo.pmiddSignals = {'pm1ddx','pm1ddy','pm2ddx','pm2ddy','pm3ddx','pm3ddy','pm4ddx','pm4ddy','pm5ddx','pm5ddy','pm6ddx','pm6ddy'};%accelerations measured by accelerometers mounted around the plate in their local x-y frames
        handles.globalinfo.pmiddSignals2 = {'pm1dd','pm2dd','pm3dd','pm4dd','pm5dd','pm6dd'};
        handles.globalinfo.PddSignals = {'pddx','pddy','pddz','alphax','alphay','alphaz'};%xyzrpy accleration of plate in P' (equivalently, W) frame
        handles.globalinfo.amiddSignals = {'am1ddy','am2ddy','am3ddy','am4ddy','am5ddy','am6ddy'};%accelerations measured by accelerometers on actuator shafts in their local x-y frames
        handles.globalinfo.amiddSignals2 = {'am1dd','am2dd','am3dd','am4dd','am5dd','am6dd'};
        handles.globalinfo.diddSignals = {'d1dd','d2dd','d3dd','d4dd','d5dd','d6dd'};%accelerations along actuator shafts (i.e., z-axis acceleration of shafts in Ai frame)
        handles.globalinfo.rawForceSignals = {};%raw force/torque signals measured in force sensor's frame
        handles.globalinfo.forceSignals = {};%force/torque signals
        handles.globalinfo.diSignals = {};%actuator position signals measured by laser sensor
        handles.globalinfo.date = datestr(clock);%date
        handles.globalinfo.usernotes = [];%user notes
        handles.globalinfo.filename = 'Temp';
        
        %controllerinfo
        freqResponseData = load([cd,'\freqResponseData\freqResponseDataStandard']);%load data for the transfer functions
        handles.controllerinfo.F_ui_all = freqResponseData.F_ui_all; %set of frequencies for ui for which responses have been measured
        handles.controllerinfo.G_ui2Pdd_all = freqResponseData.G_ui2Pdd_all;%set of discrete transfer functions from u to xyzrpy plate acceleration
        handles.controllerinfo.G_ui2pmidd_all = freqResponseData.G_ui2pmidd_all;%set of discrete transfer functions from u to plate accelerometers
        handles.controllerinfo.G_ui2didd_all = freqResponseData.G_ui2didd_all;%set of discrete transwer functions from u to actuator axial acceleration
        handles.controllerinfo.G_ui2amidd_all = freqResponseData.G_ui2amidd_all;%set of discrete transwer functions from u to actuator accelerometers
        handles.controllerinfo.F_didd_all = freqResponseData.F_didd_all; %set of frequencies for didd for which responses have been measured
        handles.controllerinfo.G_didd2Pdd_all = freqResponseData.G_didd2Pdd_all;%set of discrete transwer functions from didd to xyzrpy plate acceleration
        handles.controllerinfo.G_didd2pmidd_all = freqResponseData.G_didd2pmidd_all;%set of discrete transwer functions from didd to plate accelerometers
        handles.controllerinfo.G_didd2f_all = freqResponseData.G_didd2f_all;%set of discrete transwer functions from didd to forces/torques
        handles.controllerinfo.F_Pdd_all = freqResponseData.F_Pdd_all; %set of frequencies for didd for which responses have been measured
        handles.controllerinfo.G_Pdd2f_all = freqResponseData.G_Pdd2f_all;%set of discrete transwer functions from didd to xyzrpy plate acceleration
        
        handles.controllerinfo.harmonicsCollectedPerFreq = 25;%number of harmonics of output are collected per input frequency
        handles.controllerinfo.uiHarmonics = 1;%set of harmonics actively controlled
        
        F_ui_all = handles.controllerinfo.F_ui_all;
        f1_ui = min(F_ui_all(F_ui_all>=20));
        if isempty(f1_ui)
            f1_ui = F_ui_all(1);
        end
        
        handles.controllerinfo.F_ui = f1_ui*handles.controllerinfo.uiHarmonics;%set of frequencies actively controlled
        handles.controllerinfo.uMax = 6;%maximum allowed pre-amplified control voltage (saturation limit)
        handles.controllerinfo.k = 0.15;%controller gain
        handles.controllerinfo.GuiInputMag = .5;%input voltage used to generate transfer functions
        handles.controllerinfo.GdiddInputMag = 10;%input actuator acceleration used to generate transfer functions
        handles.controllerinfo.numTransientCycles = 10;%number of cycles to wait after control signal is updated before collecting data
        handles.controllerinfo.numCollectedCycles = 5;%number of cycles collected
        handles.controllerinfo.numProcessingCycles = 25;%number of cycles after data collection during which time new control is computed
        handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
        handles.controllerinfo.maxUpdate = 1000;%number of updates before controller stops
        handles.controllerinfo.currentUpdate = 0;%current controller update
        
        %signalinfo
        handles.signalinfo.T = 1/f1_ui;%cycle time (period)
        handles.signalinfo.constants = {'w = 2*pi/T'};
        handles.signalinfo.samplingFreq = 10000;%DAQ sampling rate (Hz)
        handles.signalinfo.dt = 1/handles.signalinfo.samplingFreq;%time between samples (s)
        handles.signalinfo.tCyc = (0:handles.signalinfo.dt:handles.signalinfo.T - handles.signalinfo.dt)';%one cycle of time data
        handles.signalinfo.samplesPerCycle = length(handles.signalinfo.tCyc);
        handles.signalinfo.PddDesChar = {'0', '0', '0', '0', '0', '0'};
        handles.signalinfo.uiDesChar = {'0', '0', '0', '0', '0', '0'};
        handles.signalinfo.diddDesChar = {'0', '0', '0', '0', '0', '0'};
        
        [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles); %outputs number of signals
        SPC = handles.signalinfo.samplesPerCycle;
        
        handles.signalinfo.PddCyc = zeros(SPC, NPDDS);%one cycle of plate acceleration data (columns correspond to PddSignals)
        handles.signalinfo.PddDesCyc = zeros(SPC, NPDDS);%one cycle of desired plate acceleration data (columns correspond to PddSignals)
        handles.signalinfo.pmiddCyc = zeros(SPC, NPMIDDS);%one cycle of local plate acceleration data (columns correspond to pmiddSignals)
        handles.signalinfo.amiddCyc = zeros(SPC, NAMIDDS);%one cycle of local actuator acceleration data (columns correspond to amiddSignals)
        handles.signalinfo.diddCyc = zeros(SPC, NDIDDS);%one cycle of actuator acceleration data (columns correspond to diddSignals)
        handles.signalinfo.diddDesCyc = zeros(SPC, NDIDDS);%one cycle of actuator acceleration data (columns correspond to diddSignals)
        handles.signalinfo.uiCyc = zeros(SPC, NUIS);%one cycle of control data (columns correspond to uiSignals)
        handles.signalinfo.uiDesCyc = zeros(SPC, NUIS);%one cycle of desired control data (columns correspond to uiSignals)
        handles.signalinfo.fCyc = zeros(SPC, NFS);%one cycle of force data (columns correspond to forceSignals)
        handles.signalinfo.diCyc = zeros(SPC,NDIS);%one cycle of laser sensor data
        
        %daqinfo
        handles.daqinfo.aoChannelNames = [];%analog output channel names
        handles.daqinfo.aiChannelNames = [];%analog input channel names
        handles.daqinfo.ao = [];%analog output object
        handles.daqinfo.ai = [];%analog input object
        handles.daqinfo = InitializeDAQInfo(handles);%puts data into empty fields above
        
        %calibrationinfo
        [T_W2pmi, T_di2ami, T_F2W, T_LS2W] = frameTransformations(handles);%conversion between local acceleration readings to plate accelerations??
        handles.calibrationinfo.T_W2pmi = T_W2pmi;%transforms accelerations in world frame to accelerations in measured plate frames
        handles.calibrationinfo.T_di2ami = T_di2ami;%transforms accelerations along axes of actuators to accelerations in measured actuator frames
        handles.calibrationinfo.T_F2W = T_F2W;%transforms wrenches in F frame to wrenches in world frame
        handles.calibrationinfo.T_LS2W = T_LS2W;%transforms positions in laser sensor frame to positions in world frame
        handles.calibrationinfo.V_per_ms2 = 0.01;%volts per m/s^2 of accelerometers
        handles.calibrationinfo.FsensorCrosstalk = [0.0415545, -1.3084753, -0.0209014, 1.3708784, -0.0007212, -0.0037188;
            0.0153681, -0.7556705, 0.0205839, -0.7789058, -0.0193142, 1.5373701;
            -2.3604085, 0.0834155, -2.4158316, 0.0624050, -2.3448311, -0.0132399;
            -1.3171405, -0.1171120, 1.3567893, -0.1945159, -0.0251065,0.3247306;
            -0.7579343,	0.3042172, -0.7516815, -0.2737271, 1.5049942, 0.0110706;
            -0.0274613, 0.7175862, -0.0193200, 0.7383569, -0.0119917, 0.7391482]'; %transposed from Matt's
        handles.calibrationinfo.lbf2N = 4.448;
        handles.calibrationinfo.lbfin2Nm = 0.1129;
        handles.calibrationinfo.V2m_LS = 0.005; %volts per meter for laser sensor
        handles.calibrationinfo.diInit = [];%stationary reading of laser sensor
        handles.calibrationinfo.SMR = .045; %start off measuring range for laser sensor (position offset)
        
        %camerainfo
        handles.camerainfo.fps = f1_ui;
        
    case 'forceModeAI'
        %globalinfo
        handles.globalinfo.aiConfig = 'force';%can be 'standard' or 'force'
        switch aoConfig
            case 'standardModeAO'
                handles.globalinfo.aoConfig = 'standard';%can be 'standard' or 'camera'
            case 'cameraModeAO'
                handles.globalinfo.aoConfig = 'camera';%can be 'standard' or 'camera'
            otherwise
                error('selection does not match any case')
        end
        switch desSignals
            case 'desSignals_Pdd'
                handles.globalinfo.mode = 'PddControl';%can be 'PddControl','diddControl','uiControl','uiAddFreqs','diddAddFreqs','PddAddFreqs'
            case 'desSignals_didd'
                handles.globalinfo.mode = 'diddControl';
            case 'desSignals_ui'
                handles.globalinfo.mode = 'uiControl';
            otherwise
                error('selection does not match any case')
        end
        handles.globalinfo.uiSignals = {'u1'};%control signals (pre-amplified voltages)
        handles.globalinfo.pmiddSignals = {'pm1ddx','pm1ddy','pm2ddx','pm2ddy'};%accelerations measured by accelerometers mounted around the plate in their local x-y frames
        handles.globalinfo.pmiddSignals2 = {'pm1dd','pm2dd'};
        handles.globalinfo.PddSignals = {'pddx','pddy','pddz'};%xyzrpy accleration of plate in P' (equivalently, W) frame
        handles.globalinfo.amiddSignals = {'am1ddx','am1ddy','am2ddx','am2ddy'};%accelerations measured by accelerometers on actuator shafts in their local x-y frames
        handles.globalinfo.amiddSignals2 = {'am1dd','am2dd'};
        handles.globalinfo.diddSignals = {'d1dd'};%accelerations along actuator shafts (i.e., z-axis acceleration of shafts in Ai frame)
        handles.globalinfo.rawForceSignals = {'S1','S2','S3','S4','S5','S6','R1','R2','R3','R4','R5','R6'};%raw force/torque signals measured in force sensor's frame
        handles.globalinfo.forceSignals = {'Fx','Fy','Fz','Mx','My','Mz'};%force/torque signals
        handles.globalinfo.diSignals = {'d1'};%actuator position measured by laser sensor
        handles.globalinfo.date = datestr(clock);%date
        handles.globalinfo.usernotes = [];%user notes
        handles.globalinfo.filename = 'Temp';
        
        %controllerinfo
        freqResponseData = load([cd,'\freqResponseData\freqResponseDataForce']);%load data for the transfer functions
        handles.controllerinfo.F_ui_all = freqResponseData.F_ui_all; %set of frequencies for ui for which responses have been measured
        handles.controllerinfo.G_ui2Pdd_all = freqResponseData.G_ui2Pdd_all;%set of discrete transfer functions from u to xyzrpy plate acceleration
        handles.controllerinfo.G_ui2pmidd_all = freqResponseData.G_ui2pmidd_all;%set of discrete transfer functions from u to plate accelerometers
        handles.controllerinfo.G_ui2didd_all = freqResponseData.G_ui2didd_all;%set of discrete transwer functions from u to actuator axial acceleration
        handles.controllerinfo.G_ui2amidd_all = freqResponseData.G_ui2amidd_all;%set of discrete transwer functions from u to actuator accelerometers
        handles.controllerinfo.F_didd_all = freqResponseData.F_didd_all; %set of frequencies for didd for which responses have been measured
        handles.controllerinfo.G_didd2Pdd_all = freqResponseData.G_didd2Pdd_all;%set of discrete transwer functions from didd to xyzrpy plate acceleration
        handles.controllerinfo.G_didd2pmidd_all = freqResponseData.G_didd2pmidd_all;%set of discrete transwer functions from didd to plate accelerometers
        handles.controllerinfo.G_didd2f_all = freqResponseData.G_didd2f_all;%set of discrete transwer functions from didd to forces/torques
        handles.controllerinfo.F_Pdd_all = freqResponseData.F_Pdd_all; %set of frequencies for didd for which responses have been measured
        handles.controllerinfo.G_Pdd2f_all = freqResponseData.G_Pdd2f_all;%set of discrete transwer functions from didd to xyzrpy plate acceleration
        
        handles.controllerinfo.harmonicsCollectedPerFreq = 25;%number of harmonics of output are collected per input frequency
        handles.controllerinfo.uiHarmonics = 1;%set of harmonics actively controlled
        
        F_ui_all = handles.controllerinfo.F_ui_all;
        f1_ui = min(F_ui_all(F_ui_all>=20));
        if isempty(f1_ui)
            f1_ui = F_ui_all(1);
        end
        
        handles.controllerinfo.F_ui = f1_ui*handles.controllerinfo.uiHarmonics;%set of frequencies actively controlled
        handles.controllerinfo.uMax = 6;%maximum allowed pre-amplified control voltage (saturation limit)
        handles.controllerinfo.k = 0.15;%controller gain
        handles.controllerinfo.GuiInputMag = .5;%input voltage used to generate transfer functions
        handles.controllerinfo.GdiddInputMag = 10;%input actuator acceleration used to generate transfer functions
        handles.controllerinfo.numTransientCycles = 10;%number of cycles to wait after control signal is updated before collecting data
        handles.controllerinfo.numCollectedCycles = 5;%number of cycles collected
        handles.controllerinfo.numProcessingCycles = 25;%number of cycles after data collection during which time new control is computed
        handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
        handles.controllerinfo.maxUpdate = 1000;%number of updates before controller stops
        handles.controllerinfo.currentUpdate = 0;%current controller update
        
        %signalinfo
        handles.signalinfo.T = 1/f1_ui;%cycle time (period)
        handles.signalinfo.constants = {'w = 2*pi/T'};
        handles.signalinfo.samplingFreq = 10000;%DAQ sampling rate (Hz)
        handles.signalinfo.dt = 1/handles.signalinfo.samplingFreq;%time between samples (s)
        handles.signalinfo.tCyc = (0:handles.signalinfo.dt:handles.signalinfo.T - handles.signalinfo.dt)';%one cycle of time data
        handles.signalinfo.samplesPerCycle = length(handles.signalinfo.tCyc);
        handles.signalinfo.PddDesChar = {'0', '0', '0', '0', '0', '0'};
        handles.signalinfo.uiDesChar = {'0', '0', '0', '0', '0', '0'};
        handles.signalinfo.diddDesChar = {'0', '0', '0', '0', '0', '0'};
        
        [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles); %outputs number of signals
        SPC = handles.signalinfo.samplesPerCycle;
        
        handles.signalinfo.PddCyc = zeros(SPC, NPDDS);%one cycle of plate acceleration data (columns correspond to PddSignals)
        handles.signalinfo.PddDesCyc = zeros(SPC, NPDDS);%one cycle of desired plate acceleration data (columns correspond to PddSignals)
        handles.signalinfo.pmiddCyc = zeros(SPC, NPMIDDS);%one cycle of local plate acceleration data (columns correspond to pmiddSignals)
        handles.signalinfo.amiddCyc = zeros(SPC, NAMIDDS);%one cycle of local actuator acceleration data (columns correspond to amiddSignals)
        handles.signalinfo.diddCyc = zeros(SPC, NDIDDS);%one cycle of actuator acceleration data (columns correspond to diddSignals)
        handles.signalinfo.diddDesCyc = zeros(SPC, NDIDDS);%one cycle of actuator acceleration data (columns correspond to diddSignals)
        handles.signalinfo.uiCyc = zeros(SPC, NUIS);%one cycle of control data (columns correspond to uiSignals)
        handles.signalinfo.uiDesCyc = zeros(SPC, NUIS);%one cycle of desired control data (columns correspond to uiSignals)
        handles.signalinfo.fCyc = zeros(SPC, NFS);%one cycle of force data (columns correspond to forceSignals)
        handles.signalinfo.diCyc = zeros(SPC,NDIS);%one cycle of laser sensor data
        
        %daqinfo
        handles.daqinfo.aoChannelNames = [];%analog output channel names
        handles.daqinfo.aiChannelNames = [];%analog input channel names
        handles.daqinfo.ao = [];%analog output object
        handles.daqinfo.ai = [];%analog input object
        handles.daqinfo = InitializeDAQInfo(handles);%puts data into empty fields above
        
        %calibrationinfo
        [T_W2pmi, T_di2ami, T_F2W, T_LS2W] = frameTransformations(handles);%conversion between local acceleration readings to plate accelerations??
        handles.calibrationinfo.T_W2pmi = T_W2pmi;%transforms accelerations in world frame to accelerations in measured plate frames
        handles.calibrationinfo.T_di2ami = T_di2ami;%transforms accelerations along axes of actuators to accelerations in measured actuator frames
        handles.calibrationinfo.T_F2W = T_F2W;%transforms wrenches in F frame to wrenches in world frame
        handles.calibrationinfo.T_LS2W = T_LS2W;%transforms positions in laser sensor frame to positions in world frame
        handles.calibrationinfo.V_per_ms2 = 0.01;%volts per m/s^2 of accelerometers
        handles.calibrationinfo.FsensorCrosstalk = [0.0415545, -1.3084753, -0.0209014, 1.3708784, -0.0007212, -0.0037188;
            0.0153681, -0.7556705, 0.0205839, -0.7789058, -0.0193142, 1.5373701;
            -2.3604085, 0.0834155, -2.4158316, 0.0624050, -2.3448311, -0.0132399;
            -1.3171405, -0.1171120, 1.3567893, -0.1945159, -0.0251065,0.3247306;
            -0.7579343,	0.3042172, -0.7516815, -0.2737271, 1.5049942, 0.0110706;
            -0.0274613, 0.7175862, -0.0193200, 0.7383569, -0.0119917, 0.7391482]'; %transposed from Matt's
        handles.calibrationinfo.lbf2N = 4.448;
        handles.calibrationinfo.lbfin2Nm = 0.1129;
        handles.calibrationinfo.V2m_LS = 0.005; %volts per meter for laser sensor
        handles.calibrationinfo.diInit = [];%stationary reading of laser sensor
        handles.calibrationinfo.SMR = .045; %start off measuring range for laser sensor (position offset)
        
        %camerainfo
        handles.camerainfo.fps = f1_ui;
    otherwise
        error('selection does not match any case')
end