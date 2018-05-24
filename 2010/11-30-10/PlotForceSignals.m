function PlotForceSignals(handles)

forceSignals = handles.globalinfo.forceSignals;
T = handles.signalinfo.T;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

tCyc = handles.signalinfo.tCyc;
fCyc = handles.signalinfo.fCyc;
fCyc_fft = fft(fCyc);

yMax1 = max(max(abs(fCyc(:,1:3))));
yMax2 = max(max(abs(fCyc(:,4:6))));

samplesPerCycle = handles.signalinfo.samplesPerCycle;

NFS = numel(forceSignals);
for i = 1:NFS
    %go to ith axes of control signals panel
    eval(['axes(handles.fAxes',num2str(i),')'])
    
    tag = ['f',num2str(i),'Cyc'];
    
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            set(findobj('tag',tag),'xdata',tCyc,'ydata',fCyc(:,i)) %update f
            set(gca,'xlim',[0 T],'xtick',0:T/2:T)
        case 'freqDomain'
            set(findobj('tag',tag),'xdata',plottedFreqs,'ydata',abs(fCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2) %update f
            set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
    end

    if ~get(handles.floatAxes,'value')
        if i <= 3
            if yMax1 > 0
                set(gca,'ylim',[-1.5*yMax1, 1.5*yMax1])
            else
                set(gca,'ylim',[-10, 10])
            end
        else
            if yMax2 > 0
                set(gca,'ylim',[-1.5*yMax2, 1.5*yMax2])
            else
                set(gca,'ylim',[-10, 10])
            end
        end
    else
        set(gca,'ylim',[-Inf Inf])
    end
end