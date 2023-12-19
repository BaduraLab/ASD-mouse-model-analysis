%% README %%
%======================== Script: Making Graphs of Three Genotype norm. to another ========================%

% This code displays data relating to three datasets, normalised to another
% dataset (e.g. behaviour of Shank std, Shank ee, TSC std
% norm. to wild type standard housed mice). This code will display each 
% behaviour of the "test" genotype/group in three colours, and in the background 
% will be the "control" std/sem (whichever is specified) in the background as a 
% grey shaded region. See Amy Hassett's thesis for an example of this.

% Here the code is configured to make graphs of the Total Frames spent in 
% each behaviour. By modifying the code in Section 3, one can also 
% plot "Average Event Duration" or "Number of Events". For more info, 
% check the documentation of the "ComputeGroupData.m" function

% Instructions:
% 1. In Section 1, define the type of experimental day being analysed (and
%    this will ensure that the correct set of behaviours are computed)
% 2. Place all .mat files into a single directory. Specify that directory
%    in section two of the code. This will load all of these files into
%    the workspace.
% 3. Ensure that the rest of the variables in the code are named
%    appropriately (according to what data you would like to plot). Pay
%    particular attention to Sections 3 (which parameters to plot) and 6
%    (plotting SEM vs STD)
% 4. Run
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
Behaviours = BehaviourSet('Elodie'); % Set text in brackets 

%% Section 2: Load files into MATLAB:
direct = 'C:\Users\amyrh\Documents\AA_Masters\MATLAB_Processing\AAA_MATLAB_LMT_Processing Scripts\AA_SCRIPTS_COMPLETED\3_MATLAB_GraphMaking\Finished\';
filenames = dir('C:\Users\amyrh\Documents\AA_Masters\MATLAB_Processing\AAA_MATLAB_LMT_Processing Scripts\AA_SCRIPTS_COMPLETED\3_MATLAB_GraphMaking\Finished\*.mat');

for i=1:length(filenames)
    file = strcat(direct, filenames(i).name)
    load(file);
end

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
[~, ~, S2_KOs_std1_SH_TotalFrames, S2_KOs_std1_SH_TotalFrames_Each, ~]        = ComputeGroupData(S2_KO_std1_SH, Behaviours);

%SHANK2_KOs_EE
[~, ~, S2_KOs_std1_EE_TotalFrames, S2_KOs_std1_EE_TotalFrames_Each, ~]        = ComputeGroupData(S2_KO_std1_EE, Behaviours);

%TSC1_KOs_SH
[~, ~, T1_KOs_std1_SH_TotalFrames, T1_KOs_std1_SH_TotalFrames_Each, ~]        = ComputeGroupData(T1_KO_std1_SH, Behaviours);

%%%Control animals (e.g. WT_SH (wild type standard housed))

%WTs_SH
[~, ~, WT_std1_SH_TotalFrames, WT_std1_SH_TotalFrames_Each, ~]                = ComputeGroupData(WT_std1_SH,    Behaviours);


%% Section 4: Normalize our data
% This code normalises the test data, as a fold change of the control
% animal data (e.g. Shank2 mice spend 1.3x more time in behaviour X,
% relative to wild type animals)


norm_S2_KOs_std1_SH_TotalFrames = S2_KOs_std1_SH_TotalFrames./WT_std1_SH_TotalFrames;
norm_S2_KOs_std1_SH_TotalFrames_Each = S2_KOs_std1_SH_TotalFrames_Each./WT_std1_SH_TotalFrames;

norm_S2_KOs_std1_EE_TotalFrames = S2_KOs_std1_EE_TotalFrames./WT_std1_SH_TotalFrames;
norm_S2_KOs_std1_EE_TotalFrames_Each = S2_KOs_std1_EE_TotalFrames_Each./WT_std1_SH_TotalFrames;

