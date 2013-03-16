clear all
clc
close all
delete(instrfindall);
%Delete previous connections
%delete(instrfind({'Port'},{'/dev/tty.usbserial-A900abKE'}));
%Create a serial connection
s = serial('/dev/tty.usbserial-A900abKE','BaudRate',57600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Open Port

set(s,'DataBits', 8);
set(s,'StopBits', 1);
fopen(s);
s.ReadAsyncMode = 'continuous';


readasync(s);

%Initialize the variables
Nvalues=500; %Number of values ??we want to read
m1=zeros(1,Nvalues);

i=1;
k=1;
exit = 0;
tic;
starttime = tic;
start = -10;


s_data = zeros(Nvalues,3);
s_derv = zeros(Nvalues,3);

while start <= 0
        m1 = fscanf(s, '%d');
    if (m1 == 9999999 )
        m1 = fscanf(s, '%d');
        m1 = fscanf(s, '%d');
        m1 = fscanf(s, '%d');
        disp(start);
        start = start+1;

  
     end
end


while k<=Nvalues
    %Read the serial port
    m1 = fscanf(s, '%d');
    
    if (m1 == 9999999 )
        s_data(k,1) = fscanf(s, '%d');
        s_data(k,2) = fscanf(s, '%d');
        s_data(k,3) = fscanf(s, '%d');
        disp(k);
        
        k=k+1;
    else
        fprintf('wrong line - %d\n',m1);
        exit = exit+1;
        if exit >= 20
            break;
        end
    end
    
    
    %subplot(4,1,1); %plot the raw input
    %plot(m1);
    %axis([0 Nvalues 94000 105000])
    
    %     i=i+1;
    %   k=k+1;
end
fclose(s);
delete(s);
elapsed_time = toc(starttime);
s_min = 0;
s_max = 0;

for x = 1: Nvalues
    for y = 1:3
        if s_data(x,y) <150000 && s_data(x,y)> 50000
            if (s_data(x,y)>s_max)
                s_max = s_data(x,y);
            end
            if (s_data(x,y)<s_min)
                s_min = s_data(x,y);
            end
        end
    end
end
raw = figure();
subplot(3,2,1);
plot(s_data(:,1),'DisplayName','s_data(:,1)','YDataSource','s_data(:,1)');

subplot(3,2,3);
plot(s_data(:,2),'DisplayName','s_data(:,2)','YDataSource','s_data(:,2)');

subplot(3,2,5);
plot(s_data(:,end),'DisplayName','s_data(:,3)','YDataSource','s_data(:,3)');

xlabel('Time [# Datapoints]');
ylabel('Pressure [Pa]');
%axis([0 Nvalues s_max-200 s_max+100]);
fprintf('We read %d datapoints in %f seconds\n',Nvalues, elapsed_time);
fprintf('The update rate is thus %f Hz\n',Nvalues/elapsed_time);

for x = 2: Nvalues
    for y = 1:3
          s_derv(x,y) = s_data(x-1,y)-s_data(x,y);

 
    end
end

subplot(3,2,2);
plot(s_derv(:,1),'DisplayName','s_derv(:,1)','YDataSource','s_derv(:,1)');

subplot(3,2,4);
plot(s_derv(:,2),'DisplayName','s_derv(:,2)','YDataSource','s_derv(:,2)');

subplot(3,2,6);
plot(s_derv(:,end),'DisplayName','s_derv(:,3)','YDataSource','s_derv(:,3)');
