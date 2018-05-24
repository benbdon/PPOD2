%Initializes plots for speakers.  the control signal (green) and the
%acceleration signal (red) are initially horizontal lines at zero

function InitializeControlPlots(handles)

T = handles.plateinfo.T;
samplesPerCycle = handles.signalinfo.samplesPerCycle;
tCyc = handles.signalinfo.tCyc;
uCyc = handles.signalinfo.uCyc;

ymax = handles.controllerinfo.uMax*1.5;
uMax = handles.controllerinfo.uMax;
uMaxCyc = uMax*ones(1,samplesPerCycle);
uMinCyc = -uMax*ones(1,samplesPerCycle);

titlefontsize = 8;
titletext = {'u_1','u_2','u_3','u_4','u_5','u_6'};

controlSignals = handles.globalinfo.controlSignals;
for i = 1:numel(controlSignals)
    eval(['axes(handles.',controlSignals{i},'_axes)'])
    cla
    title(titletext{i},'fontsize',titlefontsize);
    set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
    set(gca, 'ylim', [-ymax ymax]);
    %draw saturation voltage lines
    line(tCyc, uMaxCyc,'color','k','linestyle',':','tag','uMaxCyc')
    line(tCyc, uMinCyc,'color','k','linestyle',':','tag','uMinCyc')
    %draw control signal
    line(tCyc, uCyc(:,i),'Color','g','tag','uCyc');
    if i == 1
        ylabel('Voltage(V)')
    end
    if i == 6
        xlabel('Time(s)')
    end
end
 
