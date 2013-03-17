function [ direction ] = triangulate(time_data)
%TRIANGULATE Summary of this function goes here
%   Detailed explanation goes here
rad2deg = 180/pi
v12 = [1 0]';
v13 = [0.5 (sqrt(3)/2)]';
v23 = [-0.5 (sqrt(3)/2)]';

for x = 1: length(time_data)
    x12 = time_data(x,1)-time_data(x,2);
    x13 = time_data(x,1)-time_data(x,3);
    x23 = time_data(x,2)-time_data(x,3);
    
    vector = v12*x12+v13*x13+v23*x23;
    
    direction(x,1) = atan2(vector(2),vector(2))*rad2deg;
end
end