clear all
clc
close all
%Delete previous connections
delete(instrfind({'Port'},{'/dev/tty.usbserial-A900abKE'}));
%Create a serial connection
s = serial('/dev/tty.usbserial-A900abKE','BaudRate',115200,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Open Port
fopen(s);
%Initialize the variables
Nvalues=2000; %Number of values ??we want to read
m1=zeros(1,Nvalues);
windowSize1 = 30;
i=1;
k=0;
tic;
starttime = tic;
while k<Nvalues
    %Read the serial port
    a = fscanf(s,'%f.%f')';
    if a(1) <= 110000
        m1(i)=a(1);
    else
        m1(i) = m1(i-1);%removes impossible serial reads
    end
    
    figure(1);
    subplot(4,1,1); %plot the raw input
    plot(m1);
    xlabel('Time [# Datapoints]');ylabel('Pressure [Pa]');
    %axis([0 Nvalues 94000 105000])
    axis([0 Nvalues min(m1)-200 max(m1)+200]);
    
    if i > windowSize1 %plot the averaged (low passed values)
        
        subplot(4,1,2);
        f1 = filter(ones(1,windowSize1)/windowSize1,1,m1);
        plot(f1);
        xlabel('Time - Running average windowsize 30');ylabel('[Pa]');
        %axis([0 Nvalues 94000 105000])
        axis([0 Nvalues min(m1)-200 max(m1)+200]);
        
        if i > ((windowSize1*2) +1)
            subplot(4,1,3);
            f2(i) = filter(ones(1,windowSize1)/windowSize1,1,(f1(i)-f1(i-1)));
            plot(f2);
            xlabel('Time - Averaged derivative of above');ylabel('[Pa]');
            axis([0 Nvalues -5 5]);
        end
    end
    
    %Increment the counter
    i=i+1;
    k=k+1;
end
fclose(s);
delete(s);
elapsed_time = toc(starttime);
fprintf('We read %d datapoints in %f seconds\n',Nvalues, elapsed_time);
fprintf('The update rate is thus %f Hz\n',Nvalues/elapsed_time);
%axis([0 Nvalues min(m1)-200 max(m1)+200]);

