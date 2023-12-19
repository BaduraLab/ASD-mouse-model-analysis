%% README %%
%======================== Script 2: Genotype Grouping ========================%

% After the first script, we have segregated our data such that mice of
% each genotype are separated into separate .mat files (according also to
% their batch identity and the experimental day involved). We now need to
% concatenate the data relating to a single genotype into one .mat file,
% for making graphs with this data. Note that it is super important to make
% sure that we are looking at the correct experimental day, because the
% behaviours are dependent upon this.

% Instructions:
% 1. Place all .mat files into a single directory. Specify that directory
%    in lines 29 and 30 of the code. This will load all of these files into
%    the workspace
% 2. Change the code in Section 2 of this code to place the correct animals
%    into the correct variables. These variables will be loaded into the rest
%    of the scripts to make graphs from this data. Therefore, it is essential
%    that this part is done correctly!!!! This will save the mice of each
%    genotype to a .mat variable that can be easily loaded into MATLAB to
%    make graphs
clc
clear

%% Section 1: Load files into MATLAB:
% Change these to correspond to your directory and where your files are
% located. Note: this will not change the original files, only create new
% ones
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/LMT_Data/**/std1/*.mat');

for i=1:length(filenames)
    file = filenames(i).folder +"/"+ filenames(i).name;
    load(file);
end

%% Section 2: Concatenate based on Genotype > modify this accordingly!
% Note: in the graphing code which follows this one, I have named the
% variables according to a certain structure. If you follow this structure
% that I have set out in naming your variables down below, then producing graphs corresponding
% to different conditions/ experimental days becomes a simple matter of
% using "Ctrl-F" and replacing part of the code. Trust me this is much faster!

% The syntax that I use is the following: GeneticConstruct_KO/WT_experimentalDay_HousingCond.
%   e.g. S2_KO_obj_SH

% Follow this, even if you are looking at one genotype, or only mice housing
% in a single housing type and the rest of the codes will run smoothly and
% quickly

%Note: here I and in future scripts, I abbreviated Shank2 to S2, and TSC1
%to T1. WT is wild types

%WT_std1_SH  = [Shank2_WT_std1_10159 Shank2_WT_std1_10377 Shank2_WT_std1_10382 Shank2_WT_std1_11582_11577 Shank2_WT_std1_14269 Shank2_WT_std1_15511 Shank2_WT_std1_15857 Shank2_WT_std1_17568 Shank2_WT_std1_19154 Shank2_WT_std1_19308_19442 Shank2_WT_std1_19442 Shank2_WT_std1_19666_1 Shank2_WT_std1_19666_2 Shank2_WT_std_19183];                    % make structures of all mice of each genotype
WT_std1_EE  = [Shank2_WT_std1_10378_10384_10379 Shank2_WT_std1_10677 Shank2_WT_std1_13135_2 Shank2_WT_std1_14679_146811 Shank2_WT_std1_14972 Shank2_WT_std1_15441 Shank2_WT_std2_13135_1];                        
%S2_KO_std1_SH  = [Shank2_KO_std1_10159 Shank2_KO_std1_10377 Shank2_KO_std1_10382 Shank2_KO_std1_10549_496 Shank2_KO_std1_11582_11577 Shank2_KO_std1_14269 Shank2_KO_std1_15511 Shank2_KO_std1_15857 Shank2_KO_std1_17568 Shank2_KO_std1_19154 Shank2_KO_std1_19308_19442 Shank2_KO_std1_19442 Shank2_KO_std_19183];
S2_KO_std1_EE  = [Shank2_KO_std1_10339 Shank2_KO_std1_10378_10384_10379 Shank2_KO_std1_10677 Shank2_KO_std1_13135_2 Shank2_KO_std1_13251_1 Shank2_KO_std1_14679_146811 Shank2_KO_std1_14972 Shank2_KO_std1_15441 Shank2_KO_std2_13135_1 Shank2_KO_std_11486];

%Shank2_WTs_SH  = [Shank2_WT_mouse_19183 Shank2_WT_mouse_10549_10496 TSC1_WT_mouse_19666_1 TSC1_WT_mouse_19666_2 TSC1_WT_mouse_19706_1 TSC1_WT_mouse_19706_2];                    % make structures of all mice of each genotype
%  WT_obj_SH  = [WT_obj_SH Shank2_WT_obj_14269];                        
%Shank2_KOs_SH  = [Shank2_KO_mouse_19183 Shank2_KO_mouse_10549_10496];
%  S2_KO_obj_SH  = [S2_KO_obj_SH Shank2_KO_obj_14269];

%WT_mouse_SH_mouse = [WT_mouse_SH_mouse, L7_TSC1_WT_mouse_12903_1_mouse, L7_TSC1_WT_mouse_12903_2_mouse];


% Saves the variables as .mat files which can be easily reloaded to make graphs
%save WT_std1_SH_070422 WT_std1_SH
save WT_std1_EE_070422 WT_std1_EE
%save S2_KO_std1_SH_070422 S2_KO_std1_SH
save S2_KO_std1_EE_070422 S2_KO_std1_EE

%save WT_std1_260820 WT_obj_SH
%save Shank2_KOs_SH Shank2_KOs_SH
%save S2_obj_SH_260820 S2_KO_obj_SH

%save WT_mouse_SH_mouse WT_mouse_SH_mouse