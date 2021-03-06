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

% Last Modified by GUIDE v2.5 09-Dec-2010 15:06:42

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
function PPOD_6D_Master_GUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
clc
%set radio buttons on GUI
set(handles.standardModeAI,'value',1)
set(handles.standardModeAO,'value',1)
set(handles.uiInitial_guess,'value',1)
set(handles.desSignals_Pdd,'value',1)
set(handles.plottedSignals_Pdd,'value',1)
set(handles.timeDomain,'value',1)
set(handles.updatePlots,'value',1)

%initialize all variables and GUI
handles = InitializeHandles(handles);
InitializeGUI(handles);

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

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
if get(hObject,'value')
    set(hObject,'string','Stop')
    set(handles.T,'enable','off')
    set(handles.samplingFreq,'enable','off')
    set(handles.numCollectedCycles,'enable','off')
    switch desSignals
        case 'desSignals_Pdd'
            set(handles.desSignals_didd,'enable','off')
            set(handles.desSignals_ui,'enable','off')
        case 'desSignals_didd'
            set(handles.desSignals_Pdd,'enable','off')
            set(handles.desSignals_ui,'enable','off')
        case 'desSignals_ui'
            set(handles.desSignals_Pdd,'enable','off')
            set(handles.desSignals_didd,'enable','off')
    end
    set(handles.standardModeAI,'enable','off')
    set(handles.forceModeAI,'enable','off')
    
    set(handles.standardModeAO,'enable','off')
    set(handles.cameraModeAO,'enable','off')
    set(handles.saveSignals,'enable','off')
    set(handles.uiAddFreqs,'enable','off')
    set(handles.uiDeleteFreqs,'enable','off')
    set(handles.diddAddFreqs,'enable','off')
    set(handles.diddDeleteFreqs,'enable','off')
    set(handles.diddErrorTol,'enable','off')
    set(handles.maxUpdatediddAddFreqs,'enable','off')
    set(handles.PddAddFreqs,'enable','off')
    set(handles.PddDeleteFreqs,'enable','off')
    set(handles.PddErrorTol,'enable','off')
    set(handles.maxUpdatePddAddFreqs,'enable','off')
    set(handles.viewTransferFunctions,'enable','off')
    set(handles.currentUpdatePddAddFreqs,'enable','off')
    set(handles.currentUpdatediddAddFreqs,'enable','off')
    
    handles = PPODcontroller(handles);
    InitializeGUI(handles)
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
    %if user input was not a scalar, reset maxUpdate to uiInitial_previous value
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
    %if user input was not a scalar, reset to uiInitial_previous value
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
    
    desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
    switch desSignals
        case 'desSignals_Pdd'
            [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        case 'desSignals_didd'
            [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        case 'desSignals_ui'
            [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
            handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
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
    PddSignals = handles.globalinfo.PddSignals;
    pmiddSignals = handles.globalinfo.pmiddSignals;
    diddSignals = handles.globalinfo.diddSignals;
    uiSignals = handles.globalinfo.uiSignals;
    
    t = handles.signalinfo.tCyc; %call it t so that d_char can be evalulated
    
    handles.signalinfo.y = zeros(length(t),numel(PddSignals));
    handles.signalinfo.y_raw = zeros(length(t), numel(pmiddSignals));
    handles.signalinfo.y_sp = zeros(length(t), numel(diddSignals));
    handles.signalinfo.u = zeros(length(t), numel(uiSignals));
    
    constants = handles.signalinfo.constants;
    T = handles.signalinfo.T;
    f = 1/T;%delete???
    for i = 1:length(constants)
        eval([constants{i},';'])
    end
    for i = 1:numel(PddSignals)
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


% --- Executes on selection change in savedSignalsListbox.
function savedSignalsListbox_Callback(hObject, eventdata, handles)
% hObject    handle to savedSignalsListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns savedSignalsListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from savedSignalsListbox

handles = loadSavedSignals(handles);
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function savedSignalsListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedSignalsListbox (see GCBO)
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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

%if text box for desired signal was left empty, make it a uiInitial_zero
if isempty(get(hObject,'string'))
    desChar = '0';
    set(hObject,'string',desChar)
end

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_didd'
        [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
    case 'desSignals_ui'
        [handles.signalinfo.uiDesChar, handles.signalinfo.uiDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
    otherwise
        error('selection does not match any case')
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
f1_ui = eval(sym(1/T));

%first test if the value has been changed
if T ~= handles.signalinfo.T

    F_ui_all = handles.controllerinfo.F_ui_all;
    %make sure the new base frequency is in Gnfreqs; if not, reset to old
    %frequency and do not update anything
    if isempty(F_ui_all(f1_ui == F_ui_all))
        warndlg({['There is no frequency response data for ',num2str(f1_ui),' Hz.'];
            ['Period will be reset to ',char(sym(handles.signalinfo.T)),'s']})
        uiwait
        set(handles.T,'string',char(sym(handles.signalinfo.T)))
    else
        %update signalinfo
        handles.signalinfo.T = T;
        dt = handles.signalinfo.dt;
        handles.signalinfo.tCyc = (0:dt:T-dt)';
        tCyc = handles.signalinfo.tCyc;
        
        handles.signalinfo.samplesPerCycle = length(tCyc);
        
        handles.globalinfo.filename = 'temp';
        
        %update controllerinfo
        F_ui = handles.controllerinfo.uiHarmonics*f1_ui;
        discardFreqs = F_ui(~ismember(F_ui,F_ui_all));
        discardHarmonics = discardFreqs/f1_ui;
        F_ui = F_ui(ismember(F_ui,F_ui_all));
        uiHarmonics = F_ui/f1_ui;
        if ~isempty(discardHarmonics)
            warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
                [mat2str(discardHarmonics),' (',mat2str(discardFreqs),' Hz)']})
            uiwait
        end
        handles.controllerinfo.F_ui = F_ui;
        handles.controllerinfo.uiHarmonics = uiHarmonics;
        
        %update control signals panel in GUI
        if length(F_ui) == 1
            set(handles.uiHarmonics,'string',['[',mat2str(handles.controllerinfo.uiHarmonics),']'])
        else
            set(handles.uiHarmonics,'string',mat2str(handles.controllerinfo.uiHarmonics))
        end
        set(handles.F_ui,'string',[mat2str(handles.controllerinfo.F_ui),' Hz'])
        
        %update signalinfo
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
        
        
        %update desired signals
        switch get(get(handles.desSignalsSelector,'selectedobject'),'tag')
            case 'desSignals_Pdd'
                [handles.signalinfo.PddDesChar, handles.signalinfo.PddDesCyc] = desCycUpdater(handles);%udpate desired acceleration signal
            case 'desSignals_didd'
                [handles.signalinfo.diddDesChar, handles.signalinfo.diddDesCyc] = desCycUpdater(handles);
            case 'desSignals_ui'
                [handles.signalinfo.uiDesChar, handles.signalinfo.uiCyc] = desCycUpdater(handles);%udpate desired acceleration signal
        end
        
        %update plate motion panel in GUI
        set(handles.T,'string',char(sym(handles.signalinfo.T)))
        set(handles.platemotionfilename,'string',handles.globalinfo.filename);
        
        %update sampling panel in GUI
        set(handles.samplesPerCycle,'string',num2str(SPC))
        
        %update control signals panel in GUI
        if length(F_ui) == 1
            set(handles.uiHarmonics,'string',['[',mat2str(handles.controllerinfo.uiHarmonics),']'])
        else
            set(handles.uiHarmonics,'string',mat2str(handles.controllerinfo.uiHarmonics))
        end
        set(handles.F_ui,'string',[mat2str(handles.controllerinfo.F_ui),' Hz'])
        timePerUpdate = eval(get(handles.cyclesPerUpdate,'string'))*T;
        set(handles.timePerUpdate,'string',num2str(timePerUpdate))
        
        %update control signals in GUI
        InitializePlotControlSignals(handles)
        PlotControlSignals(handles)

        %update plate signals in GUI
        InitializePlotAccSignals(handles)
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


function uiHarmonics_Callback(hObject, eventdata, handles)
% hObject    handle to uiHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiHarmonics as text
%        str2double(get(hObject,'String')) returns contents of uiHarmonics as a double

f1_ui = sym(1/handles.signalinfo.T);
uiHarmonics = sort(eval(get(hObject,'String')));
F_ui = f1_ui*uiHarmonics;
F_ui_all = handles.controllerinfo.F_ui_all;

discardFreqs = F_ui(~ismember(F_ui,F_ui_all));
discardHarmonics = discardFreqs/f1_ui;
F_ui = F_ui(ismember(F_ui,F_ui_all));
uiHarmonics = F_ui/f1_ui;
if ~isempty(discardHarmonics)
    warndlg({'The following harmonics cannot be controlled with the current frequency response data:';
        [mat2str(eval(discardHarmonics)),' (',mat2str(eval(discardFreqs)),' Hz)']})
    uiwait
end
handles.controllerinfo.F_ui = eval(F_ui);
handles.controllerinfo.uiHarmonics = eval(uiHarmonics);

%update control signals panel in GUI
if length(F_ui) == 1
    set(handles.uiHarmonics,'string',['[',mat2str(handles.controllerinfo.uiHarmonics),']'])
else
    set(handles.uiHarmonics,'string',mat2str(handles.controllerinfo.uiHarmonics))
end
set(handles.F_ui,'string',[mat2str(handles.controllerinfo.F_ui),' Hz'])


guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function uiHarmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiAddFreqs.
function uiAddFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to uiAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')
    mode = handles.globalinfo.mode;%store previous mode to be returned to once completed
    handles.globalinfo.mode = 'uiAddFreqs';
    
    GuiInputMag = handles.controllerinfo.GuiInputMag;
    freqsOld = handles.controllerinfo.F_ui_all;
    NPCOld = handles.controllerinfo.numProcessingCycles;
    answer = inputdlg({['New frequencies to add (current frequencies: ',mat2str(freqsOld),'):'];'Input voltage:'},'Frequency Response Data Collection',[1],{'20';num2str(GuiInputMag)});
    
    if isempty(answer)
        set(hObject,'value',0,'enable','on')
        return
    else
        %check to make sure that transfer functions are the right size--if
        %not, set them equal to zero
        [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles);
        NHCPF = handles.controllerinfo.harmonicsCollectedPerFreq; %number of harmonics recorded per frequency
        
        numuiFreqs = numel(handles.controllerinfo.F_ui_all);
        if ~isequal([NPDDS,NUIS,1,NHCPF],size(handles.controllerinfo.G_ui2Pdd_all(:,:,1,:)))
            handles.controllerinfo.G_ui2Pdd_all = zeros(NPDDS,NUIS,numuiFreqs,NHCPF);
        end
        if ~isequal([NPMIDDS,NUIS,1,NHCPF],size(handles.controllerinfo.G_ui2pmidd_all(:,:,1,:)))
            handles.controllerinfo.G_ui2pmidd_all = zeros(NPMIDDS,NUIS,numuiFreqs,NHCPF);
        end
        if ~isequal([NDIDDS,NUIS,1,NHCPF],size(handles.controllerinfo.G_ui2didd_all(:,:,1,:)))
            handles.controllerinfo.G_ui2didd_all = zeros(NDIDDS,NUIS,numuiFreqs,NHCPF);
        end
        if ~isequal([NAMIDDS,NUIS,1,NHCPF],size(handles.controllerinfo.G_ui2amidd_all(:,:,1,:)))
            handles.controllerinfo.G_ui2amidd_all = zeros(NAMIDDS,NUIS,numuiFreqs,NHCPF);
        end
        
        
        freqsNew = eval(answer{1});
        handles.controllerinfo.GuiInputMag = eval(answer{2});
        GuiInputMag = handles.controllerinfo.GuiInputMag;
        
        F_ui_all = sort(unique([freqsOld,freqsNew]));
        indsNew = find(ismember(F_ui_all,freqsNew));
        
        G_ui2PddOld = handles.controllerinfo.G_ui2Pdd_all;
        G_ui2pmiddOld = handles.controllerinfo.G_ui2pmidd_all;
        G_ui2diddOld = handles.controllerinfo.G_ui2didd_all;
        G_ui2amiddOld = handles.controllerinfo.G_ui2amidd_all;
        
        %store current user-selections/value to be reset later
        desSignal = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
        initialControl = get(get(handles.uiInitialModeSelector,'selectedobject'),'tag');
        signalinfo = handles.signalinfo;
        
        %reset radio buttons for duration of transfer function generation
        set(handles.desSignals_ui,'value',1)
        set(handles.uiInitial_user,'enable','on','value',1)
        
        set(handles.standardModeAI,'enable','off')
        set(handles.forceModeAI,'enable','off')
        
        set(handles.standardModeAO,'enable','off')
        set(handles.cameraModeAO,'enable','off')
        
        set(handles.samplingFreq,'enable','off')
        set(handles.numTransientCycles,'enable','off')
        set(handles.numCollectedCycles,'enable','off')
        set(handles.numProcessingCycles,'enable','off')
        
        set(handles.uiHarmonics,'enable','off')
        set(handles.F_ui,'enable','off')
        set(handles.useNonlinearHarmonicTerms,'enable','off')
        set(handles.k,'enable','off')
        set(handles.uMax,'enable','off')
        
        set(handles.uiInitial_previous,'enable','off')
        set(handles.uiInitial_guess,'enable','off')
        set(handles.uiInitial_zero,'enable','off')
        
        set(handles.desSignals_Pdd,'enable','off')
        set(handles.desSignals_didd,'enable','off')
        
        set(handles.T,'enable','off')
        
        set(handles.constants,'enable','off')
        set(handles.savedSignalsListbox,'enable','off')
        
        set(handles.diddErrorTol,'enable','off')
        set(handles.maxUpdatediddAddFreqs,'enable','off')
        set(handles.PddErrorTol,'enable','off')
        set(handles.maxUpdatePddAddFreqs,'enable','off')
        
        set(handles.maxUpdate,'enable','off')
        set(handles.run,'enable','off')
        
        set(handles.uiDeleteFreqs,'enable','off')
        set(handles.viewTransferFunctions,'enable','off')
        set(handles.diddAddFreqs,'enable','off')
        set(handles.diddDeleteFreqs,'enable','off')
        set(handles.PddAddFreqs,'enable','off')
        set(handles.PddDeleteFreqs,'enable','off')
        set(handles.viewTransferFunctions,'enable','off')
        set(handles.currentUpdate,'enable','off')
        set(handles.currentUpdatediddAddFreqs,'enable','off')
        set(handles.currentUpdatePddAddFreqs,'enable','off')
        
        %update desired signal text
        for i = 1:numel(handles.globalinfo.uiSignals)
            set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.uiSignals{i},' = '],'enable','on')
            set(eval(['handles.desSignalChar',num2str(i)]),'string','0','enable','off')
        end
        
        %loop to collect new transfer function data
        G_ui2PddNew = zeros(NPDDS,NUIS,length(freqsNew), NHCPF);
        G_ui2pmiddNew = zeros(NPMIDDS,NUIS,length(freqsNew),NHCPF);
        G_ui2diddNew = zeros(NDIDDS,NUIS,length(freqsNew),NHCPF);
        G_ui2amiddNew = zeros(NAMIDDS,NUIS,length(freqsNew),NHCPF);
        
        dt = 1/handles.signalinfo.samplingFreq;
        for in = 1:length(freqsNew)
            for i = 1:NUIS
                f = freqsNew(in);
                handles.signalinfo.T = 1/f;
                T = handles.signalinfo.T;
                set(handles.T,'string',char(sym(T)));
                tCyc = (0:dt:T-dt)';
                handles.signalinfo.tCyc = tCyc;
                handles.signalinfo.samplesPerCycle = length(tCyc);
                SPC = handles.signalinfo.samplesPerCycle;
                
                handles.signalinfo.uiCyc = zeros(SPC,NUIS);
                handles.signalinfo.uiCyc(:,i) = GuiInputMag*sin(2*pi*f*tCyc);
                handles.signalinfo.uiDesCyc = zeros(SPC,NUIS);
                handles.signalinfo.uiDesCyc(:,i) = GuiInputMag*sin(2*pi*f*tCyc);
                handles.signalinfo.PddCyc = zeros(SPC,NPDDS);
                handles.signalinfo.PddDesCyc = zeros(SPC,NPDDS);
                handles.signalinfo.diddCyc = zeros(SPC,NDIDDS);
                handles.signalinfo.diddDesCyc = zeros(SPC,NDIDDS);
                handles.signalinfo.fCyc = zeros(SPC,NFS);
                handles.signalinfo.diCyc = zeros(SPC,NDIS);
                
                uiDesChari = [num2str(GuiInputMag),'*sin(2*pi*',char(sym(f)),'*t)'];
                handles.signalinfo.uiDesChar{i} = uiDesChari;
                eval(['set(handles.desSignalChar',num2str(i),',''string'',uiDesChari)'])
                
                handles = PPODcontroller(handles);
                
                eval(['set(handles.desSignalChar',num2str(i),',''string'',''0'')'])
                
                uiCyc_fft = fft(handles.signalinfo.uiCyc);
                PddCyc_fft = fft(handles.signalinfo.PddCyc);
                pmiddCyc_fft = fft(handles.signalinfo.pmiddCyc);
                diddCyc_fft = fft(handles.signalinfo.diddCyc);
                amiddCyc_fft = fft(handles.signalinfo.amiddCyc);
                
                
                %note that NCC = 1 because Cyc signals are getting FFTed
                for out = 1:min(NHCPF,size(PddCyc_fft,1)-1)
                    fftIndIn = 2; %always want first harmonic of input signal
                    fftIndOut = out+1; %cycle through harmonics of output signal
                    G_ui2PddNew(:,i,in,out) = PddCyc_fft(fftIndOut,:)/uiCyc_fft(fftIndIn,i);
                    G_ui2pmiddNew(:,i,in,out) = pmiddCyc_fft(fftIndOut,:)/uiCyc_fft(fftIndIn,i);
                    G_ui2diddNew(:,i,in,out) = diddCyc_fft(fftIndOut,:)/uiCyc_fft(fftIndIn,i);
                    G_ui2amiddNew(:,i,in,out) = amiddCyc_fft(fftIndOut,:)/uiCyc_fft(fftIndIn,i);
                end
            end
        end
        
        %merge old and new transfer functions
        for in = 1:length(F_ui_all)
            if ismember(in,indsNew)
                ind = find(freqsNew==F_ui_all(in));
                handles.controllerinfo.F_ui_all(in) = freqsNew(ind);
                handles.controllerinfo.G_ui2Pdd_all(:,:,in,:) = G_ui2PddNew(:,:,ind,:);
                handles.controllerinfo.G_ui2pmidd_all(:,:,in,:) = G_ui2pmiddNew(:,:,ind,:);
                handles.controllerinfo.G_ui2didd_all(:,:,in,:) = G_ui2diddNew(:,:,ind,:);
                handles.controllerinfo.G_ui2amidd_all(:,:,in,:) = G_ui2amiddNew(:,:,ind,:);
            else
                ind = find(freqsOld==F_ui_all(in));
                handles.controllerinfo.F_ui_all(in) = freqsOld(ind);
                handles.controllerinfo.G_ui2Pdd_all(:,:,in,:) = G_ui2PddOld(:,:,ind,:);
                handles.controllerinfo.G_ui2pmidd_all(:,:,in,:) = G_ui2pmiddOld(:,:,ind,:);
                handles.controllerinfo.G_ui2didd_all(:,:,in,:) = G_ui2diddOld(:,:,ind,:);
                handles.controllerinfo.G_ui2amidd_all(:,:,in,:) = G_ui2amiddOld(:,:,ind,:);
            end
        end
        
        G_ui2Pdd_all = handles.controllerinfo.G_ui2Pdd_all;
        G_ui2pmidd_all = handles.controllerinfo.G_ui2pmidd_all;
        G_ui2didd_all = handles.controllerinfo.G_ui2didd_all;
        G_ui2amidd_all = handles.controllerinfo.G_ui2amidd_all;
        
        switch handles.globalinfo.aiConfig
            case 'standard'
                save([cd,'\freqResponseData\freqResponseDataStandard'],'F_ui_all','G_ui2Pdd_all','G_ui2pmidd_all','G_ui2didd_all','G_ui2amidd_all','GuiInputMag','-append')
            case 'force'
                save([cd,'\freqResponseData\freqResponseDataForce'],'F_ui_all','G_ui2Pdd_all','G_ui2pmidd_all','G_ui2didd_all','G_ui2amidd_all','GuiInputMag','-append')
        end
        
        
        %put signalinfo data back into handles as it was before
        handles.signalinfo = signalinfo;
        handles.globalinfo.mode = mode;
        handles.controllerinfo.numProcessingCycles = NPCOld;
        handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
        set(handles.(desSignal),'value',1)
        set(handles.(initialControl),'value',1)
        
        InitializeGUI(handles)
        guidata(hObject, handles)
    end
    set(hObject,'value',0,'enable','on')
else
    warndlg('No frequency data was saved')
    uiwait
    InitializeGUI(handles)
end



% --- Executes on button press in exporthandles.
function exporthandles_Callback(hObject, eventdata, handles)
% hObject    handle to exporthandles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

assignin('base','handles',handles)


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


% --- Executes on button press in saveSignals.
function saveSignals_Callback(hObject, eventdata, handles)
% hObject    handle to saveSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, path] = uiputfile([cd,'\SavedSignals_Pdd\',handles.globalinfo.filename,'.mat'],'Save Handles As');
if file ~= 0
    handles.globalinfo.filename = file;
    signalinfo = handles.signalinfo;
    save([cd,'\SavedSignals_Pdd\',file],'signalinfo')
end
populateSavedSignalsListbox(handles)

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


% --- Executes when selected object is changed in uiInitialModeSelector.
function uiInitialModeSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uiInitialModeSelector
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in plottedSignalSelector.
function plottedSignalSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in plottedSignalSelector
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
InitializePlotAccSignals(handles)


% --- Executes when selected object is changed in desSignalsSelector.
function desSignalsSelector_SelectionChangeFcn(hObject, eventdata, handles)

desSignals = get(hObject,'tag');
switch desSignals
    case 'desSignals_Pdd'
        handles.signalinfo.uiCyc = 0*handles.signalinfo.uiDesCyc;
        handles.globalinfo.mode = 'PddControl';
    case 'desSignals_didd'
        handles.signalinfo.uiCyc = 0*handles.signalinfo.uiDesCyc;
        handles.globalinfo.mode = 'diddControl';
    case 'desSignals_ui'
        handles.signalinfo.uiCyc = handles.signalinfo.uiDesCyc;
        handles.globalinfo.mode = 'uiControl';
    otherwise
        error('selection does not match any case')
end

InitializeGUI(handles)
guidata(hObject,handles)



function plottedHarmonics_Callback(hObject, eventdata, handles)
% hObject    handle to plottedHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottedHarmonics as text
%        str2double(get(hObject,'String')) returns contents of plottedHarmonics as a double
InitializePlotAccSignals(handles)
InitializePlotControlSignals(handles)
InitializePlotForceSignals(handles)
PlotAccSignals(handles)
PlotControlSignals(handles)
if strcmp(handles.globalinfo.aiConfig,'force')
    PlotForceSignals(handles)
end

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
if strcmp(handles.globalinfo.aiConfig,'force')
    InitializePlotForceSignals(handles)
    InitializePlotLaserSignals(handles)
end

if ~get(handles.run,'value')
    PlotControlSignals(handles)
    PlotAccSignals(handles)
    if strcmp(handles.globalinfo.aiConfig,'force')
        PlotForceSignals(handles)
        PlotLaserSignals(handles)
    end
end



function harmonicsCollectedPerFreq_Callback(hObject, eventdata, handles)
% hObject    handle to harmonicsCollectedPerFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harmonicsCollectedPerFreq as text
%        str2double(get(hObject,'String')) returns contents of harmonicsCollectedPerFreq as a double


% --- Executes during object creation, after setting all properties.
function harmonicsCollectedPerFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harmonicsCollectedPerFreq (see GCBO)
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
            handles.camerainfo.fps = fps;
        else
            warndlg('Frames per second requested does not lead to interger number of samples between frames.  Value will be reset')
            set(hObject,'string',num2str(handles.camerainfo.fps))
        end
    else
        warndlg('Camera may not maintain requested frame rate')
        handles.camerainfo.fps = fps;
    end
else
    set(hObject,'string',num2str(handles.camerainfo.fps))
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



function maxUpdatediddAddFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to maxUpdatediddAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxUpdatediddAddFreqs as text
%        str2double(get(hObject,'String')) returns contents of maxUpdatediddAddFreqs as a double


% --- Executes during object creation, after setting all properties.
function maxUpdatediddAddFreqs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxUpdatediddAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diddErrorTol_Callback(hObject, eventdata, handles)
% hObject    handle to diddErrorTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diddErrorTol as text
%        str2double(get(hObject,'String')) returns contents of diddErrorTol as a double


% --- Executes during object creation, after setting all properties.
function diddErrorTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diddErrorTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiDeleteFreqs.
function uiDeleteFreqs_Callback(hObject, eventdata, handles)
F_ui_all = handles.controllerinfo.F_ui_all;
answer = inputdlg({['Frequencies to delete: (current frequencies: ',mat2str(F_ui_all),')']},'Delete Frequencies',1,{'[]'});
if ~isempty(answer)
    F_ui_delete = eval(answer{1});
    ind_all = ismember(F_ui_all,F_ui_delete);
    
    handles.controllerinfo.F_ui_all(ind_all) = [];
    handles.controllerinfo.G_ui2Pdd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_ui2pmidd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_ui2didd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_ui2amidd_all(:,:,ind_all,:) = [];
    
    F_ui_all = handles.controllerinfo.F_ui_all;
    G_ui2Pdd_all = handles.controllerinfo.G_ui2Pdd_all;
    G_ui2pmidd_all = handles.controllerinfo.G_ui2pmidd_all;
    G_ui2didd_all = handles.controllerinfo.G_ui2didd_all;
    G_ui2amidd_all = handles.controllerinfo.G_ui2amidd_all;
    
    switch handles.globalinfo.aiConfig
        case 'standard'
            save([cd,'\freqResponseData\freqResponseDataStandard'],'F_ui_all','G_ui2Pdd_all','G_ui2pmidd_all','G_ui2didd_all','G_ui2amidd_all','-append')
        case 'force'
            save([cd,'\freqResponseData\freqResponseDataForce'],'F_ui_all','G_ui2Pdd_all','G_ui2pmidd_all','G_ui2didd_all','G_ui2amidd_all','-append')
    end
end

set(hObject,'value',0)

guidata(hObject, handles)


% --- Executes when selected object is changed in analogInputModeSelector.
function analogInputModeSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in analogInputModeSelector
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles = InitializeHandles(handles);
InitializeGUI(handles)

guidata(hObject, handles)

% --- Executes on button press in diddAddFreqs.
function diddAddFreqs_Callback(hObject, eventdata, handles)

if get(hObject,'value')
    mode = handles.globalinfo.mode;%store previous mode to be returned to once completed
    handles.globalinfo.mode = 'diddAddFreqs';
    GdiddInputMag = handles.controllerinfo.GdiddInputMag;
    freqsOld = handles.controllerinfo.F_didd_all;
    NPCOld = handles.controllerinfo.numProcessingCycles;
    answer = inputdlg({['New frequencies to add (current frequencies: ',mat2str(freqsOld),'):'];'Input acceleration amplitude:'},'Frequency Response Data Collection',[1],{'20';num2str(GdiddInputMag)});
    
    if isempty(answer)
        set(hObject,'value',0,'enable','on')
        return
    else
        %check to make sure that transfer functions are the right size--if
        %not, set them equal to zero
        [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles);
        NHCPF = handles.controllerinfo.harmonicsCollectedPerFreq; %number of harmonics recorded per frequency
        
        numuiFreqs = numel(handles.controllerinfo.F_ui_all);
        if ~isequal([NPDDS,NDIDDS,1,NHCPF],size(handles.controllerinfo.G_didd2Pdd_all(:,:,1,:)))
            handles.controllerinfo.G_didd2Pdd_all = zeros(NPDDS,NDIDDS,numuiFreqs,NHCPF);
        end
        if ~isequal([NAMIDDS,NDIDDS,1,NHCPF],size(handles.controllerinfo.G_didd2amidd_all(:,:,1,:)))
            handles.controllerinfo.G_didd2amidd_all = zeros(NAMIDDS,NDIDDS,numuiFreqs,NHCPF);
        end
        if ~isequal([NPMIDDS,NDIDDS,1,NHCPF],size(handles.controllerinfo.G_didd2pmidd_all(:,:,1,:)))
            handles.controllerinfo.G_didd2pmidd_all = zeros(NPMIDDS,NDIDDS,numuiFreqs,NHCPF);
        end
        if ~isequal([NDIDDS,NDIDDS,1,NHCPF],size(handles.controllerinfo.G_didd2f_all(:,:,1,:)))
            handles.controllerinfo.G_didd2f_all = zeros(NFS,NDIDDS,numuiFreqs,NHCPF);
        end
        
        freqsNew = eval(answer{1});
        handles.controllerinfo.GdiddInputMag = eval(answer{2});
        GdiddInputMag = handles.controllerinfo.GdiddInputMag;
        
        F_didd_all = sort(unique([freqsOld,freqsNew]));
        indsNew = find(ismember(F_didd_all,freqsNew));
        
        G_didd2PddOld = handles.controllerinfo.G_didd2Pdd_all;
        G_didd2amiddOld = handles.controllerinfo.G_didd2amidd_all;
        G_didd2pmiddOld = handles.controllerinfo.G_didd2pmidd_all;
        G_didd2fOld = handles.controllerinfo.G_didd2f_all;
        
        %store current user-selections/value to be reset later
        F_ui_old = handles.controllerinfo.F_ui;
        
        desSignal = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
        initialControl = get(get(handles.uiInitialModeSelector,'selectedobject'),'tag');
        signalinfo = handles.signalinfo;
        
        %reset radio buttons for duration of transfer function generation
        set(handles.desSignals_didd,'value',1)
        set(handles.desSignals_Pdd,'enable','off')
        set(handles.desSignals_ui,'enable','off')
        
        set(handles.standardModeAI,'enable','off')
        set(handles.forceModeAI,'enable','off')
        
        set(handles.standardModeAO,'enable','off')
        set(handles.cameraModeAO,'enable','off')
        
        set(handles.samplingFreq,'enable','off')
        
        set(handles.uiHarmonics,'enable','off')
        
        set(handles.T,'enable','off')
        
        set(handles.constants,'enable','off')
        set(handles.savedSignalsListbox,'enable','off')
        
        set(handles.maxUpdate,'enable','off')
        set(handles.run,'enable','off')
        
        set(handles.uiAddFreqs,'enable','off')
        set(handles.uiDeleteFreqs,'enable','off')
        set(handles.diddDeleteFreqs,'enable','off')
        set(handles.PddAddFreqs,'enable','off')
        set(handles.PddDeleteFreqs,'enable','off')
        set(handles.PddErrorTol,'enable','off')
        set(handles.maxUpdatePddAddFreqs,'enable','off')
        set(handles.viewTransferFunctions,'enable','off')
        set(handles.currentUpdate,'enable','off')
        set(handles.currentUpdatePddAddFreqs,'enable','off')
        
        
        %update desired signal text
        for i = 1:numel(handles.globalinfo.diddSignals)
            set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.diddSignals{i},' = '],'enable','on')
            set(eval(['handles.desSignalChar',num2str(i)]),'string','0','enable','off')
        end
        
        %set(handles.plottedSignals_didd,'value',1)
        
        %loop to collect new transfer function data
        [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS] = signalCounter(handles);
        
        NHCPF = handles.controllerinfo.harmonicsCollectedPerFreq; %number of harmonics recorded per frequency
        G_didd2PddNew = zeros(NPDDS,NDIDDS,length(freqsNew), NHCPF);
        G_didd2amiddNew = zeros(NAMIDDS,NDIDDS,length(freqsNew),NHCPF);
        G_didd2pmiddNew = zeros(NPMIDDS,NDIDDS,length(freqsNew),NHCPF);
        G_didd2fNew = zeros(NFS,NDIDDS,length(freqsNew),NHCPF);
        
        dt = 1/handles.signalinfo.samplingFreq;
        for in = 1:length(freqsNew)
            f = freqsNew(in);
            handles.signalinfo.T = 1/f;
            T = handles.signalinfo.T;
            set(handles.T,'string',char(sym(T)));
            
            %update controlled frequencies
            handles.controllerinfo.F_ui = f*handles.controllerinfo.uiHarmonics;
            for freq = handles.controllerinfo.F_ui
                if ~ismember(freq,handles.controllerinfo.F_ui_all)
                    error('harmonics do not exist for this test')
                end
            end
            
            set(handles.F_ui,'string',mat2str(handles.controllerinfo.F_ui))
            
            tCyc = (0:dt:T-dt)';
            handles.signalinfo.tCyc = tCyc;
            handles.signalinfo.samplesPerCycle = length(tCyc);
            SPC = handles.signalinfo.samplesPerCycle;
            
            for i = 1:NDIDDS
                
                handles.signalinfo.uiCyc = zeros(SPC,NUIS);
                handles.signalinfo.PddCyc = zeros(SPC,NPDDS);
                handles.signalinfo.PddDesCyc = zeros(SPC,NPDDS);
                handles.signalinfo.pmiddCyc = zeros(SPC,NPMIDDS);
                handles.signalinfo.diddCyc = zeros(SPC,NDIDDS);
                handles.signalinfo.diddDesCyc = zeros(SPC,NDIDDS);
                handles.signalinfo.diddDesCyc(:,i) = GdiddInputMag*sin(2*pi*f*tCyc);
                handles.signalinfo.amiddCyc = zeros(SPC,NAMIDDS);
                handles.signalinfo.fCyc = zeros(SPC,NFS);
                
                diddDesChari = [num2str(GdiddInputMag),'*sin(2*pi*',char(sym(f)),'*t)'];
                eval(['set(handles.desSignalChar',num2str(i),',''string'',diddDesChari)'])
                
                if get(handles.updatePlots,'value')
                    InitializePlotAccSignals(handles)
                    InitializePlotControlSignals(handles)
                end
                
                if ~get(handles.diddAddFreqs,'value')
                    return
                end
                handles = PPODcontroller(handles);
                
                eval(['set(handles.desSignalChar',num2str(i),',''string'',''0'')'])
                
                PddCyc_fft = fft(handles.signalinfo.PddCyc);
                amiddCyc_fft = fft(handles.signalinfo.amiddCyc);
                pmiddCyc_fft = fft(handles.signalinfo.pmiddCyc);
                diddCyc_fft = fft(handles.signalinfo.diddCyc);
                if strcmp(handles.globalinfo.aiConfig,'force')
                    fCyc_fft = fft(handles.signalinfo.fCyc);
                end
                
                %note that NCC = 1 because Cyc signals are getting FFTed
                for out = 1:NHCPF
                    fftIndIn = 2; %always want first harmonic of input signal
                    fftIndOut = out+1; %cycle through harmonics of output signal
                    G_didd2PddNew(:,i,in,out) = PddCyc_fft(fftIndOut,:)/diddCyc_fft(fftIndIn,i);
                    G_didd2amiddNew(:,i,in,out) = amiddCyc_fft(fftIndOut,:)/diddCyc_fft(fftIndIn,i);
                    G_didd2pmiddNew(:,i,in,out) = pmiddCyc_fft(fftIndOut,:)/diddCyc_fft(fftIndIn,i);
                    if strcmp(handles.globalinfo.aiConfig,'force')
                        G_didd2fNew(:,i,in,out) = fCyc_fft(fftIndOut,:)/diddCyc_fft(fftIndIn,i);
                    end
                end
            end
        end
        
        %merge old and new transfer functions
        for in = 1:length(F_didd_all)
            if ismember(in,indsNew)
                ind = find(freqsNew==F_didd_all(in));
                handles.controllerinfo.F_didd_all(in) = freqsNew(ind);
                handles.controllerinfo.G_didd2Pdd_all(:,:,in,:) = G_didd2PddNew(:,:,ind,:);
                handles.controllerinfo.G_didd2amidd_all(:,:,in,:) = G_didd2amiddNew(:,:,ind,:);
                handles.controllerinfo.G_didd2pmidd_all(:,:,in,:) = G_didd2pmiddNew(:,:,ind,:);
                if strcmp(handles.globalinfo.aiConfig,'force')
                    handles.controllerinfo.G_didd2f_all(:,:,in,:) = G_didd2fNew(:,:,ind,:);
                end
            else
                ind = find(freqsOld==F_didd_all(in));
                handles.controllerinfo.F_didd_all(in) = freqsOld(ind);
                handles.controllerinfo.G_didd2Pdd_all(:,:,in,:) = G_didd2PddOld(:,:,ind,:);
                handles.controllerinfo.G_didd2amidd_all(:,:,in,:) = G_didd2amiddOld(:,:,ind,:);
                handles.controllerinfo.G_didd2pmidd_all(:,:,in,:) = G_didd2pmiddOld(:,:,ind,:);
                if strcmp(handles.globalinfo.aiConfig,'force')
                    handles.controllerinfo.G_didd2f_all(:,:,in,:) = G_didd2fOld(:,:,ind,:);
                end
            end
        end
        
        G_didd2Pdd_all = handles.controllerinfo.G_didd2Pdd_all;
        G_didd2amidd_all = handles.controllerinfo.G_didd2amidd_all;
        G_didd2pmidd_all = handles.controllerinfo.G_didd2pmidd_all;
        if strcmp(handles.globalinfo.aiConfig,'force')
            G_didd2f_all = handles.controllerinfo.G_didd2f_all;
        end
        
        switch handles.globalinfo.aiConfig
            case 'standard'
                save([cd,'\freqResponseData\freqResponseDataStandard'],'F_didd_all','G_didd2Pdd_all','G_didd2amidd_all','G_didd2pmidd_all','GdiddInputMag','-append')
            case 'force'
                save([cd,'\freqResponseData\freqResponseDataForce'],'F_didd_all','G_didd2Pdd_all','G_didd2amidd_all','G_didd2pmidd_all','G_didd2f_all','GdiddInputMag','-append')
        end
        
        
        %put signalinfo data back into handles as it was before
        handles.signalinfo = signalinfo;
        handles.globalinfo.mode = mode;
        handles.controllerinfo.numProcessingCycles = NPCOld;
        handles.controllerinfo.cyclesPerUpdate = handles.controllerinfo.numTransientCycles + handles.controllerinfo.numCollectedCycles + handles.controllerinfo.numProcessingCycles;
        handles.controllerinfo.F_ui = F_ui_old;
        set(handles.(desSignal),'value',1)
        set(handles.(initialControl),'value',1)
        
        InitializeGUI(handles)       
        guidata(hObject, handles)
    end
    set(hObject,'value',0,'enable','on')
else
    warndlg('No frequency data was saved')
    uiwait
    InitializeGUI(handles)
end



% --- Executes on button press in diddDeleteFreqs.
function diddDeleteFreqs_Callback(hObject, eventdata, handles)
F_didd_all = handles.controllerinfo.F_didd_all;
answer = inputdlg({['Frequencies to delete: (current frequencies: ',mat2str(F_didd_all),')']},'Delete Frequencies',1,{'[]'});
if ~isempty(answer)
    F_didd_delete = eval(answer{1});
    ind_all = ismember(F_didd_all,F_didd_delete);
    
    handles.controllerinfo.F_didd_all(ind_all) = [];
    handles.controllerinfo.G_didd2Pdd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_didd2amidd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_didd2pmidd_all(:,:,ind_all,:) = [];
    handles.controllerinfo.G_didd2f_all(:,:,ind_all,:) = [];
    
    F_didd_all = handles.controllerinfo.F_didd_all;
    G_didd2Pdd_all = handles.controllerinfo.G_didd2Pdd_all;
    G_didd2amidd_all = handles.controllerinfo.G_didd2amidd_all;
    G_didd2pmidd_all = handles.controllerinfo.G_didd2pmidd_all;
    if strcmp(handles.globalinfo.aiConfig,'force')
        G_didd2f_all = handles.controllerinfo.G_didd2f_all;
    end
    
    switch handles.globalinfo.aiConfig
        case 'standard'
            save([cd,'\freqResponseData\freqResponseDataStandard'],'F_didd_all','G_didd2Pdd_all','G_didd2amidd_all','G_didd2pmidd_all','-append')
        case 'force'
            save([cd,'\freqResponseData\freqResponseDataForce'],'F_didd_all','G_didd2Pdd_all','G_didd2amidd_all','G_didd2pmidd_all','G_didd2f_all','-append')
    end
end

set(hObject,'value',0)

guidata(hObject, handles)

% --- Executes on button press in viewTransferFunctions.
function viewTransferFunctions_Callback(hObject, eventdata, handles)
% hObject    handle to viewTransferFunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ViewTransferFunctions_GUI(handles.globalinfo, handles.controllerinfo)

% --- Executes on button press in useNonlinearHarmonicTerms.
function useNonlinearHarmonicTerms_Callback(hObject, eventdata, handles)
% hObject    handle to useNonlinearHarmonicTerms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useNonlinearHarmonicTerms


% --- Executes on button press in resetDAQ.
function resetDAQ_Callback(hObject, eventdata, handles)
% hObject    handle to resetDAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = InitializeHandles(handles);
InitializeGUI(handles);
guidata(hObject,handles)


% --- Executes when selected object is changed in analogOutputModeSelector.
function analogOutputModeSelector_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in analogOutputModeSelector 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'tag')
    case 'standardModeAO'
        handles.globalinfo.aoConfig = 'standard';
        set(handles.fps,'enable','off')
    case 'cameraModeAO'
        handles.globalinfo.aoConfig = 'camera';
        set(handles.fps,'enable','on')
    otherwise
        error('no matching selection')
end

guidata(hObject,handles)


% --- Executes on button press in PddDeleteFreqs.
function PddDeleteFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to PddDeleteFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PddDeleteFreqs
warndlg('Not functional')
uiwait
set(hObject,'value',0)

% --- Executes on button press in PddAddFreqs.
function PddAddFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to PddAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PddAddFreqs
warndlg('Not functional')
uiwait
set(hObject,'value',0)


function maxUpdatePddAddFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to maxUpdatePddAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxUpdatePddAddFreqs as text
%        str2double(get(hObject,'String')) returns contents of maxUpdatePddAddFreqs as a double


% --- Executes during object creation, after setting all properties.
function maxUpdatePddAddFreqs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxUpdatePddAddFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PddErrorTol_Callback(hObject, eventdata, handles)
% hObject    handle to PddErrorTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PddErrorTol as text
%        str2double(get(hObject,'String')) returns contents of PddErrorTol as a double


% --- Executes during object creation, after setting all properties.
function PddErrorTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PddErrorTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in readLaser.
function readLaser_Callback(hObject, eventdata, handles)
% hObject    handle to readLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.daqinfo.ai,'triggertype','Immediate')
[NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS NDIS] = signalCounter(handles);
V2m_LS = handles.calibrationinfo.V2m_LS;
T_LS2W = handles.calibrationinfo.T_LS2W;
T = handles.signalinfo.T;
start(handles.daqinfo.ai)
wait(handles.daqinfo.ai,2)
aidata_raw = getdata(handles.daqinfo.ai);
stop(handles.daqinfo.ai)
diInit = T_LS2W*mean(aidata_raw(:,NPMIDDS+NAMIDDS+NRFS+1:NPMIDDS+NAMIDDS+NRFS+NDIS))*V2m_LS - .045;
handles.calibrationinfo.diInit = diInit;
set(findobj('tag','diInit'), 'xdata',[0 T],'ydata',[diInit diInit])
ylim = get(handles.laserAxes,'ylim');
if diInit < ylim(1)
    ylim = [diInit - (ylim(2)-ylim(1))/10, ylim(2)];
end
if diInit > ylim(2)
    ylim = [ylim(1), diInit + (ylim(2)-ylim(1))/10];
end
set(handles.laserAxes,'ylim',ylim)

set(handles.daqinfo.ai,'triggertype','HwDigital')
guidata(hObject,handles)


% --- Executes on selection change in signalPanel2Selector.
function signalPanel2Selector_Callback(hObject, eventdata, handles)
% hObject    handle to signalPanel2Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns signalPanel2Selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalPanel2Selector


% --- Executes during object creation, after setting all properties.
function signalPanel2Selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalPanel2Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

