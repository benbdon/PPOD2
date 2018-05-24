function InitializePlatePlots(handles)

pddmax = 20;
alphamax = 150;

T = handles.plateinfo.T;
t_all = handles.plateinfo.t_all;
d = handles.signalinfo.d;
y = handles.signalinfo.y;
platesignals = handles.globalinfo.platesignals;
titletext = {'pdd_x','pdd_y', 'pdd_z','\alpha_x','\alpha_y','\alpha_z'};

titlefontsize = 8;

for i = 1:numel(platesignals)
    eval(['axes(handles.',platesignals{i},'_axes)'])
    cla
    
    %plot d and y signals (shoudl be initialized to zero)
    line(t_all, d(:,i),'Color','b','tag','d');
    line(t_all, y(:,i),'Color','r','tag','y');
    
    %format the axes of the plots
    title(titletext{i},'fontsize',titlefontsize,'interpreter','tex');
    set(gca, 'xlim', [0 T],'xtick',0:T/4:T);
    if i <= 3
        set(gca, 'ylim', [-pddmax pddmax]);
    else
        set(gca,'ylim', [-alphamax, alphamax]);
    end
    if i == 1
        ylabel('Acc(m/s^2)')
    end
    if i == 4
        ylabel('Ang Acc(rad/s^2)')
    end
    if i == 3 || i == 6
        xlabel('Time(s)')
    end
end