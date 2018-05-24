function PlotGn(handles)

mainGUIhandles = handles.mainGUIhandles;

diddSignals = mainGUIhandles.globalinfo.diddSignals;
PddSignals = mainGUIhandles.globalinfo.PddSignals;
pmiddSignals = mainGUIhandles.globalinfo.pmiddSignals;
uiSignals = mainGUIhandles.globalinfo.uiSignals;

if isempty(diddSignals)
    for i = 1:numel(uiSignals)
        eval(['set(handles.',uiSignals{i},'_2_y_sp,''visible'',''off'')'])
    end
    for i = 1:6
        eval(['set(handles.u_2_sp',num2str(i),',''visible'',''off'')'])
    end
    set(handles.uipanel19,'visible','off')
    set(handles.uipanel20,'visible','off')
end

F_ui_all = mainGUIhandles.controllerinfo.F_ui_all;

G_ui2Pdd = mainGUIhandles.controllerinfo.G_ui2Pdd_all;
G_ui2Pdd_mag = abs(G_ui2Pdd);
G_ui2Pdd_phase = angle(G_ui2Pdd);
G_ui2pmidd = mainGUIhandles.controllerinfo.G_ui2pmidd_all;
G_ui2pmidd_mag = abs(G_ui2pmidd);
G_ui2pmidd_phase = angle(G_ui2pmidd);
G_ui2didd = mainGUIhandles.controllerinfo.G_ui2didd_all;
G_ui2didd_mag = abs(G_ui2didd);
G_ui2didd_phase = angle(G_ui2didd);

set(handles.controlledfreqs,'string',[mat2str(F_ui_all), ' Hz'])

%create cell array of plotting options with each panel in GUI
%corresponding to a row and the entries in that panel making up the columns in
%that row
for i = 1:6
    switch i
        case 1 %e.g., u1 --> Pdd
            for j = 1:numel(uiSignals)
                plotoptions{i,j} = [uiSignals{j},'_2_Pdd'];
            end
        case 2 %e.g., ui --> pddx
            for j = 1:numel(PddSignals)
                plotoptions{i,j} = ['ui_2_',PddSignals{j}];
            end
        case 3 %e.g., u1 --> pmidd
            for j = 1:numel(uiSignals)
                plotoptions{i,j} = [uiSignals{j},'_2_pmidd'];
            end
        case 4 % e.g., ui --> pmiddx
            for j = 1:numel(pmiddSignals)
                plotoptions{i,j} = ['ui_2_',pmiddSignals{j}];
            end
        case 5 %e.g., u1 --> didd
            for j = 1:numel(uiSignals)
                plotoptions{i,j} = [uiSignals{j},'_2_didd'];
            end
        case 6 %e.g., ui --> d1dd
            for j = 1:numel(diddSignals)
                plotoptions{i,j} = ['ui_2_',diddSignals{j}];
            end
    end
end


%get tag of selected radio button in frequency units button panel
frequencyunits = get(get(handles.frequencyunits,'selectedobject'),'tag');
if strcmp(frequencyunits,'Hz')
    freqs = F_ui_all; %cyc/s (Hz)
    xlabeltext = 'Frequency (Hz)';
else
    freqs = F_ui_all/(2*pi); %rad/s
    xlabeltext = 'Frequency (rad/s)';
end

%get tag of selected radio button in gain units button panel
gainunits = get(get(handles.gainunits,'selectedobject'),'tag');
if strcmp(gainunits,'V_per_acc')
    gain_ui2Pdd = G_ui2Pdd_mag;
    gain_ui2pmidd = G_ui2pmidd_mag;
    gain_ui2didd = G_ui2didd_mag;
    ylabeltext = {'gain (m/s^2/V)','gain (rad/s^2/V)'};

    %largest linear and angular responses
    ymax = max(max(max(abs(G_ui2Pdd(1:3,:,:)))));
    ymin = 0;
    alphamax = max(max(max(abs(G_ui2Pdd(4:6,:,:)))));
    alphamin = 0;

    %largest raw responses
    ymax_raw = max(max(max(abs(G_ui2pmidd(:,:,:)))));
    ymin_raw = 0;

    %largest speaker responses
    ymax_sp = max(max(max(abs(G_ui2didd(:,:,:)))));
    ymin_sp = 0;

