function daqinfo = InitializeDAQInfo(handles)

uiSignals = handles.globalinfo.uiSignals;
amiddSignals = handles.globalinfo.amiddSignals;
pmiddSignals = handles.globalinfo.pmiddSignals;
rawForceSignals = handles.globalinfo.rawForceSignals;
diSignals = handles.globalinfo.diSignals;

%analog output and analog input channel names
daqinfo.aoChannelNames = ['aiTrig', uiSignals, 'camTrig'];
daqinfo.aiChannelNames = [pmiddSignals, amiddSignals, rawForceSignals, diSignals];

numOutputs = numel(daqinfo.aoChannelNames);
numInputs = numel(daqinfo.aiChannelNames);

if license('test','data_acq_toolbox')%check to make sure data acquisition toolbox is installed
    if ismember('ni',daq.getVendors().ID)
        daqreset
        %create input and output objects
        %AI: PCI-6323, analog input board 32 channels
        %AO: PCI-6713, analog output board
        
        BoardNames = daq.getDevices();
        for i = 1:length(BoardNames)
            switch BoardNames(i).Model
                case 'PCIe-6323'
                    %add analog input channels to session
                    sAI = daq.createSession('ni');
                    ch = addAnalogInputChannel(sAI,BoardNames(i).ID,0:numInputs-1,'Voltage');
                    
                    %configure each channel
                    for i3 = 1:numInputs
                        ch(i3).Name = daqinfo.aiChannelNames{i3};
                        ch(i3).Range = [-5, 5];
                        ch(i3).TerminalConfig = 'SingleEnded';  
                    end
                    
                    %trigger properties
                    addTriggerConnection(sAI,'External','Dev2/PFI0','StartTrigger');
                    sAI.Connections(1).TriggerCondition = 'RisingEdge';
  
                case 'PCI-6713'
                    sAO = daq.createSession('ni');
                    %add analog output channels to session
                    ch = addAnalogOutputChannel(sAO,BoardNames(i).ID,0:numOutputs-1,'Voltage');
                    
                    %configure each channel
                    for i2 = 1:numOutputs
                        ch(i2).Name = daqinfo.aoChannelNames{i2};
                    end
                    daqinfo.ao = ch;
                otherwise
                    disp("Unexpected DAQ card")
            end
        end
    end 
end

%set sample rates
samplingFreq = handles.signalinfo.samplingFreq;
sAI.Rate = samplingFreq;
sAO.Rate = samplingFreq;
sAO.IsContinuous = true;
%add sessions to the handle
daqinfo.sAI = sAI;
daqinfo.sAO = sAO;
