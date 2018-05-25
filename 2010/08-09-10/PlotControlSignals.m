function PlotControlSignals(handles)

controlSignals = handles.globalinfo.controlSignals;
T = handles.signalinfo.T;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

tCyc = handles.signalinfo.tCyc;
uCyc = handles.signalinfo.uCyc;
uCyc_fft = fft(uCyc);

samplesPerCycle = handles.signalinfo.samplesPerCycle;
uMax = handles.controllerinfo.uMax;
uMaxCyc = uMax*ones(1,samplesPerCycle);

%find handles for u.  each handles is a vector with
%numel(controlignals) components (one handle for each of the plots)
uCyc_han = findobj('tag','uCyc');
uMaxCyc_han = findobj('tag','uMaxCyc');
uMinCyc_han = findobj('tag','uMinCyc');

N_CS = numel(controlSignals);
for i = 1:N_CS
    %go to ith axes of control signals panel
    eval(['axes(handles.uAxes',num2str(i),')'])
    
    tag = {['u',num2str(i),'Cyc'],'uMaxCyc','uMinCyc'};
    
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            set(findobj('tag',tag{1}),'xdata',tCyc,'ydata',uCyc(:,i)) %update u
            set(findobj('tag',tag{2}),'xdata',tCyc,'ydata',uMaxCyc) 
            set(findobj('tag',tag{3}),'xdata',tCyc,'ydata',-uMaxCyc)
            set(gca,'xlim',[0 T],'xtick',0:T/2:T)
        case 'freqDomain'
            set(findobj('tag',tag{1}),'xdata',plottedFreqs,'ydata',abs(uCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2) %update u
            set(findobj('tag',tag{2}),'xdata',plottedFreqs,'ydata',uMaxCyc(plottedHarmonics+1))
            set(findobj('tag',tag{3}),'xdata',plottedFreqs,'ydata',-uMaxCyc(plottedHarmonics+1))
            set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
    end

    if ~get(handles.floatAxes,'value')
        set(gca,'ylim',[-1.25*uMax 1.25*uMax])
    else
        set(gca,'ylim',[-Inf,Inf])
    end
end