norm_T1_KOs_std1_SH_TotalFrames = T1_KOs_std1_SH_TotalFrames./WT_std1_SH_TotalFrames;
norm_T1_KOs_std1_SH_TotalFrames_Each = T1_KOs_std1_SH_TotalFrames_Each./WT_std1_SH_TotalFrames;

norm_WT_std1_SH_TotalFrames = WT_std1_SH_TotalFrames./WT_std1_SH_TotalFrames;
norm_WT_std1_SH_TotalFrames_Each = WT_std1_SH_TotalFrames_Each./ WT_std1_SH_TotalFrames;

%% Section 5: Calculate STD/SEM of data

% Test animals (to be displayed as error bars on the graph)
norm_S2_KOs_std1_SH_TotalFrames_std = std(norm_S2_KOs_std1_SH_TotalFrames_Each,1);
norm_S2_KOs_std1_SH_TotalFrames_sem = std(norm_S2_KOs_std1_SH_TotalFrames_Each,1)/sqrt(length(norm_S2_KOs_std1_SH_TotalFrames_Each));

norm_S2_KOs_std1_EE_TotalFrames_std = std(norm_S2_KOs_std1_EE_TotalFrames_Each,1);
norm_S2_KOs_std1_EE_TotalFrames_sem = std(norm_S2_KOs_std1_EE_TotalFrames_Each,1)/sqrt(length(norm_S2_KOs_std1_EE_TotalFrames_Each));

norm_T1_KOs_std1_SH_TotalFrames_std = std(norm_T1_KOs_std1_SH_TotalFrames_Each,1);
norm_T1_KOs_std1_SH_TotalFrames_sem = std(norm_T1_KOs_std1_SH_TotalFrames_Each,1)/sqrt(length(norm_T1_KOs_std1_SH_TotalFrames_Each));

% Control animals (to be displayed as a shaded grey region behind the bars)
norm_WT_std1_SH_TotalFrames_std = std(norm_WT_std1_SH_TotalFrames_Each,1);
norm_WT_std1_SH_TotalFrames_sem = std(norm_WT_std1_SH_TotalFrames_Each,1)/sqrt(length(norm_WT_std1_SH_TotalFrames_Each));

%%% this piece of code just sets up the grey region:
greyRegion_Data_std = [norm_WT_std1_SH_TotalFrames; (norm_WT_std1_SH_TotalFrames+norm_WT_std1_SH_TotalFrames_std); (norm_WT_std1_SH_TotalFrames-norm_WT_std1_SH_TotalFrames_std)];
    % first column is the norm. mean (so all 1's), then the second and
    % third column is the mean +/- the std, the region between these values
    % will be shaded in grey.
    
greyRegion_Data_sem = [norm_WT_std1_SH_TotalFrames; (norm_WT_std1_SH_TotalFrames+norm_WT_std1_SH_TotalFrames_sem); (norm_WT_std1_SH_TotalFrames-norm_WT_std1_SH_TotalFrames_sem)];
    % same as above, except for SEM

%% Section 6: Graph the data

% Before running this section, you must decide whether you wish to plot
    % 1. The SEM or STD of the 'control data' (to be displayed as a grey
    %    shaded region
    % 2. The SEM or STD of the 'test data' (to be displayed as error bars
    %    atop the coloured bars)
    
    % Change this is in the graphing variables below
    
% General Graph parameters
Legend = {'Shank2 KO EE (n=3)'}; % Legend
YLabel = ('% rel. to Shank2 WT SH'); % Y axis label
Title  = ('Normalised total frames spent in each behaviour (per genotype)'); % Title

% Plot graph
GraphDataThree( Title, Legend, YLabel, greyRegion_Data_std, Behaviours, norm_S2_KOs_std1_SH_TotalFrames, norm_S2_KOs_std1_EE_TotalFrames, norm_T1_KOs_std1_SH_TotalFrames, norm_S2_KOs_std1_SH_TotalFrames_std, norm_S2_KOs_std1_EE_TotalFrames_std, norm_T1_KOs_std1_SH_TotalFrames_std )
