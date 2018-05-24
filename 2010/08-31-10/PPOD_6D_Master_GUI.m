function varargout = PPOD_6D_Master_GUI(varargin)
% PPOD_6D_MASTER_GUI M-file for PPOD_6D_Master_GUI.fig
%      PPOD_6D_MASTER_GUI, by itself, creates a new PPOD_6D_MASTER_GUI or raises the existing
%      singleton*.
%
%      H = PPOD_6D_MASTER_GUI returns the handle to a new PPOD_6D_MASTER_GUI or the handle to
%      the existing singleton*.
%
%      PPOD_6D_MASTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PPOD_6D_MASTER_GUI.M with the given input arguments.
%
%      PPOD_6D_MASTER_GUI('Property','Value',...) creates a new PPOD_6D_MASTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PPOD_6D_Master_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PPOD_6D_Master_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PPOD_6D_Master_GUI

% Last Modified by GUIDE v2.5 01-Sep-2010 10:57:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PPOD_6D_Master_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PPOD_6D_Master_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PPOD_6D_Master_GUI is made visible.
function PPOD_6D_Master_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PPOD_6D_Master_GUI (see VARARGIN)

clc
%*********************************************************************
%DEFINE HANDLES STRUCTURE
%*********************************************************************

%globalinfo
handles.globalinfo.controlSignals = {'u1','u2','u3','u4','u5','u6'};%control signals (pre-amplified voltages)
handles.globalinfo.plateAccLocalSignals = {'x1dd','y1dd','x2dd','y2dd','x3dd','y3dd','x4dd','y4dd','x5dd','y5dd','x6dd','y6dd'};%accelerations measured by accelerometers mounted around the plate
handles.globalinfo.plateAccSignals = {'pddx','pddy','pddz','alphax','alphay','alphaz'};%xyzrpy accleration of plate
handles.globalinfo.actuatorAccSignals = {'d1dd','d2dd','d3dd','d4dd','d5dd','d6dd'};%accelerations along actuator shafts
handles.globalinfo.date = date;%date
handles.globalinfo.usernotes = [];%user notes
handles.globalinfo.filename = 'Temp';

%controllerinfo
freqResponseData = load([cd,'\freqResponseData\freqResponseData']);%load data for the four variables below
handles.controllerinfo.F_all = freqResponseData.F_all; %set of frequencies for which responses have been measured
handles.controllerinfo.G_u2acc_all = freqResponseData.G_u2acc_all;%set of discrete transfer functions from u to xyzrpy plate acceleration
handles.controllerinfo.G_u2accLocal_all = freqResponseData.G_u2accLocal_all;%set of discrete transfer functions from u to plate accelerometers
handles.controllerinfo.G_u2ddd_all = freqResponseData.G_u2ddd_all;%set of discrete transwer functions from u to actuator accelerometers
handles.controllerinfo.harmonicsPerFreq = 5;
handles.controllerinfo.controlledHarmonics = 1;%set of harmonics actively controlled
F_all = handles.controllerinfo.F_all;
f1 = min(F_all(F_all>=20));
if isempty(f1)
    f1 = F_all(1);
end
handles.controllerinfo.F = f1;%set of frequencies actively controlled
handles.controllerinfo.uMax = 6;%maximum allowed pre-amplified control voltage (saturation limit)
handles.controllerinfo.k = .25;%controller gain
handles.controllerinfo.GInputMag = .5;%input voltage used to generate transfer functions
handles.controllerinfo.numTransientCycles = 10;%number of cycles to wait after control signal is updated before collecting data
handles.controllerinfo.numCollectedCycles = 5;%number of cycles collected
handles.controllerinfo.numProcessingCycles = 25;%number of cycles after data collection during which time new control is computed
handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
handles.controllerinfo.maxUpdate = 1000;%number of updates before controller stops
handles.controllerinfo.currentUpdate = 0;%current controller update

%signalinfo
handles.signalinfo.T = 1/f1;%cycle time (period)
handles.signalinfo.fps = f1;%frames per second trigger rate for camera
handles.signalinfo.constants = {'w = 2*pi*f'};
handles.signalinfo.samplingFreq = 9000;%DAQ sampling rate (Hz)
handles.signalinfo.dt = 1/handles.signalinfo.samplingFreq;%time between samples (s)
handles.signalinfo.tCyc = (0:handles.signalinfo.dt:handles.signalinfo.T - handles.signalinfo.dt)';%one cycle of time data
handles.signalinfo.samplesPerCycle = length(handles.signalinfo.tCyc);
handles.signalinfo.aCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccSignals));%one cycle of plate acceleration data (columns correspond to plateAccSignals)
handles.signalinfo.adesCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccSignals));%one cycle of desired plate acceleration data (columns correspond to plateAccSignals)
handles.signalinfo.aLocalCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccLocalSignals));%one cycle of local plate acceleration data (columns correspond to plateAccLocalSignals)
handles.signalinfo.dddCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.actuatorAccSignals));%one cycle of actuator acceleration data (columns correspond to actuatorAccSignals)
handles.signalinfo.uCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.controlSignals));%one cycle of control data (columns correspond to controlSignals)
handles.signalinfo.adesChar = {'0', '0', '0', '0', '0', '0'};
handles.signalinfo.udesChar = {'0', '0', '0', '0', '0', '0'};
handles.signalinfo.ddddesChar = {'0', '0', '0', '0', '0', '0'};

