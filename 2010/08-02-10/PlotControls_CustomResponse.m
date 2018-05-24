%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.

function PlotControls_CustomResponse(handles)

controlSignals = handles.globalinfo.controlSignals;
uCyc = handles.signalinfo.uCyc;
tCyc = handles.signalinfo.tCyc;

uMax = handles.controllerinfo.uMax;

%find handles for u.  each handles is a vector with
%numel(controlignals) components (one handle for each of the plots)
u_han = findobj('tag','u');

for i = 1:numel(controlSignals)
    %go to ith axes of control signals panel
    eval(['axes(handles.',controlSignals{i},'_axes)'])
    
    %determine handles to u line objects in axes so u_han(1)
    %corresponds to controlsignals{end}
    set(u_han(numel(controlSignals)+1-i),'xdata',tCyc,'ydata',uCyc(:,i)) %update u

    set(gca,'xlim',[0 tCyc(end)])
    set(gca,'ylim',[-1.5*uMax 1.5*uMax])
end