function varargout = ViewGn_GUI(varargin)
% VIEWGN_GUI M-file for ViewGn_GUI.fig
%      VIEWGN_GUI, by itself, creates a new VIEWGN_GUI or raises the existing
%      singleton*.
%
%      H = VIEWGN_GUI returns the handle to a new VIEWGN_GUI or the handle to
%      the existing singleton*.
%
%      VIEWGN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWGN_GUI.M with the given input arguments.
%
%      VIEWGN_GUI('Property','Value',...) creates a new VIEWGN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ViewGn_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ViewGn_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ViewGn_GUI

% Last Modified by GUIDE v2.5 13-Feb-2009 13:39:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ViewGn_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ViewGn_GUI_OutputFcn, ...
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


% --- Executes just before ViewGn_GUI is made visible.
function ViewGn_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ViewGn_GUI (see VARARGIN)

% Choose default command line output for ViewGn_GUI
handles.output = hObject;

handles.mainGUIhandles = varargin{1};
PlotGn(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ViewGn_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ViewGn_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in u_2_x1dd.
function u_2_x1dd_Callback(hObject, eventdata, handles)
% hObject    handle to u_2_x1dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u_2_x1dd


% --- Executes on button press in u_2_y1dd.
function u_2_y1dd_Callback(hObject, eventdata, handles)
% hObject    handle to u_2_y1dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u_2_y1dd


% --- Executes on button press in u_2_x2dd.
function u_2_x2dd_Callback(hObject, eventdata, handles)
% hObject    handle to u_2_x2dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u_2_x2dd


% --- Executes on button press in sp42y_sp.
function sp42y_sp_Callback(hObject, eventdata, handles)
% hObject    handle to sp42y_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp42y_sp


% --- Executes on button press in u3_2_y_sp.
function u3_2_y_sp_Callback(hObject, eventdata, handles)
% hObject    handle to u3_2_y_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u3_2_y_sp


% --- Executes on button press in u2_2_y_sp.
function u2_2_y_sp_Callback(hObject, eventdata, handles)
% hObject    handle to u2_2_y_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u2_2_y_sp


% --- Executes on button press in u1_2_y_sp.
function u1_2_y_sp_Callback(hObject, eventdata, handles)
% hObject    handle to u1_2_y_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u1_2_y_sp


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

% --- Executes on button press in u_2_y2dd.
function u_2_y2dd_Callback(hObject, eventdata, handles)
% hObject    handle to u_2_y2dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u_2_y2dd


% --- Executes when selected object is changed in frequencyunits.
function frequencyunits_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in frequencyunits 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
PlotGn(handles)

