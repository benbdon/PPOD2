function [desChar, desCyc] = desCycUpdater(handles)

constants = handles.signalinfo.constants;
T = handles.signalinfo.T;

for i = 1:length(constants)
    eval([constants{i},';'])
end

t = handles.signalinfo.tCyc; %needed when evaluating user input

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        desCharOld = handles.signalinfo.PddDesChar;
        desChar = handles.signalinfo.PddDesChar;
        desCyc = handles.signalinfo.PddDesCyc;
    case 'desSignals_didd'
        desCharOld = handles.signalinfo.diddDesChar;
        desChar = handles.signalinfo.diddDesChar;
        desCyc = handles.signalinfo.diddDesCyc;
    case 'desSignals_ui'
        desCharOld = handles.signalinfo.uiDesChar;
        desChar = handles.signalinfo.uiDesChar;
        desCyc = handles.signalinfo.uiDesCyc;
end

for i = 1:length(desChar)
    desChar{i} = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
    %determine if user input is valid.  if not, load old input
    try
        desCyc(:,i) = eval(desChar{i}).*ones(size(t));
    catch
        warndlg('Invalid syntax. String will be reset to previous entry.')
        uiwait
        desChar{i} = desCharOld{i};
        set(eval(['handles.desSignalChar',num2str(i)]),'string',desChar{i},'enable','on')
    end
end

%make sure desCyc has no NaN entries (e.g., from heaviside functions)
nanind = find(isnan(desCyc));
if ~isempty(nanind)
    desCyc(nanind) = desCyc(nanind+1);
end
