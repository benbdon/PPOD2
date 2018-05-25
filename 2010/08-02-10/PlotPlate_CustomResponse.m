%This function plots the control (green) and acceleration (red) signals
%corresponding to the speakers.  It does this by updating the lines
%associated with these signals which are tagged in the
%InitializeSpeakerPlots function.

function PlotPlate_CustomResponse(handles)

tCyc = handles.signalinfo.tCyc;

%determine whether plate signals or raw plate signals has been selected
signalsource = get(get(handles.signalsourcepanel,'selectedobject'),'tag');

%find maximum of linear and angular acceleration signals
switch signalsource
    case 'platesignals'
        signals = handles.globalinfo.plateAccSignals;
        signalsCyc = handles.signalinfo.aCyc;
        
        ylinmax = max(max(signalsCyc(:,1:3)));
        yangmax = max(max(signalsCyc(:,4:6)));
        
    case 'actuatorsignals'
        signals = handles.globalinfo.actuatorAccSignals;
        signalsCyc = handles.signalinfo.dddCyc;
        
        ylinmax = max(max(y));
        
    case 'rawplatesignals'
        signals = handles.globalinfo.plateAccLocalSignals;
        signalsCyc = handles.signalinfo.aLocalCyc;
        
        ylinmax = 15;%max(max(y));
end

%find handles for y.  each handles is a vector with
%numel(platesignals) components
y_han = findobj('tag','y');

for i = 1:numel(signals)
    %go to ith axes of plate signals panel
    eval(['axes(handles.y',num2str(i),'_axes)'])

    %determine handles to y line objects in axes so y_han(1)
    %corresponds to platesignals{end}    
    set(y_han(numel(signals)+1-i),'xdata',tCyc,'ydata',signalsCyc(:,i))

    set(gca,'xlim',[0 tCyc(end)])
    
    switch signalsource
        case 'platesignals'
            if ~get(handles.floatplateaxes,'value')
                if i <= 3
                    if ylinmax > 0
                        set(gca,'ylim',[-1.5*ylinmax, 1.5*ylinmax])
                    else
                        set(gca,'ylim',[-10, 10])
                    end
                else
                    if yangmax > 0
                        set(gca,'ylim',[-1.5*yangmax, 1.5*yangmax])
                    else
                        set(gca,'ylim',[-100, 100])
                    end
                end
            else
                set(gca,'ylim',[-Inf Inf])
            end
            
        case 'actuatorsignals'
            if ~get(handles.floatplateaxes,'value')
                if ylinmax > 0
                    set(gca,'ylim',[-1.5*ylinmax, 1.5*ylinmax])
                else
                    set(gca,'ylim',[-10, 10])
                end
            else
                set(gca,'ylim',[-Inf Inf])
            end
            
        case 'rawplatesignals'
            if ~get(handles.floatplateaxes,'value')
                if ylinmax > 0
                    set(gca,'ylim',[-1.5*ylinmax, 1.5*ylinmax])
                else
                    set(gca,'ylim',[-10, 10])
                end
            else
                set(gca,'ylim',[-Inf Inf])
            end
    end
end