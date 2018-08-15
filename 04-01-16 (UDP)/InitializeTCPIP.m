function handles = InitializeTCPIP(handles)

%initialize a TCP connection
handles.socket = tcpip('0.0.0.0', 27015, 'NetworkRole', 'Server');
handles.socket.InputBufferSize = 19;
handles.socket.Timeout = 120;