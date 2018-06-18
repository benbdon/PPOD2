%This function does a loopback test using a stairstep from 0 - 5 (step size
%of 1) as an output from ao6 and measures it back on channel ai23.

daqreset

%Create a session
s = daq.createSession('ni');
s.Rate=10000;

ch = addAnalogOutputChannel(s,'Dev1', 'ao6', 'Voltage');
ch.Name = 'Command Signal';

ch = addAnalogInputChannel(s, 'Dev2', 'ai23', 'Voltage');
ch.Name = 'Measurement Signal';
ch.TerminalConfig = 'SingleEnded';

%Generate Sample Data (linear 0 to 5V ending back at zero
outputSignal = [linspace(0,5,50000)';0];
queueOutputData(s,outputSignal);
data = startForeground(s);

plot(outputSignal)
hold on
plot(data)
xlabel('Time');
ylabel('Voltage');
legend('Analog Output','Measured Signal')
stop(s);
disp('Done')