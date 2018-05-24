%Initializes plots for speakers.  the control signal (green) and the
%acceleration signal (red) are initially horizontal lines at zero

function InitializeControlPlots(handles)

t_all = handles.plateinfo.t_all;
T = handles.plateinfo.T;
u = handles.signalinfo.u;

ymax = handles.controllerinfo.saturation*1.5;
saturation = handles.controllerinfo.saturation;
samples_per_cycle = handles.plateinfo.samples_per_cycle;

titlefontsize = 8;
titletext = {'u_1','u_2','u_3','u_4','u_5','u_6'};

controlsignals = handles.globalinfo.controlsignals;
for i = 1:numel(controlsignals)
    eval(['axes(handles.',controlsignals{i},'_axes)'])
    cla
    title(titletext{i},'fontsize',titlefontsize);
    set(gca, 'xlim', [0 T],'xtick',0:T/2:T);
    set(gca, 'ylim', [-ymax ymax]);
    %draw saturation voltage lines
    line(t_all, saturation*ones(1,samples_per_cycle),'color','g','linestyle','--','tag','umax')
    line(t_all, -saturation*ones(1,samples_per_cycle),'color','g','linestyle','--','tag','umin')
    %draw control signal
    line(t_all, u(:,i),'Color','g','tag','u');
    if i == 1
        ylabel('Voltage(V)')
    end
    if i == 6
        xlabel('Time(s)')
    end
end
 
