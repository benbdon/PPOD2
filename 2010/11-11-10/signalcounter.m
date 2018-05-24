function [NCS NPMIS NPS NAMIS NDIS NRFS NFS] = signalcounter(handles)

NCS = numel(handles.globalinfo.uSignals);
NPMIS = numel(handles.globalinfo.pmiddSignals);
NPS = numel(handles.globalinfo.PddSignals);
NAMIS = numel(handles.globalinfo.amiddSignals);
NDIS = numel(handles.globalinfo.diddSignals);
NRFS = numel(handles.globalinfo.rawForceSignals);
NFS = numel(handles.globalinfo.forceSignals);