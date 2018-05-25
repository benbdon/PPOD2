clc
clear 
close all

dt = 1/10;
T = 1;
f = 1/T;

t = 0:dt:T-dt;

y = sin(2*pi*f*t);


dt2 = 1/21;
t2 = 0:dt2:T-dt2;

y2 = resample(y,length(t2),length(t));

hold on
plot(t,y,'o-')
plot(t2,y2,'*r-')