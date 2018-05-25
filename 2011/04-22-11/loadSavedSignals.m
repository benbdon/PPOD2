function handles = loadSavedSignals(handles)

filenames = get(handles.savedSignalsListbox,'String');
selectedfile = filenames{get(handles.savedSignalsListbox,'Value')};

%load selected plate motion file into current handles.  The variable H that
%the file is loaded into has fields plateinfo, signalinfo, and
%samples_per_second
H = load([cd,'\SavedSignals_Pdd\',selectedfile]);
signalinfo = H.signalinfo;

%make sure basefreq of loaded plate motion is in Gnfreqs
f1_ui = 1/signalinfo.T;
F_ui_all = handles.controllerinfo.F_ui_all;
if ~ismember(f1_ui,F_ui_all)
    warndlg(['Plate motion cannot be loaded because no frequency response data exists for ',num2str(f1_ui),'Hz base frequency.'])
    uiwait
    return
end
samplingFreq = handles.signalinfo.samplingFreq;
if samplingFreq ~= signalinfo.samplingFreq
    warndlg(['Plate motion cannot be loaded unless sampling frequency is set to ',num2str(signalinfo.samplingFreq)])
    uiwait
    return
end

%update signalinfo in handles
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
for i = 1:numel(handles.globalinfo.PddSignals)
    set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.PddDesChar{i})
end

%     %update sampling panel in GUI
%     set(handles.samples_per_second,'string',num2str(handles.daqinfo.samples_per_second))
%     set(handles.samples_per_cycle,'string',num2str(handles.plateinfo.samples_per_cycle))
%
%     %update control signals panel in GUI
%     set(handles.controlledfreqs,'string',mat2str(handles.controllerinfo.controlledfreqs))
%     set(handles.maxharmonic,'string',num2str(handles.controllerinfo.maxharmonic))

% %update speaker signals panel in GUI
% PlotControlSignals(handles)
% 
% %update plate signals panel in GUI
% PlotAccSignals(handles)
