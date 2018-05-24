function InitializePlotLaserSignals(handles)

T = handles.signalinfo.T;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
tCyc = handles.signalinfo.tCyc;
diCyc = handles.signalinfo.diCyc;
diCycAve = mean(diCyc);
diCyc_fft = fft(diCyc);
diCycACC = -handles.signalinfo.diddCyc(:,1)/(2*pi/T)^2 + mean(diCyc);
diCycACC_fft = fft(diCycACC);

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = sort(f1*plottedHarmonics);

diSignals = handles.globalinfo.diSignals;

titlefontsize = 8;
titletext = diSignals;

diMax = max(max(diCyc));

axes(handles.laserAxes)
cla
hold on

tag = {'d1Cyc','diCycACC','diCycAve'};
%draw di signal
domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
switch domain
    case 'timeDomain'
        line(tCyc, diCyc,'Color','c','tag',tag{1});
        line(tCyc, diCycACC,'Color','r','tag',tag{2});
        line([0 T],[diCycAve diCycAve],'color','c','tag',tag{3})%update average di reading from laser
        line([0 T],[diCycAve diCycAve],'color','c','marker','o','tag','diInit')%update average di reading from laser
        set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
        xlabeltext = {'Time (s)'};
    case 'freqDomain'
        stem(plottedFreqs, abs(diCyc_fft(plottedHarmonics+1))/samplesPerCycle*2,'Color','k','marker','*','tag',tag{1});
        stem(plottedFreqs, abs(diCycACC_fft(plottedHarmonics+1))/samplesPerCycle*2,'Color','c','marker','*','tag',tag{2});
        set(gca,'xlim',[plottedFreqs(1) plottedFreqs(end)],'xtick',plottedFreqs)
        xlabeltext = {'Frequency (Hz)'};
end

title(titletext,'fontsize',titlefontsize);

if diMax > 0
    set(gca,'ylim',[-1.5*diMax, 1.5*diMax])
else
    set(gca,'ylim',[-.1, .1])
end

ylabel('Position (m)')
xlabel(xlabeltext)


