function daqinfo = Initializedaqinfo(handles)

uSignals = handles.globalinfo.uSignals;
diddSignals = handles.globalinfo.diddSignals;
amiddSignals = handles.globalinfo.amiddSignals;
pmiddSignals = handles.globalinfo.pmiddSignals;
rawForceSignals = handles.globalinfo.rawForceSignals;

samplingFreq = handles.signalinfo.samplingFreq;

%ao channel names are: aiTrig uSignals, camTrig
daqinfo.aoChannelNames = ['aiTrig', uSignals, 'camTrig'];
%ai channel names are: 
%standard mode: pmiddSignals, diddSignals
%flexure testing mode: pmiddSignals, rawForceSignals

daqinfo.aiChannelNames = [pmiddSignals, amiddSignals, rawForceSignals];

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
    %AI: PCI-6224
    %AO: PCI-6713
    nidaq = daqhwinfo('nidaq');
    BoardNames = nidaq.BoardNames;
    InstalledBoardIds = nidaq.InstalledBoardIds;
    for i = 1:length(BoardNames)
        switch BoardNames{i}
            case 'PCI-6224'
                daqinfo.ai = analoginput('nidaq',InstalledBoardIds{i});
            case 'PCI-6713'
                daqinfo.ao = analogoutput('nidaq',InstalledBoardIds{i});
        end
    end

    
    %daq properties
    set(daqinfo.ai,'InputType','SingleEnded')
    set(daqinfo.ai,'TriggerType','HwDigital')
    set(daqinfo.ai,'TriggerCondition','PositiveEdge');

    %set up channels
    addchannel(daqinfo.ao, 0:numOutputs-1,1:numOutputs, daqinfo.aoChannelNames);
    if ~get(handles.resetDAQForceMode,'value')
        addchannel(daqinfo.ai, 0:numInputs-1,1:numInputs, daqinfo.aiChannelNames);
    else
        addchannel(daqinfo.ai, [0:7,18:23,26:31],1:numInputs,daqinfo.aiChannelNames);
    end
    
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
