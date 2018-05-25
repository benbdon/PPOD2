function InitializePlotForceSignals(handles)

T = handles.signalinfo.T;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
tCyc = handles.signalinfo.tCyc;
fCyc = handles.signalinfo.fCyc;
fCyc_fft = fft(fCyc);

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = sort(f1*plottedHarmonics);

titlefontsize = 8;
titletext = {'F_x','F_y','F_z','M_x','M_y','M_z'};

yMax = max(max(fCyc));

forceSignals = handles.globalinfo.forceSignals;
for i = 1:numel(forceSignals)
    eval(['axes(handles.fAxes',num2str(i),')'])
    cla
    
    tag = {['f',num2str(i),'Cyc']};
    %draw force signal
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            line(tCyc, fCyc(:,i),'Color','k','tag',tag{1});
            set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
            xlabeltext = {'Time (s)'};
        case 'freqDomain'
            stem(plottedFreqs, abs(fCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2,'Color','k','marker','*','tag',tag);
            set(gca,'xlim',[plottedFreqs(1) plottedFreqs(end)],'xtick',plottedFreqs)
            xlabeltext = {'Frequency (Hz)'};
    end
    
    title(titletext{i},'fontsize',titlefontsize);
   
    if yMax > 0
            set(gca,'ylim',[-1.5*yMax, 1.5*yMax])
        else
            set(gca,'ylim',[-10, 10])
    end
        
    if i == 1
        ylabel('Force(N)')
    end
    if i == 4
        ylabel('Moment(Nm)')
    end
    if i == 3 || i == 6
        xlabel(xlabeltext)
    end
end
 