else
    gain_ui2Pdd = 20*log10(G_ui2Pdd_mag);
    gain_ui2pmidd = 20*log10(G_ui2pmidd_mag);
    gain_ui2didd = 20*log10(G_ui2didd_mag);
    ylabeltext = {'gain (dB)','gain (dB)'};

    %largest linear and angular repsonses
    ymax = 20*log10(max(max(max(abs(G_ui2Pdd(1:2,:,:))))));
    ymin = 20*log10(min(min(min(abs(G_ui2Pdd(1:2,:,:))))));

    alphamax = 20*log10(max(max(max(abs(G_ui2Pdd(3,:,:))))));
    alphamin = 20*log10(min(min(min(abs(G_ui2Pdd(3,:,:))))));

    %largest raw responses
    ymax_raw = 20*log10(max(max(max(abs(G_ui2pmidd(:,:,:))))));
    ymin_raw = 20*log10(min(min(min(abs(G_ui2pmidd(:,:,:))))));

    %largest speaker responses
    ymax_sp = 20*log10(max(max(max(abs(G_ui2didd(:,:,:))))));
    ymin_sp = 20*log10(min(min(min(abs(G_ui2didd(:,:,:))))));
end

%get the plot options block (blocknum) and position within the block (blocknum_ind)
plottype = get(get(handles.plotoptions,'selectedobject'),'tag');

[row col] = size(plotoptions);
for i = 1:row
    for j = 1:col
        if strcmp(plottype, plotoptions{i,j})
            panel = i;
            ind = j;
        end
    end
end

