function PlotAccSignals(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
signals = get(get(handles.accSignalSelector,'selectedobject'),'tag');

switch signals
    case 'plateAcc'
        accSignals = handles.globalinfo.plateAccSignals;
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.aCyc;
                if ~get(handles.actuatorVoltages,'value')
                    signal2 = handles.signalinfo.adesCyc;
                else
                    signal2 = NaN*signal1;
                end
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.aCyc))/samplesPerCycle*2;
                if ~get(handles.actuatorVoltages,'value')
                    signal2 = abs(fft(handles.signalinfo.adesCyc))/samplesPerCycle*2;
                else
                    signal2 = NaN*signal1;
                end
        end
        
        yMax1 = max(max([signal1(:,1:3), signal2(:,1:3)]));
        if size(signal1,2) > 3
            yMax2 = max(max([signal1(:,4:6), signal2(:,4:6)]));
        else
            yMax2 = 0;
        end
    case 'plateAccLocal'
        accSignals = {'accLocal1','accLocal2', 'accLocal3','accLocal4','accLocal5','accLocal6'};
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.aLocalCyc(:,1:2:end);
                signal2 = handles.signalinfo.aLocalCyc(:,2:2:end);
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.aLocalCyc(:,1:2:end)))/samplesPerCycle*2;
                signal2 = abs(fft(handles.signalinfo.aLocalCyc(:,2:2:end)))/samplesPerCycle*2;
        end
        
        yMax1 = max(max([signal1 signal2]));
        yMax2 = yMax1;
    case 'actuatorAcc'
        accSignals = handles.globalinfo.actuatorAccSignals;
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.dddCyc;
                signal2 = handles.signalinfo.ddddesCyc;
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.dddCyc))/samplesPerCycle*2;
                signal2 = abs(fft(handles.signalinfo.ddddesCyc))/samplesPerCycle*2;
        end

        yMax1 = max(max([signal1 signal2]));
        yMax2 = yMax1;
end


pause(.0001)%this elimantes redrawing legend for some reason
N = length(accSignals);
for i = 1:N
    switch signals
        case 'plateAcc'
            order = [1 2 3 4 5 6];
            eval(['axes(handles.accAxes',num2str(order(i)),')'])
        case 'plateAccLocal'
            order = [1 4 2 5 3 6];
            eval(['axes(handles.accAxes',num2str(order(i)),')'])
        case 'actuatorAcc'
            order = [1 4 2 5 3 6];
            eval(['axes(handles.accAxes',num2str(order(i)),')'])
    end
    
    tag = {['axes',num2str(i),'signal1'],['axes',num2str(i),'signal2']};
    switch domain
        case 'timeDomain'
            set(findobj('tag',tag{1}),'xdata',tCyc,'ydata',signal1(:,i)) %update signal1
            set(findobj('tag',tag{2}),'xdata',tCyc,'ydata',signal2(:,i)) %update signal1
            
            set(gca,'xlim',[0 T],'xtick',0:T/4:T)
        case 'freqDomain'
            set(findobj('tag',tag{1}),'xdata',plottedFreqs,'ydata',signal1(plottedHarmonics+1,i)) %update signal1
            set(findobj('tag',tag{2}),'xdata',plottedFreqs,'ydata',signal2(plottedHarmonics+1,i)) %update signal2 
              
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