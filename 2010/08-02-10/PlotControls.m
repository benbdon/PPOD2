%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.

function PlotControls(handles)

controlSignals = handles.globalinfo.controlSignals;
T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;
uCyc = handles.signalinfo.uCyc;

samplesPerCycle = handles.signalinfo.samplesPerCycle;
uMax = handles.controllerinfo.uMax;
uMaxCyc = uMax*ones(1,samplesPerCycle);

%find handles for u.  each handles is a vector with
%numel(controlignals) components (one handle for each of the plots)
uCyc_han = findobj('tag','uCyc');
uMaxCyc_han = findobj('tag','uMaxCyc');
uMinCyc_han = findobj('tag','uMinCyc');

N_CS = numel(controlSignals);
for i = 1:N_CS
    %go to ith axes of control signals panel
    eval(['axes(handles.',controlSignals{i},'_axes)'])
    
    %determine handles to u line objects in axes so u_han(1)
    %corresponds to controlsignals{end}
    set(uCyc_han(N_CS+1-i),'xdata',tCyc,'ydata',uCyc(:,i)) %update u
    set(uMaxCyc_han(N_CS+1-i),'xdata',tCyc,'ydata',uMaxCyc) %update u
    set(uMinCyc_han(N_CS+1-i),'xdata',tCyc,'ydata',-uMaxCyc) %update u

    set(gca,'xlim',[0 T],'xtick',0:T/2:T)
    if ~get(handles.floatcontrolaxes,'value')
        set(gca,'ylim',[-1.25*uMax 1.25*uMax])
    else
        set(gca,'ylim',[-Inf,Inf])
    end
end