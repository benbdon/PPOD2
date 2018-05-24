function populateSavedSignalsListbox(handles)

dir_struct = dir([cd,'\SavedSignals_Pdd']);
[sorted_names, sorted_index] = sortrows({dir_struct.name}');
%get rid of "." and ".." files
all_file_names = sorted_names(3:end);

%make sure to just load .mat files
j = 1;
for i = 1:numel(all_file_names)
    [pathstr, name, ext] = fileparts(all_file_names{i});
    if strcmp(ext,'.mat')
        file_names{j,1} = all_file_names{i};
        j = j + 1;
    end
end

%displays all files in directory in the list box
if exist('file_names')
    set(handles.savedSignalsListbox,'String', file_names);
end