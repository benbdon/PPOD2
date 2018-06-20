%This program outputs a continouos output signal 0 - 5V on ao6
daqreset

%'Dev2' - PCIe-6323 - AI
sAI = daq.createSession('ni');
sAI.Rate = 1000;
ch = addAnalogInputChannel(sAI, 'Dev2', 'ai23', 'Voltage');
ch.Name = 'Measurement Signal';
ch.TerminalConfig = 'SingleEnded';
addTriggerConnection(sAI,'External','Dev2/PFI0','StartTrigger');
sAI.Connections(1).TriggerCondition = 'RisingEdge';

%'Dev1' - PCI-6713 - AO
sAO = daq.createSession('ni');
sAO.Rate = 1000;
lhAO = addlistener(sAO,'DataRequired', ...
    @(src,event) src.queueOutputData([clock, signal]));
sAO.IsContinuous = true; %NECESSARY AND NOT IN DOCUMENTATION

ch = addAnalogOutputChannel(sAO,'Dev1', 'ao0', 'Voltage');
ch.Name = 'clock';
clock = zeros(5000,1);
clock(250,1) = 5;

ch = addAnalogOutputChannel(sAO,'Dev1', 'ao6', 'Voltage');
ch.Name = 'signal';
signal = [linspace(0,5,4999)';0];

%Queue up the output
queueOutputData(sAO,[clock,signal])

%Start AI/AO tasks
startBackground(sAO);
pause(); %await keypress
[data,timestamps] = startForeground(sAI);
delete(lhAO)
stop(sAO)
stop(sAI)
plot(timestamps,data)
