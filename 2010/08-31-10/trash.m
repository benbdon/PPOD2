clc
clear
close all

T1 = 1/9;
T2 = 1/11;
w1 = 2*pi/T1;
w2 = 2*pi/T2;

dt = 1/9000;
tmax = 35*T1;
t = 0:dt:tmax;

y1 = sin(w1*t+-.23);
y2 = sin(w2*t);



figure(1)
hold on
plot(t,y1)

t_cam = T2*[0:round(tmax/T2)];
y_cam = sin(w1*t_cam);
plot(t_cam,y_cam,'r-')
plot([0 t(end)], [0 0],'k')

legend('plate','camera')