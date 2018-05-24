function varargout = ResponseToCustomControls_GUI(varargin)
% RESPONSETOCUSTOMCONTROLS_GUI M-file for ResponseToCustomControls_GUI.fig
%      RESPONSETOCUSTOMCONTROLS_GUI, by itself, creates a new RESPONSETOCUSTOMCONTROLS_GUI or raises the existing
%      singleton*.
%
%      H = RESPONSETOCUSTOMCONTROLS_GUI returns the handle to a new RESPONSETOCUSTOMCONTROLS_GUI or the handle to
%      the existing singleton*.
%
%      RESPONSETOCUSTOMCONTROLS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSETOCUSTOMCONTROLS_GUI.M with the given input arguments.
%
%      RESPONSETOCUSTOMCONTROLS_GUI('Property','Value',...) creates a new RESPONSETOCUSTOMCONTROLS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResponseToCustomControls_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResponseToCustomControls_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResponseToCustomControls_GUI

% Last Modified by GUIDE v2.5 09-Mar-2009 11:37:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResponseToCustomControls_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ResponseToCustomControls_GUI_OutputFcn, ...
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


% --- Executes just before ResponseToCustomControls_GUI is made visible.
function ResponseToCustomControls_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResponseToCustomControls_GUI (see VARARGIN)

% Choose default command line output for ResponseToCustomControls_GUI
handles.output = hObject;

clc

%globalinfo
handles.globalinfo.controlsignals = {'u1','u2','u3','u4','u5','u6'};
handles.globalinfo.platesignals = {'pddx','pddy','pddz','alphax','alphay','alphaz'};
handles.globalinfo.rawplatesignals = {'x1dd','y1dd','x2dd','y2dd','x3dd','y3dd','x4dd','y4dd','x5dd','y5dd','x6dd','y6dd'};
handles.globalinfo.actuatorsignals = {'sp1','sp2','sp3','sp4','sp5','sp6'};
handles.globalinfo.maxupdates = 1000;
handles.globalinfo.date = date;
handles.globalinfo.usernotes = [];

%daqinfo
handles = Initializedaqinfo(handles);

%controllerinfo
handles.controllerinfo.saturation = 6;
handles.controllerinfo.basefreq = 30;
handles.controllerinfo.T = 1/handles.controllerinfo.basefreq;
handles.controllerinfo.dt = 1/handles.daqinfo.samples_per_second;
handles.controllerinfo.t_all = [0:handles.controllerinfo.dt:handles.controllerinfo.T-handles.controllerinfo.dt]';
handles.controllerinfo.samples_per_cycle = length(handles.controllerinfo.t_all);
handles.controllerinfo.constants = {'w = 2*pi*f';'';'A1 = 1';'A2 = 0';'A3 = 0';'A4 = 0';'A5 = 0';'A6 = 0'};
handles.controllerinfo.u_char = {'A1*sin(w*t)','A2*sin(w*t)','A3*sin(w*t)','A4*sin(w*t)','A5*sin(w*t)','A6*sin(w*t)'};

%signalinfo
handles.signalinfo.y = zeros(handles.controllerinfo.samples_per_cycle, numel(handles.globalinfo.platesignals));
handles.signalinfo.y_raw = zeros(handles.controllerinfo.samples_per_cycle, numel(handles.globalinfo.rawplatesignals));
handles.signalinfo.y_sp = zeros(handles.controllerinfo.samples_per_cycle, numel(handles.globalinfo.actuatorsignals));
handles.signalinfo.u = zeros(handles.controllerinfo.samples_per_cycle, numel(handles.globalinfo.controlsignals));
handles.signalinfo.u(:,1) = sin(2*pi*handles.controllerinfo.basefreq*handles.controllerinfo.t_all);
handles.signalinfo.A = L2Wconverter(handles);
handles.signalinfo.V_per_ms2 = 0.01;

%update sampling panel in GUI
set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
set(handles.samples_per_cycle,'string',num2str(handles.controllerinfo.samples_per_cycle))
set(handles.num_transient_cycles,'string',handles.daqinfo.num_transient_cycles)
set(handles.num_collected_cycles,'string',handles.daqinfo.num_collected_cycles)
set(handles.num_processing_cycles,'string',handles.daqinfo.num_processing_cycles)
set(handles.cycles_per_update,'string',num2str(handles.daqinfo.cycles_per_update))

%update actuation panel in GUI
set(handles.maxupdates,'string',num2str(handles.globalinfo.maxupdates))
set(handles.controllerupdates,'string','0')

%initialize plots
InitializeControlPlots_CustomResponse(handles);
InitializePlatePlots_CustomResponse(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ResponseToCustomControls_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ResponseToCustomControls_GUI_OutputFcn(hObject, eventdata, handles) 
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
    handles = PPODcontroller_CustomResponse(handles);
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
    T = handles.controllerinfo.T;
    dt = 1/samples_per_second;
    handles.controllerinfo.t_all = 0:dt:T-dt;
    t_all = handles.controllerinfo.t_all;
    t = t_all; %so that you can evaluate desired signals
    handles.controllerinfo.samples_per_cycle = length(t_all);

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;

    handles.signalinfo.y = zeros(length(t_all),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t_all), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t_all), numel(controlsignals));

    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(controlsignals)
        handles.signalinfo.u(:,i) = eval(handles.controllerinfo.u_char{i}).*ones(size(t_all));
    end

    %update sampling panel in GUI
    set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
    set(handles.samples_per_cycle,'string',num2str(handles.controllerinfo.samples_per_cycle))

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

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
if ~strcmp(char(constants),char(handles.controllerinfo.constants))

    %update plateinfo
    handles.controllerinfo.constants = constants;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(platesignals)
        handles.signalinfo.u(:,i) = eval(handles.controllerinfo.u_char{i}).*ones(size(t));
    end

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

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


