function varargout = SignalDetails_GUI(varargin)
% SIGNALDETAILS_GUI M-file for SignalDetails_GUI.fig
%      SIGNALDETAILS_GUI, by itself, creates a new SIGNALDETAILS_GUI or raises the existing
%      singleton*.
%
%      H = SIGNALDETAILS_GUI returns the handle to a new SIGNALDETAILS_GUI or the handle to
%      the existing singleton*.
%
%      SIGNALDETAILS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNALDETAILS_GUI.M with the given input arguments.
%
%      SIGNALDETAILS_GUI('Property','Value',...) creates a new SIGNALDETAILS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SignalDetails_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SignalDetails_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SignalDetails_GUI

% Last Modified by GUIDE v2.5 17-Feb-2009 10:28:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SignalDetails_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SignalDetails_GUI_OutputFcn, ...
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


% --- Executes just before SignalDetails_GUI is made visible.
function SignalDetails_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SignalDetails_GUI (see VARARGIN)

% Choose default command line output for SignalDetails_GUI
handles.output = hObject;

handles.mainGUIhandles = varargin{1};

%set check boxes in signals panel
set(handles.y,'value',1)
set(handles.d,'value',1)
set(handles.e,'value',1)
set(handles.pddx,'Value',1)

T = handles.mainGUIhandles.signalinfo.T;
f1 = sym(1/T);
F_ui = handles.mainGUIhandles.controllerinfo.F_ui;
set(handles.plottedfreqs,'string',['[',num2str(eval(f1)),':',num2str(eval(f1)),':',num2str(F_ui(end)*3),']'])

%turn off frequency options panel
set(handles.freqoptions_panel,'visible','off')
set(handles.amplitude,'value',1)

set(handles.frequency,'value',1)

PlotSignalDetails(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SignalDetails_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SignalDetails_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function plottedfreqs_Callback(hObject, eventdata, handles)
% hObject    handle to plottedfreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plottedfreqs as text
%        str2double(get(hObject,'String')) returns contents of plottedfreqs as a double
PlotSignalDetails(handles)

% --- Executes during object creation, after setting all properties.
function plottedfreqs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottedfreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in y.
function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of y

PlotSignalDetails(handles)

% --- Executes on button press in d.
function d_Callback(hObject, eventdata, handles)
% hObject    handle to d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of d

PlotSignalDetails(handles)

% --- Executes on button press in e.
function e_Callback(hObject, eventdata, handles)
% hObject    handle to e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of e

PlotSignalDetails(handles)


% --- Executes when selected object is changed in signalpanel.
function signalpanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in signalpanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

PlotSignalDetails(handles)


% --- Executes when selected object is changed in domainpanel.
function domainpanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in domainpanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

PlotSignalDetails(handles)


% --- Executes when selected object is changed in magscalepanel.
function magscalepanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in magscalepanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

PlotSignalDetails(handles)


% --- Executes on button press in u.
function u_Callback(hObject, eventdata, handles)
% hObject    handle to u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of u

PlotSignalDetails(handles)
