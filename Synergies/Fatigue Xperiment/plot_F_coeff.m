function  [] = plot_F_coeff(structure)

sd = [];
aver = [];

% Calculata the data for the errorbar graph
for n= 1:size(structure,2)
    data    = structure(n).S(1).H;
    sd      = [sd, std(data)];
    aver    = [aver mean(data)];
    x       = 1:1:size(structure,2);
end

% Plot the error bar 
    figure();
    e = errorbar(x,aver,sd);
    box off;

% Line properties
    e.Marker = 'o';
    e.MarkerEdgeColor = 'black';
    e.MarkerFaceColor = 'black';
    e.LineWidth = 2.5;
    e.Color = 'black';
    
% Axes Properties
    ax = gca;
    ax.TickDir = 'out';
    ax.YLabel.String = 'Synergy Coefficient Activation';
    ax.XLabel.String = 'Epoch Instance';
    ax.XAxis.FontSize = 16;
    ax.YAxis.FontSize = 16;
    ax.YLabel.FontSize = 24;
    ax.XLabel.FontSize = 24;
    ax.FontWeight = 'Bold';
    ax.YLim = ([5 20]);
    ax.XTick = 0:1:6;
    
    %Graph properties
    set(gcf,'color','w');
    hold on;
end