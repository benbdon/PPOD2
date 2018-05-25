function [NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS] = signalCounter(handles)

NUIS = numel(handles.globalinfo.uiSignals);
NPMIDDS = numel(handles.globalinfo.pmiddSignals);
NPDDS = numel(handles.globalinfo.PddSignals);
NAMIDDS = numel(handles.globalinfo.amiddSignals);
NDIDDS = numel(handles.globalinfo.diddSignals);
NRFS = numel(handles.globalinfo.rawForceSignals);
NFS = numel(handles.globalinfo.forceSignals);