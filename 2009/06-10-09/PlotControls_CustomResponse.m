%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.

function PlotControls_CustomResponse(handles)

controlsignals = handles.globalinfo.controlsignals;
u = handles.signalinfo.u;
t_all = handles.controllerinfo.t_all;

saturation = handles.controllerinfo.saturation;

%find handles for u.  each handles is a vector with
%numel(controlignals) components (one handle for each of the plots)
u_han = findobj('tag','u');

for i = 1:numel(controlsignals)
    %go to ith axes of control signals panel
    eval(['axes(handles.',controlsignals{i},'_axes)'])
    
    %determine handles to u line objects in axes so u_han(1)
    %corresponds to controlsignals{end}
    set(u_han(numel(controlsignals)+1-i),'xdata',t_all,'ydata',u(:,i)) %update u

    set(gca,'xlim',[0 t_all(end)])
    set(gca,'ylim',[-1.5*saturation 1.5*saturation])
end