function handles = load_signals(handles)

filenames = get(handles.savedhandles_listbox,'String');
selectedfile = filenames{get(handles.savedhandles_listbox,'Value')}; 

%load selected plate motion file into current handles.  The variable H that
%the file is loaded into has fields plateinfo, signalinfo, and
%samples_per_second
H = load([cd,'\SavedHandles\',selectedfile]);
signalinfo = H.signalinfo;

%make sure basefreq of loaded plate motion is in Gnfreqs
f1 = 1/signalinfo.T;
F_all = handles.controllerinfo.F_all;
if ~ismember(f1,F_all)
    warndlg(['Plate motion cannot be loaded because no frequency response data exists for ',num2str(f1),'Hz base frequency.'])
    uiwait
else   
    %update signalinfo
    handles.signalinfo = signalinfo;
    
    %%NEED TO UPDATE THIS LATER!!!!
% %     %update daqinfo
% %     handles.daqinfo.samples_per_second = H.samples_per_second;
% %     handles.daqinfo.ai.SampleRate = handles.daqinfo.samples_per_second;
% %     handles.daqinfo.ao.SampleRate = handles.daqinfo.samples_per_second;
% % 
% %     %update controllerinfo
% %     %make sure controlled frequencies are all in Gnfreqs
% %     if controlledfreqs(end) > Gnfreqs(end)
% %         handles.controllerinfo.controlledfreqs = basefreq:basefreq:Gnfreqs(end);
% %         handles.controllerinfo.maxharmonic = numel(handles.controllerinfo.controlledfreqs);
% %         warndlg(['Controlled frequencies changed from ',mat2str(controlledfreqs),' to ',mat2str(handles.controllerinfo.controlledfreqs),' because frequency response data only goes to ',num2str(Gnfreqs(end)),'Hz'])
% %         uiwait
% %     end
% % 
% %     %update plate motion panel in GUI
% %     set(handles.platemotionfilename,'string',handles.plateinfo.filename)
% %     set(handles.constants,'string',handles.plateinfo.constants)
% %     set(handles.T,'string',char(sym(handles.plateinfo.T)))
    for i = 1:numel(handles.globalinfo.plateAccSignals)
        set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.adesChar{i})
    end

%     %update sampling panel in GUI
%     set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
%     set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))
% 
%     %update control signals panel in GUI
%     set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
%     set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))
    
    %update speaker signals panel in GUI
    PlotControlSignals(handles)
    
    %update plate signals panel in GUI
    PlotAccSignals(handles)
    
end