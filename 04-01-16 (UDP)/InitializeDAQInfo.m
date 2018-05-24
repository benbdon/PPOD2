function daqinfo = InitializeDAQInfo(handles)

uiSignals = handles.globalinfo.uiSignals;
amiddSignals = handles.globalinfo.amiddSignals;
pmiddSignals = handles.globalinfo.pmiddSignals;
rawForceSignals = handles.globalinfo.rawForceSignals;
diSignals = handles.globalinfo.diSignals;

%analog output and analog input channel names
daqinfo.aoChannelNames = ['aiTrig', uiSignals, 'camTrig'];%, 'camTrig'];
daqinfo.aiChannelNames = [pmiddSignals, amiddSignals, rawForceSignals, diSignals];

numOutputs = numel(daqinfo.aoChannelNames);
numInputs = numel(daqinfo.aiChannelNames);

if license('test','data_acq_toolbox')%check to make sure data acquisition toolbox is installed
    if ismember('ni',daq.getVendors().ID)
        daqreset
        %create input and output objects
        %AI: PCI-6323, analog input board 32 channels
        %AO: PCI-6713, analog output board
        s = daq.createSession('ni');
        BoardNames = daq.getDevices();
        for i = 1:length(BoardNames)
            switch BoardNames(i).Model
                case 'PCI-6323'
                    switch handles.globalinfo.aiConfig
                        case 'standard'
                            daqinfo.ai = addAnalogInputChannel(s,BoardNames(i).ID,0:numInputs-1,'Voltage');
                            %daqinfo.ai = addAnalogInputChannel(s,BoardNames(i).ID,0:numInputs-1,1:numInputs,'Voltage');
                        case 'force'
                            daqinfo.ai = addAnalogInputChannel(s,BoardNames(i).ID,0:numInputs-1,'Voltage');
                            %daqinfo.ai = addAnalogInputChannel(s,BoardNames(i).ID,0:numInputs-1,1:numInputs,'Voltage');
                    end
                    daqinfo.ai.Name = daqinfo.aiChannelNames;
                case 'PCI-6713'
                    addAnalogOutputChannel(s,BoardNames(i).ID,0:numOutputs-1,'Voltage');
%                   daqinfo.ao = addAnalogOutputChannel(s,BoardNames(i).ID,0:numOutputs-1,1:numOutputs,'Voltage');
                    daqinfo.ao.Name = daqinfo.aoChannelNames;
            end
        end
        
        
        %daq properties
        daqinfo.ai.TerminalConfig = 'SingleEnded';
        %set(daqinfo.ai,'InputType','SingleEnded')
        daqinfo.ai = addTriggerConnection(s,'External','Dev1/PFI0','StartTrigger');
        %set(daqinfo.ai,'TriggerType','HwDigital')
        s.Connections(1).TriggerCondition = 'RisingEdge';
        %set(daqinfo.ai,'TriggerCondition','PositiveEdge');
        
        %set up channels
        %addchannel(daqinfo.ao, 0:numOutputs-1,daqinfo.aoChannelNames);
        
        
        %set sample rates
        samplingFreq = handles.signalinfo.samplingFreq;
        s.Rate = samplingFreq;
%       daqinfo.ao.SampleRate = samplingFreq;
%       daqinfo.ai.SampleRate = samplingFreq;
%         
        %set range of input voltages
        daqinfo.Range = [-5, 5];
%       daqinfo.ai.Channel.InputRange = [-5, 5];
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
