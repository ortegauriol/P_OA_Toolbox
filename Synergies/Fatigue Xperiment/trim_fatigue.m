function [fatigue] = trim_fatigue(EMGs,files)
%function to trim the fatigue trials, each into five segments at 
% 0-5% || 20-25% || 50-55% || 70-75% || 94-99%
%
%
%   INPUT:
%           - EMGs:     Containing a 1*1 cell, where each cell contains N columns of EMG Channels. 
%           - files:    List of .mat files to process. 
%   OUTPUT:
%           - synDir:   Preffered direction of each synergy based on the
%                       activation coefficients
% 
%   ADDITONAL FUNCTIONS:
%           
%           - tight_subplot: available online.
% 
% Created; December 09, 2016
% ortegauriol@gmail.com
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        get END trimming sample per file        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
load(files{size(files,1)})                       %Load the fatigue File.
A = log.Headers.FT_COMPLETE.send_time(1);        %Get the time when fatigue was reached.
B = log.Headers.TRIGNO_DATA.send_time;         %Time at which the trigno messages are sent.

tmp = abs(B-A);                                  %                    
[~,idx] = min(tmp);                            % Find the index of the minimal difference package
sample = idx * 27;                               % Multiply times 27, to find the sample number 
c = size(log.Data.TRIGNO_DATA.T,2)*27;           % Get the size of the last sample
sample = c - sample;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               GET INITIAL TRIM Sample          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(files{1})                       %Load the fatigue File.
try 
    A = log.Headers.FT_COMPLETE.send_time(1);        %
catch 
    A =  log.Headers.TRIGNO_DATA.send_time(2000);
end
    
B = log.Headers.TRIGNO_DATA.send_time;           %Time at which the trigno messages are sent.
tmp = abs(B-A);                                  %                    
[~,idx] = min(tmp);                            % Find the index of the minimal difference package
x = idx * 27;                               % Multiply times 27, to find the sample number 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TRIM EVERY FILE                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for aa = 1:size(EMGs,2)
data = EMGs{aa};


%****************************************************
%            REMOVE CHANNELS W/ NO DATA             %
%****************************************************

    %Get indexes first 
%     [row, column] = find(data(2,:));
    % Remove data withot channels
    i=1;
    for k=1:size(data,2)    
        if mean(data(:,k))~=0
            cwd(:,i)=data(:,k);
            i=i+1;
        end
    end
    clear data;
    data = cwd;

%Manual option
% % fig = figure(); title('Choose Init Trim'); set(gcf,'color','w');
% % ha = tight_subplot(ceil(size(data,2)/2),2,0.05,[.1 .1],[.1 .03]);
% %     for p = 1:size(data,2)
% %         axes(ha(p));
% %         plot(data(:,p))
% %         hold on    
% %     end
% % 
% %     [x,y] = ginput(1);


%****************************************************
%               TRIM FINAL SAMPLE:                  %
%****************************************************
sample = size(data,1)-sample;
data = data(1:sample(aa),:);

%****************************************************
%               TRIM INITIAL SAMPLE:                  %
%****************************************************
data = data(x:end,:);


%****************************************************
%               PLOT AFTER TRIM                     %
%****************************************************
fig = figure(); title('Choose Init Trim'); set(gcf,'color','w');
ha = tight_subplot(ceil(size(data,2)/2),2,0.05,[.1 .1],[.1 .03]);
    for p = 1:size(data,2)
        axes(ha(p));
        plot(data(:,p))
        hold on    
    end

%****************************************************
%          GET TRIM SAMPLES for 5 SEGMENTS          %
%****************************************************
 % Defenitly can be improved by strings and loops but not today!
total = size(data,1);
% data sample point to trim again. 
first  = ceil((1*total)/100);
second = ceil((6*total)/100);

third  = ceil((21*total)/100);
fourth = ceil((26*total)/100);

fifth  = ceil((46*total)/100);
sixth  = ceil((51*total)/100);

seventh= ceil((71*total)/100);
eighth = ceil((76*total)/100);

nineth = ceil((94*total)/100);
tenth  = ceil((99*total)/100);


figure(); plot(data); ax = gca;
limy = ax.YLim;

line ([first first], [limy(1) limy(2)],'LineWidth',3);
line ([second second], [limy(1) limy(2)],'LineWidth',3); 

line ([third third], [limy(1) limy(2)],'LineWidth',3); 
line ([fourth fourth], [limy(1) limy(2)],'LineWidth',3); 

line ([fifth fifth], [limy(1) limy(2)],'LineWidth',3); 
line ([sixth sixth], [limy(1) limy(2)],'LineWidth',3); 

line ([seventh seventh], [limy(1) limy(2)],'LineWidth',3); 
line ([eighth eighth], [limy(1) limy(2)],'LineWidth',3); 

line ([nineth nineth], [limy(1) limy(2)],'LineWidth',3); 
line ([tenth tenth], [limy(1) limy(2)],'LineWidth',3); 

%****************************************************
%             TRIM & STORE 5 SEGMENTS               %
%****************************************************

% fatigue(aa).Trial = aa;
fatigue{1}  = data(first:second,:);
fatigue{2}  = data(third:fourth,:);
fatigue{3}  = data(fifth:sixth,:);
fatigue{4}  = data(seventh:eighth,:);
fatigue{5}  = data(nineth:tenth,:);

clear data cwd;

end