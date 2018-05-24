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

% Last Modified by GUIDE v2.5 29-Jul-2010 17:45:24

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

%globalinfo
handles.globalinfo.controlSignals = {'u1','u2','u3','u4','u5','u6'};%control signals (pre-amplified voltages)
handles.globalinfo.actuatorAccSignals = {'d1dd','d2dd','d3dd','d4dd','d5dd','d6dd'};%accelerations along actuator shafts
handles.globalinfo.plateAccSignals = {'pddx','pddy','pddz','alphax','alphay','alphaz'};%xyzrpy accleration of plate
handles.globalinfo.plateAccLocalSignals = {'x1dd','y1dd','x2dd','y2dd','x3dd','y3dd','x4dd','y4dd','x5dd','y5dd','x6dd','y6dd'};%accelerations measured by accelerometers mounted around the plate
handles.globalinfo.date = date;%date
handles.globalinfo.usernotes = [];%user notes

%controllerinfo
freqResponseData = load([cd,'\freqResponseData\freqResponseData']);%load data for the four variables below
handles.controllerinfo.F = freqResponseData.F; %set of frequencies for which responses have been measured
handles.controllerinfo.G_u2acc = freqResponseData.G_u2acc;%set of discrete transfer functions from u to xyzrpy plate acceleration
handles.controllerinfo.G_u2accLocal = freqResponseData.G_u2accLocal;%set of discrete transfer functions from u to plate accelerometers
handles.controllerinfo.G_u2ddd = freqResponseData.G_u2ddd;%set of discrete transwer functions from u to actuator accelerometers
handles.controllerinfo.controlledHarmonics = [1];%set of harmonics actively controlled
handles.controllerinfo.controlledFreqs = handles.controllerinfo.F(1);%set of frequencies actively controlled
handles.controllerinfo.uMax = 6;%maximum allowed pre-amplified control voltage (saturation limit)
handles.controllerinfo.k = .25;%controller gain
handles.controllerinfo.GInputMag = .5;%input voltage used to generate transfer functions
handles.controllerinfo.numTransientCycles = 10;%number of cycles to wait after control signal is updated before collecting data
handles.controllerinfo.numCollectedCycles = 5;%number of cycles collected
handles.controllerinfo.numProcessingCycles = 25;%number of cycles after data collection during which time new control is computed
handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
handles.controllerinfo.maxUpdate = 1000;%number of updates before controller stops
handles.controllerinfo.currentUpdate = 0;%current controller update

%plateinfo
handles.plateinfo.T = 1/handles.controllerinfo.F(1);%cycle time (period)
handles.plateinfo.constants = {'w = 2*pi*f'};
handles.plateinfo.adesChar = {'0', '0', '0', '0', '0', '0'};
handles.plateinfo.filename = 'Temp';

%signalinfo
handles.signalinfo.samplingFreq = 9000;%DAQ sampling rate (Hz)
handles.signalinfo.dt = 1/handles.signalinfo.samplingFreq;%time between samples (s)
handles.signalinfo.tCyc = [0:handles.signalinfo.dt:handles.plateinfo.T - handles.signalinfo.dt]';%one cycle of time data
handles.signalinfo.samplesPerCycle = length(handles.signalinfo.tCyc);
handles.signalinfo.aCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccSignals));%one cycle of plate acceleration data (columns correspond to plateAccSignals)
handles.signalinfo.adesCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccSignals));%one cycle of desired plate acceleration data (columns correspond to plateAccSignals)
handles.signalinfo.aLocalCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.plateAccLocalSignals));%one cycle of local plate acceleration data (columns correspond to plateAccLocalSignals)
handles.signalinfo.dddCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.actuatorAccSignals));%one cycle of actuator acceleration data (columns correspond to actuatorAccSignals)
handles.signalinfo.uCyc = zeros(handles.signalinfo.samplesPerCycle, numel(handles.globalinfo.controlSignals));%one cycle of control data (columns correspond to controlSignals)

