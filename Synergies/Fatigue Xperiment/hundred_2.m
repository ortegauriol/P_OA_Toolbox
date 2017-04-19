function [EMG,enveCat] = hundred_2(F)
% 
% Function transform the signals into one hundred points by averaging every
% one percent of the signal. 
% 
% Input:
%       - output of emg_init_.m function, the cell structure with the
%       envelope. 
% 
% output: 
%
X = size(F,2);
Y = size(F,1);
for p = 1:Y
    start = 1;
    for n = 1:X
        [a,b] = size(F{3,n});
        tmp = F{3,n};
        points = a*0.01;
        start=1;
        for i  = 1:100
            data{n}(i,:) = mean(tmp(start:start+(floor(points)-1),:));
            start = start + floor(points);
        end
    end
    EMG = data;
    enveCat = vertcat(EMG{1,1:end});
end