function [handles] = udpReceive(handles)

% Modify these values to be those of your first computer:
ipA = '129.105.69.211'; portA = 4500;   % Machine A

% Modify these values to be those of your second computer:
%ipC = '129.105.69.255'; portC = 9091;   % Machine C

% Create UDP Object
handles.udp = udp(ipA,portA);