%daqinfo
handles.daqinfo.aoChannelNames = [];%analog output channel names
handles.daqinfo.aiChannelNames = [];%analog input channel names
handles.daqinfo.ao = [];%analog output object
handles.daqinfo.ai = [];%analog input object
handles.daqinfo = Initializedaqinfo(handles);%puts data into empty fields above

%calibrationinfo
handles.calibrationinfo.A = L2Wconverter(handles);%conversion between local acceleration readings to plate accelerations??
handles.calibrationinfo.V_per_ms2 = 0.01;%volts per m/s^2 of accelerometers




%update control signals panel in GUI
set(handles.controlledharmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledFreqs))
set(handles.gain,'string',num2str(handles.controllerinfo.k))
set(handles.saturation,'string',num2str(handles.controllerinfo.uMax))
set(handles.zero,'Value',1)%selects initial control signals to be zero

%update acceleration signals panel in GUI
set(handles.plateAcc,'Value',1)%selects initial control signals to be zero

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.plateinfo.filename)
set(handles.constants,'string',handles.plateinfo.constants)
set(handles.T,'string',char(sym(handles.plateinfo.T)))
plateAccSignals = handles.globalinfo.plateAccSignals;
for i = 1:numel(plateAccSignals)
    set(eval(['handles.',plateAccSignals{i}]),'string',handles.plateinfo.adesChar{i})
end

%update sampling panel in GUI
set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq))
set(handles.samples_per_cycle,'string',num2str(handles.signalinfo.samplesPerCycle))
set(handles.num_transient_cycles,'string',handles.controllerinfo.numTransientCycles)
set(handles.num_collected_cycles,'string',handles.controllerinfo.numCollectedCycles)
set(handles.num_processing_cycles,'string',handles.controllerinfo.numProcessingCycles)
set(handles.cycles_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
set(handles.time_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.plateinfo.T))

%update actuation panel in GUI
set(handles.maxupdates,'string',num2str(handles.controllerinfo.maxUpdate))
set(handles.controllerupdates,'string',num2str(handles.controllerinfo.currentUpdate))

%initialize plots
InitializeControlPlots(handles);
InitializePlotAccSignals(handles);

%load saved plate motions into listbox
load_listbox(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PPOD_6D_Master_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PPOD_6D_Master_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')
    set(hObject,'string','Stop')
    handles = PPODcontroller(handles);
else
    set(hObject,'string','Run')
end

guidata(hObject, handles)


function maxupdates_Callback(hObject, eventdata, handles)
% hObject    handle to maxupdates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxupdates as text
%        str2double(get(hObject,'String')) returns contents of maxupdates as a double

maxUpdate = str2double(get(hObject,'String'));

if ~isnan(maxUpdate)
    handles.controllerinfo.maxUpdate = maxUpdate;
else
    %if user input was not a scalar, reset maxUpdate to previous value
    set(hObject,'string',num2str(handles.controllerinfo.maxUpdate))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxupdates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxupdates (see GCBO)
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

samples_per_second = str2double(get(hObject,'String'));

%first test if the value has been changed
if samples_per_second ~= handles.daqinfo.samples_per_second
    
    %update daqinfo
    handles.daqinfo.samples_per_second = samples_per_second;
    handles.daqinfo.ai.SampleRate = samples_per_second;
    handles.daqinfo.ao.SampleRate = samples_per_second;

    %update plateinfo
    T = handles.plateinfo.T;
    dt = 1/samples_per_second;
    handles.signalinfo.tCyc = 0:dt:T-dt;
    t_all = handles.signalinfo.tCyc;
    t = t_all; %so that you can evaluate desired signals
    handles.plateinfo.samples_per_cycle = length(t_all);
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    plateAccSignals = handles.globalinfo.plateAccSignals;
    plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
    actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
    controlSignals = handles.globalinfo.controlSignals;

    handles.signalinfo.y = zeros(length(t_all),numel(plateAccSignals));
    handles.signalinfo.y_raw = zeros(length(t_all), numel(plateAccLocalSignals));
    handles.signalinfo.y_sp = zeros(length(t_all), numel(actuatorAccSignals));
    handles.signalinfo.u = zeros(length(t_all), numel(controlSignals));
    handles.signalinfo.d = zeros(length(t_all), numel(plateAccSignals));

    constants = handles.plateinfo.constants;
    f = 1/handles.plateinfo.T;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(plateAccSignals)
        handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t_all));
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update sampling panel in GUI
    set(handles.samplingFreq,'string',num2str(handles.daqinfo.samples_per_second))
    set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

    %update control signals in GUI
    PlotControls(handles)

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
if ~strcmp(char(constants),char(handles.plateinfo.constants))

    %update plateinfo
    handles.plateinfo.constants = constants;
    handles.plateinfo.filename = 'temp';

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
    
    constants = handles.plateinfo.constants;
    f = 1/handles.plateinfo.T;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(plateAccSignals)
        handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t));
    end
    
    %make sure d has no NaN entries (e.g., from heaviside functions)
    nanind = find(isnan(handles.signalinfo.d));
    if ~isempty(nanind)
        handles.signalinfo.d(nanind) = handles.signalinfo.d(nanind+1);
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

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

