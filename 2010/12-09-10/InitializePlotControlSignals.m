function InitializePlotControlSignals(handles)

T = handles.signalinfo.T;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
tCyc = handles.signalinfo.tCyc;
uiCyc = handles.signalinfo.uiCyc;
uiCyc_fft = fft(uiCyc);

uMax = handles.controllerinfo.uMax;
ymax = uMax*1.2;

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = sort(f1*plottedHarmonics);

titlefontsize = 8;
titletext = {'u_1','u_2','u_3','u_4','u_5','u_6'};

[NUIS] = signalCounter(handles);
for i = 1:NUIS
    eval(['axes(handles.uAxes',num2str(i),')'])
    cla
    eval(['set(handles.uAxes',num2str(i),',''visible'',''on'')'])
    hold on
    
    tag = {['u',num2str(i),'Cyc'],['u',num2str(i),'Max'],['u',num2str(i),'Min']};
    %draw control signal
    domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
    switch domain
        case 'timeDomain'
            line(tCyc, uiCyc(:,i),'Color','g','tag',tag{1});
            
            %draw saturation voltage lines
            line([tCyc(1), tCyc(end)], [uMax,uMax],'color','k','linestyle',':','tag',tag{2})
            line([tCyc(1), tCyc(end)], -[uMax,uMax] ,'color','k','linestyle',':','tag',tag{3})
            set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
            xlabeltext = {'Time (s)'};
        case 'freqDomain'
            stem(plottedFreqs, abs(uiCyc_fft(plottedHarmonics+1,i))/samplesPerCycle*2,'Color','g','marker','*','tag',tag{1});
            %draw saturation voltage lines
            line([plottedFreqs(1), plottedFreqs(end)], [uMax,uMax],'color','k','linestyle',':','tag',tag{2})
            line([plottedFreqs(1), plottedFreqs(end)], -[uMax,uMax],'color','k','linestyle',':','tag',tag{3})
            set(gca,'xlim',[plottedFreqs(1) plottedFreqs(end)],'xtick',plottedFreqs)
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
    xtick = get(gca,'xtick');
    set(gca,'xtick',xtick(1:round(length(xtick)/5):length(xtick)));
end

for i = NUIS+1:6
    eval(['axes(handles.uAxes',num2str(i),')'])
    cla
    eval(['set(handles.uAxes',num2str(i),',''visible'',''off'')'])
end
 