function u1_Callback(hObject, eventdata, handles)
% hObject    handle to u1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u1 as text
%        str2double(get(hObject,'String')) returns contents of u1 as a double

u_char_u1 = get(hObject,'String');

if isempty(u_char_u1)
    u_char_u1 = '0';
    set(hObject,'string',u_char_u1)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4, etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u1'));

%first test if the value has been changed
if ~strcmp(u_char_u1, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u1;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that u_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function u1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u2_Callback(hObject, eventdata, handles)
% hObject    handle to u2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u2 as text
%        str2double(get(hObject,'String')) returns contents of u2 as a double

u_char_u2 = get(hObject,'String');

if isempty(u_char_u2)
    u_char_u2 = '0';
    set(hObject,'string',u_char_u2)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u2'));

%first test if the value has been changed
if ~strcmp(u_char_u2, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u2;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function u2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u3_Callback(hObject, eventdata, handles)
% hObject    handle to u3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u3 as text
%        str2double(get(hObject,'String')) returns contents of u3 as a double

u_char_u3 = get(hObject,'String');

if isempty(u_char_u3)
    u_char_u3 = '0';
    set(hObject,'string',u_char_u3)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u3'));

%first test if the value has been changed
if ~strcmp(u_char_u3, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u3;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function u3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function u4_Callback(hObject, eventdata, handles)
% hObject    handle to u4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u4 as text
%        str2double(get(hObject,'String')) returns contents of u4 as a double

u_char_u4 = get(hObject,'String');

if isempty(u_char_u4)
    u_char_u4 = '0';
    set(hObject,'string',u_char_u4)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u4'));

%first test if the value has been changed
if ~strcmp(u_char_u4, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u4;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)
% --- Executes during object creation, after setting all properties.
function u4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u5_Callback(hObject, eventdata, handles)
% hObject    handle to u5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u5 as text
%        str2double(get(hObject,'String')) returns contents of u5 as a double

u_char_u5 = get(hObject,'String');

if isempty(u_char_u5)
    u_char_u5 = '0';
    set(hObject,'string',u_char_u5)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u5'));

%first test if the value has been changed
if ~strcmp(u_char_u5, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u5;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)
% --- Executes during object creation, after setting all properties.
function u5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u6_Callback(hObject, eventdata, handles)
% hObject    handle to u6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u6 as text
%        str2double(get(hObject,'String')) returns contents of u6 as a double

u_char_u6 = get(hObject,'String');

if isempty(u_char_u6)
    u_char_u6 = '0';
    set(hObject,'string',u_char_u6)
end

%determine index of signal (e.g., u1 = 1, u2 = 2, u3 = 3, u4 = 4,
%etc 
[val ind] = find(strcmp(handles.globalinfo.controlsignals,'u6'));

%first test if the value has been changed
if ~strcmp(u_char_u6, handles.controllerinfo.u_char{ind})
    
    handles.controllerinfo.u_char{ind} = u_char_u6;

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;
    
    t = handles.controllerinfo.t_all; %call it t so that d_char can be evalulated

    handles.signalinfo.y = zeros(length(t),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t), numel(controlsignals));
    
    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    handles.signalinfo.u(:,ind) = eval(handles.controllerinfo.u_char{ind}).*ones(size(t));

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)

end

guidata(hObject, handles)
% --- Executes during object creation, after setting all properties.
function u6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u6 (see GCBO)
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
if basefreq ~= handles.controllerinfo.basefreq

    %update controllerinfo
    handles.controllerinfo.basefreq = basefreq;
    handles.controllerinfo.T = 1/basefreq;
    T = handles.controllerinfo.T;
    dt = handles.controllerinfo.dt;
    handles.controllerinfo.t_all = 0:dt:T-dt;
    t_all = handles.controllerinfo.t_all;
    t = t_all; %so that you can evaluate desired signals
    handles.controllerinfo.samples_per_cycle = length(t_all);

    %update signalinfo
    platesignals = handles.globalinfo.platesignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    controlsignals = handles.globalinfo.controlsignals;

    handles.signalinfo.y = zeros(length(t_all),numel(platesignals));
    handles.signalinfo.y_raw = zeros(length(t_all), numel(rawplatesignals));
    handles.signalinfo.u = zeros(length(t_all), numel(controlsignals));

    constants = handles.controllerinfo.constants;
    f = handles.controllerinfo.basefreq;
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(controlsignals)
        handles.signalinfo.u(:,i) = eval(handles.controllerinfo.u_char{i}).*ones(size(t_all));
    end

    %update plate motion panel in GUI
    set(handles.basefreq,'string',num2str(handles.controllerinfo.basefreq))

    %update sampling panel in GUI
    set(handles.samples_per_cycle,'string',num2str(handles.controllerinfo.samples_per_cycle))

    %update control signals in GUI
    PlotControls_CustomResponse(handles)

    %update plate signals in GUI
    PlotPlate_CustomResponse(handles)
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

PlotPlate_CustomResponse(handles)

        
% --- Executes on button press in exporthandles.
function exporthandles_Callback(hObject, eventdata, handles)
% hObject    handle to exporthandles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','handles',handles)


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


% --- Executes when selected object is changed in signalsourcepanel.
function signalsourcepanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in signalsourcepanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

InitializePlatePlots_CustomResponse(handles)


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

guidata(hObject, handles)