V_per_ms2 = handles.signalinfo.V_per_ms2;
handles = load_signals(handles);
handles.signalinfo.V_per_ms2 = V_per_ms2;
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



function pddx_Callback(hObject, eventdata, handles)
% hObject    handle to pddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pddx as text
%        str2double(get(hObject,'String')) returns contents of pddx as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function pddx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pddy_Callback(hObject, eventdata, handles)
% hObject    handle to pddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pddy as text
%        str2double(get(hObject,'String')) returns contents of pddy as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function pddy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pddz_Callback(hObject, eventdata, handles)
% hObject    handle to pddz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pddz as text
%        str2double(get(hObject,'String')) returns contents of pddz as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function pddz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pddz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function alphax_Callback(hObject, eventdata, handles)
% hObject    handle to alphax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphax as text
%        str2double(get(hObject,'String')) returns contents of alphax as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function alphax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphay_Callback(hObject, eventdata, handles)
% hObject    handle to alphay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphay as text
%        str2double(get(hObject,'String')) returns contents of alphay as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function alphay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaz_Callback(hObject, eventdata, handles)
% hObject    handle to alphaz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaz as text
%        str2double(get(hObject,'String')) returns contents of alphaz as a double

adesChar = get(hObject,'string');%user-input for desired acceleration
plateAccSignals = handles.globalinfo.plateAccSignals;
ind = strcmp(plateAccSignals, get(hObject,'tag'))*(1:length(plateAccSignals))'; %=1 if pddx, =2 if pddy, etc

