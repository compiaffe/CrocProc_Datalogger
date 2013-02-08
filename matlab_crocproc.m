clear all
clc
close all
%Delete previous connections
delete(instrfind({'Port'},{'/dev/tty.usbserial-A900abKE*'}));
%Create a serial connection
s = serial('/dev/tty.usbserial-A900abKE8','BaudRate',9600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Open Port
fopen(s);
%Initialize the variables
Nvalues=2000; %Number of values ??we want to read
m1=zeros(1,Nvalues);
windowSize1 = 20;
i=1;
k=0;
tic;
starttime = tic;
while k<Nvalues
    %Read the serial port
    a = fscanf(s,'%f.%f')';
    m1(i)=a(1);
    %Draw the figure
    figure(1);
    subplot(2,1,1);
    plot(m1);
    xlabel('Time [# Datapoints]');ylabel('Pressure [Pa]');
    axis([0 Nvalues 94000 105000])
    
    subplot(2,1,2);
    plot(filter(ones(1,windowSize1)/windowSize1,1,m1));
    xlabel('Time - Running average windowsize 20');ylabel('[Pa]');
    
    axis([0 Nvalues 94000 105000])
    
    %Increment the counter
    i=i+1;
    k=k+1;
end
fclose(s);
elapsed_time = toc(starttime);
fprintf('We read %d datapoints in %f seconds\n',Nvalues, elapsed_time);
fprintf('The update rate is thus %f Hz\n',Nvalues/elapsed_time);

