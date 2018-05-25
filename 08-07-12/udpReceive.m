 %% Define computer-specific variables
% Modify these values to be those of your first computer:
ipA = '169.254.247.227'; portA = 8080;
% Modify these values to be those of your second computer:
ipB = '169.254.40.245'; portB = 8081;

%% Create UDP Object
udpB = udp(ipA,portA,'LocalPort',portB);

set(udpB,'Timeout',80)
fopen(udpB);

%% Connect to UDP Object
i = 0;
x = [];
while i<100
    if (udpB.bytesavailable>0)
        b = str2num(fscanf(udpB));
        x = [x;b];
        plot(b(1),b(2),'x');
        %drawnow
        i = i+1;
        hold on;
    end
end
fclose(udpB);
%% Clean Up Machine B

delete(udpB);
clear ipA portA ipB portB udpB