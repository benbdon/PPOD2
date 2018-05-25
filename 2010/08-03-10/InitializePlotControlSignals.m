function InitializePlotControlSignals(handles)

T = handles.signalinfo.T;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
tCyc = handles.signalinfo.tCyc;
uCyc = handles.signalinfo.uCyc;
uCyc_fft = fft(uCyc);

uMax = handles.controllerinfo.uMax;
ymax = uMax*1.5;
uMaxCyc = uMax*ones(1,samplesPerCycle);
uMinCyc = -uMax*ones(1,samplesPerCycle);

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

titlefontsize = 8;
titletext = {'u_1','u_2','u_3','u_4','u_5','u_6'};

controlSignals = handles.globalinfo.controlSignals;
for i = 1:numel(controlSignals)
    eval(['axes(handles.',controlSignals{i},'_axes)'])
    cla
    
    tag = {['u',num2str(i),'Cyc'],'uMaxCyc','uMinCyc'};
    %draw control signal
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            line(tCyc, uCyc(:,i),'Color','g','tag',tag{1});
            %draw saturation voltage lines
            line(tCyc, uMaxCyc,'color','k','linestyle',':','tag',tag{2})
            line(tCyc, uMinCyc,'color','k','linestyle',':','tag',tag{3})
            set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
            xlabeltext = {'Time (s)'};
        case 'freqDomain'
            stem(plottedFreqs, abs(uCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2,'Color','g','tag',tag{1});
            %draw saturation voltage lines
            line(plottedFreqs, uMaxCyc(plottedHarmonics+1),'color','k','linestyle',':','tag',tag{2})
            line(plottedFreqs, uMinCyc(plottedHarmonics+1),'color','k','linestyle',':','tag',tag{3})
            set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
            xlabeltext = {'Frequency (Hz)'};
    end
    

    
    title(titletext{i},'fontsize',titlefontsize);
    set(gca, 'ylim', [-ymax ymax]);
    
    if i == 1
        ylabel('Voltage(V)')
    end
    if i == 6
        xlabel(xlabeltext)
    end
end
 
