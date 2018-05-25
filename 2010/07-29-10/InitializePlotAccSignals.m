function InitializePlotAccSignals(handles)



T = handles.plateinfo.T;
tCyc = handles.signalinfo.tCyc;

switch get(get(handles.accSignalSelector,'selectedobject'),'tag')
    case 'plateAcc'
        accSignals = handles.globalinfo.plateAccSignals;
        signal1Cyc = handles.signalinfo.aCyc;
        signal2Cyc = handles.signalinfo.adesCyc;
        
        yMax1 = 20;
        yMax2 = 150;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
  
        titletext = {'pdd_x','pdd_y', 'pdd_z','\alpha_x','\alpha_y','\alpha_z'};
        legtext = {'Measured','Desired'};
    case 'plateAccLocal'
        accSignals = {'accLocal1','accLocal2', 'accLocal3','accLocal4','accLocal5','accLocal6'};
        signal1Cyc = handles.signalinfo.aLocalCyc;
        signal2Cyc = zeros(size(signal1Cyc));
        
        yMax1 = 20;
        yMax2 = 20;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'accLocal1','accLocal2', 'accLocal3','accLocal4','accLocal5','accLocal6'};
        legtext = {'^{L}xdd','^{L}ydd'};
    case 'actuatorAcc'
        accSignals = handles.globalinfo.actuatorAccSignals;
        signal1Cyc = handles.signalinfo.dddCyc;
        signal2Cyc = zeros(size(signal1Cyc));
        
        yMax1 = 20;
        yMax2 = 20;
        
        yLabel1 = 'Acc(m/s^2)';
        yLabel2 = 'Ang Acc(rad/s^2)';
        
        titletext = {'d1dd','d2dd', 'd3dd','d4dd','d5dd','d6dd'};
        legtext = {};
end

titlefontsize = 8;

for i = 1:numel(accSignals)
    eval(['axes(handles.accAxes',num2str(i),')'])
    cla
    
    %plot d and y signals (shoudl be initialized to zero)
    line(tCyc, signal1Cyc(:,i),'Color','r','tag','signal1');
    line(tCyc, signal2Cyc(:,i),'Color','b','tag','signal2');

    %format the axes of the plots
    title(titletext{i},'fontsize',titlefontsize,'interpreter','tex');
    set(gca, 'xlim', [0 T],'xtick',0:T/4:T);
    if i <= 3
        set(gca, 'ylim', [-yMax1 yMax1]);
    else
        set(gca,'ylim', [-yMax2, yMax2]);
    end
    if i == 1
        ylabel(yLabel1)
        if ~isempty(legtext)
            leg_han = legend(legtext);
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
        xlabel('Time(s)')
    end
end