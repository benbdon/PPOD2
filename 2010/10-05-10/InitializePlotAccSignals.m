function InitializePlotAccSignals(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;

domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
signals = get(get(handles.accSignalSelector,'selectedobject'),'tag');

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;
samplesPerCycle = handles.signalinfo.samplesPerCycle;

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
        yMax2 = max(max([signal1(:,4:6), signal2(:,4:6)]));
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'pdd_x','pdd_y', 'pdd_z','\alpha_x','\alpha_y','\alpha_z'};
        if ~get(handles.actuatorVoltages,'value')
            legtext = {'Measured','Desired'};
        else
            legtext = {};
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
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'accLocal1','accLocal2', 'accLocal3','accLocal4','accLocal5','accLocal6'};
        legtext = {'^{L}xdd','^{L}ydd'};
    case 'actuatorAcc'
        accSignals = handles.globalinfo.actuatorAccSignals;
        
        switch domain
            case 'timeDomain'
                signal1 = handles.signalinfo.dddCyc;
                signal2 = NaN*signal1;
            case 'freqDomain'
                signal1 = abs(fft(handles.signalinfo.dddCyc))/samplesPerCycle*2;
                signal2 = NaN*signal1;
        end
            
        yMax1 = max(max(signal1));
        yMax2 = yMax1;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'d1dd','d2dd', 'd3dd','d4dd','d5dd','d6dd'};
        legtext = {};
end

titlefontsize = 8;

for i = 1:numel(accSignals)
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
    cla
    hold on
    
    tag = {['axes',num2str(i),'signal1'],['axes',num2str(i),'signal2']};
    switch domain
        case 'timeDomain'
            line(tCyc, signal1(:,i),'Color','r','tag',tag{1});
            line(tCyc, signal2(:,i),'Color','b','tag',tag{2});
            set(gca, 'xlim', [0 T],'xtick',0:T/4:T);
        case 'freqDomain'
            stem(plottedFreqs,signal1(plottedHarmonics+1,i),'r','marker','*','tag',tag{1})
            stem(plottedFreqs,signal2(plottedHarmonics+1,i),'b','marker','o','tag',tag{2})
            set(gca,'xlim',[min(plottedFreqs) max(plottedFreqs)],'xtick',plottedFreqs)
    end
    
    
    %format the axes of the plots
    title(titletext{i},'fontsize',titlefontsize,'interpreter','tex');
    
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
    if i == 1
        ylabel(yLabel1)
        if ~isempty(legtext)
            leg_han = legend(legtext,'location','best');
            set(leg_han,'visible','on')
        else
            legHan = findobj('tag','legend');
            set(legHan,'visible','off')
        end
        
    end
    if i == 4
        ylabel(yLabel2)
    end
    if i == 3 || i == 6
        switch domain
            case 'timeDomain'
                xlabel('Time(s)')
            case 'freqDomain'
                xlabel('Frequncy (Hz)')
        end
    end
end