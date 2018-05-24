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

% Last Modified by GUIDE v2.5 13-Feb-2009 11:03:09

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

% Choose default command line output for PPOD_6D_Master_GUI
handles.output = hObject;

clc

%globalinfo
handles.globalinfo.controlsignals = {'u1','u2','u3','u4','u5','u6'};
handles.globalinfo.speakersignals = {};%{'sp1','sp2','sp3','sp4','sp5','sp6'};
handles.globalinfo.platesignals = {'pddx','pddy','pddz','alphax','alphay','alphaz'};
handles.globalinfo.rawplatesignals = {'x1dd','y1dd','x2dd','y2dd','x3dd','y3dd','x4dd','y4dd','x5dd','y5dd','x6dd','y6dd'};
handles.globalinfo.maxupdates = 1000;
handles.globalinfo.controllerupdates = 0;
handles.globalinfo.date = date;
handles.globalinfo.usernotes = [];

%controllerinfo
handles.controllerinfo.Gnfreqs = [];
handles.controllerinfo.Gn = [];
handles.controllerinfo.Gn_raw = [];
handles.controllerinfo.Gn_sp = [];
handles.controllerinfo.maxharmonic = 1;
handles.controllerinfo.saturation = 5;
handles.controllerinfo.controlledfreqs = [];
handles.controllerinfo.gain = .1;
handles.controllerinfo.input_mag = .5; %have user enter with frequency*************
%load controllerinfo.mat which contains the variable controllerinfo, which
%fills in the empty controllerinfo struct fields above
load([cd,'\SavedGn\controllerinfo'])
handles.controllerinfo = controllerinfo;

%daqinfo
handles.daqinfo.samples_per_second = 9000;
handles.daqinfo.num_transient_cycles = 10;
handles.daqinfo.num_collected_cycles = 10;
handles.daqinfo.num_processing_cycles = 10;
handles.daqinfo.cycles_per_update = handles.daqinfo.num_transient_cycles+handles.daqinfo.num_collected_cycles+handles.daqinfo.num_processing_cycles;

%ao channel names are: clock sp1, sp2, sp3, sp4, sp5, sp6
%ai channel names are: x1dd, y1dd, x2dd, y2dd, x3dd,
%y3dd, x4dd, y4dd, x5dd, y5dd, x6dd, y6dd
handles.daqinfo.ao_channel_names = ['clock', handles.globalinfo.controlsignals];
handles.daqinfo.ai_channel_names = handles.globalinfo.rawplatesignals;

daqinfo = daqhwinfo;
if ismember('nidaq',daqinfo.InstalledAdaptors)
    %nidaq has been found, so configure daq settings
    if (~isempty(daqfind))
        stop(daqfind)
    end
    daqreset

    %create input and output objects
    handles.daqinfo.ao = analogoutput('nidaq','Dev2');
    handles.daqinfo.ai = analoginput('nidaq','Dev1');
    
    %daq properties
    set(handles.daqinfo.ai,'InputType','SingleEnded')
    set(handles.daqinfo.ai,'TriggerType','HwDigital')
    set(handles.daqinfo.ai,'TriggerCondition','PositiveEdge');

    %set up channels
    controlsignals = handles.globalinfo.controlsignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    addchannel(handles.daqinfo.ao, [0:numel(controlsignals)],[1:numel(controlsignals)+1], handles.daqinfo.ao_channel_names);
    addchannel(handles.daqinfo.ai, [0:numel(rawplatesignals)-1],[1:numel(rawplatesignals)], handles.daqinfo.ai_channel_names);

    %set sample rates
    handles.daqinfo.ao.SampleRate = handles.daqinfo.samples_per_second;
    handles.daqinfo.ai.SampleRate = handles.daqinfo.samples_per_second;
    
else
    %no nidaq found

    handles.daqinfo.ao = [];
    handles.daqinfo.ai = [];
    handles.daqinfo.ao.SampleRate = [];
    handles.daqinfo.ai.SampleRate = [];
end