%daqinfo
handles.daqinfo.aoChannelNames = [];%analog output channel names
handles.daqinfo.aiChannelNames = [];%analog input channel names
handles.daqinfo.ao = [];%analog output object
handles.daqinfo.ai = [];%analog input object
handles.daqinfo = Initializedaqinfo(handles);%puts data into empty fields above

%calibrationinfo
handles.calibrationinfo.A = L2Wconverter(handles);%conversion between local acceleration readings to plate accelerations??
handles.calibrationinfo.V_per_ms2 = 0.01;%volts per m/s^2 of accelerometers

%**************************************************************************
%UPDATE GUI PANELS
%**************************************************************************

%update Acceleration Signals panel in GUI
set(handles.plateAcc,'Value',1)%selects plate acceleration for initial plots
set(handles.timeDomain,'Value',1)%selects time domain for initial plots
set(handles.plottedHarmonics,'string',['[0:',num2str(max(10,max(handles.controllerinfo.controlledHarmonics)*5)),']'],'enable','off')
set(handles.plottedHarmonicsText,'enable','off')

%update Sampling panel in GUI
set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq))
set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle))
set(handles.numTransientCycles,'string',handles.controllerinfo.numTransientCycles)
set(handles.numCollectedCycles,'string',handles.controllerinfo.numCollectedCycles)
set(handles.numProcessingCycles,'string',handles.controllerinfo.numProcessingCycles)
set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T))

%update Controller Parameters panel in GUI
set(handles.controlledHarmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
set(handles.F,'string',[mat2str(handles.controllerinfo.F),' Hz'])
set(handles.harmonicsPerFreq,'string',num2str(handles.controllerinfo.harmonicsPerFreq))
set(handles.k,'string',num2str(handles.controllerinfo.k))
set(handles.uMax,'string',num2str(handles.controllerinfo.uMax))
set(handles.zero,'Value',1)%selects initial control signals to be zero
set(handles.userSpecified','enable','off')

%update Camera Triggering panel in GUI
if handles.signalinfo.fps > 20
    handles.signalinfo.fps = 15;
end
set(handles.fps,'string',num2str(handles.signalinfo.fps))

%update Desired Signals panel in GUI
set(handles.plateAccelerations,'value',1)%sets initial desired signal type to plate acclerations
set(handles.platemotionfilename,'string',handles.globalinfo.filename)
set(handles.T,'string',char(sym(handles.signalinfo.T)))
for i = 1:numel(handles.globalinfo.plateAccSignals)
    set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.adesChar{i})
end
set(handles.constants,'string',handles.signalinfo.constants)

%update Frequency Response panel in GUI
set(handles.F_all,'string',mat2str(handles.controllerinfo.F_all))

%update actuation panel in GUI
set(handles.maxUpdate,'string',num2str(handles.controllerinfo.maxUpdate))
set(handles.currentUpdate,'string',num2str(handles.controllerinfo.currentUpdate))
set(handles.updatePlots,'value',1)

%initialize plots
InitializePlotControlSignals(handles);
InitializePlotAccSignals(handles);

%load saved plate motions into listbox
load_listbox(handles)

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = PPOD_6D_Master_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles;


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')
    set(hObject,'string','Stop')
    set(handles.actuatorAccelerations,'enable','off')
    set(handles.actuatorVoltages,'enable','off')
    set(handles.T,'enable','off')
    set(handles.samplingFreq,'enable','off')
    set(handles.numCollectedCycles,'enable','off')
    
    handles = PPODcontroller(handles);
else
    set(hObject,'string','Run')
    set(handles.actuatorAccelerations,'enable','on')
    set(handles.actuatorVoltages,'enable','on')
    set(handles.T,'enable','on')
    set(handles.samplingFreq,'enable','on')
    set(handles.numCollectedCycles,'enable','on')
end

guidata(hObject, handles)


function maxUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to maxUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxUpdate as text
%        str2double(get(hObject,'String')) returns contents of maxUpdate as a double

maxUpdate = str2double(get(hObject,'String'));

if ~isnan(maxUpdate)
    handles.controllerinfo.maxUpdate = maxUpdate;
else
    %if user input was not a scalar, reset maxUpdate to previous value
    set(hObject,'string',num2str(handles.controllerinfo.maxUpdate))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function samplingFreq_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplingFreq as text
%        str2double(get(hObject,'String')) returns contents of samplingFreq as a double

samplingFreq = str2double(get(hObject,'String'));

%make sure user input is valid
if isnan(samplingFreq)
    %if user input was not a scalar, reset to previous value
    set(hObject,'string',num2str(handles.signalinfo.samplingFreq))
    return
end

%first test if the value has been changed
if samplingFreq ~= handles.signalinfo.samplingFreq
    
    %update daqinfo
    handles.signalinfo.samplingFreq = samplingFreq;
    handles.daqinfo.ai.SampleRate = samplingFreq;
    handles.daqinfo.ao.SampleRate = samplingFreq;

    %update signalinfo
    T = handles.signalinfo.T;
    dt = 1/samplingFreq;
    handles.signalinfo.tCyc = 0:dt:T-dt;
    tCyc = handles.signalinfo.tCyc;
    t = tCyc; %so that you can evaluate desired signals
    handles.signalinfo.samplesPerCycle = length(tCyc);
    handles.globalinfo.filename = 'temp';

    %update signalinfo
    plateAccSignals = handles.globalinfo.plateAccSignals;
    plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
    actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
    controlSignals = handles.globalinfo.controlSignals;

    handles.signalinfo.aCyc = zeros(length(tCyc),numel(plateAccSignals));
    handles.signalinfo.aLocalCyc = zeros(length(tCyc), numel(plateAccLocalSignals));
    handles.signalinfo.dddCyc = zeros(length(tCyc), numel(actuatorAccSignals));
    handles.signalinfo.uCyc = zeros(length(tCyc), numel(controlSignals));
    handles.signalinfo.adesCyc = zeros(length(tCyc), numel(plateAccSignals));

    constants = handles.signalinfo.constants;
    f = 1/handles.signalinfo.T;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    
    signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
    for i = 1:numel(plateAccSignals)
        switch signals
            case 'plateAccelerations'
                handles.signalinfo.adesCyc(:,i) = eval(handles.signalinfo.desChar{i}).*ones(size(tCyc));
            case 'actuatorAccelerations'
            case 'actuatorVoltages'
                handles.signalinfo.uCyc(:,i) = eval(handles.signalinfo.desChar{i}).*ones(size(tCyc));
        end
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.globalinfo.filename);

    %update sampling panel in GUI
    set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq))
    set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle))

    %update control signals in GUI
    PlotControlSignals(handles)

    %update plate signals in GUI
    PlotAccSignals(handles)

