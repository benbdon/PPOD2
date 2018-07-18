% Create UDP Object
%handles.udp = udp(ipA,portA,'LocalPort',portB);
handles.udp = udp(ipA,portA);
handles.udp.bytesavailablefcnmode = 'byte';     % A bytes-available event is generated when the specified number of bytes is available (bytesavailablefcncount)
handles.udp.inputbuffersize = 256;
handles.udp.bytesavailablefcncount = 3;

% Where to store signals sent over UDP - InitializeHandles.m
disp(handles.signalinfo.PddCyc) % <384x6 double>

H = load('C:\Documents and Settings\LIMS\Desktop\PPOD_6D\08-07-12\SavedSignals_Pdd\Circle.mat');
H.signalinfo

%  ans = 
% 
%                   T: 0.0500
%           constants: {'w = 2*pi/T'}
%        samplingFreq: 10000
%                  dt: 1.0000e-04
%                tCyc: [500x1 double]
%     samplesPerCycle: 500
%          PddDesChar: {'0'  '0'  '7*sin(w*t+1/2*pi)'  '0'  '0'  '100*sin(w*t)'}
%           uiDesChar: {'0'  '0'  '0'  '0'  '0'  '0'}
%         diddDesChar: {'0'  '0'  '0'  '0'  '0'  '0'}
%              PddCyc: [500x6 double]
%           PddDesCyc: [500x6 double]
%            pmiddCyc: [500x12 double]
%            amiddCyc: [500x12 double]
%             diddCyc: [500x6 double]
%          diddDesCyc: [500x6 double]
%               uiCyc: [500x6 double]
%            uiDesCyc: [500x6 double]
%                fCyc: [500x0 double]
%               diCyc: [500x0 double]

 


%initialize all variables and GUI - PPOD_6D_Master_GUI.m - near top
handles = InitializeHandles(handles);
InitializeGUI(handles);
handles = udpReceive(handles);
handles.udp.BytesAvailableFcnCount = 2;
handles.udp.bytesavailablefcn = {@UpdateFromCamera_Callback,handles};
fopen(handles.udp);
set(handles.udp_text,'value',0)
handles.count = 0;

udpCommand = str2double(fscanf(handles.udp));
handles.count = handles.count + 1;
set(handles.udp_text,'value',udpCommand);
set(handles.udp_text,'string',num2str(udpCommand));
set(handles.savedSignalsListbox,'value',udpCommand);


% Hints: get(hObject,'String') returns contents of udp_text as text
%        str2double(get(hObject,'String')) returns contents of udp_text as a double



% PPODcontroller.m - main while loop - check handles.udp_txt
while currentUpdate < maxUpdate

     if (savedSignalVal ~= get(handles.udp_text,'value')) && (get(handles.udp_text,'value')~=0)
         set(handles.savedSignalsListbox,'value',get(handles.udp_text,'value'));
     end
end