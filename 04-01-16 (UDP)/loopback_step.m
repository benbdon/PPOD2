%This function does a loopback test using a stairstep from 0 - 5 (step size
%of 1) as an output from ao6 and measures it back on channel ai23.

%Create a session
s = daq.createSession('ni');
%Adding an Output Channel (session, deviceID, measurementType)

%
addAnalogOutputChannel(s,'Dev1', 'ao6', 'Voltage');
ch = addAnalogInputChannel(s, 'Dev2', 'ai23', 'Voltage');
ch.TerminalConfig = 'SingleEnded';
outputSignal = [];
for n = 0:5
    outputSignal = vertcat(outputSignal,n*ones(1000,1));
end
outputSignal = vertcat(outputSignal,zeros());
queueOutputData(s,outputSignal);
data = startForeground(s);
disp(s)
plot(outputSignal)
hold on
plot(data)
xlabel('Time');
ylabel('Voltage');
legend('Analog Output','Measured Signal')
stop(s);
disp('Done')