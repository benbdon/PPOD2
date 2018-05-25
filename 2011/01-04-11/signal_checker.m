%07-16-10: this file takes a saved handles with saved signal information and plots
%the true measured acceleration at each accelerometer (in it's local A
%frame) against the acceleration at that location predicted by the least
%squares fit

clc
clear all
close all

%load handles
load([cd,'\Savedhandles\pddx_trash'],'handles')

y_raw = handles.signalinfo.y_raw;
y = handles.signalinfo.y;
t_all = handles.plateinfo.t_all;

N = length(t_all);


pidd_A_meas_all = y_raw'; %acceleration of p1 in accelerometer (L) frame

pdd_all = y(:,1:3)';
alpha_all = y(:,4:6)';

th_all = [140 160 260 280 20 40]*pi/180;
r = 0.17; %radial distance of accelerometers from origin of S
z = -.025; %height of accelerometers from origin of S

pidd_A_all = zeros(18,N);
for i = 1:6
    th = th_all(i);
    pi = [r*cos(th); r*sin(th); z];
    R = [-sin(th), 0, cos(th);
        cos(th), 0, sin(th);
        0, 1, 0];
    for j = 1:N
        pdd = pdd_all(:,j);
        alpha = alpha_all(:,j);
        pidd_A = R'*(pdd + cross(alpha,pi));
        pidd_A_all(3*i-2:3*i,j) = pidd_A;
    end
end


for i = 1:6
    figure(i)
    set(gcf,'position',[200 100 500 800])
    subplot(2,1,1)
    hold on
    plot(t_all, pidd_A_all(3*i-2,:))
    plot(t_all, pidd_A_meas_all(2*i-1,:),'r')
    xlabel('time (s)')
    ylabel('acceleration (m/s^2)')
    title(['p',num2str(i),'dd_x'])
    legend('Least Squares','Direct Measurement')
    
    subplot(2,1,2)
    hold on
    plot(t_all, pidd_A_all(3*i-1,:))
    plot(t_all, pidd_A_meas_all(2*i,:),'r')
    xlabel('time (s)')
    ylabel('acceleration (m/s^2)')
    title(['p',num2str(i),'dd_y'])
end