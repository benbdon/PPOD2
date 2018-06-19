%This function does a loopback test using a stairstep from 0 - 5
% as an output from ao6 and measures it back on channel ai23. 

%FYI: despite starting the the AO/AI task at the same time, the AO leads
%the AI by ~45 mSec

%reset all DAQ settings (just in case)
daqreset

%Create a session
sAI = daq.createSession('ni');
sAO = daq.createSession('ni');
sAI.Rate = 10000;
sAO.Rate = 10000;

ch = addAnalogOutputChannel(sAO,'Dev1', 'ao6', 'Voltage');
ch.Name = 'Command Signal';

ch = addAnalogInputChannel(sAI, 'Dev2', 'ai23', 'Voltage');
ch.Name = 'Measurement Signal';
ch.TerminalConfig = 'SingleEnded';

%Generate Sample Data (linear 0 to 5V ending back at zero
outputSignal = [linspace(0,5,9999)';0];
queueOutputData(sAO,outputSignal);
d = startBackground(sAO);
[measured_data,timestamps] = startForeground(sAI);

plot(timestamps,measured_data)
hold on
plot(timestamps,outputSignal)
xlabel('Time');
ylabel('Voltage');
legend('measured data','outputSignal')
stop(s);
disp('Done')