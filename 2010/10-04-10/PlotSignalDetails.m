function PlotSignalDetails(handles)


mainGUIhandles = handles.mainGUIhandles;

plateAccSignals = mainGUIhandles.globalinfo.plateAccSignals;

controlledFreqs = mainGUIhandles.controllerinfo.controlledFreqs;
samplesPerCycle = mainGUIhandles.signalinfo.samplesPerCycle;

T = mainGUIhandles.signalinfo.T;

tCyc = mainGUIhandles.signalinfo.tCyc;
uCyc = mainGUIhandles.signalinfo.uCyc;
adesCyc = mainGUIhandles.signalinfo.adesCyc;
aCyc = mainGUIhandles.signalinfo.aCyc;
eCyc = adesCyc-aCyc;

%determine which signal has been selected and set i equal to its index in
%the plateAccSignals array
signal = get(get(handles.signalpanel,'selectedobject'),'tag');
i = find(strcmp(signal,plateAccSignals));

%determine which domain is selected
domain = get(get(handles.domainpanel,'selectedobject'),'tag');

if strcmp(domain,'time')
    set(handles.freqoptions_panel,'visible','off')
    set(handles.axes2panel,'visible','off')
    
    axes(handles.axes1)
    cla
    hold on
    if get(handles.u,'value')
        plot(tCyc,uCyc(:,i),'g')
    end
    if get(handles.y,'value')
        plot(tCyc,aCyc(:,i),'r')
    end
    if get(handles.d,'value')
        plot(tCyc,adesCyc(:,i),'b')
    end
    if get(handles.e,'value')
        plot(tCyc,eCyc(:,i),'k')
    end
    set(gca,'xlim',[0 T])
    xlabel('Time (s)')
    if i <= 3
        ylabel('m/s^2')
    else
        ylabel('rad/s^2')
    end
else
    
    ades_fft = fft(adesCyc);
    a_fft = fft(aCyc);
    e_fft = fft(eCyc);
    u_fft = fft(uCyc);
    
    magscale = get(get(handles.magscalepanel,'selectedobject'),'tag');
    plottedfreqs = [0 eval(get(handles.plottedfreqs,'string'))];
    switch magscale
        case 'norm'
            mag_y = abs(a_fft(1:numel(plottedfreqs),i));
            mag_d = abs(ades_fft(1:numel(plottedfreqs),i));
            mag_e = abs(e_fft(1:numel(plottedfreqs),i));
            mag_u = abs(u_fft(1:numel(plottedfreqs),i));
            ylabeltext = '|| fft ||';
        case 'lognorm'
            mag_y = log10(abs(a_fft(1:numel(plottedfreqs),i)));
            mag_d = log10(abs(ades_fft(1:numel(plottedfreqs),i)));
            mag_e = log10(abs(e_fft(1:numel(plottedfreqs),i)));
            mag_u = log10(abs(u_fft(1:numel(plottedfreqs),i)));
            ylabeltext = 'log || fft ||';
        case 'amplitude'
            mag_y = abs(a_fft(1:numel(plottedfreqs),i))/samplesPerCycle*2;
            mag_d = abs(ades_fft(1:numel(plottedfreqs),i))/samplesPerCycle*2;
            mag_e = abs(e_fft(1:numel(plottedfreqs),i))/samplesPerCycle*2;
            mag_u = abs(u_fft(1:numel(plottedfreqs),i))/samplesPerCycle*2;
            if i <= 3
                ylabeltext = 'Amplitude (m/s^2)';
            else
                ylabeltext = 'Amplitude (rad/s^2)';
            end
    end

    set(handles.freqoptions_panel,'visible','on')
    set(handles.controlledfreqs,'string',mat2str(controlledFreqs))

    axes(handles.axes1)
    cla
    hold on

    if get(handles.u,'value')
        stem(plottedfreqs,mag_u,'g','marker','d')
    end
    if get(handles.y,'value')
        stem(plottedfreqs,mag_y,'r')
    end
    if get(handles.d,'value')
        stem(plottedfreqs,mag_d,'b','marker','s')
    end
    if get(handles.e,'value')
        stem(plottedfreqs,mag_e,'k','marker','*')
    end
    set(gca,'xlim',[0 plottedfreqs(end)+10])
    set(gca,'xtick',plottedfreqs)
    xlabel('Frequency (Hz)')
    ylabel(ylabeltext)
    

    set(handles.axes2panel,'visible','on')
    axes(handles.axes2)
    cla
    hold on
    plottedfreqs = [0 eval(get(handles.plottedfreqs,'string'))];
    if get(handles.u,'value')
        stem(plottedfreqs,angle(u_fft(1:numel(plottedfreqs),i)),'g','marker','d')
    end
    if get(handles.y,'value')
        stem(plottedfreqs,angle(a_fft(1:numel(plottedfreqs),i)),'r')
    end
    if get(handles.d,'value')
        stem(plottedfreqs,angle(ades_fft(1:numel(plottedfreqs),i)),'b','marker','s')
    end
    if get(handles.e,'value')
        stem(plottedfreqs,angle(e_fft(1:numel(plottedfreqs),i)),'k','marker','*')
    end

    xlabel('Frequency (Hz)')
    set(gca,'xlim',[0 plottedfreqs(end)+10])
    set(gca,'xtick',plottedfreqs)
    ylabel('Phase (rad)')
    set(gca,'ylim',[-2*pi 2*pi])
    set(gca,'ytick',[-2*pi -pi 0 pi 2*pi])
end