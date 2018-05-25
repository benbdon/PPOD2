function InitializePlotAccSignals(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;

domain = get(get(handles.freqTimeSelector,'selectedobject'),'tag');
plottedSignals = get(get(handles.plottedSignalSelector,'selectedobject'),'tag');
desSignals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');

f1 = 1/handles.signalinfo.T;
plottedHarmonics = eval(get(handles.plottedHarmonics,'string'));
plottedFreqs = f1*plottedHarmonics;
samplesPerCycle = handles.signalinfo.samplesPerCycle;

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
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'pdd_x','pdd_y', 'pdd_z','\alpha_x','\alpha_y','\alpha_z'};
        if get(handles.desSignals_Pdd,'value')
            legtext = {'Measured','Desired'};
        else
            legtext = {};
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

        yMax1 = max(max([signal1, signal2]));
        yMax2 = yMax1;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'pm1dd','pm2dd', 'pm3dd','pm4dd','pm5dd','pm6dd'};
        legtext = {'^{L}xdd','^{L}ydd'};
        
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
            
        yMax1 = max(max([signal1, signal2]));
        yMax2 = yMax1;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'d1dd','d2dd', 'd3dd','d4dd','d5dd','d6dd'};
        if get(handles.desSignals_didd,'value')
            legtext = {'Measured','Desired'};
        else
            legtext = {};
        end
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

        yMax1 = max(max([signal1, signal2]));
        yMax2 = yMax1;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'am1dd','am2dd', 'am3dd','am4dd','am5dd','am6dd'};
        legtext = {'^{L}xdd','^{L}ydd'};
end

titlefontsize = 8;

for i = 1:numAxes
    switch plottedSignals
        case 'plottedSignals_Pdd'
            axesOrder = [1 2 3 4 5 6];
        case {'plottedSignals_pmidd','plottedSignals_didd','plottedSignals_amidd'}
            axesOrder = [1 4 2 5 3 6];
    end
    eval(['axes(handles.accAxes',num2str(axesOrder(i)),')'])
    cla
    eval(['set(handles.accAxes',num2str(axesOrder(i)),',''visible'',''on'')'])
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
    xtick = get(gca,'xtick');
    set(gca,'xtick',xtick(1:round(length(xtick)/5):length(xtick)));
end

for i = numAxes+1:6
    eval(['axes(handles.accAxes',num2str(axesOrder(i)),')'])
    cla
    eval(['set(handles.accAxes',num2str(axesOrder(i)),',''visible'',''off'')'])
end