%if desired acceleration has changed, upate things
if ~strcmp(handles.plateinfo.adesChar{ind},adesChar)
    if isempty(adesChar)
        adesChar = '0';
        set(hObject,'string',adesChar)
    end
    handles.plateinfo.adesChar{ind} = adesChar; %update desired acceleration string
    
    adesTag = get(hObject, 'tag');
    handles.signalinfo.adesCyc(:,ind) = adesCycUpdater(handles,adesTag);%udpate desired acceleration signal
    
    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);
    
    %update control signals in GUI
    PlotControls(handles)
    
    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function alphaz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaz (see GCBO)
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
if T ~= handles.plateinfo.T
    
    F = handles.controllerinfo.F;

    %make sure the new base frequency is in Gnfreqs; if not, reset to old
    %frequency and do not update anything
    if isempty(F(f1 == F))
        warndlg({['There is no frequency response data for ',num2str(eval(f1)),' Hz.'];
            ['Period will be reset to ',char(sym(handles.plateinfo.T)),'s']})
        uiwait
        set(handles.T,'string',char(sym(handles.plateinfo.T)))
    else
        
        %update plateinfo
        handles.plateinfo.T = T;
        dt = handles.signalinfo.dt;
        handles.signalinfo.tCyc = 0:dt:T-dt;
        tCyc = handles.signalinfo.tCyc;

        handles.plateinfo.samplesPerCycle = length(tCyc);
        handles.plateinfo.filename = 'temp';
        
        %update controllerinfo
        controlledFreqs = handles.controllerinfo.controlledHarmonics*f1;
        discardFreqs = controlledFreqs(~ismember(controlledFreqs,F));
        discardHarmonics = discardFreqs/f1;
        controlledFreqs = controlledFreqs(ismember(controlledFreqs,F));
        controlledHarmonics = controlledFreqs/f1;
        if ~isempty(discardHarmonics)
            warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
                [mat2str(eval(discardHarmonics)),' (',mat2str(eval(discardFreqs)),' Hz)']})
            uiwait
        end
        handles.controllerinfo.controlledFreqs = eval(controlledFreqs);
        handles.controllerinfo.controlledHarmonics = eval(controlledHarmonics);
        
        %update control signals panel in GUI
        if length(controlledFreqs) == 1
            set(handles.controlledharmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
        else
            set(handles.controlledharmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
        end
        set(handles.controlledfreqs,'string',[mat2str(handles.controllerinfo.controlledFreqs),' Hz'])
        
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

        constants = handles.plateinfo.constants;
        f = 1/handles.plateinfo.T;
        for i = 1:length(constants)
            eval([constants{i},';'])
        end
        
        t = tCyc; %so that you can evaluate desired signals
        for i = 1:numel(plateAccSignals)
            handles.signalinfo.adesCyc(:,i) = eval(handles.plateinfo.adesChar{i}).*ones(size(tCyc));
        end

        %update plate motion panel in GUI
        set(handles.T,'string',char(sym(handles.plateinfo.T)))
        set(handles.platemotionfilename,'string',handles.plateinfo.filename);

        %update sampling panel in GUI
        set(handles.samples_per_cycle,'string',num2str(handles.signalinfo.samplesPerCycle))
        
        %update control signals panel in GUI
        if length(controlledFreqs) == 1
            set(handles.controlledharmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
        else
            set(handles.controlledharmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
        end
        set(handles.controlledfreqs,'string',[mat2str(handles.controllerinfo.controlledFreqs),' Hz'])

        %update control signals in GUI
        InitializeControlPlots(handles)
        PlotControls(handles)
        
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


% --- Executes on button press in floatplateaxes.
function floatplateaxes_Callback(hObject, eventdata, handles)
% hObject    handle to floatplateaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotAccSignals(handles)


function controlledharmonics_Callback(hObject, eventdata, handles)
% hObject    handle to controlledharmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of controlledharmonics as text
%        str2double(get(hObject,'String')) returns contents of controlledharmonics as a double

f1 = sym(1/handles.plateinfo.T);
controlledHarmonics = sort(eval(get(hObject,'String')));
controlledFreqs = f1*controlledHarmonics;
F = handles.controllerinfo.F;

discardFreqs = controlledFreqs(~ismember(controlledFreqs,F));
discardHarmonics = discardFreqs/f1;
controlledFreqs = controlledFreqs(ismember(controlledFreqs,F));
controlledHarmonics = controlledFreqs/f1;
if ~isempty(discardHarmonics)
    warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
        [mat2str(eval(discardHarmonics)),' (',mat2str(eval(discardFreqs)),' Hz)']})
    uiwait
end
handles.controllerinfo.controlledFreqs = eval(controlledFreqs);
handles.controllerinfo.controlledHarmonics = eval(controlledHarmonics);

%update control signals panel in GUI
if length(controlledFreqs) == 1
    set(handles.controlledharmonics,'string',['[',mat2str(handles.controllerinfo.controlledHarmonics),']'])
else
    set(handles.controlledharmonics,'string',mat2str(handles.controllerinfo.controlledHarmonics))
end
set(handles.controlledfreqs,'string',[mat2str(handles.controllerinfo.controlledFreqs),' Hz'])


guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function controlledharmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controlledharmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newGn.
function newGn_Callback(hObject, eventdata, handles)
% hObject    handle to newGn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plateinfo = handles.plateinfo;
signalinfo = handles.signalinfo;
T = handles.plateinfo.T;
f1 = sym(1/T);
controlledHarmonics = handles.controllerinfo.controlledHarmonics;
answer = inputdlg({'Enter new frequencies for data collection:';'Enter input voltage:'},'Input Frequencies',[1],{strcat('[',num2str(f1),':',num2str(f1),':',num2str(f1*controlledHarmonics(end)*3),']');'1'});
if ~isempty(answer)
    F = eval(answer{1});
    GInputMag = eval(answer{2});
    handles.controllerinfo.F = F;
    handles.controllerinfo.GInputMag = GInputMag;

    handles = GenerateGn(handles);
    
    %reset plateinfo and signalinfo
    handles.plateinfo = plateinfo;
    handles.signalinfo = signalinfo;
    
    %update plateinfo
    %check to see if T has to change due to new Gn
    basefreq = handles.plateinfo.basefreq;
    if basefreq ~= handles.controllerinfo.controlledfreqs(1) %isempty(find(basefreq == Gnfreqs))
        %determine closest allowable base frequency
        [val ind] = min(abs(basefreq - Gnfreqs));
        warndlg(['Frequency response data does not include ',num2str(basefreq),'Hz.  Base frequency will be set to',num2str(Gnfreqs(ind)),'Hz'])
        uiwait
        basefreq = Gnfreqs(ind);
        handles.plateinfo.basefreq = basefreq;
        handles.plateinfo.T = 1/basefreq;
        T = handles.plateinfo.T;
        dt = handles.plateinfo.dt;
        handles.signalinfo.tCyc = 0:dt:T-dt;
        t_all = handles.signalinfo.tCyc;
        t = t_all; %so that you can evaluate desired signals
        handles.plateinfo.samples_per_cycle = length(t_all);
        handles.plateinfo.filename = 'temp';

        %update controllerinfo
        Gnfreqs = handles.controllerinfo.Gnfreqs;
        maxharmonic = handles.controllerinfo.maxharmonic;
        if maxharmonic*basefreq > Gnfreqs(end)
            maxharmonic_limit = floor(Gnfreqs(end)/basefreq);
            warndlg(['Cannot control ',num2str(maxharmonic),' harmonics with current frequency response data.  Highest controlled harmonic will be set to ',num2str(maxharmonic_limit),'.'])
            uiwait
            maxharmonic = maxharmonic_limit;
        end
        handles.controllerinfo.maxharmonic = maxharmonic;
        handles.controllerinfo.controlledfreqs = basefreq:basefreq:basefreq*maxharmonic;

        %update signalinfo
        plateAccSignals = handles.globalinfo.plateAccSignals;
        plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
        actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
        controlSignals = handles.globalinfo.controlSignals;

        handles.signalinfo.y = zeros(length(t_all),numel(plateAccSignals));
        handles.signalinfo.y_raw = zeros(length(t_all), numel(plateAccLocalSignals));
        handles.signalinfo.y_sp = zeros(length(t_all), numel(actuatorAccSignals));
        handles.signalinfo.u = zeros(length(t_all), numel(controlSignals));
        handles.signalinfo.d = zeros(length(t_all), numel(plateAccSignals));
        
        constants = handles.plateinfo.constants;
        f = 1/handles.plateinfo.T;
        for i = 1:length(constants)
            eval([constants{i},';'])
        end
        for i = 1:numel(plateAccSignals)
            handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t_all));
        end
    end
    
    %update plate motion panel in GUI
    set(handles.T,'string',char(sym(handles.plateinfo.T)))
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update sampling panel in GUI
    set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

    %update control signals panel in GUI
    set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
    set(handles.controlledharmonics,'string',num2str(handles.controllerinfo.maxharmonic))

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotAccSignals(handles)
end

