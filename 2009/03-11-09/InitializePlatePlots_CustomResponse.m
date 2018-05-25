function InitializePlatePlots_CustomResponse(handles)

pddmax = 20;
alphamax = 150;

T = handles.controllerinfo.T;
t_all = handles.controllerinfo.t_all;

%determine whether plate signals or raw plate signals has been selected
signalsource = get(get(handles.signalsourcepanel,'selectedobject'),'tag');

if strcmp(signalsource, 'platesignals')
    y = handles.signalinfo.y;
    platesignals = handles.globalinfo.platesignals;
    titletext = {'pdd_x','pdd_y', 'pdd_z','\alpha_x','\alpha_y','\alpha_z'};
else
    y = handles.signalinfo.y_raw;
    platesignals = handles.globalinfo.rawplatesignals;
    titletext = handles.globalinfo.rawplatesignals;
end

titlefontsize = 8;

%get domain type
signaldomain = get(get(handles.signaldomainpanel,'selectedobject'),'tag');

for i = 1:numel(platesignals)
    eval(['axes(handles.y',num2str(i),'_axes)'])
    set(gca,'Visible','on')
    cla

    %plot d and y signals (shoudl be initialized to zero)
    line(t_all, y(:,i),'Color','r','tag','y');

    %format the axes of the plots
    title(titletext{i},'fontsize',titlefontsize,'interpreter','tex');
    set(gca, 'xlim', [0 T]);

    switch signaldomain
        case 'timedomain'
            switch signalsource
                case 'platesignals'
                    %first time through, hide axes 7-12
                    if i == 1
                        for j = 7:12
                            eval(['axes(handles.y',num2str(j),'_axes)'])
                            set(gca,'Visible','off')
                            cla
                        end
                    end

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
                case 'rawplatesignals'
                    set(gca, 'ylim', [-pddmax pddmax]);
                    if i == 4
                        ylabel('')
                    end
            end
            if i == 5
                xlabel('Time(s)')
            end
        case 'frequencydomain'
            set(gca, 'ylim', [-pddmax pddmax]);
            if i == 1
                ylabel('Acc(m/s^2)')
            end
            if i == 5
                xlabel('Time(s)')
            end
    end

end