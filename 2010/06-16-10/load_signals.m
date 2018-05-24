function handles = load_signals(handles)

platesignals = handles.globalinfo.platesignals;

filenames = get(handles.savedhandles_listbox,'String');
selectedfile = filenames{get(handles.savedhandles_listbox,'Value')}; 

%load selected plate motion file into current handles.  The variable H that
%the file is loaded into has fields plateinfo, signalinfo, and
%samples_per_second
H = load([cd,'\SavedHandles\',selectedfile]);

%make sure basefreq of loaded plate motion is in Gnfreqs
Gnfreqs = handles.controllerinfo.Gnfreqs;
controlledfreqs = handles.controllerinfo.controlledfreqs;
basefreq = H.plateinfo.basefreq;
if isempty(find(basefreq == Gnfreqs))
    warndlg(['Plate motion cannot be loaded because no frequency response data exists for ',num2str(basefreq),'Hz base frequency.'])
    uiwait
else
    %update plateinfo
    handles.plateinfo = H.plateinfo;
    
    %update signalinfo
    handles.signalinfo = H.signalinfo;
    
    %update daqinfo
    handles.daqinfo.samples_per_second = H.samples_per_second;
    handles.daqinfo.ai.SampleRate = handles.daqinfo.samples_per_second;
    handles.daqinfo.ao.SampleRate = handles.daqinfo.samples_per_second;

    %update controllerinfo
    %make sure controlled frequencies are all in Gnfreqs
    if controlledfreqs(end) > Gnfreqs(end)
        handles.controllerinfo.controlledfreqs = basefreq:basefreq:Gnfreqs(end);
        handles.controllerinfo.maxharmonic = numel(handles.controllerinfo.controlledfreqs);
        warndlg(['Controlled frequencies changed from ',mat2str(controlledfreqs),' to ',mat2str(handles.controllerinfo.controlledfreqs),' because frequency response data only goes to ',num2str(Gnfreqs(end)),'Hz'])
        uiwait
    end

    %update plate motion panel in GUI
    set(handles.platemotionfilename,'string',handles.plateinfo.filename)
    set(handles.constants,'string',handles.plateinfo.constants)
    set(handles.basefreq,'string',num2str(handles.plateinfo.basefreq))
    for i = 1:numel(platesignals)
        set(eval(['handles.',platesignals{i}]),'string',handles.plateinfo.d_char{i})
    end
    
    %update sampling panel in GUI
    set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
    set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))

    %update control signals panel in GUI
    set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
    set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))
    
    %update speaker signals panel in GUI
    PlotControls(handles)
    
    %update plate signals panel in GUI
    PlotPlate(handles)
    
end