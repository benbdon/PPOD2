function varargout = ViewG_didd_GUI(varargin)
% VIEWG_DIDD_GUI M-file for ViewG_didd_GUI.fig
%      VIEWG_DIDD_GUI, by itself, creates a new VIEWG_DIDD_GUI or raises the existing
%      singleton*.
%
%      H = VIEWG_DIDD_GUI returns the handle to a new VIEWG_DIDD_GUI or the handle to
%      the existing singleton*.
%
%      VIEWG_DIDD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWG_DIDD_GUI.M with the given input arguments.
%
%      VIEWG_DIDD_GUI('Property','Value',...) creates a new VIEWG_DIDD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ViewG_didd_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ViewG_didd_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ViewG_didd_GUI

% Last Modified by GUIDE v2.5 16-Nov-2010 14:57:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ViewG_didd_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ViewG_didd_GUI_OutputFcn, ...
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


% --- Executes just before ViewG_didd_GUI is made visible.
function ViewG_didd_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ViewG_didd_GUI (see VARARGIN)

% Choose default command line output for ViewG_didd_GUI
handles.output = hObject;

handles.mainGUIhandles = varargin{1};

set(handles.u1_2_Pdd,'Value',1)

PlotGn(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ViewG_didd_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ViewG_didd_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ui_2_pm1ddx.
function ui_2_pm1ddx_Callback(hObject, eventdata, handles)
% hObject    handle to ui_2_pm1ddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_2_pm1ddx


% --- Executes on button press in ui_2_pm1ddy.
function ui_2_pm1ddy_Callback(hObject, eventdata, handles)
% hObject    handle to ui_2_pm1ddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_2_pm1ddy


% --- Executes on button press in ui_2_pm2ddx.
function ui_2_pm2ddx_Callback(hObject, eventdata, handles)
% hObject    handle to ui_2_pm2ddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_2_pm2ddx


% --- Executes on button press in sp42y_sp.
function sp42y_sp_Callback(hObject, eventdata, handles)
% hObject    handle to sp42y_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp42y_sp


% --- Executes on button press in u3_2_didd.
function u3_2_didd_Callback(hObject, eventdata, handles)
% hObject    handle to u3_2_didd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u3_2_didd


% --- Executes on button press in u2_2_didd.
function u2_2_didd_Callback(hObject, eventdata, handles)
% hObject    handle to u2_2_didd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u2_2_didd


% --- Executes on button press in u1_2_didd.
function u1_2_didd_Callback(hObject, eventdata, handles)
% hObject    handle to u1_2_didd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u1_2_didd


% --------------------------------------------------------------------
function plotoptions_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plotoptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when selected object is changed in plotoptions.
function plotoptions_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in plotoptions 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

PlotGn(handles)


% --- Executes when selected object is changed in gainunits.
function gainunits_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in gainunits 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

PlotGn(handles)

% --- Executes on button press in ui_2_pm2ddy.
function ui_2_pm2ddy_Callback(hObject, eventdata, handles)
% hObject    handle to ui_2_pm2ddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_2_pm2ddy


% --- Executes when selected object is changed in frequencyunits.
function frequencyunits_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in frequencyunits 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
PlotGn(handles)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
