% PPOD_TCP_IP_Test - this is a simple piece of code that decides to read
% and write based on timing (rather than bytes available which will block
% code execution and throw warnings

t = tcpip('0.0.0.0', 27015, 'NetworkRole', 'Server');
set(t,'InputBufferSize',20);
socket.Timeout = 30; %number of seconds to wait to complete a read/write
fopen(t); %this is blocking. Waiting for client connection before next line
disp("Neat. We connected");

%test 1
char(fread(t,[1,19])) %should be nineteen to just fit an E size
disp('1')
disp('2')
disp('3')
pause(10);
fwrite(t,'Done');

%test 2
char(fread(t,[1,19]))
pause(10);
fwrite(t,'Done');

%test 3
char(fread(t,[1,19]))
pause(10);
fwrite(t,'Done');

fclose(t);