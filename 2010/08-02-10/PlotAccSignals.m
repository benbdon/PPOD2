function PlotAccSignals(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;

switch get(get(handles.accSignalSelector,'selectedobject'),'tag')
    case 'plateAcc'
        accSignals = handles.globalinfo.plateAccSignals;
        signal1Cyc = handles.signalinfo.aCyc;
        signal2Cyc = handles.signalinfo.adesCyc;
        
        yMax1 = max(max(signal2Cyc(:,1:3)));
        yMax2 = max(max(signal2Cyc(:,4:6)));
    case 'plateAccLocal'
        accSignals = {'accLocal1','accLocal2', 'accLocal3','accLocal4','accLocal5','accLocal6'};
        signal1Cyc = handles.signalinfo.aLocalCyc(:,1:2:end);
        signal2Cyc = handles.signalinfo.aLocalCyc(:,2:2:end);
        
        yMax1 = max(max([signal1Cyc signal2Cyc]));
        yMax2 = yMax1;
    case 'actuatorAcc'
        accSignals = handles.globalinfo.actuatorAccSignals;
        signal1Cyc = handles.signalinfo.dddCyc;
        signal2Cyc = zeros(size(signal1Cyc));

        yMax1 = max(max(signal1Cyc));
        yMax2 = yMax1;
end

%find handles for d and y.  each handles is a vector with
%numel(platesignals) components (one d and y for each of the plots)
signal1_han = findobj('tag','signal1');
signal2_han = findobj('tag','signal2');

pause(.0001)%this elimantes redrawing legend for some reason
N = length(accSignals);
for i = 1:N
    %go to ith axes of plate signals panel
    eval(['axes(handles.accAxes',num2str(i),')'])

    %determine handles to signal1 and signal2 line objects in axes so signal1_han(1)
    %corresponds to plateAccSignal{end}
    set(signal1_han(N+1-i),'xdata',tCyc,'ydata',signal1Cyc(:,i)) %update signal1
    set(signal2_han(N+1-i),'xdata',tCyc,'ydata',signal2Cyc(:,i)) %update signal2

    set(gca,'xlim',[0 T],'xtick',0:T/4:T)
    if ~get(handles.floatplateaxes,'value')
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
                set(gca,'ylim',[-150, 150])
            end
        end
    else
        set(gca,'ylim',[-Inf Inf])
    end
end