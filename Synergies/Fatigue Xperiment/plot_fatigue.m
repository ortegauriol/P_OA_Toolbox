function []= plot_fatigue(data)
% Function to plot the a single fatigue trial different epochs
% 
% 
%   Input: 
%           - 3D or 2D matrix coeffients*time*SynergyIndividual
% 
% 
% 
%   Dependencies: 
%           - tight_subplot from matalab central. 

n_chan = 14;
muscle_str = {'U. Trap', 'M. Trap','Infrasp.','Serr. Ant.',...
    'A.Deltoid','M.Deltoid','P.Deltoid','P.Major','L.Triceps',...
    'S.Triceps','L.Biceps','S.Biceps','Wrist Ext.','Wrist Flx.'};
n_syn=1;
sz = size(data);
if length(sz)==2
    sz = [sz 1];
end
colmap = {'Gold','GreenYellow','Teal','DarkOrange','DarkMagenta','FireBrick','Gray'};
% str = 'Channel. ';
% idx = [1:3:n_syn^2];
%Plot Synergy coefficients
% ADD SOME SOLUTION FOR THE 3D synergies but ok for now.
figure();
W_syn =data;
[ha,~] = tight_subplot(sz(3), sz(2), 0.01,[.1 .1],[.1 .03]);
for p=1:sz(2)
    axes(ha(p));
    barh(W_syn(:,p),'FaceColor',rgb(colmap(sz(3))),'EdgeColor',rgb(colmap(sz(3))));
    box off;
    ax=gca;
    ax.TickDir = 'out';
    if p ==1 
    ax.YTickLabel = muscle_str;
    ax.FontWeight = 'Bold';
    ax.XLabel.String = 'Normalized Syn Weight';
    else
        ax.YColor = 'white';  
    end
    ax.YAxis.FontSize = 28;
    ax.XLim = [0 1];
    ax.XTick = 0:0.25:1;
    ax.XAxis.FontSize = 18;
    ax.XLabel.FontWeight = 'Bold';
    if p>1       
        ax.YAxis.Visible = 'off';
        ax.YColor = 'white';
%       ax.XColor = 'white';
        ax.FontWeight = 'Bold';
    end
end
set(gcf,'color','w');
end