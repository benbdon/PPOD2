function A = L2Wconverter(handles)

%W: fixed world frame centered on plate home position
%S: plate frame centered on plate
%L1: local accelerometer 1 frame (left hand side accelerometer)
%L2: local accelerometer 2 frame (right hand side accelerometer)

%position vectors in S of accelerometers
%Put into GUI**************************
rawplatesignals = handles.globalinfo.rawplatesignals;
platesignals = handles.globalinfo.platesignals;

th = [5 115 125 235 245 355]*pi/180;
r = 0.17; %radial distance of accelerometers from origin of S
z = -.01; %height of accelerometers from origin of S

l_S = zeros(3,numel(th));
for i = 1:numel(th)
    l_S(:,i) = [r*cos(th(i)); r*sin(th(i)); z];
end

A = zeros(numel(rawplatesignals),numel(platesignals));
for i = 1:numel(rawplatesignals)/2
    l = l_S(:,i); %position of ith accelerometer in S
    A(2*i-1,:) = [-sin(th(i)), cos(th(i)), 0, -l(3)*cos(th(i)), -l(3)*sin(th(i)), r];
    A(2*i,:) = [0, 0, 1, l(2), -l(1), 0];
end