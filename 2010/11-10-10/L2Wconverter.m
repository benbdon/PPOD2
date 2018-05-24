function [T_P2pmi, T_ai2ami, T_pi2pmi] = L2Wconverter(handles)

%W: fixed world frame centered on plate home position
%S: plate frame centered on plate
%L1: local accelerometer 1 frame (left hand side accelerometer)
%L2: local accelerometer 2 frame (right hand side accelerometer)

%position vectors in S of accelerometers
%Put into GUI**************************
plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
plateAccSignals = handles.globalinfo.plateAccSignals;

switch handles.globalinfo.mode
    case 'standard'
        th_all = [140 160 260 280 20 40]*pi/180;
        r = 0.17; %radial distance of accelerometers from origin of S
        z = -.025; %height of accelerometers from origin of S
        
        T_P2pmi = zeros(numel(plateAccLocalSignals),numel(plateAccSignals));
        
        for i = 1:numel(th_all)
            th = th_all(i);
            l = [r*cos(th); r*sin(th); z]; %position of ith accelerometer in S
            
            T_P2pmi(2*i-1,:) = [-sin(th), cos(th), 0, -l(3)*cos(th), -l(3)*sin(th), r];
            T_P2pmi(2*i,:) = [0, 0, 1, l(2), -l(1), 0];
        end
        T_ai2ami = [];
        T_pi2pmi = [];
        
    case 'force'
        %assumes two dual axis accelerometers mounted on cube.  local
        %y-axes are along shaft axis pointing towards fixed end of flexure
        %(this is the z-axis in A frame).
        T_ai2ami = [
            1 0 0;
            0 0 1;
            0 -1 0;
            0 0 1];
        
        T_pi2pmi = T_ai2ami;
        T_P2pmi = T_ai2ami;
end