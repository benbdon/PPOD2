function handles = InitializeGUI(handles)

%*********************************************************************
%DEFINE HANDLES STRUCTURE
%*********************************************************************

%globalinfo
handles.globalinfo.aiConfig = 'standard';%can be 'standard' or 'force'
handles.globalinfo.aoConfig = 'standard';%can be 'standard' or 'camera'
handles.globalinfo.mode = 'PddControl';%can be 'PddControl','diddControl','uiControl','uiAddFreqs','diddAddFreqs','PddAddFreqs'
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
handles.controllerinfo.GdiddInputMag = 2;%input actuator acceleration used to generate transfer functions
handles.controllerinfo.numTransientCycles = 10;%number of cycles to wait after control signal is updated before collecting data
handles.controllerinfo.numCollectedCycles = 5;%number of cycles collected
handles.controllerinfo.numProcessingCycles = 25;%number of cycles after data collection during which time new control is computed
handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
handles.controllerinfo.maxUpdate = 1000;%number of updates before controller stops
handles.controllerinfo.currentUpdate = 0;%current controller update

%signalinfo
handles.signalinfo.T = 1/f1_ui;%cycle time (period)
handles.signalinfo.constants = {'w = 2*pi*f'};
handles.signalinfo.samplingFreq = 9000;%DAQ sampling rate (Hz)
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
handles.signalinfo.fCyc = zeros(SPC, NFS);%one cycle of force data (columns correspond to forceSignals)
handles.signalfinfo.diCyc = zeros(SPC,NDIS);%one cycle of laser sensor data

%daqinfo
handles.daqinfo.aoChannelNames = [];%analog output channel names
handles.daqinfo.aiChannelNames = [];%analog input channel names
handles.daqinfo.ao = [];%analog output object
handles.daqinfo.ai = [];%analog input object
handles.daqinfo = Initializedaqinfo(handles);%puts data into empty fields above

%calibrationinfo
[T_W2pmi, T_di2ami] = frameTransformations(handles);%conversion between local acceleration readings to plate accelerations??
handles.calibrationinfo.T_W2pmi = T_W2pmi;
handles.calibrationinfo.T_di2ami = T_di2ami;
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
%handles.calibrationinfo.V2m

%camerainfo
handles.camerainfo.fps = f1_ui;


%**************************************************************************
%UPDATE GUI PANELS
%**************************************************************************
%update Analog Input Mode panel in GUI
set(handles.standardModeAI,'value',1,'enable','on');
set(handles.forceModeAI,'value',0,'enable','on');

%update Analog Output Mode panel in GUI
set(handles.standardModeAO,'value',1,'enable','on')
set(handles.cameraModeAO,'value',0,'enable','on')
if handles.camerainfo.fps > 20
    handles.camerainfo.fps = 15;
end
set(handles.fps,'string',num2str(handles.camerainfo.fps),'enable','off')

%update Sampling panel in GUI
set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq),'enable','on')
set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle),'enable','on')
set(handles.numTransientCycles,'string',handles.controllerinfo.numTransientCycles,'enable','on')
set(handles.numCollectedCycles,'string',handles.controllerinfo.numCollectedCycles,'enable','on')
set(handles.numProcessingCycles,'string',handles.controllerinfo.numProcessingCycles,'enable','on')
set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate),'enable','on')
set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T),'enable','on')

%update Controller Parameters panel in GUI
set(handles.uiHarmonics,'string',mat2str(handles.controllerinfo.uiHarmonics),'enable','on')
set(handles.F_ui,'string',[mat2str(handles.controllerinfo.F_ui),' Hz'],'enable','on')
set(handles.useNonlinearHarmonicTerms,'value',0,'enable','on')
set(handles.k,'string',num2str(handles.controllerinfo.k),'enable','on')
set(handles.uMax,'string',num2str(handles.controllerinfo.uMax),'enable','on')
set(handles.uiInitial_previous,'Value',0,'enable','on')
set(handles.uiInitial_guess,'Value',0,'enable','on')
set(handles.uiInitial_zero,'Value',1,'enable','on')
set(handles.uiInitial_user','value',0,'enable','off')

%update Desired Signals panel in GUI
set(handles.desSignals_Pdd,'value',1,'enable','on')%sets initial desired signal type to plate acclerations
set(handles.desSignals_didd,'value',0,'enable','on')
set(handles.desSignals_ui,'value',0,'enable','on')
set(handles.platemotionfilename,'string',handles.globalinfo.filename)
set(handles.T,'string',char(sym(handles.signalinfo.T)),'enable','on')
for i = 1:numel(handles.globalinfo.PddSignals)
    set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.PddSignals{i},' = '],'enable','on')
    set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.PddDesChar{i},'enable','on')
end
set(handles.constants,'string',handles.signalinfo.constants,'enable','on')
set(handles.savedhandles_listbox','enable','on')
load_listbox(handles) %load saved plate motions

%update Actuation panel in GUI
set(handles.maxUpdate,'string',num2str(handles.controllerinfo.maxUpdate),'enable','on')
set(handles.currentUpdate,'string',num2str(handles.controllerinfo.currentUpdate),'enable','on')
set(handles.run,'value',0,'enable','on')

%update Frequency Response panel in GUI
set(handles.uiAddFreqs,'value',0,'enable','on')
set(handles.uiDeleteFreqs,'value',0,'enable','on')
set(handles.diddAddFreqs,'value',0,'enable','on')
set(handles.diddDeleteFreqs,'value',0,'enable','on')
set(handles.diddErrorTol,'string',num2str(0.025),'enable','on')
set(handles.maxUpdatediddAddFreqs,'string',20,'enable','on')
set(handles.currentUpdatediddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate))
set(handles.PddAddFreqs,'value',0,'enable','on')
set(handles.PddDeleteFreqs,'value',0,'enable','on')
set(handles.PddErrorTol,'string',num2str(0.025),'enable','on')
set(handles.maxUpdatePddAddFreqs,'string',20,'enable','on')
set(handles.currentUpdatePddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate))
set(handles.viewTransferFunctions,'enable','on')

%update Acceleration Signals panel in GUI
set(handles.plottedSignals_Pdd,'Value',1)%selects plate acceleration for initial plots
set(handles.timeDomain,'Value',1)%selects time domain for initial plots
set(handles.plottedHarmonics,'string',['[0:',num2str(max(5,max(handles.controllerinfo.uiHarmonics)*2)),']'],'enable','off')
set(handles.plottedHarmonicsText,'enable','off')
set(handles.currentError,'string','')
set(handles.updatePlots,'value',1)

%initialize plots
InitializePlotControlSignals(handles);
InitializePlotAccSignals(handles);
if strcmp(handles.globalinfo.aiConfig,'force')
    InitializePlotForceSignals(handles);
    InitializePlotLaserSignals(handles);
end
