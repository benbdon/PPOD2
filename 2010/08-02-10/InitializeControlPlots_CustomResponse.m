function InitializeControlPlots_CustomResponse(handles)

T = handles.signalinfo.T;
tCyc = handles.signalinfo.tCyc;
uCyc = handles.signalinfo.uCyc;

ymax = handles.controllerinfo.uMax*1.5;

titlefontsize = 8;
titletext = {'u_1','u_2','u_3','u_4','u_5','u_6'};

controlSignals = handles.globalinfo.controlSignals;
for i = 1:numel(controlSignals)
    eval(['axes(handles.',controlSignals{i},'_axes)'])
    cla
    title(titletext{i},'fontsize',titlefontsize);
    set(gca, 'xlim', [0 T]);
    set(gca, 'ylim', [-ymax ymax]);
    line(tCyc,uCyc(:,i),'Color','g','tag','u');
    if i == 1
        ylabel('Voltage(V)')
    end
    if i == 6
        xlabel('Time(s)')
    end
end
 
