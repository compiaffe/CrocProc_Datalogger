clc
clear all
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

%Initialize the variables
Nvalues=300; %Number of values ??we want to read
m1=zeros(1,4);

i=1;
k=1;
exit = 0;
tic;
starttime = tic;
start = -15;
s_data = zeros(Nvalues,4);



fopen(s);
s.ReadAsyncMode = 'continuous';
readasync(s);

while start <= 0
    fscanf(s,'%d %d %d %d')';
    disp(start);
    start = start+1;
    
    
    
end


while k<=Nvalues
    %Read the serial port
    s_data(k,:) = fscanf(s, '%d %d %d %d')';
    
    %     if (m1 == 9999999 )
    %         s_data(k,2) = fscanf(s, '%d');
    %         s_data(k,3) = fscanf(s, '%d');
    %         s_data(k,4) = fscanf(s, '%d');
    %         s_data(k,1) = fscanf(s, '%d'); %save the timestamp
    % %         s_data(k,5) = fscanf(s, '%d');
    % %         s_data(k,6) = fscanf(s, '%d');
    
     disp(k);
    
    k=k+1;
    



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

plot_data( s_data );
wave = find_wave(s_data, 0.35, -0.3, 10000000 );
direction = triangulate(wave);