if exist('panel')
    switch panel

        case 1 %panel 1: %e.g., u1 --> y (1 input --> 6 outputs)

            for i = 1:numel(PddSignals)
                %gain plots
                eval(['axes(handles.axes',num2str(2*i-1),')'])
                stem(freqs, squeeze(gain_ui2Pdd(i,ind,:,1)))
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if i <= 3
                    set(gca,'ylim',[1.1*ymin 1.1*ymax])
                    if i == 1
                        ylabel(ylabeltext{1})
                    end
                else
                    set(gca,'ylim',[1.1*alphamin 1.1*alphamax])
                    if i == 4
                        ylabel(ylabeltext{2})
                    end
                end
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                title([uiSignals{ind},' --> ',PddSignals{i}])

                %phase plots
                eval(['axes(handles.axes',num2str(2*i),')'])
                stem(freqs, unwrap(squeeze(G_ui2Pdd_phase(i,ind,:,1))))
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                set(gca,'ylim',[1.5*-2*pi,1.5*2*pi])
                set(gca,'ytick',[-2*pi:pi:2*pi])
                if i == 1
                    xlabel(xlabeltext)
                    ylabel('phase (rad)')
                end
            end

        case 2 %panel 2: %e.g., u --> y.pddx (6 inputs --> 1 output)

            for i = 1:numel(uiSignals)
                %gain plots
                eval(['axes(handles.axes',num2str(2*i-1),')'])
                stem(freqs, squeeze(gain_ui2Pdd(ind,i,:)))
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if ind <= 3
                    set(gca,'Ylim',[1.1*ymin 1.1*ymax])
                    if i == 1
                        ylabel(ylabeltext{1})
                    end
                else
                    set(gca,'Ylim',[1.1*alphamin 1.1*alphamax])
                    if i == 1
                        ylabel(ylabeltext{2})
                    end

                end
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                title([uiSignals{i},' --> ',PddSignals{ind}])

                %phase plots
                eval(['axes(handles.axes',num2str(2*i),')'])
                stem(freqs, unwrap(squeeze(G_ui2Pdd_phase(ind,i,:))))
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                set(gca,'ylim',[-1.5*2*pi,1.5*2*pi])
                set(gca,'ytick',[-2*pi:pi:2*pi])
                if i == 1
                    xlabel(xlabeltext)
                    ylabel('phase (rad)')
                end
            end

        case 3 %panel 3: %e.g., u1 --> y_raw (1 input --> 12 outputs)
            %since this requires 24 plots, just plot the magnitude plots

            for i = 1:numel(pmiddSignals)
                %gain plots
                eval(['axes(handles.axes',num2str(i),')'])
                stem(freqs, squeeze(gain_ui2pmidd(i,ind,:,1)))
                set(gca,'ylim',[1.1*ymin_raw 1.1*ymax_raw])
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                title([uiSignals{ind},' --> ',pmiddSignals{i}])
                if i == 1 || i == 2
                    ylabel(ylabeltext{1})
                    if i == 2
                        xlabel(xlabeltext)
                    end
                end
            end

        case 4  %panel 4: %e.g., u --> y_raw.x1dd (6 inputs --> 1 output)

            for i = 1:numel(uiSignals)
                %gain plots
                eval(['axes(handles.axes',num2str(2*i-1),')'])
                stem(freqs, squeeze(gain_ui2pmidd(ind,i,:)))
                set(gca,'ylim',[1.1*ymin_raw 1.1*ymax_raw])
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                title([uiSignals{i},' --> ',pmiddSignals{ind}])
                if i == 1
                    ylabel(ylabeltext{1})
                end

                %phase plots
                eval(['axes(handles.axes',num2str(2*i),')'])
                stem(freqs, unwrap(squeeze(G_ui2pmidd_phase(ind,i,:))))
                set(gca,'xlim',[0 F_ui_all(end)+10])
                if strcmp(frequencyunits,'rad_per_s')
                    set(gca,'Xscale','log')
                end
                set(gca,'ylim',[-1.5*2*pi,1.5*2*pi])
                set(gca,'ytick',[-2*pi:pi:2*pi])
                if i == 1
                    xlabel(xlabeltext)
                    ylabel('phase (rad)')
                end
            end

        case 5 %panel 5: %e.g., u1 --> y_sp (1 input --> 6 outputs)
            if ~isempty(diddSignals)
                for i = 1:numel(diddSignals)
                    %gain plots
                    eval(['axes(handles.axes',num2str(2*i-1),')'])
                    stem(freqs, squeeze(gain_ui2didd(i,ind,:,1)))
                    set(gca,'ylim',[1.1*ymin_sp 1.1*ymax_sp])
                    set(gca,'xlim',[0 F_ui_all(end)+10])
                    if strcmp(frequencyunits,'rad_per_s')
                        set(gca,'Xscale','log')
                    end
                    title([uiSignals{ind},' --> ',diddSignals{i}])
                    if i == 1
                        ylabel(ylabeltext{1})
                    end

                    %phase plots
                    eval(['axes(handles.axes',num2str(2*i),')'])
                    stem(freqs, unwrap(squeeze(G_ui2didd_phase(i,ind,:,1))))
                    set(gca,'xlim',[0 F_ui_all(end)+10])
                    if strcmp(frequencyunits,'rad_per_s')
                        set(gca,'Xscale','log')
                    end
                    set(gca,'ylim',[-1.5*2*pi,1.5*2*pi])
                    set(gca,'ytick',[-2*pi:pi:2*pi])
                    if i == 1
                        xlabel(xlabeltext)
                        ylabel('phase (rad)')
                    end
                end
            else
                warndlg('This option is not available because the speaker signals were not measured.')
                uiwait
            end


        case 6  %panel 6: %e.g., u --> y_sp1
            if ~ismempty(diddSignals)
                axes(handles.axes7)
                cla
                set(gca,'visible','off')
                axes(handles.axes8)
                cla
                set(gca,'visible','off')

                for i = 1:numel(uiSignals)
                    %gain plots
                    eval(['axes(handles.axes',num2str(2*i-1),')'])
                    stem(freqs, squeeze(gain_ui2didd(ind,i,:)))
                    set(gca,'ylim',[1.1*ymin_sp 1.1*ymax_sp])
                    set(gca,'xlim',[0 F_ui_all(end)+10])
                    if strcmp(frequencyunits,'rad_per_s')
                        set(gca,'Xscale','log')
                    end
                    title([uiSignals{i},' --> ',diddSignals{ind}])
                    if i == 1
                        ylabel(ylabeltext{1})
                    end

                    %phase plots
                    eval(['axes(handles.axes',num2str(2*i),')'])
                    stem(freqs, unwrap(squeeze(G_ui2didd_phase(ind,i,:))))
                    set(gca,'xlim',[0 F_ui_all(end)+10])
                    if strcmp(frequencyunits,'rad_per_s')
                        set(gca,'Xscale','log')
                    end
                    set(gca,'ylim',[-1.5*2*pi,1.5*2*pi])
                    set(gca,'ytick',[-2*pi:pi:2*pi])
                    if i == 1
                        xlabel(xlabeltext)
                        ylabel('phase (rad)')
                    end
                end
            else
                warndlg('This option is not available because the speaker signals were not measured.')
                uiwait
            end
    end
end