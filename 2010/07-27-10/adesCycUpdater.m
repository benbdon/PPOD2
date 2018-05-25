function adesCyc = adesCycUpdater(handles,adesTag)

hObject = eval(['handles.',adesTag]);
adesChar = get(hObject,'String');

constants = handles.plateinfo.constants;
f = 1/handles.plateinfo.T;%needed when evaluating user input
for i = 1:length(constants)
    eval([constants{i},';'])
end
t = handles.signalinfo.tCyc; %needed when evaluating user input

adesCyc = eval(adesChar).*ones(size(t));

%make sure d has no NaN entries (e.g., from heaviside functions)
nanind = find(isnan(adesCyc));
if ~isempty(nanind)
    adesCyc(nanind) = adesCyc(nanind+1);
end