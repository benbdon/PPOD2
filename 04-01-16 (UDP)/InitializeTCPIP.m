function tcp = InitializeTCPIP()

% Create TCP Object
tcp = tcpip('0.0.0.0', 27015, 'NetworkRole', 'Server');
set(tcp,'InputBufferSize',20);
tcp.BytesAvailableFcnCount = 19;
tcp.BytesAvailableFcnMode = 'byte';
tcp.Timeout = 120;