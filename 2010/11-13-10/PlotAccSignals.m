function PlotAccSignals(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;

domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
plottedSignals = get(get(handles.plottedSignalSelector,'selectedobject'),'tag');
desSignals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');

[NCS NPMIS NPS NAMIS NDIS] = signalCounter(handles);

switch plottedSignals
    case 'plottedSignals_Pdd'
        numAxes = NPS;
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.PddCyc;
                if strcmp(desSignals,'desSignals_Pdd')
                    signal2 = handles.signalinfo.PddDesCyc;
                else
                    signal2 = NaN*signal1;
                end
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.PddCyc))/samplesPerCycle*2;
                if strcmp(desSignals,'desSignals_Pdd')
                    signal2 = abs(fft(handles.signalinfo.PddDesCyc))/samplesPerCycle*2;
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
    case 'plottedSignals_pmidd'
        numAxes = NPMIS/2;
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.pmiddCyc(:,1:2:end);
                signal2 = handles.signalinfo.pmiddCyc(:,2:2:end);
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.pmiddCyc(:,1:2:end)))/samplesPerCycle*2;
                signal2 = abs(fft(handles.signalinfo.pmiddCyc(:,2:2:end)))/samplesPerCycle*2;
        end
        
        yMax1 = max(max([signal1 signal2]));
        yMax2 = yMax1;
    case 'plottedSignals_didd'
        numAxes = NDIS;
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.diddCyc;
                if strcmp(desSignals,'desSignals_didd')
                    signal2 = handles.signalinfo.diddDesCyc;
                else
                    signal2 = NaN*signal1;
                end
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.diddCyc))/samplesPerCycle*2;
                if strcmp(desSignals,'desSignals_didd')
                    signal2 = abs(fft(handles.signalinfo.diddDesCyc))/samplesPerCycle*2;
                else
                    signal2 = NaN*signal1;
                end
        end

        yMax1 = max(max([signal1 signal2]));
        yMax2 = yMax1;
    case 'plottedSignals_amidd'
        if NAMIS > NDIS
            numAxes = NAMIS/2;
        else
            numAxes = NDIS;
        end
        
        switch domain
            case 'timeDomain'
                if NAMIS > NDIS
                    signal1 = handles.signalinfo.amiddCyc(:,1:2:end);
                    signal2 = handles.signalinfo.amiddCyc(:,2:2:end);
                else
                    signal2 = handles.signalinfo.amiddCyc;
                    signal1 = NaN*signal2;
                end
                
            case 'freqDomain'
                if NAMIS > NDIS
                    signal1 = abs(fft(handles.signalinfo.amiddCyc(:,1:2:end)))/samplesPerCycle*2;
                    signal2 = abs(fft(handles.signalinfo.amiddCyc(:,2:2:end)))/samplesPerCycle*2;
                else
                    signal2 = abs(fft(handles.signalinfo.amiddCyc))/samplesPerCycle*2;
                    signal1 = NaN*signal2;
                end
        end
        
        yMax1 = max(max([signal1 signal2]));
        yMax2 = yMax1;
        
end


pause(.0001)%this elimantes redrawing legend for some reason
for i = 1:numAxes
    switch plottedSignals
        case 'plottedSignals_Pdd'
            order = [1 2 3 4 5 6];
        case {'plottedSignals_pmidd','plottedSignals_didd','plottedSignals_amidd'}
            order = [1 4 2 5 3 6];
    end
    eval(['axes(handles.accAxes',num2str(order(i)),')'])
    
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