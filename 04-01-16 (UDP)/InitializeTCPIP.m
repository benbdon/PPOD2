function t = InitializeTCPIP()

% Create TCP Object
t = tcpip('0.0.0.0', 27015, 'NetworkRole', 'Server');
set(t,'InputBufferSize',20);
t.BytesAvailableFcnCount = 19;
t.BytesAvailableFcnMode = 'byte';
t.Timeout = 120;