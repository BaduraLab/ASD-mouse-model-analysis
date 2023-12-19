%% README %%
%======================== Script 1.5: Extracting Novel Mouse Data ========================%

% The previous script extracted our data relating to each batch of mice and
% each experiment (e.g. Shank2_KO_mouse_14269). We now need to process the
% "Novel Mouse" related .mat files one more time in order to isolate the
% behaviours that are related to the novel mouse i.e. the behaviours
% involving each mouse and the novel mouse.

% Instructions:
% 1. Place all .mat files into a single directory. Specify that directory
%    in lines 27 and 28 of the code. This will load all of these files into
%    the workspace
% 2. Change the code in Section 2 of this code to place the correct animals
%    into the correct variables. These variables will be loaded into the rest
%    of the scripts to make graphs from this data. Therefore, it is essential
%    that this part is done correctly!!!! This will save the mice of each
%    genotype to a .mat variable that can be easily loaded into MATLAB to
%    make graphs
clc
clear

%% Section 1: Load files into MATLAB and Define behaviours:
% Change these to correspond to your directory and where your files are
% located. Note: this will not change the original files, only create new
% ones
directory = 'C:\Users\amyhassett\Documents\LMT_Analysis\MATLAB_Processing\AAA_MATLAB_LMT_Processing Scripts\AA_SCRIPTS_COMPLETED\2_Processing_SQL_MATLAB\Step 1.5 - Extracting Novel Mouse Related Data\';
filenames = dir('C:\Users\amyhassett\Documents\LMT_Analysis\MATLAB_Processing\AAA_MATLAB_LMT_Processing Scripts\AA_SCRIPTS_COMPLETED\2_Processing_SQL_MATLAB\Step 1.5 - Extracting Novel Mouse Related Data\*.mat');

for i=1:length(filenames)
    file = strcat(directory, filenames(i).name)
    load(file);
end

%% Section 2: Pull Novel Mouse Data
% This piece of script calls on the NovelMouse.m function, which pulls data
% relating to the behaviour of group of mouse with its respective novel
% mouse. The code is as follows:

%%GeneticConstruct_KO_mouse_MouseGroup_mouse = NovelMouse(GeneticConstruct_KO_mouse_MouseGroup, NovelMouse)

% Here, the variable ending _mouse, is the variable that will contain only
% the novel mouse related data. In the NovelMouse function you must put in
% 1. The variable you would like to process.
% 2. The identity of the Novel Mouse (which is between 1-4). To find this,
% you must look in the SQLite file, open the ANIMAL table and look at the
% ID column to find this.

Shank2_KO_mouse_13135_1_mouse = NovelMouse(Shank2_KO_mouse_13135_1, 1)
Shank2_WT_mouse_13135_1_mouse = NovelMouse(Shank2_WT_mouse_13135_1, 1)


%% Section 3: Save Novel Mouse Data

% Note: here I include the suffix _mouse to indicate that this is the
% "Novel Mouse" experimental day, but only the data pertaining to the
% interaction of the mice with the novel mouse