end

guidata(hObject,handles)

% --- Executes on selection change in constants.
function constants_Callback(hObject, eventdata, handles)
% hObject    handle to constants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns constants contents as cell array
%        contents{get(hObject,'Value')} returns selected item from constants

constants = get(hObject,'String');

%first test if the value has been changed
if ~strcmp(char(constants),char(handles.signalinfo.constants))

    %update signalinfo
    handles.signalinfo.constants = constants;
    handles.globalinfo.filename = 'temp';

    %update signalinfo
    plateAccSignals = handles.globalinfo.plateAccSignals;
    plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
    actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
    controlSignals = handles.globalinfo.controlSignals;
    
    t = handles.signalinfo.tCyc; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(plateAccSignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(plateAccLocalSignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(actuatorAccSignals));
    handles.signalinfo.u = zeros(length(t), numel(controlSignals));
    
    constants = handles.signalinfo.constants;
    f = 1/handles.signalinfo.T;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(plateAccSignals)
        handles.signalinfo.d(:,i) = eval(handles.signalinfo.d_char{i}).*ones(size(t));
    end
    
    %make sure d has no NaN entries (e.g., from heaviside functions)
    nanind = find(isnan(handles.signalinfo.d));
    if ~isempty(nanind)
        handles.signalinfo.d(nanind) = handles.signalinfo.d(nanind+1);
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.globalinfo.filename);

    %update control signals in GUI
    PlotControlSignals(handles)

    %update plate signals in GUI
    PlotAccSignals(handles)

end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function constants_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in savedhandles_listbox.
function savedhandles_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to savedhandles_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns savedhandles_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from savedhandles_listbox

handles = load_signals(handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function savedhandles_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedhandles_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function desSignalChar1_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar1 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar1 as a double
        
%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function desSignalChar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function desSignalChar2_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar2 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar2 as a double

%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function desSignalChar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function desSignalChar3_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar3 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar3 as a double

%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function desSignalChar3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function desSignalChar4_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar4 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar4 as a double

%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function desSignalChar4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function desSignalChar5_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar5 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar5 as a double

%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function desSignalChar5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function desSignalChar6_Callback(hObject, eventdata, handles)
% hObject    handle to desSignalChar6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desSignalChar6 as text
%        str2double(get(hObject,'String')) returns contents of desSignalChar6 as a double

%if text box for desired signal was left empty, make it a zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'actuatorVoltages'
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
end

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.globalinfo.filename);

