function [  ] = plot_data( s_data )
%PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here
% s_min = 100000;
% s_max = 0;
%
% for x = 1: size(s_data)
%     for y = 1:3
%         if s_data(x,y) <150000 && s_data(x,y)> 50000
%             if (s_data(x,y)>s_max)
%                 s_max = s_data(x,y);
%             end
%             if (s_data(x,y)<s_min)
%                 s_min = s_data(x,y);
%             end
%         end
%     end
% end
s_derv = zeros(length(s_data),3);
s_derv2 = zeros(length(s_data),3);


raw = figure();
subplot(3,2,1);
plot(s_data(:,1),s_data(:,2),'DisplayName','Sensor 1','YDataSource','s_data(:,2)');

subplot(3,2,3);
plot(s_data(:,1),s_data(:,3),'DisplayName','Sensor 2','YDataSource','s_data(:,3)');

subplot(3,2,5);
plot(s_data(:,1),s_data(:,4),'DisplayName','Sensor 3','YDataSource','s_data(:,4)');

xlabel('Time [# Datapoints]');
ylabel('Pressure [Pa]');
%axis([0 size(s_data) s_min-200 s_max+100]);


for x = 2: length(s_data)
    for y = 2:4
        s_derv(x,y-1) = s_data(x,y)-s_data(x-1,y);
        
        
    end
end
windowSize = 30;
s_derv2(:,1)= filter(ones(1,windowSize)/windowSize,1,s_derv(:,1));
s_derv2(:,2)= filter(ones(1,windowSize)/windowSize,1,s_derv(:,2));
s_derv2(:,3)= filter(ones(1,windowSize)/windowSize,1,s_derv(:,3));


s_min = 0;
s_max = 0;

for x = 1: size(s_derv2)
    for y = 1:3
        
        if (s_derv2(x,y)>s_max)
            s_max = s_derv2(x,y);
        end
        if (s_derv2(x,y)<s_min)
            s_min = s_derv2(x,y);
        end
        
    end
end

subplot(3,2,2);
plot(s_data(:,1),s_derv2(:,1),'DisplayName','s_derv2(:,1)','YDataSource','s_derv2(:,1)');
axis([s_data(1,1) s_data(length(s_data),1) s_min-1 s_max+1]);
title('Running average of 20');
subplot(3,2,4);
plot(s_data(:,1),s_derv2(:,2),'DisplayName','s_derv2(:,2)','YDataSource','s_derv2(:,2)');
axis([s_data(1,1) s_data(length(s_data),1) s_min-1 s_max+1]);

subplot(3,2,6);
plot(s_data(:,1),s_derv2(:,3),'DisplayName','s_derv2(:,3)','YDataSource','s_derv2(:,3)');
axis([s_data(1,1) s_data(length(s_data),1) s_min-1 s_max+1]);

end

