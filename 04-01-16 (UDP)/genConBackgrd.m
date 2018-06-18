%This program outputs a continouos output signal 0 - 5V on ao6
daqreset

%Initialize DAQ settings
s = daq.createSession('ni');
sAI = daq.createSession('ni');
s.Rate=1000;
sAI.Rate=1000;
sAI.DurationInSeconds = 2;

ch = addAnalogOutputChannel(s,'Dev1', 'ao6', 'Voltage');
ch.Name = 'Command Signal';

ch = addAnalogInputChannel(sAI, 'Dev2', 'ai23', 'Voltage');
ch.Name = 'Measurement Signal';
ch.TerminalConfig = 'SingleEnded';

%Add listener to the 'DataRequired' event and assign it to the variable lh
%lhAI = addlistener(sAI,'DataAvailable', @plotData);
lhAO = addlistener(s,'DataRequired',@queueMoreData);
s.IsContinuous = true; %NECESSARY AND NOT IN DOCUMENTATION

%Queue sample data
queueOutputData(s,linspace(0,5,999)');

%Start AI/AO tasks
startBackground(s);

%await keypress
pause();
disp(s.ScansQueued)
measured = startForeground(sAI);
delete(lhAO)
plot(measured)