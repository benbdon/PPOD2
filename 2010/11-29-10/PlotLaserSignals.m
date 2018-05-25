function PlotLaserSignals(handles)

diSignals = handles.globalinfo.diSignals;
T = handles.signalinfo.T;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

tCyc = handles.signalinfo.tCyc;
diCyc = handles.signalinfo.diCyc;
diCyc_fft = fft(diCyc);
diCycACC = handles.signalinfo.diddCyc(:,1)/(2*pi/T)^2 + mean(diCyc);
diCycACC_fft = fft(diCycACC);

diMin = min(diCyc);
diMax = max(diCyc);
diRange = diMax - diMin;

samplesPerCycle = handles.signalinfo.samplesPerCycle;


%go to ith axes of control signals panel
axes(handles.laserAxes)

tag = {'d1Cyc','diCycACC'};

domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
switch domain
    case 'timeDomain'
        set(findobj('tag',tag{1}),'xdata',tCyc,'ydata',diCyc) %update di
        set(findobj('tag',tag{2}),'xdata',tCyc,'ydata',diCycACC) %update di
        set(gca,'xlim',[0 T],'xtick',0:T/2:T)
    case 'freqDomain'
        set(findobj('tag',tag{1}),'xdata',plottedFreqs,'ydata',abs(diCyc_fft(plottedHarmonics+1))/samplesPerCycle*2) %update f
        set(findobj('tag',tag{2}),'xdata',plottedFreqs,'ydata',abs(diCycACC_fft(plottedHarmonics+1))/samplesPerCycle*2) %update f
        set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
end

if ~get(handles.floatAxes,'value')
    if diRange > 0
        set(gca,'ylim',[diMin-diRange/5, diMax+diRange/5])
    else
        set(gca,'ylim',[-10, 10])
    end
else
    set(gca,'ylim',[-Inf Inf])
end
