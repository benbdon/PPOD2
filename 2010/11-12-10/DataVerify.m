clc
clear all
close all

M = load('C:\Documents and Settings\LIMS\Desktop\PPOD Tracking\Data\PPODDataNew.txt');

mperin = 2.54/100;
%ROI, X, Y, TIME, FOUND, IMG_NBR
ROI = M(:,1);
X = M(:,2)*mperin;
Y = M(:,3)*mperin;
T = M(:,4)-M(1,4);
found = M(:,5);

j = 1;
x1 = NaN;
y1 = NaN;
t1 = NaN;
x2 = NaN;
y2 = NaN;
t2 = NaN;
for i = 1:length(found)-1
    if ROI(i) == 0 && found(i) == 1 && found(i+1) == 1
        x1(j) = X(i);
        y1(j) = Y(i);
        t1(j) = T(i);
        
        if ROI(i+1) == 1
            x2(j) = X(i+1);
            y2(j) = Y(i+1);
            t2(j) = T(i+1);
        end
        
        j = j + 1;
    end
end

ONEDOT = 0;
if isnan(x2)
    ONEDOT = 1;
end

if ~ONEDOT
    sx = mean([x1;x2]);
    sy = mean([y1;y2]);
    dsx = x2-x1;
    dsy = y2-y1;
    th = atan2(dsy,dsx);
    th_degrees = th*180/pi;
end

figure(1);
hold on
ind = 1:length(t1);
plot(ind,t1) %part 1 time vs index
plot(ind,t2,'r') %part 2 time vs index
plot(ind,.1*ind,'k') %expected part 1 time vs index

figure(2)
hold on
plot(t1,x1)
plot(t2,x2)
xlabel('t')
ylabel('x')
xt_axis = axis;

figure(3)
hold on
plot(t1,y1)
plot(t2,y2)
xlabel('t')
ylabel('y')

figure(4)
hold on
plot(x1,y1,'b')
plot(x2,y2,'r')
plot(x1(1),y1(1),'ob')
plot(x2(1),y2(1),'or')
if ~ONEDOT
    plot(sx,sy,'k')
    
    plot(sx(1),sy(1),'ok')
    
    for i = 1:50:length(t1)
        V1 = [x1(i), y1(i)];
        V2 = [x1(i) + hypot(dsx(1),dsy(1))*cos(th(i)), y1(i) + hypot(dsx(1),dsy(1))*sin(th(i))];
        
        plot([V1(1) V2(1)],[V1(2) V2(2)],'k')
        plot([x1(i) x2(i)],[y1(i) y2(i)],'g')
    end
    
    legend('dot1','dot2','cm')
end
xlabel('x')
ylabel('y')
axis equal

if ~ONEDOT
    figure(5)
    l = hypot(dsx,dsy);
    plot(t1,l)
end
