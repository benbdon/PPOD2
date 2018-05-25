function [T_P2pmi, T_di2ami] = frameTransformations(handles)

%T_P2pmi: transformation from accelerations of P frame (equivalently P-prime and W frames)
%to accelerations measured at each plate accelerometer

%T_di2ami: transformation from accelerations along actuator shafts 
%to accelerations measured at each actuator accelerometer

pmiddSignals = handles.globalinfo.pmiddSignals;
PddSignals = handles.globalinfo.PddSignals;
forceSignals = handles.globalinfo.forceSignals;

if isempty(forceSignals) %standard input mode
    th_all = [140 160 260 280 20 40]*pi/180;
    r = 0.17; %radial distance of accelerometers from origin of S
    z = -.025; %height of accelerometers from origin of S
    
    T_P2pmi = zeros(numel(pmiddSignals),numel(PddSignals));
    
    for i = 1:numel(th_all)
        th = th_all(i);
        l = [r*cos(th); r*sin(th); z]; %position of ith accelerometer in S
        
        T_P2pmi(2*i-1,:) = [-sin(th), cos(th), 0, -l(3)*cos(th), -l(3)*sin(th), r];
        T_P2pmi(2*i,:) = [0, 0, 1, l(2), -l(1), 0];
    end
    T_di2ami = eye(6);
    
else %force input mode
    %assumes two dual axis accelerometers mounted on cube.  local
    %y-axes are along shaft axis pointing towards fixed end of flexure
    %(this is the z-axis in A frame).
    T_di2ami = [
        0;
        1;
        0;
        1];
    
    T_P2pmi = T_ai2ami;
end