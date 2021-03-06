function PlotPlate(handles)

T = handles.plateinfo.T;
plateAccSignals = handles.globalinfo.plateAccSignals;
aCyc = handles.signalinfo.aCyc;
adesCyc = handles.signalinfo.adesCyc;
tCyc = handles.signalinfo.tCyc;

%find maximum of linear and angular acceleration signals
dlinmax = max(max(adesCyc(:,1:3)));
dangmax = max(max(adesCyc(:,4:6)));

%find handles for d and y.  each handles is a vector with
%numel(platesignals) components (one d and y for each of the plots)
adesCyc_han = findobj('tag','adesCyc');
aCyc_han = findobj('tag','aCyc');

N_PAS = length(plateAccSignals);
for i = 1:N_PAS
    %go to ith axes of plate signals panel
    eval(['axes(handles.',plateAccSignals{i},'_axes)'])

    %determine handles to d and y line objects in axes so d_han(1)
    %corresponds to platesignals{end}    
    set(adesCyc_han(N_PAS+1-i),'xdata',tCyc,'ydata',adesCyc(:,i)) %update desired plate acceleration
    set(aCyc_han(N_PAS+1-i),'xdata',tCyc,'ydata',aCyc(:,i)) %update plate acceleration

    set(gca,'xlim',[0 T],'xtick',0:T/4:T)
    if ~get(handles.floatplateaxes,'value')
        if i <= 3
            if dlinmax > 0
                set(gca,'ylim',[-1.5*dlinmax, 1.5*dlinmax])
            else
                set(gca,'ylim',[-10, 10])
            end
        else
            if dangmax > 0
                set(gca,'ylim',[-1.5*dangmax, 1.5*dangmax])
            else
                set(gca,'ylim',[-150, 150])
            end
        end
    else
        set(gca,'ylim',[-Inf Inf])
    end
end