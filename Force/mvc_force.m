function [Max, Force] = mvc_force(Data)
% Function to arrange the force data in a column struictured way and
% acquire the max force exerted during the trial in each axis. 
% 
% Input mat file (output from bin file using the read_bin function) containing the Dragonfly forces. 
%
% 
% 
% Output:   -Max force in the 3 axes and a simple plot of it 
%           -Force in a structured way

matrix = Data.Data.FT_DATA.F;

final = 30;

for j =1:3
    channel{j} = [];
end

for j = 1:3   

    % 1 channel data point is stored every 3 points from the BIN, x,y,z
    for i = 1:size(matrix,2)
    channel{j} = [channel{j};matrix(j:3:final,i)]; 
    end
end

Force = cell2mat(channel);

figure();plot(Force);
Max = max(Force);



S = sprintf ('Data is a Force array ordered in columns %n');
disp(S)
