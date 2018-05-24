function handles = Initializedaqinfo(handles)

%daqinfo
handles.daqinfo.samples_per_second = 9000;
handles.daqinfo.num_transient_cycles = 5;
handles.daqinfo.num_collected_cycles = 5;
handles.daqinfo.num_processing_cycles = 20;
handles.daqinfo.cycles_per_update = handles.daqinfo.num_transient_cycles+handles.daqinfo.num_collected_cycles+handles.daqinfo.num_processing_cycles;

%ao channel names are: clock sp1, sp2, sp3, sp4, sp5, sp6
%ai channel names are: x1dd, y1dd, x2dd, y2dd, x3dd,
%y3dd, x4dd, y4dd, x5dd, y5dd, x6dd, y6dd
handles.daqinfo.ao_channel_names = ['clock', handles.globalinfo.controlsignals];
handles.daqinfo.ai_channel_names = handles.globalinfo.rawplatesignals;

daqinfo = daqhwinfo;
if ismember('nidaq',daqinfo.InstalledAdaptors)
    %nidaq has been found, so configure daq settings
    if (~isempty(daqfind))
        stop(daqfind)
    end
    daqreset

    %create input and output objects
    handles.daqinfo.ao = analogoutput('nidaq','Dev2');
    handles.daqinfo.ai = analoginput('nidaq','Dev1');
    
    %daq properties
    set(handles.daqinfo.ai,'InputType','SingleEnded')
    set(handles.daqinfo.ai,'TriggerType','HwDigital')
    set(handles.daqinfo.ai,'TriggerCondition','PositiveEdge');

    %set up channels
    controlsignals = handles.globalinfo.controlsignals;
    rawplatesignals = handles.globalinfo.rawplatesignals;
    addchannel(handles.daqinfo.ao, [0:numel(controlsignals)],[1:numel(controlsignals)+1], handles.daqinfo.ao_channel_names);
    %addchannel(handles.daqinfo.ai, [0:numel(rawplatesignals)-1],[1:numel(rawplatesignals)], handles.daqinfo.ai_channel_names);

    addchannel(handles.daqinfo.ai, [0:2,4:7,15,8:11],[1:numel(rawplatesignals)], handles.daqinfo.ai_channel_names);

    %set sample rates
    handles.daqinfo.ao.SampleRate = handles.daqinfo.samples_per_second;
    handles.daqinfo.ai.SampleRate = handles.daqinfo.samples_per_second;
    
    %set range of input voltages
    handles.daqinfo.ai.Channel.InputRange = [-5, 5];

else
    %no nidaq found

    handles.daqinfo.ao = [];
    handles.daqinfo.ai = [];
    handles.daqinfo.ao.SampleRate = [];
    handles.daqinfo.ai.SampleRate = [];
end
