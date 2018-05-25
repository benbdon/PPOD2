%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.  It does this by updating the lines
%associated with these signals which are tagged in the
%InitializeSpeakerPlots function.

function PlotPlate(handles)

platesignals = handles.globalinfo.platesignals;
y = handles.signalinfo.y;
d = handles.signalinfo.d;
t_all = handles.plateinfo.t_all;
T = handles.plateinfo.T;

%find maximum of linear and angular acceleration signals
dlinmax = max(max(d(:,1:3)));
dangmax = max(max(d(:,4:6)));

%find handles for d and y.  each handles is a vector with
%numel(platesignals) components (one d and y for each of the plots)
d_han = findobj('tag','d');
y_han = findobj('tag','y');
for i = 1:numel(platesignals)
    %go to ith axes of plate signals panel
    eval(['axes(handles.',platesignals{i},'_axes)'])

    %determine handles to d and y line objects in axes so d_han(1)
    %corresponds to platesignals{end}    
    set(d_han(numel(platesignals)+1-i),'xdata',t_all,'ydata',d(:,i)) %update d
    set(y_han(numel(platesignals)+1-i),'xdata',t_all,'ydata',y(:,i)) %update y

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