clear all
clc
close all
%Delete previous connections
%delete(instrfind({'Port'},{'/dev/tty.usbserial-A900abKE'}));
%Create a serial connection
s = serial('/dev/tty.usbserial-A900abKE','BaudRate',115200,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Open Port
fopen(s);
%Initialize the variables
Nvalues=2000; %Number of values ??we want to read
m1=zeros(1,Nvalues);

i=1;
k=0;
tic;
starttime = tic;
figure(1);
plot(m1);
xlabel('Time [# Datapoints]');
ylabel('Pressure [Pa]');
axis([0 Nvalues -50 50]);

while k<Nvalues
    %Read the serial port
    m1 = fgetl(s);
    
    
    %subplot(4,1,1); %plot the raw input
    %plot(m1);
    %axis([0 Nvalues 94000 105000])
    
    %     i=i+1;
    %   k=k+1;
end
fclose(s);
delete(s);
elapsed_time = toc(starttime);
fprintf('We read %d datapoints in %f seconds\n',Nvalues, elapsed_time);
fprintf('The update rate is thus %f Hz\n',Nvalues/elapsed_time);
%axis([0 Nvalues min(m1)-200 max(m1)+200]);

