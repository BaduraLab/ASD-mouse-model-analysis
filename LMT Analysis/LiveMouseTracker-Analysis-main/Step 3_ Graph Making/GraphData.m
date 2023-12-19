%%======= This function produces a graph of our normalised data ======%
function GraphData( Title, Legend, YLabel, YValuesWTs, Behaviours, norm_allmice_Genotype1, norm_allmice_Genotype2, norm_allmice_Genotype1_err, norm_allmice_Genotype2_err)
% This function graphs multiple genotype data, with the WT animals
% represented as a grey region behind the animals

    % Create figure
    h=figure; %creates figure handle
    xValues= (1:numel(Behaviours)); %x axis > each behaviour
    set(gca,'XTick',1:numel(Behaviours),'XTickLabel',Behaviours);
    set(gca, 'FontName', 'Arial')
    xtickangle(45);
    hold on; 
    
    % 1. Plot the grey shaded region and black line for WT value
    plot(xValues, 1, 'k-'); % Black line
    hold on;
    
    % 2. Plot mean of each genotype as bars
    b = bar(xValues, vertcat(norm_allmice_Genotype1, norm_allmice_Genotype2), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    b(1).FaceColor = '#ff4343';
    b(2).FaceColor = '#edc211';
    drawnow;
    hold on;
    
    % 3. Add error bars
    err = errorbar(xValues+b(1).XOffset, norm_allmice_Genotype1, norm_allmice_Genotype1_err, 'k.')
    hold on
    err1 = errorbar(xValues+b(2).XOffset, norm_allmice_Genotype2, norm_allmice_Genotype2_err, 'k.')
    hold on
    
    % 4. Grey shaded region (std/sem of WT animals)
    X_pos_firstBar = xValues+b(1).XOffset
    X_pos_secondBar =xValues+b(2).XOffset
    
    xValues = reshape ([ X_pos_firstBar ; X_pos_secondBar], size(X_pos_firstBar,2), [] );
    xValues = xValues(:)';
    
    upper_line= repelem(YValuesWTs(2, :), 2); %%repeats these points so that the region behind each of the two bars has the same value (gives straight line)
    lower_line = repelem(YValuesWTs(3,:), 2);

            % Shaded region
    plot(xValues, upper_line, 'LineWidth', 0.5, 'Color', 'white');
    hold on;
    plot(xValues, lower_line, 'LineWidth', 0.5, 'Color', 'white');
    x2 = [xValues, fliplr(xValues)];
    inBetween = [upper_line, fliplr(lower_line)];
    f= fill(x2, inBetween, 'k');
    set(f,'facealpha',.1)
    set(f,'edgecolor','white');
    set(gca,'TickDir','out');
    hold on;
    
    % this code saves the graph as a jpg and epsc (vector image) as the
    % title in the folder you are working out of
    filename = Title
    saveas(h,filename, 'svg')
    
end
