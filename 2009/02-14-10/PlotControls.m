%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.

function PlotControls(handles)

controlsignals = handles.globalinfo.controlsignals;
u = handles.signalinfo.u;
t_all = handles.plateinfo.t_all;
T = handles.plateinfo.T;

saturation = handles.controllerinfo.saturation;
samples_per_cycle = handles.plateinfo.samples_per_cycle;
umax = saturation*ones(1,samples_per_cycle);

%find handles for u.  each handles is a vector with
%numel(controlignals) components (one handle for each of the plots)
u_han = findobj('tag','u');
u_max_han = findobj('tag','umax');
u_min_han = findobj('tag','umin');

for i = 1:numel(controlsignals)
    %go to ith axes of control signals panel
    eval(['axes(handles.',controlsignals{i},'_axes)'])
    
    %determine handles to u line objects in axes so u_han(1)
    %corresponds to controlsignals{end}
    set(u_han(numel(controlsignals)+1-i),'xdata',t_all,'ydata',u(:,i)) %update u
    set(u_max_han(numel(controlsignals)+1-i),'xdata',t_all,'ydata',umax) %update u
    set(u_min_han(numel(controlsignals)+1-i),'xdata',t_all,'ydata',-umax) %update u

    set(gca,'xlim',[0 T],'xtick',0:T/2:T)
    if ~get(handles.floatcontrolaxes,'value')
        set(gca,'ylim',[-1.1*saturation 1.1*saturation])
    else
        set(gca,'ylim',[-Inf,Inf])
    end
end