%plateinfo
handles.plateinfo.basefreq = handles.controllerinfo.controlledfreqs(1);
handles.plateinfo.T = 1/handles.plateinfo.basefreq;
handles.plateinfo.dt = 1/handles.daqinfo.samples_per_second;
handles.plateinfo.t_all = [0:handles.plateinfo.dt:handles.plateinfo.T-handles.plateinfo.dt]';
handles.plateinfo.constants = {'w = 2*pi*f'};
handles.plateinfo.samples_per_cycle = length(handles.plateinfo.t_all);
handles.plateinfo.d_char = {'0', '0', '0', '0', '0', '0'};
handles.plateinfo.filename = 'Temp';

%signalinfo
handles.signalinfo.y = zeros(handles.plateinfo.samples_per_cycle, numel(handles.globalinfo.platesignals));
handles.signalinfo.y_raw = zeros(handles.plateinfo.samples_per_cycle, numel(handles.globalinfo.rawplatesignals));
handles.signalinfo.y_sp = zeros(handles.plateinfo.samples_per_cycle, numel(handles.globalinfo.speakersignals));
handles.signalinfo.u = zeros(handles.plateinfo.samples_per_cycle, numel(handles.globalinfo.controlsignals));
handles.signalinfo.d = zeros(handles.plateinfo.samples_per_cycle, numel(handles.globalinfo.platesignals));
handles.signalinfo.A = L2Wconverter(handles);

%update plate motion panel in GUI
set(handles.platemotionfilename,'string',handles.plateinfo.filename)
set(handles.constants,'string',handles.plateinfo.constants)
set(handles.basefreq,'string',num2str(handles.plateinfo.basefreq))
platesignals = handles.globalinfo.platesignals;
for i = 1:numel(platesignals)
    set(eval(['handles.',platesignals{i}]),'string',handles.plateinfo.d_char{i})
end

%update sampling panel in GUI
set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))
set(handles.num_transient_cycles,'string',handles.daqinfo.num_transient_cycles)
set(handles.num_collected_cycles,'string',handles.daqinfo.num_collected_cycles)
set(handles.num_processing_cycles,'string',handles.daqinfo.num_processing_cycles)
set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cycles_per_update))

%update control signals panel in GUI
set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))
set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
set(handles.gain,'string',num2str(handles.controllerinfo.gain))
set(handles.saturation,'string',num2str(handles.controllerinfo.saturation))

%update actuation panel in GUI
set(handles.maxupdates,'string',num2str(handles.globalinfo.maxupdates))
set(handles.controllerupdates,'string',num2str(handles.globalinfo.controllerupdates))

%initialize plots
InitializeControlPlots(handles);
InitializePlatePlots(handles);

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
varargout{1} = handles.output;


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

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function maxupdates_Callback(hObject, eventdata, handles)
% hObject    handle to maxupdates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxupdates as text
%        str2double(get(hObject,'String')) returns contents of maxupdates as a double

maxupdates = str2double(get(hObject,'String'));

%first test if the value has been changed
if maxupdates ~= handles.globalinfo.maxupdates
    handles.globalinfo.maxupdates = maxupdates;
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


% --- Executes on button press in usepreviouscontrol.
function usepreviouscontrol_Callback(hObject, eventdata, handles)
% hObject    handle to usepreviouscontrol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of usepreviouscontrol



function samples_per_second_Callback(hObject, eventdata, handles)
% hObject    handle to samples_per_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samples_per_second as text
%        str2double(get(hObject,'String')) returns contents of samples_per_second as a double

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
    handles.plateinfo.t_all = 0:dt:T-dt;
    t_all = handles.plateinfo.t_all;
    t = t_all; %so that you can evaluate desired signals
    handles.plateinfo.samples_per_cycle = length(t_all);
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;

    handles.signalinfo.y = zeros(length(t_all),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t_all), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t_all), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t_all), numel(controlsignals));
    handles.signalinfo.d = zeros(length(t_all), numel(platesignals));

    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(platesignals)
        handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t_all));
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update sampling panel in GUI
    set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
    set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(platesignals)
        handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t));
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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



function pddx_Callback(hObject, eventdata, handles)
% hObject    handle to pddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pddx as text
%        str2double(get(hObject,'String')) returns contents of pddx as a double

