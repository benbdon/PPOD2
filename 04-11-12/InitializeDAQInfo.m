function daqinfo = InitializeDAQInfo(handles)

uiSignals = handles.globalinfo.uiSignals;
amiddSignals = handles.globalinfo.amiddSignals;
pmiddSignals = handles.globalinfo.pmiddSignals;
rawForceSignals = handles.globalinfo.rawForceSignals;
diSignals = handles.globalinfo.diSignals;

%analog output and analog input channel names
daqinfo.aoChannelNames = ['aiTrig', uiSignals];%, 'camTrig'];
daqinfo.aiChannelNames = [pmiddSignals, amiddSignals, rawForceSignals, diSignals];

numOutputs = numel(daqinfo.aoChannelNames);
numInputs = numel(daqinfo.aiChannelNames);

if license('test','data_acq_toolbox')%check to make sure data acquisition toolbox is installed
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
                    daqinfo.ai = analoginput('nidaq',InstalledBoardIds{i}); %#ok<TNMLP>
                case 'PCI-6713'
                    daqinfo.ao = analogoutput('nidaq',InstalledBoardIds{i}); %#ok<TNMLP>
            end
        end
        
        
        %daq properties
        set(daqinfo.ai,'InputType','SingleEnded')
        set(daqinfo.ai,'TriggerType','HwDigital')
        set(daqinfo.ai,'TriggerCondition','PositiveEdge');
        
        %set up channels
        addchannel(daqinfo.ao, 0:numOutputs-1,1:numOutputs, daqinfo.aoChannelNames);
        switch handles.globalinfo.aiConfig
            case 'standard'
                addchannel(daqinfo.ai, 0:numInputs-1,1:numInputs, daqinfo.aiChannelNames);
            case 'force'
                %addchannel(daqinfo.ai, [0:7,18:23,26:31],1:numInputs,daqinfo.aiChannelNames);
                addchannel(daqinfo.ai, 0:numInputs-1,1:numInputs, daqinfo.aiChannelNames);
        end
        
        %set sample rates
        samplingFreq = handles.signalinfo.samplingFreq;
        daqinfo.ao.SampleRate = samplingFreq;
        daqinfo.ai.SampleRate = samplingFreq;
        
        %set range of input voltages
        daqinfo.ai.Channel.InputRange = [-5, 5];
        if ~isempty(diSignals)
            daqinfo.ai.Channel.InputRange(end) = [-10 10];
        end
    else
        disp('NI DAQ cards not found')
        daqinfo.ao = [];
        daqinfo.ai = [];
        daqinfo.ao.SampleRate = [];
        daqinfo.ai.SampleRate = [];
    end
else
    disp('Data acquisition toolbox not installed')
    daqinfo.ao = [];
    daqinfo.ai = [];
    daqinfo.ao.SampleRate = [];
    daqinfo.ai.SampleRate = [];
end
