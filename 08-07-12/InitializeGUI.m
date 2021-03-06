function InitializeGUI(handles)

aiConfig = get(get(handles.analogInputModeSelector,'selectedObject'),'tag');
aoConfig = get(get(handles.analogOutputModeSelector,'selectedObject'),'tag');

%**************************************************************************
%UPDATE GUI PANELS
%**************************************************************************
%Analog Input Mode panel
set(handles.standardModeAI,'enable','on');
set(handles.forceModeAI,'enable','on');

%Analog Output Mode panel in GUI
set(handles.standardModeAO,'enable','on')
set(handles.cameraModeAO,'enable','on')
if handles.camerainfo.fps > 200
    handles.camerainfo.fps = 200;
end
if strcmp(aoConfig,'cameraModeAO')
    set(handles.fps,'string',num2str(handles.camerainfo.fps),'enable','on')
else
    set(handles.fps,'string',num2str(handles.camerainfo.fps),'enable','off')
end

%Sampling panel
set(handles.samplingFreq,'string',num2str(handles.signalinfo.samplingFreq),'enable','on')
set(handles.samplesPerCycle,'string',num2str(handles.signalinfo.samplesPerCycle),'enable','on')
set(handles.numTransientCycles,'string',num2str(handles.controllerinfo.numTransientCycles),'enable','on')
set(handles.numCollectedCycles,'string',num2str(handles.controllerinfo.numCollectedCycles),'enable','on')
set(handles.numProcessingCycles,'string',num2str(handles.controllerinfo.numProcessingCycles),'enable','on')
set(handles.cyclesPerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate),'enable','on')
set(handles.timePerUpdate,'string',num2str(handles.controllerinfo.cyclesPerUpdate*handles.signalinfo.T),'enable','on')