d_char_pddx = get(hObject,'String');

if isempty(d_char_pddx)
    d_char_pddx = '0';
    set(hObject,'string',d_char_pddx)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4, etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'pddx'));

%first test if the value has been changed
if ~strcmp(d_char_pddx, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_pddx;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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

d_char_pddy = get(hObject,'String');

if isempty(d_char_pddy)
    d_char_pddy = '0';
    set(hObject,'string',d_char_pddy)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'pddy'));

%first test if the value has been changed
if ~strcmp(d_char_pddy, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_pddy;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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

d_char_pddz = get(hObject,'String');

if isempty(d_char_pddz)
    d_char_pddz = '0';
    set(hObject,'string',d_char_pddz)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'pddz'));

%first test if the value has been changed
if ~strcmp(d_char_pddz, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_pddz;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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

d_char_alphax = get(hObject,'String');

if isempty(d_char_alphax)
    d_char_alphax = '0';
    set(hObject,'string',d_char_alphax)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'alphax'));

%first test if the value has been changed
if ~strcmp(d_char_alphax, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_alphax;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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

d_char_alphay = get(hObject,'String');

if isempty(d_char_alphay)
    d_char_alphay = '0';
    set(hObject,'string',d_char_alphay)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'alphay'));

%first test if the value has been changed
if ~strcmp(d_char_alphay, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_alphay;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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

d_char_alphaz = get(hObject,'String');

if isempty(d_char_alphaz)
    d_char_alphaz = '0';
    set(hObject,'string',d_char_alphaz)
end

%determine index of signal (e.g., pddx = 1, pddy = 2, pddz = 3, alphax = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.platesignals,'alphaz'));

%first test if the value has been changed
if ~strcmp(d_char_alphaz, handles.plateinfo.d_char{ind})
    
    handles.plateinfo.d_char{ind} = d_char_alphaz;

    %update plateinfo
    handles.plateinfo.filename = 'temp';

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    speakersignals = handles.globalinfo.speakersignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.plateinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(speakersignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.plateinfo.constants;
    f = handles.plateinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.d(:,ind) = eval(handles.plateinfo.d_char{ind}).*ones(size(t));

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)

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



function basefreq_Callback(hObject, eventdata, handles)
% hObject    handle to basefreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basefreq as text
%        str2double(get(hObject,'String')) returns contents of basefreq as a double

basefreq = str2double(get(hObject,'String'));

%first test if the value has been changed
if basefreq ~= handles.plateinfo.basefreq
    
    Gnfreqs = handles.controllerinfo.Gnfreqs;

    %make sure the new base frequency is in Gnfreqs; if not, reset to old
    %frequency and do not update anything
    if isempty(find(basefreq == Gnfreqs))
        warndlg(['No frequency response data for ',num2str(basefreq),'Hz.  Value will be reset to ',num2str(handles.plateinfo.basefreq),'Hz'])
        uiwait
        set(handles.basefreq,'string',num2str(handles.plateinfo.basefreq))
    else
        
        %update plateinfo
        handles.plateinfo.basefreq = basefreq;
        handles.plateinfo.T = 1/basefreq;
        T = handles.plateinfo.T;
        dt = handles.plateinfo.dt;
        handles.plateinfo.t_all = 0:dt:T-dt;
        t_all = handles.plateinfo.t_all;
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
        platesignals = handles.globalinfo.platesignals;
        rawplatesignals = handles.globalinfo.rawplatesignals;
        speakersignals = handles.globalinfo.speakersignals;
        controlsignals = handles.globalinfo.controlsignals;

        handles.signalinfo.y = zeros(length(t_all),numel(platesignals));
        handles.signalinfo.y_raw = zeros(length(t_all), numel(rawplatesignals));
        handles.signalinfo.y_sp = zeros(length(t_all), numel(speakersignals));
        handles.signalinfo.u = zeros(length(t_all), numel(controlsignals));
        handles.signalinfo.d = zeros(length(t_all), numel(platesignals));

        constants = handles.plateinfo.constants;
        f = handles.plateinfo.basefreq;
        for i = 1:length(constants)
            eval([constants{i},';'])
        end
        for i = 1:numel(platesignals)
            handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t_all));
        end

        %update plate motion panel in GUI
        set(handles.basefreq,'string',num2str(handles.plateinfo.basefreq))
        set(handles.platemotionfilename,'string',handles.plateinfo.filename);

        %update sampling panel in GUI
        set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

        %update control signals panel in GUI
        set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
        set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))

        %update control signals in GUI
        PlotControls(handles)
        
        %update plate signals in GUI
        PlotPlate(handles)
    end
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function basefreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basefreq (see GCBO)
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

