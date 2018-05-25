function [desChar, desCyc] = desCycUpdater(handles)

constants = handles.signalinfo.constants;
T = handles.signalinfo.T;
f = 1/T;%needed when evaluating user input

for i = 1:length(constants)
    eval([constants{i},';'])
end

t = handles.signalinfo.tCyc; %needed when evaluating user input
rows = length(t);

desSignals = get(get(handles.desSignalsSelector,'selectedobject'),'tag');
switch desSignals
    case 'desSignals_Pdd'
        cols = size(handles.signalinfo.PddCyc,2);
        desChar = cell(1,cols);
        desCyc = zeros(rows,cols);
    case 'desSignals_didd'
        cols = size(handles.signalinfo.diddCyc,2);
        desChar = cell(1,cols);
        desCyc = zeros(rows,cols);
    case 'desSignals_ui'
        cols = size(handles.signalinfo.uiCyc,2);
        desChar = cell(1,cols);
        desCyc = zeros(rows,cols);
end

for i = 1:cols
    desChar{i} = eval(['get(handles.desSignalChar',num2str(i),',''string'')']);
    desCyc(:,i) = eval(desChar{i}).*ones(size(t));
end

for i = cols+1:6
    desChar{i} = '';
end

%make sure desCyc has no NaN entries (e.g., from heaviside functions)
nanind = find(isnan(desCyc));
if ~isempty(nanind)
    desCyc(nanind) = desCyc(nanind+1);
end