%Controller Parameters panel
set(handles.uiHarmonics,'string',mat2str(handles.controllerinfo.uiHarmonics),'enable','on')
set(handles.F_ui,'string',[mat2str(handles.controllerinfo.F_ui),' Hz'],'enable','on')
set(handles.useNonlinearHarmonicTerms,'enable','on')
set(handles.k,'string',num2str(handles.controllerinfo.k),'enable','on')
set(handles.uMax,'string',num2str(handles.controllerinfo.uMax),'enable','on')
if get(handles.desSignals_ui,'value')
    set(handles.uiInitial_previous,'enable','off')
    set(handles.uiInitial_guess,'enable','off')
    set(handles.uiInitial_zero,'enable','off')
    set(handles.uiInitial_user','enable','on','value',1)
else
    set(handles.uiInitial_previous,'enable','on')
    set(handles.uiInitial_guess,'enable','on')
    set(handles.uiInitial_zero,'enable','on','value',1)
    set(handles.uiInitial_user','enable','off')
    if get(handles.uiInitial_user,'value')
        set(handles.uiInitial_guess,'value',1)
    end
end
    
%Desired Signals panel
set(handles.desSignals_Pdd,'enable','on')%sets initial desired signal type to plate acclerations
set(handles.desSignals_didd,'enable','on')
set(handles.desSignals_ui,'enable','on')
set(handles.platemotionfilename,'string',handles.globalinfo.filename)
set(handles.T,'string',char(sym(handles.signalinfo.T)),'enable','on')
desSignals = get(get(handles.desSignalsSelector,'selectedObject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        for i = 1:numel(handles.globalinfo.PddSignals)
            set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.PddSignals{i},' = '],'enable','on')
            set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.PddDesChar{i},'enable','on')
        end
        switch aiConfig
            case 'standardModeAI'
                set(handles.savedSignalsListbox','enable','on')
                set(handles.saveSignals','enable','on')
            case 'forceModeAI'
                set(handles.savedSignalsListbox','enable','off')
                set(handles.saveSignals','enable','off')
            otherwise
                error('selection does not match any case')
        end
    case 'desSignals_didd'
        for i = 1:numel(handles.globalinfo.diddSignals)
            set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.diddSignals{i},' = '],'enable','on')
            set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.diddDesChar{i},'enable','on')
        end
        set(handles.savedSignalsListbox','enable','off')
        set(handles.saveSignals','enable','off')
    case 'desSignals_ui'
        for i = 1:numel(handles.globalinfo.uiSignals)
            set(eval(['handles.desSignalText',num2str(i)]),'string',[handles.globalinfo.uiSignals{i},' = '],'enable','on')
            set(eval(['handles.desSignalChar',num2str(i)]),'string',handles.signalinfo.uiDesChar{i},'enable','on')
        end
        set(handles.savedSignalsListbox','enable','off')
        set(handles.saveSignals','enable','off')
end
%disable unused text boxes
for j = i+1:6
    set(eval(['handles.desSignalText',num2str(j)]),'string','','enable','off')
    set(eval(['handles.desSignalChar',num2str(j)]),'string','','enable','off')
end
set(handles.constants,'string',handles.signalinfo.constants,'enable','on')
populateSavedSignalsListbox(handles) %load saved plate motions

%Actuation panel
set(handles.maxUpdate,'string',num2str(handles.controllerinfo.maxUpdate),'enable','on')
set(handles.currentUpdate,'string',num2str(handles.controllerinfo.currentUpdate),'enable','on')
set(handles.currentUpdatediddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate),'enable','on')
set(handles.currentUpdatePddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate),'enable','on')
set(handles.run,'value',0,'enable','on','string','Run')

%Frequency Response panel
set(handles.uiAddFreqs,'value',0,'enable','on')
set(handles.uiDeleteFreqs,'value',0,'enable','on')
set(handles.diddAddFreqs,'value',0,'enable','on')
set(handles.diddDeleteFreqs,'value',0,'enable','on')
set(handles.diddErrorTol,'string',num2str(0.0015),'enable','on')
set(handles.maxUpdatediddAddFreqs,'string',20,'enable','on')
set(handles.currentUpdatediddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate))
set(handles.PddAddFreqs,'value',0,'enable','on')
set(handles.PddDeleteFreqs,'value',0,'enable','on')
set(handles.PddErrorTol,'string',num2str(0.025),'enable','on')
set(handles.maxUpdatePddAddFreqs,'string',20,'enable','on')
set(handles.currentUpdatePddAddFreqs,'string',num2str(handles.controllerinfo.currentUpdate))
set(handles.viewTransferFunctions,'enable','on')

%Signal Panel 1 
cla(handles.fieldAxes,'reset')
axis(handles.fieldAxes,'equal')
set(handles.fieldAxes,'xlim',[-10 10],'ylim',[-10 10],'xtick',0,'ytick',0)
set(handles.fieldAxes,'visible','off')


switch aiConfig
    case 'standardModeAI'
        if get(handles.plottedSignals_f,'value')
            set(handles.plottedSignals_amidd,'value',1)
        end
        set(handles.plottedSignals_f,'enable','off')
    case 'forceModeAI'
        set(handles.plottedSignals_f,'enable','on')
    otherwise
        error('selection does not match any case')
end
if get(handles.timeDomain,'Value')
    set(handles.plottedHarmonics,'string',['[0:',num2str(max(5,max(handles.controllerinfo.uiHarmonics)*2)),']'],'enable','off')
    set(handles.plottedHarmonicsText,'enable','off')
else
    set(handles.plottedHarmonics,'string',['[0:',num2str(max(5,max(handles.controllerinfo.uiHarmonics)*2)),']'],'enable','on')
    set(handles.plottedHarmonicsText,'enable','on')
end
set(handles.currentError,'string','')
InitializePlotAccSignals(handles)

%Signal Panel 2
switch aiConfig
    case 'standardModeAI'
        set(handles.forceSignalsPanel,'visible','off')
    case 'forceModeAI'
        set(handles.forceSignalsPanel,'visible','on')
        InitializePlotForceSignals(handles)
    otherwise
        error('case does not match any selection')
end

%Control Signals panel
InitializePlotControlSignals(handles)

%update Laser Signals panel in GUI
switch aiConfig
    case 'standardModeAI'
        set(handles.laserSignalsPanel,'visible','off')
    case 'forceModeAI'
        set(handles.laserSignalsPanel,'visible','on')
        InitializePlotLaserSignals(handles)
    otherwise
        error('case does not match any selection')
end
