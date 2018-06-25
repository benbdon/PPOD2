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

%'Dev1' - PCI-6713 - AO channels
sAO = daq.createSession('ni');
sAO.Rate = 1000;
sAO.IsContinuous = true; %NECESSARY AND NOT IN DOCUMENTATION
ch = addAnalogOutputChannel(sAO,'Dev1', 'ao0', 'Voltage');
ch.Name = 'clock';
ch = addAnalogOutputChannel(sAO,'Dev1', 'ao1', 'Voltage');
ch.Name = 'signal';
lhAO = addlistener(sAO,'DataRequired', @(src,event) queueOutputData(src,[evalin('base','clock'), evalin('base','signal')]));
% lhAO = addlistener(sAO,'DataRequired', @(src,event) ... 
%     queueOutputData(src,[clock,signal])); %running line 22 and 23 rather
%     than 21 will cause the AI to never be triggered

%5000 voltages all 0's (won't trigger acquisition)
clock = zeros(5000,1); 

%5000 voltages data points from 0 to 5 and back to 0
signal = [linspace(0,5,4999)';0];

%add the column of 0's and the increasing signal
queueOutputData(sAO,[clock, signal]);

%eventually the AO queue will run-out of data and this new clock signal should get queued 
clock(4000,1) = 5;

%Start AI/AO tasks
startBackground(sAO);
[data,timestamps] = startForeground(sAI); %waits for a trigger before acquiring
delete(lhAO)
stop(sAO)
stop(sAI)
plot(timestamps,data)
