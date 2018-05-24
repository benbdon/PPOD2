function PlotControlSignals(handles)

uiSignals = handles.globalinfo.uiSignals;
T = handles.signalinfo.T;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

tCyc = handles.signalinfo.tCyc;
uiCyc = handles.signalinfo.uiCyc;
uiCyc_fft = fft(uiCyc);

samplesPerCycle = handles.signalinfo.samplesPerCycle;
uMax = str2double(get(handles.uMax,'string'));

N_CS = numel(uiSignals);
for i = 1:N_CS
    %go to ith axes of control signals panel
    eval(['axes(handles.uAxes',num2str(i),')'])
    
    tag = {['u',num2str(i),'Cyc'],['u',num2str(i),'Max'],['u',num2str(i),'Min']};
    
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            set(findobj('tag',tag{1}),'xdata',tCyc,'ydata',uiCyc(:,i)) %update u
            set(findobj('tag',tag{2}),'xdata',[tCyc(1),tCyc(end)],'ydata',[uMax,uMax]) 
            set(findobj('tag',tag{3}),'xdata',[tCyc(1),tCyc(end)],'ydata',-[uMax,uMax])
            set(gca,'xlim',[0 T],'xtick',0:T/2:T)
        case 'freqDomain'
            set(findobj('tag',tag{1}),'xdata',plottedFreqs,'ydata',abs(uiCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2) %update u
            set(findobj('tag',tag{2}),'xdata',[plottedFreqs(1), plottedFreqs(end)],'ydata',[uMax,uMax])
            set(findobj('tag',tag{3}),'xdata',[plottedFreqs(1), plottedFreqs(end)],'ydata',-[uMax,uMax])
            set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
    end

    if ~get(handles.floatAxes,'value')
        yMax = 1.2*uMax;
        set(gca,'ylim',[-yMax, yMax])
    else
        uCycMax = max(max(uiCyc));
        yMax = 1.2*min(uCycMax,uMax);
        if uCycMax > 0
            set(gca,'ylim',[-yMax,yMax])
        end
    end
    xtick = get(gca,'xtick');
    set(gca,'xtick',xtick(1:round(length(xtick)/5):length(xtick)));
end