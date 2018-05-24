function daqinfo = Initializedaqinfo(handles)

controlSignals = handles.globalinfo.controlSignals;
actuatorAccSignals = handles.globalinfo.actuatorAccSignals;
plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;

samplingFreq = handles.signalinfo.samplingFreq;

%ao channel names are: aiTrig controlSignals, camTrig
%ai channel names are: plateAccLocalSignals, actuatorAccSignals
daqinfo.aoChannelNames = ['aiTrig', controlSignals, 'camTrig'];
daqinfo.aiChannelNames = [plateAccLocalSignals, actuatorAccSignals];
numOutputs = numel(daqinfo.aoChannelNames);
numInputs = numel(daqinfo.aiChannelNames);

daqhw = daqhwinfo;
if ismember('nidaq',daqhw.InstalledAdaptors)
    %nidaq has been found, so configure daq settings
    if (~isempty(daqfind))
        stop(daqfind)
    end
    daqreset

    %create input and output objects
    daqinfo.ao = analogoutput('nidaq','Dev2');
    daqinfo.ai = analoginput('nidaq','Dev3');
    
    %daq properties
    set(daqinfo.ai,'InputType','SingleEnded')
    set(daqinfo.ai,'TriggerType','HwDigital')
    set(daqinfo.ai,'TriggerCondition','PositiveEdge');

    %set up channels
    addchannel(daqinfo.ao, 0:numOutputs-1,1:numOutputs, daqinfo.aoChannelNames);
    addchannel(daqinfo.ai, 0:numInputs-1,1:numInputs, daqinfo.aiChannelNames);

    %set sample rates
    daqinfo.ao.SampleRate = samplingFreq;
    daqinfo.ai.SampleRate = samplingFreq;
    
    %set range of input voltages
    daqinfo.ai.Channel.InputRange = [-5, 5];

else
    %no nidaq found
    daqinfo.ao = [];
    daqinfo.ai = [];
    daqinfo.ao.SampleRate = [];
    daqinfo.ai.SampleRate = [];
end