PlotPlate(handles)

% platesignals = handles.globalinfo.platesignals;
% if get(hObject,'value')
%     for i = 1:numel(platesignals)
%         eval(['axes(handles.',platesignals{i},'_axes)'])
%         set(gca,'ylim',[-Inf Inf])
%     end
% else
%     pddmax = 20;
%     alphamax = 150;
%     for i = 1:numel(platesignals)
%         eval(['axes(handles.',platesignals{i},'_axes)'])
%         set(gca, 'ylim', [-pddmax pddmax]);
%         if i == 3
%             set(gca,'ylim',[-alphamax, alphamax])
%         end
%     end
% end



function maxharmonic_Callback(hObject, eventdata, handles)
% hObject    handle to maxharmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxharmonic as text
%        str2double(get(hObject,'String')) returns contents of maxharmonic as a double

maxharmonic = str2double(get(hObject,'String'));

%first test if the value has been changed
if maxharmonic ~= handles.controllerinfo.maxharmonic
    
    %update controllerinfo
    basefreq = handles.plateinfo.basefreq;
    Gnfreqs = handles.controllerinfo.Gnfreqs;
    if maxharmonic*basefreq > Gnfreqs(end)
        handles.controllerinfo.maxharmonic = floor(Gnfreqs(end)/basefreq);
        warndlg({['Cannot control ',num2str(maxharmonic),' harmonics with current frequency response data.'];['Highest controlled harmonic will be set to ',num2str(handles.controllerinfo.maxharmonic),'.']})
        uiwait
    else
        handles.controllerinfo.maxharmonic = maxharmonic;
    end
    handles.controllerinfo.controlledfreqs = basefreq:basefreq:basefreq*handles.controllerinfo.maxharmonic;

    %update control signals panel in GUI
    set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))
    set(handles.controlledfreqs,'string',[mat2str(handles.controllerinfo.controlledfreqs),'Hz'])
end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function maxharmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxharmonic (see GCBO)
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
basefreq = handles.plateinfo.basefreq;
maxharmonic = handles.controllerinfo.maxharmonic;
answer = inputdlg({'Enter frequencies for testing system response:';'Enter input voltage:'},'Input Frequencies',[1],{strcat('[',num2str(basefreq),':',num2str(basefreq),':',num2str(basefreq*maxharmonic),']');'1'});
if ~isempty(answer)
    Gnfreqs = eval(answer{1});
    input_mag = eval(answer{2});
    handles.controllerinfo.Gnfreqs = Gnfreqs;
    handles.controllerinfo.input_mag = input_mag;

    handles = GenerateGn(handles);
    
    %reset plateinfo and signalinfo
    handles.plateinfo = plateinfo;
    handles.signalinfo = signalinfo;
    
    %update plateinfo
    %check to see if basefreq has to change due to new Gn
    basefreq = handles.plateinfo.basefreq;
    if isempty(find(basefreq == Gnfreqs))
        %determine closest allowable base frequency
        [val ind] = min(abs(basefreq - Gnfreqs));
        warndlg(['Frequency response data does not include ',num2str(basefreq),'Hz.  Base frequency will be set to',num2str(Gnfreqs(ind)),'Hz'])
        uiwait
        basefreq = Gnfreqs(ind);
        handles.plateinfo.basefreq = basefreq;
        handles.plateinfo.T = 1/basefreq;
        T = handles.plateinfo.T;
        dt = handles.plateinfo.dt;
        handles.plateinfo.t_all = 0:dt:T-dt;
        t_all = handles.plateinfo.t_all;
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
        platesignals = handles.globalinfo.platesignals;
        rawplatesignals = handles.globalinfo.rawplatesignals;
        speakersignals = handles.globalinfo.speakersignals;
        controlsignals = handles.globalinfo.controlsignals;

        handles.signalinfo.y = zeros(length(t_all),numel(platesignals));
        handles.signalinfo.y_raw = zeros(length(t_all), numel(rawplatesignals));
        handles.signalinfo.y_sp = zeros(length(t_all), numel(speakersignals));
        handles.signalinfo.u = zeros(length(t_all), numel(controlsignals));
        handles.signalinfo.d = zeros(length(t_all), numel(platesignals));
        
        constants = handles.plateinfo.constants;
        f = handles.plateinfo.basefreq;
        for i = 1:length(constants)
            eval([constants{i},';'])
        end
        for i = 1:numel(platesignals)
            handles.signalinfo.d(:,i) = eval(handles.plateinfo.d_char{i}).*ones(size(t_all));
        end
    end
    
    %update plate motion panel in GUI
    set(handles.basefreq,'string',num2str(handles.plateinfo.basefreq))
    set(handles.platemotionfilename,'string',handles.plateinfo.filename);

    %update sampling panel in GUI
    set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

    %update control signals panel in GUI
    set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
    set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))

    %update control signals in GUI
    PlotControls(handles)

    %update plate signals in GUI
    PlotPlate(handles)
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