if ~get(handles.run,'value')
    %update control signals in GUI
    PlotControlSignals(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function desSignalChar6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desSignalChar6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_Callback(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T as text
%        str2double(get(hObject,'String')) returns contents of T as a double

T = eval(get(hObject,'String'));
f1 = sym(1/T);

%first test if the value has been changed
if T ~= handles.signalinfo.T
    
    F_all = handles.controllerinfo.F_all;

    %make sure the new base frequency is in Gnfreqs; if not, reset to old
    %frequency and do not update anything
    if isempty(F_all(f1 == F_all))
        warndlg({['There is no frequency response data for ',num2str(eval(f1)),' Hz.'];
            ['Period will be reset to ',char(sym(handles.signalinfo.T)),'s']})
        uiwait
        set(handles.T,'string',char(sym(handles.signalinfo.T)))
    else
        
        %update signalinfo
        handles.signalinfo.T = T;
        dt = handles.signalinfo.dt;
        handles.signalinfo.tCyc = 0:dt:T-dt;
        tCyc = handles.signalinfo.tCyc;

        handles.signalinfo.samplesPerCycle = length(tCyc);
        handles.globalinfo.filename = 'temp';
        
        %update controllerinfo
        F = handles.controllerinfo.controlledHarmonics*f1;
        discardFreqs = F(~ismember(F,F_all));
        discardHarmonics = discardFreqs/f1;
        F = F(ismember(F,F_all));
        controlledHarmonics = F/f1;
        if ~isempty(discardHarmonics)
            warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
                [mat2str(eval(discardHarmonics)),' (',mat2str(eval(discardFreqs)),' Hz)']})
            uiwait
        end
        handles.controllerinfo.F = eval(F);
        handles.controllerinfo.controlledHarmonics = eval(controlledHarmonics);
        
        %update control signals panel in GUI
        if length(F) == 1
            set(handles.controlledHarmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
        else
            set(handles.controlledHarmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
        end
        set(handles.F,'string',[mat2str(handles.controllerinfo.F),' Hz'])
        
        %update signalinfo
        plateAccSignals = handles.globalinfo.plateAccSignals;
        plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
        actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
        controlSignals = handles.globalinfo.controlSignals;

        handles.signalinfo.samplesPerCycle = length(tCyc);
        handles.signalinfo.aCyc = zeros(handles.signalinfo.samplesPerCycle,numel(plateAccSignals));
        handles.signalinfo.aLocalCyc = zeros(handles.signalinfo.samplesPerCycle, numel(plateAccLocalSignals));
        handles.signalinfo.dddCyc = zeros(handles.signalinfo.samplesPerCycle, numel(actuatorAccSignals));
        handles.signalinfo.uCyc = zeros(handles.signalinfo.samplesPerCycle, numel(controlSignals));
        handles.signalinfo.adesCyc = zeros(handles.signalinfo.samplesPerCycle, numel(plateAccSignals));

        %update desired signals
        switch get(get(handles.desiredSignalSelector,'selectedobject'),'tag')
            case 'plateAccelerations'
                [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
            case 'actuatorAccelerations'
                warndlg('feature not yet working')
                return
            case 'actuatorVoltages'
                [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        end

        %update plate motion panel in GUI
        set(handles.T,'string',char(sym(handles.signalinfo.T)))
        set(handles.platemotionfilename,'string',handles.globalinfo.filename);

        %update sampling panel in GUI
        set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle))
        
        %update control signals panel in GUI
        if length(F) == 1
            set(handles.controlledHarmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
        else
            set(handles.controlledHarmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
        end
        set(handles.F,'string',[mat2str(handles.controllerinfo.F),' Hz'])

        %update control signals in GUI
        InitializePlotControlSignals(handles)
        PlotControlSignals(handles)
        
        %update plate signals in GUI
        PlotAccSignals(handles)
    end
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in floatAxes.
function floatAxes_Callback(hObject, eventdata, handles)
% hObject    handle to floatAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotAccSignals(handles)
PlotControlSignals(handles)


function controlledHarmonics_Callback(hObject, eventdata, handles)
% hObject    handle to controlledHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of controlledHarmonics as text
%        str2double(get(hObject,'String')) returns contents of controlledHarmonics as a double

f1 = sym(1/handles.signalinfo.T);
controlledHarmonics = sort(eval(get(hObject,'String')));
F = f1*controlledHarmonics;
F_all = handles.controllerinfo.F_all;

discardFreqs = F(~ismember(F,F_all));
discardHarmonics = discardFreqs/f1;
F = F(ismember(F,F_all));
controlledHarmonics = F/f1;
if ~isempty(discardHarmonics)
    warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
        [mat2str(eval(discardHarmonics)),' (',mat2str(eval(discardFreqs)),' Hz)']})
    uiwait
end
handles.controllerinfo.F = eval(F);
handles.controllerinfo.controlledHarmonics = eval(controlledHarmonics);

%update control signals panel in GUI
if length(F) == 1
    set(handles.controlledHarmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
else
    set(handles.controlledHarmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
end
set(handles.F,'string',[mat2str(handles.controllerinfo.F),' Hz'])


guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function controlledHarmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controlledHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addFreqResponseData.
function addFreqResponseData_Callback(hObject, eventdata, handles)
% hObject    handle to addFreqResponseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(hObject,'enable','off')

GInputMag = handles.controllerinfo.GInputMag;
freqsOld = handles.controllerinfo.F_all;
F = handles.controllerinfo.F;
answer = inputdlg({'New frequencies to add:';'Input voltage:'},'Frequency Response Data Collection',[1],{mat2str(F);num2str(GInputMag)});

if isempty(answer)
    set(hObject,'value',0,'enable','on')
    return
else
    freqsNew = eval(answer{1});
    handles.controllerinfo.GInputMag = eval(answer{2});
    
    F_all = sort(unique([freqsOld,freqsNew]));
    indsNew = find(ismember(F_all,freqsNew));
    
    G_u2accOld = handles.controllerinfo.G_u2acc_all;
    G_u2accLocalOld = handles.controllerinfo.G_u2accLocal_all;
    G_u2dddOld = handles.controllerinfo.G_u2ddd_all;
    
    %store current user-selections/value to be reset later
    desSignal = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
    initialControl = get(get(handles.initialcontrol,'selectedobject'),'tag');
    signalinfo = handles.signalinfo;
    
    %reset radio buttons for duration of transfer function generation
    set(handles.actuatorVoltages,'value',1)
    set(handles.userSpecified,'enable','on','value',1)
    
    set(handles.plateAccelerations,'enable','off')
    set(handles.actuatorAccelerations,'enable','off')
    set(handles.previous,'enable','off')
    set(handles.guess,'enable','off')
    set(handles.zero,'enable','off')
    
    set(handles.T,'enable','off')
    set(handles.numCollectedCycles,'enable','off')
    set(handles.k,'enable','off')
    set(handles.run,'enable','off')
    set(handles.viewFreqResponseData,'enable','off')
    set(handles.samplingFreq,'enable','off')
    set(handles.controlledHarmonics,'enable','off')
    
    %update desired signal text
    set(handles.desSignalText1,'string','u1 = ')
    set(handles.desSignalText2,'string','u2 = ')
    set(handles.desSignalText3,'string','u3 = ')
    set(handles.desSignalText4,'string','u4 = ')
    set(handles.desSignalText5,'string','u5 = ')
    set(handles.desSignalText6,'string','u6 = ')
    
    set(handles.desSignalChar1,'string','0')
    set(handles.desSignalChar2,'string','0')
    set(handles.desSignalChar3,'string','0')
    set(handles.desSignalChar4,'string','0')
    set(handles.desSignalChar5,'string','0')
    set(handles.desSignalChar6,'string','0')
    
    %loop to collect new transfer function data
    NPAS = length(handles.globalinfo.plateAccSignals);
    NCS = length(handles.globalinfo.controlSignals);
    NPALS = length(handles.globalinfo.plateAccLocalSignals);
    NAAS = length(handles.globalinfo.actuatorAccSignals);
    
    NOHPF = size(handles.controllerinfo.G_u2acc_all,4); %number of harmonics recorded per frequency
    G_u2accNew = zeros(NPAS,NCS,length(freqsNew), NOHPF);
    G_u2accLocalNew = zeros(NPALS,NCS,length(freqsNew),NOHPF);
    G_u2dddNew = zeros(NAAS,NCS,length(freqsNew),NOHPF);
    
    dt = 1/handles.signalinfo.samplingFreq;
    for in = 1:length(freqsNew)
        for i = 1:NCS
            f = freqsNew(in);
            handles.signalinfo.T = 1/f;
            T = handles.signalinfo.T;
            set(handles.T,'string',char(sym(T)));
            tCyc = 0:dt:T-dt;
            handles.signalinfo.tCyc = tCyc;
            handles.signalinfo.samplesPerCycle = length(tCyc);
            handles.signalinfo.uCyc = zeros(handles.signalinfo.samplesPerCycle,NCS);
            handles.signalinfo.uCyc(:,i) = GInputMag*sin(2*pi*f*tCyc);
            handles.signalinfo.adesCyc = 0*handles.signalinfo.uCyc;
            
            udesChari = [num2str(GInputMag),'sin(2*pi*',char(sym(f)),'*t)'];
            eval(['set(handles.desSignalChar',num2str(i),',''string'',udesChari)'])
            
            handles = PPODcontroller(handles);
            
            eval(['set(handles.desSignalChar',num2str(i),',''string'',''0'')'])
            
            aCyc_fft = fft(handles.signalinfo.aCyc);
            aLocalCyc_fft = fft(handles.signalinfo.aLocalCyc);
            dddCyc_fft = fft(handles.signalinfo.dddCyc);
            uCyc_fft = fft(handles.signalinfo.uCyc);
            
            %note that NCC = 1 because Cyc signals are getting FFTed
            for out = 1:NOHPF
                fftIndIn = 2; %always want first harmonic of input signal
                fftIndOut = out+1; %cycle through harmonics of output signal
                G_u2accNew(:,i,in,out) = aCyc_fft(fftIndOut,:)/uCyc_fft(fftIndIn,i);
                G_u2accLocalNew(:,i,in,out) = aLocalCyc_fft(fftIndOut,:)/uCyc_fft(fftIndIn,i);
                G_u2dddNew(:,i,in,out) = dddCyc_fft(fftIndOut,:)/uCyc_fft(fftIndIn,i);
            end
        end
    end
    
    %merge old and new transfer functions
    for in = 1:length(F_all)
        if ismember(in,indsNew)
            ind = find(freqsNew==F_all(in));
            handles.controllerinfo.F_all(in) = freqsNew(ind);
            handles.controllerinfo.G_u2acc_all(:,:,in,:) = G_u2accNew(:,:,ind,:);
            handles.controllerinfo.G_u2accLocal_all(:,:,in,:) = G_u2accLocalNew(:,:,ind,:);
            handles.controllerinfo.G_u2ddd_all(:,:,i,:) = G_u2dddNew(:,:,ind,:);
        else
            ind = find(freqsOld==F_all(in));
            handles.controllerinfo.F_all(in) = freqsOld(ind);
            handles.controllerinfo.G_u2acc_all(:,:,in,:) = G_u2accOld(:,:,ind,:);
            handles.controllerinfo.G_u2accLocal_all(:,:,in,:) = G_u2accLocalOld(:,:,ind,:);
            handles.controllerinfo.G_u2ddd_all(:,:,in,:) = G_u2dddOld(:,:,ind,:);
        end
    end
    
    G_u2acc_all = handles.controllerinfo.G_u2acc_all;
    G_u2accLocal_all = handles.controllerinfo.G_u2accLocal_all;
    G_u2ddd_all = handles.controllerinfo.G_u2ddd_all;
    save([cd,'\freqResponseData\freqResponseData'],'F_all','G_u2acc_all','G_u2accLocal_all','G_u2ddd_all','GInputMag')
    
    set(handles.F_all,'string',mat2str(handles.controllerinfo.F_all))
    
    %put signalinfo data back into handles as it was before
    handles.signalinfo = signalinfo;
    set(handles.T,'string',char(sym(handles.signalinfo.T)));
    
    set(handles.T,'enable','on')
    set(handles.numCollectedCycles,'enable','on')
    set(handles.k,'enable','on')
    set(handles.run,'enable','on')
    set(handles.viewFreqResponseData,'enable','on')
    set(handles.samplingFreq,'enable','on')
    set(handles.controlledHarmonics,'enable','on')
    
    %return desired signal selector to its original state
    set(handles.(desSignal),'value',1)
    set(handles.(initialControl),'value',1)
    %return desired signal text to its original state
    switch desSignal
        case 'plateAccelerations'
            set(handles.desSignalText1,'string','pddx = ')
            set(handles.desSignalText2,'string','pddy = ')
            set(handles.desSignalText3,'string','pddz = ')
            set(handles.desSignalText4,'string','alphax = ')
            set(handles.desSignalText5,'string','alphay = ')
            set(handles.desSignalText6,'string','alphaz = ')
            
            set(handles.userSpecified,'enable','off')
            set(handles.plateAccelerations,'enable','on')
            set(handles.actuatorAccelerations,'enable','on')
            set(handles.actuatorVoltages,'enable','on')
            set(handles.previous,'enable','on')
            set(handles.guess,'enable','on')
            set(handles.zero,'enable','on')
            set(handles.userSpecified,'enable','off')
            
            set(handles.desSignalChar1,'string',handles.signalinfo.adesChar{1})
            set(handles.desSignalChar2,'string',handles.signalinfo.adesChar{2})
            set(handles.desSignalChar3,'string',handles.signalinfo.adesChar{3})
            set(handles.desSignalChar4,'string',handles.signalinfo.adesChar{4})
            set(handles.desSignalChar5,'string',handles.signalinfo.adesChar{5})
            set(handles.desSignalChar6,'string',handles.signalinfo.adesChar{6})
            
        case 'actuatorAccelerations'
            set(handles.desSignalText1,'string','d1dd = ')
            set(handles.desSignalText2,'string','d2dd = ')
            set(handles.desSignalText3,'string','d3dd = ')
            set(handles.desSignalText4,'string','d4dd = ')
            set(handles.desSignalText5,'string','d5dd = ')
            set(handles.desSignalText6,'string','d6dd = ')
            
            set(handles.userSpecified,'enable','off')
            set(handles.plateAccelerations,'enable','on')
            set(handles.actuatorAccelerations,'enable','on')
            set(handles.actuatorVoltages,'enable','on')
            set(handles.previous,'enable','on')
            set(handles.guess,'enable','on')
            set(handles.zero,'enable','on')
            set(handles.userSpecified,'enable','off')
            
            set(handles.desSignalChar1,'string',handles.signalinfo.ddddesChar{1})
            set(handles.desSignalChar2,'string',handles.signalinfo.ddddesChar{2})
            set(handles.desSignalChar3,'string',handles.signalinfo.ddddesChar{3})
            set(handles.desSignalChar4,'string',handles.signalinfo.ddddesChar{4})
            set(handles.desSignalChar5,'string',handles.signalinfo.ddddesChar{5})
            set(handles.desSignalChar6,'string',handles.signalinfo.ddddesChar{6})
            
        case 'actuatorVoltages'
            set(handles.actuatorVoltages,'value',1)
            set(handles.desSignalText1,'string','u1 = ')
            set(handles.desSignalText2,'string','u2 = ')
            set(handles.desSignalText3,'string','u3 = ')
            set(handles.desSignalText4,'string','u4 = ')
            set(handles.desSignalText5,'string','u5 = ')
            set(handles.desSignalText6,'string','u6 = ')
            
            set(handles.userSpecified,'enable','on')
            set(handles.plateAccelerations,'enable','on')
            set(handles.actuatorAccelerations,'enable','on')
            set(handles.actuatorVoltages,'enable','on')
            set(handles.previous,'enable','off')
            set(handles.guess,'enable','off')
            set(handles.zero,'enable','off')
            set(handles.userSpecified,'enable','on')
            
            set(handles.desSignalChar1,'string',handles.signalinfo.udesChar{1})
            set(handles.desSignalChar2,'string',handles.signalinfo.udesChar{2})
            set(handles.desSignalChar3,'string',handles.signalinfo.udesChar{3})
            set(handles.desSignalChar4,'string',handles.signalinfo.udesChar{4})
            set(handles.desSignalChar5,'string',handles.signalinfo.udesChar{5})
            set(handles.desSignalChar6,'string',handles.signalinfo.udesChar{6})
    end
    
    guidata(hObject, handles)
end
set(hObject,'value',0,'enable','on')


% --- Executes on button press in exporthandles.
function exporthandles_Callback(hObject, eventdata, handles)
% hObject    handle to exporthandles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','handles',handles)

% --- Executes on button press in viewFreqResponseData.
function viewFreqResponseData_Callback(hObject, eventdata, handles)
% hObject    handle to viewFreqResponseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ViewGn_GUI(handles)


function uMax_Callback(hObject, eventdata, handles)
% hObject    handle to uMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uMax as text
%        str2double(get(hObject,'String')) returns contents of uMax as a double

uMax = str2double(get(hObject,'String'));

%first test if the value has been changed
if uMax ~= handles.controllerinfo.uMax
    handles.controllerinfo.uMax = uMax;
end

if ~get(handles.run,'value')
    PlotControlSignals(handles)
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function uMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function samplingFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savesignals.
function savesignals_Callback(hObject, eventdata, handles)
% hObject    handle to savesignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, path] = uiputfile([cd,'\Savedhandles\',handles.globalinfo.filename,'.mat'],'Save Handles As');
if file ~= 0
    handles.globalinfo.filename = file;
    signalinfo = handles.signalinfo;
    save([cd,'\Savedhandles\',file],'signalinfo')
end
load_listbox(handles)

guidata(hObject, handles)



function numTransientCycles_Callback(hObject, eventdata, handles)
% hObject    handle to numTransientCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numTransientCycles as text
%        str2double(get(hObject,'String')) returns contents of numTransientCycles as a double

numTransientCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numTransientCycles ~= handles.controllerinfo.numTransientCycles
    handles.controllerinfo.numTransientCycles = numTransientCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function numTransientCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numTransientCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numCollectedCycles_Callback(hObject, eventdata, handles)
% hObject    handle to numCollectedCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numCollectedCycles as text
%        str2double(get(hObject,'String')) returns contents of numCollectedCycles as a double

numCollectedCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numCollectedCycles ~= handles.controllerinfo.numCollectedCycles
    handles.controllerinfo.numCollectedCycles = numCollectedCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function numCollectedCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numCollectedCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numProcessingCycles_Callback(hObject, eventdata, handles)
% hObject    handle to numProcessingCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numProcessingCycles as text
%        str2double(get(hObject,'String')) returns contents of numProcessingCycles as a double

numProcessingCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numProcessingCycles ~= handles.controllerinfo.numProcessingCycles
    handles.controllerinfo.numProcessingCycles = numProcessingCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function numProcessingCycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numProcessingCycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double


k = str2double(get(hObject,'String'));

%first test if the value has been changed
if k ~= handles.controllerinfo.k
    handles.controllerinfo.k = k;
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in signaldetails.
function signaldetails_Callback(hObject, eventdata, handles)
% hObject    handle to signaldetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SignalDetails_GUI(handles)


% --- Executes on button press in floatcontrolaxes.
function floatcontrolaxes_Callback(hObject, eventdata, handles)
% hObject    handle to floatcontrolaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of floatcontrolaxes

PlotControlSignals(handles)


% --- Executes when selected object is changed in initialcontrol.
function initialcontrol_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in initialcontrol 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in testresponse.
function testresponse_Callback(hObject, eventdata, handles)
% hObject    handle to testresponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ResponseToCustomControls_GUI
%uiwait
handles.daqinfo = Initializedaqinfo(handles);

guidata(hObject, handles)


% --- Executes on button press in resetdaq.
function resetdaq_Callback(hObject, eventdata, handles)
% hObject    handle to resetdaq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
if get(handles.run,'value')
    set(handles.run,'string','Run')
    set(handles.run,'value',0)
end
handles.daqinfo = Initializedaqinfo(handles);

%update sampling panel in GUI
set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq))
set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle))
set(handles.numTransientCycles,'string',handles.controllerinfo.numTransientCycles)
set(handles.numCollectedCycles,'string',handles.controllerinfo.numCollectedCycles)
set(handles.numProcessingCycles,'string',handles.controllerinfo.numProcessingCycles)
set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T))

guidata(hObject, handles)


% --- Executes when selected object is changed in accSignalSelector.
function accSignalSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in accSignalSelector 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
InitializePlotAccSignals(handles)


% --- Executes when selected object is changed in desiredSignalSelector.
function desiredSignalSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in desiredSignalSelector 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'tag')
    case 'plateAccelerations'
        set(handles.desSignalChar1,'string',handles.signalinfo.adesChar{1});
        set(handles.desSignalChar2,'string',handles.signalinfo.adesChar{2});
        set(handles.desSignalChar3,'string',handles.signalinfo.adesChar{3});
        set(handles.desSignalChar4,'string',handles.signalinfo.adesChar{4});
        set(handles.desSignalChar5,'string',handles.signalinfo.adesChar{5});
        set(handles.desSignalChar6,'string',handles.signalinfo.adesChar{6});
        
        [handles.signalinfo.adesChar, handles.signalinfo.adesCyc] = desCycUpdater(handles);
        
        set(handles.desSignalText1,'string','pddx = ')
        set(handles.desSignalText2,'string','pddy = ')
        set(handles.desSignalText3,'string','pddz = ')
        set(handles.desSignalText4,'string','alphax = ')
        set(handles.desSignalText5,'string','alphay = ')
        set(handles.desSignalText6,'string','alphaz = ')
        
        set(handles.k,'string',num2str(handles.controllerinfo.k),'enable','on')
        set(handles.zero,'value',1)
        set(handles.userSpecified,'enable','off')
        set(handles.previous,'enable','on')
        set(handles.guess,'enable','on')
        set(handles.zero,'enable','on')
        set(handles.controlledHarmonics,'enable','on')
        
        
    case 'actuatorAccelerations'
        [handles.signalinfo.ddddesChar, handles.signalinfo.ddddesCyc] = desCycUpdater(handles);
        
        set(handles.desSignalText1,'string','d1dd = ')
        set(handles.desSignalText2,'string','d2dd = ')
        set(handles.desSignalText3,'string','d3dd = ')
        set(handles.desSignalText4,'string','d4dd = ')
        set(handles.desSignalText5,'string','d5dd = ')
        set(handles.desSignalText6,'string','d6dd = ')
        
    case 'actuatorVoltages'
        set(handles.desSignalChar1,'string',handles.signalinfo.udesChar{1});
        set(handles.desSignalChar2,'string',handles.signalinfo.udesChar{2});
        set(handles.desSignalChar3,'string',handles.signalinfo.udesChar{3});
        set(handles.desSignalChar4,'string',handles.signalinfo.udesChar{4});
        set(handles.desSignalChar5,'string',handles.signalinfo.udesChar{5});
        set(handles.desSignalChar6,'string',handles.signalinfo.udesChar{6});
        
        
        [handles.signalinfo.udesChar, handles.signalinfo.uCyc] = desCycUpdater(handles);
        
        set(handles.desSignalText1,'string','u1 = ')
        set(handles.desSignalText2,'string','u2 = ')
        set(handles.desSignalText3,'string','u3 = ')
        set(handles.desSignalText4,'string','u4 = ')
        set(handles.desSignalText5,'string','u5 = ')
        set(handles.desSignalText6,'string','u6 = ')
      
        set(handles.k,'string','0','enable','off')
        
        set(handles.userSpecified,'value',1)
        set(handles.userSpecified,'enable','on')
        set(handles.previous,'enable','off')
        set(handles.guess,'enable','off')
        set(handles.zero,'enable','off')
        set(handles.controlledHarmonics,'enable','off')
