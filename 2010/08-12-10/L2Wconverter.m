function A = L2Wconverter(handles)

%W: fixed world frame centered on plate home position
%S: plate frame centered on plate
%L1: local accelerometer 1 frame (left hand side accelerometer)
%L2: local accelerometer 2 frame (right hand side accelerometer)

%position vectors in S of accelerometers
%Put into GUI**************************
plateAccLocalSignals = handles.globalinfo.plateAccLocalSignals;
plateAccSignals = handles.globalinfo.plateAccSignals;

th_all = [140 160 260 280 20 40]*pi/180;
r = 0.17; %radial distance of accelerometers from origin of S
z = -.025; %height of accelerometers from origin of S

A = zeros(numel(plateAccLocalSignals),numel(plateAccSignals));

for i = 1:numel(th_all)
    th = th_all(i);
    l = [r*cos(th); r*sin(th); z]; %position of ith accelerometer in S

    A(2*i-1,:) = [-sin(th), cos(th), 0, -l(3)*cos(th), -l(3)*sin(th), r];
    A(2*i,:) = [0, 0, 1, l(2), -l(1), 0];
end