saturation = str2double(get(hObject,'String'));

%first test if the value has been changed
if saturation ~= handles.controllerinfo.saturation
    handles.controllerinfo.saturation = saturation;
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
function samples_per_second_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samples_per_second (see GCBO)
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

num_transient_cycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if num_transient_cycles ~= handles.daqinfo.num_transient_cycles
    handles.daqinfo.num_transient_cycles = num_transient_cycles;
    handles.daqinfo.cycles_per_update = handles.daqinfo.num_transient_cycles+handles.daqinfo.num_collected_cycles+handles.daqinfo.num_processing_cycles;
    set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cycles_per_update))
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

num_collected_cycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if num_collected_cycles ~= handles.daqinfo.num_collected_cycles
    handles.daqinfo.num_collected_cycles = num_collected_cycles;
    handles.daqinfo.cycles_per_update = handles.daqinfo.num_transient_cycles+handles.daqinfo.num_collected_cycles+handles.daqinfo.num_processing_cycles;
    set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cycles_per_update))
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

num_processing_cycles = str2double(get(hObject,'String'));

%first test if the value has been changed
if num_processing_cycles ~= handles.daqinfo.num_processing_cycles
    handles.daqinfo.num_processing_cycles = num_processing_cycles;
    handles.daqinfo.cycles_per_update = handles.daqinfo.num_transient_cycles+handles.daqinfo.num_collected_cycles+handles.daqinfo.num_processing_cycles;
    set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cycles_per_update))
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


gain = str2double(get(hObject,'String'));

%first test if the value has been changed
if gain ~= handles.controllerinfo.gain
    handles.controllerinfo.gain = gain;
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


% --- Executes on button press in platesignaldetails.
function platesignaldetails_Callback(hObject, eventdata, handles)
% hObject    handle to platesignaldetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlateSignalDetails_GUI(handles)


% --- Executes on button press in floatcontrolaxes.
function floatcontrolaxes_Callback(hObject, eventdata, handles)
% hObject    handle to floatcontrolaxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of floatcontrolaxes

controlsignals = handles.globalinfo.controlsignals;
if get(hObject,'value')
    for i = 1:numel(controlsignals)
        eval(['axes(handles.',controlsignals{i},'_axes)'])
        set(gca,'ylim',[-Inf Inf])
    end
else
    ymax = handles.controllerinfo.saturation;
    for i = 1:numel(controlsignals)
        eval(['axes(handles.',controlsignals{i},'_axes)'])
        set(gca,'ylim',[-ymax ymax]')
    end
end


% --- Executes when selected object is changed in initialcontrol.
function initialcontrol_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in initialcontrol 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)





