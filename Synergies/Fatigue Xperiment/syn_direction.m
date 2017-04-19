function [direction] = syn_direction(synergy, n_syn)
%function to determine the preferred direction of each synerrgy. 
%
%   INPUT:
%           - synergy:  Structure resultant from the global_synergy.m
%                       function. 
%           - n_syn:    Number of siggnifficant synergies from
%                       global_synergy.m
%           - direct:   
% 
%   OUTPUT:
%           - synDir:   Preffered direction of each synergy based on the
%                       activation coefficients
% 
% Created; December 09, 2016
% ortegauriol@gmail.com


%****************************************************
%                   Load data                       %
%****************************************************
K = importfile('order.csv');
Dict= loadjson('dictionary.json');

%****************************************************
%              Remove Rest Fields                   %
%****************************************************
% *if any
% This because this file is not recorded, thus the order is good again.
field = 'pos_13';
Dict = rmfield(Dict,field);
K(:, cellfun(@(x)x==13, K(1,:))) = [];


%****************************************************
%              Create Structured Data               %
%****************************************************
TA = zeros(length(K), 3); 
for n = 1:length(K)
    
   string = sprintf('Dict.pos_%d', cell2mat(K(n)));
   
   direction(n).order = cell2mat(K(n));
   direction(n).vector= eval(string);
   TA(n,:) = eval(string);
   TA(n,:) = TA(n,:)/norm(TA(n,:));
   direction(n).coeff = synergy(n_syn).H(:,n);
end


%****************************************************
%              Arrange Data to process              %
%****************************************************
vectors = zeros(26,3);
for n = 1:26
vectors(n,:) = direction(n).vector;
end
temp = vectors;


%****************************************************
%              Calculate components                 %
%****************************************************
% Calculate the individual components of the vectors for each synergy.
angle = 45;
for n = 1:size(temp,1)
for s = 1:n_syn
 
      magnitude = synergy(n_syn).H(s,n); %get coeff for each synergy at each trial
      zcount = sum(temp(n,:)==0);
      
      if zcount == 1
         if temp(n,2) ==0
             direction(n).components(s,1) = temp(n,1)* magnitude * sind(angle);
             direction(n).components(s,3) = temp(n,3)* magnitude * cosd(angle); 
             
         else
             direction(n).components(s,1) = temp(n,1)* magnitude * sind(angle);
             direction(n).components(s,2) = temp(n,2)* magnitude * cosd(angle);
             direction(n).components(s,3) = temp(n,3)* magnitude * sind(angle);
         end
         
      elseif zcount == 2
          direction(n).components(s,1) = temp(n,1)* magnitude;
          direction(n).components(s,2) = temp(n,2)* magnitude;
          direction(n).components(s,3) = temp(n,3)* magnitude;
             
      elseif zcount == 0
          direction(n).components(s,1) = temp(n,1)* magnitude * cosd(angle)* sind(angle);
          direction(n).components(s,2) = temp(n,2)* magnitude * cosd(angle)* cosd(angle);
          direction(n).components(s,3) = temp(n,3)* magnitude * sind(angle);
          
      end
      
%       A = reshape(direction(n).components(s,:),[1,3]);
%       calculated = norm(A) % needs to be equal to magnitude. (it is!)
end
end

% CALCULATE Mean/MAX DIRECTION OF SYNERGY to plot them


% Concatenate components belonging each synergy. 

tempStat = zeros(size(temp,1),3);
for s = 1:n_syn
    for n = 1:size(temp,1)
        tempStat(n,:) = direction(n).components(s,:);
    end
        Stats{1,s} = tempStat;
        tempStat = zeros(size(temp,1),3);
end

%****************************************************
%         Solve System of Equations & Mean          %
%****************************************************

for s = 1:n_syn
    %System
%     A = Stats{1,s};
    A = TA;
    B = synergy(s).H(s,:)';
    direction(s).LinearSolve = mldivide(A,B);
    %Mean
    direction(s).Mean= mean(Stats{s});
end
 
   

%****************************************************
%              Plot the scaled vectors              %
%****************************************************

% Plot vectors for each synergy of all the trials
for s = 1:n_syn
   figure();
   for t = 1:size(temp,1)
       quiver3(0, 0, 0, direction(t).components(s,1), direction(t).components(s,2), direction(t).components(s,3))
       hold on
   end

%Plot Mean Vector
   q = quiver3(0, 0, 0, direction(s).Mean(1),direction(s).Mean(2),direction(s).Mean(3));
   q.Color = 'black';
   q.LineWidth = 2;
   q.DisplayName = 'Mean'; 
   q.AutoScaleFactor = 2; %Double scale to be notorious
    hold on
% Plot Linear solve Vector
   q = quiver3(0, 0, 0, direction(s).LinearSolve(1),direction(s).LinearSolve(2),direction(s).LinearSolve(3));
   q.Color = 'red';
   q.LineWidth = 2;
   q.DisplayName = 'Mean'; 
   q.AutoScaleFactor = 2; %Double scale to be notorious
    hold on
     
%    General graph properties
   axis equal
   xlabel ('X');
   ylabel ('Y');
   zlabel ('Z');
   str = sprintf ('Synergy %d', s);
   title (str)
   set(gcf,'color','w');
   box on
end


%****************************************************
%                  Plot by Plane                    %
%****************************************************   

frontal = zeros(8,3);
sagital = zeros(8,3);
Transv  = zeros(8,3);
f= 1;
s=1;
t= 1;
for n = 1:size(temp,1)
    
    if temp(n,3)==0
        frontal(f,:) = temp(n,:);
        f = f+1; 
    end
       
end

%****************************************************
%              Get MAx Coeff activation             %
%****************************************************   
[M N]= max(synergy(n_syn).H,[],2);
arrayy = struct2cell(Dict)
for i = 1:length(N)
%     myString = sprintf('Dict.pos_%d', N(i));
%     target{i} = myString;
%     synDir{i} =  eval(myString);
    synDir{i} =  arrayy(N(i));
end


end