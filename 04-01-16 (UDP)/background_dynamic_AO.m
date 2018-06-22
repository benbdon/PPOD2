%This program should output an increasing output signal from 0 - 5 V
%continuously on ao6 UNTIL it becomes 1 V and stays there.


%Initialize DAQ Device 'Dev1' - PCI-6713 - AO
daqreset %reset daq
sAO = daq.createSession('ni'); %create a DAQ session for NI card
sAO.Rate = 100; %Update AO 100 times per second
ch = addAnalogOutputChannel(sAO,'Dev1', 'ao1', 'Voltage'); %Add daq device and channel to session
signal = [linspace(0,5,299)';0]; %Incremental values from 0 to 5V ending back at 0.
queueOutputData(sAO,signal) %buffer some output

%Start AI/AO tasks
sAO.IsContinuous = true; %NECESSARY AND NOT IN DOCUMENTATION
lhAO = addlistener(sAO,'DataRequired', @(src,event) queueOutputData(src,evalin('base','signal')));
startBackground(sAO);

%Change values to buffer in the output queue
signal = ones(300,1);
pause(); %await keypress
signal = 2*ones(300,1);
pause();
delete(lhAO)
stop(sAO)
disp('Done')