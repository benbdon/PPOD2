%This function does a loopback test using a stairstep from 0 - 5
% as an output from ao6 and measures it back on channel ai23. 

%FYI: despite starting the the AO/AI task at the same time, the AO leads
%the AI by ~45 mSec

%reset all DAQ settings (just in case)
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
sAO.Rate = 10000;

ch = addAnalogOutputChannel(sAO,'Dev1', 'ao0', 'Voltage');
ch.Name = 'clock';
clock = zeros(2000,1);
clock(1000,1) = 5;

ch = addAnalogOutputChannel(sAO,'Dev1', 'ao6', 'Voltage');
ch.Name = 'signal';
signal = [linspace(0,1,1999)';0];

%Queue up the output
queueOutputData(sAO,[clock,signal])
startBackground(sAO);
[measured_data,timestamps] = startForeground(sAI);

plot(timestamps+1,measured_data)
hold on
time = linspace(0,2,2000)';
plot(time,signal)
xlabel('Time');
ylabel('Voltage');
legend('measured data','signal')
stop(sAO);
stop(sAI);
disp('Done')