end

InitializePlotAccSignals(handles)
InitializePlotControlSignals(handles)

guidata(hObject,handles)



function plottedHarmonics_Callback(hObject, eventdata, handles)
% hObject    handle to plottedHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottedHarmonics as text
%        str2double(get(hObject,'String')) returns contents of plottedHarmonics as a double
InitializePlotAccSignals(handles)
InitializePlotControlSignals(handles)
PlotAccSignals(handles)
PlotControlSignals(handles)

% --- Executes during object creation, after setting all properties.
function plottedHarmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottedHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when selected object is changed in freqTimeSelector.
function freqTimeSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in freqTimeSelector 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was
%	selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'tag')
    case 'timeDomain'
        set(handles.plottedHarmonics,'enable','off')
        set(handles.plottedHarmonicsText,'enable','off')
    case 'freqDomain'
        set(handles.plottedHarmonics,'enable','on')
        set(handles.plottedHarmonicsText,'enable','on')
end

InitializePlotControlSignals(handles)
InitializePlotAccSignals(handles)

if ~get(handles.run,'value')
    PlotControlSignals(handles)
    PlotAccSignals(handles)
end



function harmonicsPerFreq_Callback(hObject, eventdata, handles)
% hObject    handle to harmonicsPerFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harmonicsPerFreq as text
%        str2double(get(hObject,'String')) returns contents of harmonicsPerFreq as a double


% --- Executes during object creation, after setting all properties.
function harmonicsPerFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harmonicsPerFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fps_Callback(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fps as text
%        str2double(get(hObject,'String')) returns contents of fps as a double

fps = str2double(get(hObject,'string'));
if ~isnan(fps)
    if fps <= 20
        if mod(handles.signalinfo.samplingFreq,fps) == 0
            handles.signalinfo.fps = fps;
        else
            warndlg('Frames per second requested does not lead to interger number of samples between frames.  Value will be reset')
            set(hObject,'string',num2str(handles.signalinfo.fps))
        end
    else
        warndlg('Camera may not maintain requested frame rate')
        handles.signalinfo.fps = fps;
    end
else
    set(hObject,'string',num2str(handles.signalinfo.fps))
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatePlots.
function updatePlots_Callback(hObject, eventdata, handles)
% hObject    handle to updatePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of updatePlots
if get(hObject,'value') && ~get(handles.run,'value')
    PlotControlSignals(handles)
    PlotAccSignals(handles)
end