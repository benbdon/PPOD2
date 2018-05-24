function [T_W2pmi, T_di2ami] = frameTransformations(handles)

%T_W2pmi: transformation from accelerations of W frame (technically P-prime
%frame) to accelerations measured at each plate accelerometer

%T_di2ami: transformation from accelerations along actuator shafts
%to accelerations measured at each actuator accelerometer

[NUIS NPMIDDS NPDDS NAMIDDS NDIDDS NRFS NFS] = signalCounter(handles); %outputs number of signals

switch handles.globalinfo.aiConfig
    case 'standard'
        th_all = [10 110 130 230 250 350]*pi/180;
        r = 0.17; %radial distance of accelerometers from origin of S
        z = -.025; %height of accelerometers from origin of S
        
        T_W2pmi = zeros(NPMIDDS,NPDDS);
        
        for i = 1:numel(th_all)
            th = th_all(i);
            l = [r*cos(th); r*sin(th); z]; %position of ith accelerometer in S
            
            T_W2pmi(2*i-1,:) = [-sin(th), cos(th), 0, -l(3)*cos(th), -l(3)*sin(th), r];
            T_W2pmi(2*i,:) = [0, 0, 1, l(2), -l(1), 0];
        end
        T_di2ami = eye(6);
        
    case 'force'
        %assumes two dual axis accelerometers mounted on cube.  local
        %y-axes are along shaft axis pointing towards fixed end of flexure
        %(this is the z-axis in A frame).
        T_di2ami = [
            0;
            1;
            0;
            1];
        
        T_W2pmi = [
            -1 0 0;
            0 0 -1;
            -1 0 0;
            0 -1 0];
end