guidata(hObject, handles)
        
% --- Executes on button press in exporthandles.
function exporthandles_Callback(hObject, eventdata, handles)
% hObject    handle to exporthandles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','handles',handles)

% --- Executes on button press in viewGn.
function viewGn_Callback(hObject, eventdata, handles)
% hObject    handle to viewGn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ViewGn_GUI(handles)


function saturation_Callback(hObject, eventdata, handles)
% hObject    handle to saturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saturation as text
%        str2double(get(hObject,'String')) returns contents of saturation as a double

uMax = str2double(get(hObject,'String'));

%first test if the value has been changed
if uMax ~= handles.controllerinfo.uMax
    handles.controllerinfo.uMax = uMax;
end

PlotControls(handles)

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function saturation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saturation (see GCBO)
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

[file, path] = uiputfile([cd,'\Savedhandles\',handles.plateinfo.filename,'.mat'],'Save Handles As');
if file ~= 0
    handles.plateinfo.filename = file;
    plateinfo = handles.plateinfo;
    signalinfo = handles.signalinfo;
    signalinfo.y = 0*handles.signalinfo.y;
    singalinfo.y_raw = 0*handles.signalinfo.y_raw;
    signalinfo.y_sp = 0*handles.signalinfo.y_sp;
    samples_per_second = handles.daqinfo.samples_per_second;
    save([cd,'\Savedhandles\',file],'plateinfo','signalinfo','samples_per_second')
end
load_listbox(handles)

guidata(hObject, handles)



function num_transient_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to num_transient_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_transient_cycles as text
%        str2double(get(hObject,'String')) returns contents of num_transient_cycles as a double

numTransientCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numTransientCycles ~= handles.controllerinfo.numTransientCycles
    handles.controllerinfo.numTransientCycles = numTransientCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cycles_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.time_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.plateinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function num_transient_cycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_transient_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_collected_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to num_collected_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_collected_cycles as text
%        str2double(get(hObject,'String')) returns contents of num_collected_cycles as a double

numCollectedCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numCollectedCycles ~= handles.controllerinfo.numCollectedCycles
    handles.controllerinfo.numCollectedCycles = numCollectedCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cycles_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.plateinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function num_collected_cycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_collected_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_processing_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to num_processing_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_processing_cycles as text
%        str2double(get(hObject,'String')) returns contents of num_processing_cycles as a double

numProcessingCycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if numProcessingCycles ~= handles.controllerinfo.numProcessingCycles
    handles.controllerinfo.numProcessingCycles = numProcessingCycles;
    handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles+handles.controllerinfo.numCollectedCycles+handles.controllerinfo.numProcessingCycles;
    set(handles.cycles_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate))
    set(handles.time_per_update,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.plateinfo.T))
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function num_processing_cycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_processing_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain_Callback(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain as text
%        str2double(get(hObject,'String')) returns contents of gain as a double


k = str2double(get(hObject,'String'));

%first test if the value has been changed
if k ~= handles.controllerinfo.k
    handles.controllerinfo.k = k;
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
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

PlotControls(handles)


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
handles = Initializedaqinfo(handles);

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
handles = Initializedaqinfo(handles);

%update sampling panel in GUI
set(handles.samplingFreq,'string',num2str(handles.daqinfo.samples_per_second))
set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))
set(handles.num_transient_cycles,'string',handles.daqinfo.numTransientCycles)
set(handles.num_collected_cycles,'string',handles.daqinfo.numCollectedCycles)
set(handles.num_processing_cycles,'string',handles.daqinfo.num_processing_cycles)
set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cyclesPerUpdate))
set(handles.time_per_update,'string',num2str(handles.daqinfo.cyclesPerUpdate*handles.plateinfo.T))

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