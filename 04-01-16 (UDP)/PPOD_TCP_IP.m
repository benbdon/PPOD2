t = tcpip('0.0.0.0', 27015, 'NetworkRole', 'Server');
set(t,'OutputBufferSize',512);
disp(t)
fopen(t); %this is blocking. Waiting for client connection before next line
a = fread(t, 14);
%disp(num2str(a,'%c'));
fwrite(t,a);
fclose(t);