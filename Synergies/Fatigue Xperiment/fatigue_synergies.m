function [syn_fatigue, fatigue_structs] = fatigue_synergies (F)
% Function to calculate synergies from fatigue trials
% 
%   Input:
%           - F = 1*5 cells each corresponding to one fatigue trial
%           - nsyn 
%   output:
% 
for n = 1:size(F,2)
    data = F{n};
    temp = global_synergy(data);
    synergy(:,n) = temp(1).W;
    fatigue_structs(n).S = temp;
end
    syn_fatigue = synergy;
end