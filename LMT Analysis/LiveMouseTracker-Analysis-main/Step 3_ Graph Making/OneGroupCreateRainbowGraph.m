
clc
clear

%% Section 1: Choose Experimental Day Type
%This function pulls the correct behavious depending on the experimental
%day being tested and the type of behaviours being examined.

% IF you want all the behaviours relating to one experimental day set the
% text in brackets to 'Std1'/'std2'/'Wheel'/'Object'/'Mouse'.

% For information on particular behavioural sets that can be graphed,
% please check the "BehaviourSet" script which gives descriptions of
% possibilities.
Behaviours = BehaviourSet('Std1'); % Set text in brackets 

%% Section 2: Load files into MATLAB:
%the directory here should be the directory with your concatenate .mat, to
%speed up 
%files
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/Genotypes5/*.mat');

for i=1:length(filenames)
    file = strcat(filenames(i).folder,"/", filenames(i).name);
    load(file);
end
%%
% General Graph parameters
Legend = {'L7 TSC1 MUT f EE (n=11)'}; % Legend
YLabel = ('L7 TSC1 MUT m SH % rel. to L7 TSC1 WT m SH'); % Y axis label
saveloc="/mnt/Data1/Arun/Matlab Figs Final/"
save_dir="/mnt/Data1/Arun/Matlab Figs Final/"
Title  = ('Normalised total frames spent in each behaviour compared to wild type'); % Title
%%
if ~exist(save_dir,'dir') mkdir(save_dir); end
%% Section 3: Compute MeanEventDuration/ #Frames/ #Events for each of our groups
% This piece of code takes the genotpe specific data and computes parameters
% relating to these as follows:
%       XXX_TotalFrames = total frames spent in each behaviour/ genotype (i.e. mean)
%       XXX_TotalFrames_Each = total frames spent in each behaviour/ animal
% Note: the function ComputeGroupData can compute other parameters, see
% function info for details. If you wish to display MeanDuration,
% TotalEvents then change the variables below, but see ComputeData for more
% information on this, and simply use Cntrl+F to "Find and Replace" all
% "TotalFrames" with the variable you will use

%%%Test animals (e.g. Shank2_KO_SH (standard housed))

%SHANK2_KOs_SH
[~, ~, Shank2_KO_std1_f_SH_TotalFrames, Shank2_KO_std1_f_SH_TotalFrames_Each, ~]        = ComputeGroupData(Shank2_KO_std1_f_SH, Behaviours);


%%%Control animals (e.g. WT_SH (wild type standard housed))

%WTs_SHSH
[~, ~, Shank2_WT_std1_f_SH_TotalFrames, Shank2_WT_std1_f_SH_TotalFrames_Each, ~]                = ComputeGroupData(Shank2_WT_std1_f_SH,    Behaviours);


%% Section 4: Normalize our data
% This code normalises the test data, as a fold change of the control
% animal data (e.g. Shank2 mice spend 1.3x more time in behaviour X,
% relative to wild type animals)


norm_Shank2_KO_std1_f_SH_TotalFrames = Shank2_KO_std1_f_SH_TotalFrames./Shank2_WT_std1_f_SH_TotalFrames;
norm_Shank2_KO_std1_f_SH_TotalFrames_Each = Shank2_KO_std1_f_SH_TotalFrames_Each./Shank2_WT_std1_f_SH_TotalFrames;

norm_Shank2_WT_std1_f_SH_TotalFrames = Shank2_WT_std1_f_SH_TotalFrames./Shank2_WT_std1_f_SH_TotalFrames;
norm_Shank2_WT_std1_f_SH_TotalFrames_Each = Shank2_WT_std1_f_SH_TotalFrames_Each./ Shank2_WT_std1_f_SH_TotalFrames;

%% Section 5: Calculate STD/SEM of data

% Test animals (to be displayed as error bars on the graph)
norm_Shank2_KO_std1_f_SH_TotalFrames_std = std(norm_Shank2_KO_std1_f_SH_TotalFrames_Each,1);
norm_Shank2_KO_std1_f_SH_TotalFrames_sem = std(norm_Shank2_KO_std1_f_SH_TotalFrames_Each,1)/sqrt(length(norm_Shank2_KO_std1_f_SH_TotalFrames_Each));

% Control animals (to be displayed as a shaded grey region behind the bars)
norm_Shank2_WT_std1_f_SH_TotalFrames_std = std(norm_Shank2_WT_std1_f_SH_TotalFrames_Each,1);
norm_Shank2_WT_std1_f_SH_TotalFrames_sem = std(norm_Shank2_WT_std1_f_SH_TotalFrames_Each,1)/sqrt(length(norm_Shank2_WT_std1_f_SH_TotalFrames_Each));


%%% this piece of code just sets up the grey region:
greyRegion_Data_std = [norm_Shank2_WT_std1_f_SH_TotalFrames; (norm_Shank2_WT_std1_f_SH_TotalFrames+norm_Shank2_WT_std1_f_SH_TotalFrames_std); (norm_Shank2_WT_std1_f_SH_TotalFrames-norm_Shank2_WT_std1_f_SH_TotalFrames_std)];
    % first column is the norm. mean (so all 1's), then the second and
    % third column is the mean +/- the std, the region between these values
    % will be shaded in grey.
    
greyRegion_Data_sem = [norm_Shank2_WT_std1_f_SH_TotalFrames; (norm_Shank2_WT_std1_f_SH_TotalFrames+norm_Shank2_WT_std1_f_SH_TotalFrames_sem); (norm_Shank2_WT_std1_f_SH_TotalFrames-norm_Shank2_WT_std1_f_SH_TotalFrames_sem)];
    % same as above, except for SEM



%% Section 6: Graph the dataf_

% Before running this section, you must decide whether you wish to plot
    % 1. The SEM or STD of the 'control data' (to be displayed as a grey
    %    shaded region
    % 2. The SEM or STD of the 'test data' (to be displayed as error bars
    %    atop the coloured bars)
    
    
% Change the following variables according:
 greyRegion = greyRegion_Data_sem;
 errorBar_testData = norm_Shank2_KO_std1_f_SH_TotalFrames_sem;

    



h = figure;
x = 1:numel(Behaviours);
 

% Plot mean of control animals as straight black line
plot(x, greyRegion(1, :), 'k-');
hold on;
% Plot coloured bars, corresponding to mean of 'test' data, with error bars
c = hsv(numel(Behaviours));
for i = 1:numel(Behaviours)
        b = bar(x(i), norm_Shank2_KO_std1_f_SH_TotalFrames(i), 'BarWidth', 1)
        set(b, 'FaceColor', c(i,:))
        set(b, 'EdgeColor', 'none');
end
er = errorbar(norm_Shank2_KO_std1_f_SH_TotalFrames, errorBar_testData, 'k.')    %% Change here to display STD/SEM!!!
hold on;

% Plot grey shaded region
upper_line= repelem(greyRegion(2,:), 1);
lower_line = repelem(greyRegion(3,:), 1);

plot(x, upper_line, 'LineWidth', 0.5, 'Color', 'white'); %plot line that should be upper interval line
hold on;
plot(x, lower_line, 'LineWidth', 0.5 , 'Color', 'white'); %plot line that should be lower interval line
x2 = [x, fliplr(x)];
inBetween = [upper_line, fliplr(lower_line)];
f= fill(x2, inBetween, 'k');
set(f,'facealpha',.1)
set(f,'edgecolor','white');
set(gca,'TickDir','out');
hold on;


% Gen graph plotting
set(gca,'XTick',1:numel(Behaviours),'XTickLabel',Behaviours);
ax = gca;
ax.XColor = 'k'
ax.YColor = 'k'
ax.YLim= [0 3]
set(gca, 'FontName', 'Tahoma')
xtickangle(35);
title(Title);
ylabel (YLabel)
h.Position = [100 100 800 600]
savename = "Shank2_KO_std1_f_SH.svg";
saveas(gcf,saveloc+savename)


