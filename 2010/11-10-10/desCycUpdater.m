function [desChar, desCyc] = desCycUpdater(handles)

constants = handles.signalinfo.constants;
f = 1/handles.signalinfo.T;%needed when evaluating user input
for i = 1:length(constants)
    eval([constants{i},';'])
end

t = handles.signalinfo.tCyc; %needed when evaluating user input
rows = length(t);

signals = get(get(handles.desiredSignalSelector,'selectedobject'),'tag');
switch signals
    case 'plateAccelerations'
        cols = size(handles.signalinfo.aCyc,2);
        desChar = cell(1,cols);
        desCyc = zeros(rows,cols);
    case 'actuatorAccelerations'
        cols = size(handles.signalinfo.dddCyc,2);
        desChar = cell(1,cols);
        desCyc = zeros(rows,cols);
    case 'actuatorVoltages'
        cols = size(handles.signalinfo.uCyc,2);
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
