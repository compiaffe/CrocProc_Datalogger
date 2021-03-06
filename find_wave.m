function [ wave_time ] = find_wave( s_data, th1, th2, t)
%FIND_WAVE Summary of this function goes here
%   Detailed explanation goes here
s_derv = zeros(length(s_data),3);
wave_time = zeros(length(s_data),3);
for x = 2: length(s_data)
    for y = 2:4
        s_derv(x,y-1) = s_data(x,y)-s_data(x-1,y);
        
        
    end
end
windowSize = 30;
s_derv(:,1)= filter(ones(1,windowSize)/windowSize,1,s_derv(:,1));
s_derv(:,2)=filter(ones(1,windowSize)/windowSize,1,s_derv(:,2));
s_derv(:,3)=filter(ones(1,windowSize)/windowSize,1,s_derv(:,3));
w_pos = ones(3,1);
for y = 1:3          %look at each sensor
    x = 1;
    while x <= length(s_derv) %go throught the whole length
        
        if s_derv(x,y) >=th1 %if we saw a peak
            z = x+1;
            while ((z<=length(s_data)) && (t > (s_data(z,1)-s_data(x,1))))%search for the trough within a fixed range
                if s_derv(z,y) <= th2           %if we saw the trough
                    wave_time(w_pos(y),y) = s_data(x,1);
                    w_pos(y) = w_pos(y)+1;
                    x = z+1; %skip over the found wave

                    break;
                end
                z = z+1;
                
            end
        end
        x = x+1;
    end
    
end

end

