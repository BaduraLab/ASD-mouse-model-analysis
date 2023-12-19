%% README %%
%======================== Script 1: SQL processing ========================%

% The aim of this script is to take the LMT SQL file and process it.
% Here, we extract data from the SQLite file and organise it in an
% animal-per-animal basis, instead of its original "EVENT" basis.

% Instructions:
% 1. Insert file name into line 22 (incl. filetype)
% 2. Change function name in line 35 depending on the experimental day type
% 2.5 IF experimental day = NovelMouse, uncomment lines 47-60!!!!!!!! IF
%     experimental day =/= NovelMouse, make sure that lines 47-60 are commented
%     out!
% 3. Run sections 1 and 2 of the code (STOP BEFORE STARTING SECTION 3)
% 4. Inspect the "data" structure to assign the each animmal to the correct
%    genotype group (see Section 3 for more instructions)
% 5. Run section 3 of the code

clc
clear

%% Section 1: Load
% Insert name of SQLite file here: (incl. ".sqlite")
dbfile          =       "/home/akarim/Desktop/mnt/Data1/Arun/LMT/LMT_data/Not processed/std1/21-MI10447-5-6-9_21-03-2022_std1/21-MI10447-5-6-9_21-03-2022_std1.sqlite";

%% Section 2. Process SQL file > create "data" structure containing all mice info

% Implementation note:
    % Depending on the experimental day (std1/std2/wheel/object/mouse), you
    % must choose the corresponding function out the of the below list and
    % insert it into the code here:
    
            % 1. ProcessSQL_std       (for std1/std2)
            % 2. ProcessSQL_wheel     (for wheel)
            % 3. ProcessSQL_obj       (for object)
            % 4. ProcessSQL_mouse     (for mouse)
            
[results_All_BehavType, results_All, results_animalData] = ProcessSQL_std(dbfile); 

% The following code creates Train Behaviours, and calls the function "TrainBehaviour" to do so.
%%%Train Behaviours (Train Leader and Train Follower)
[TrainBehaviourType, TrainBehaviourData] = TrainBehaviour(results_All_BehavType, results_All);

results_All_BehavType = vertcat(results_All_BehavType, TrainBehaviourType);
results_All           = vertcat(results_All, TrainBehaviourData);


% !!!!!!!! Uncomment this code IF experimental day = NovelMouse !!!!!!!!!!!

% % Group 4 Behaviours
% [Group4BehaviourType, Group4BehaviourData] = Group4Behaviour(results_All_BehavType, results_All);
% 
% results_All_BehavType = vertcat(results_All_BehavType, Group4BehaviourType);
% results_All           = vertcat(results_All, Group4BehaviourData);
% 
% % Nest 4 Behaviours
% [Nest4BehaviourType, Nest4BehaviourData] = Nest4Behaviour(results_All_BehavType, results_All);
% 
% results_All_BehavType = vertcat(results_All_BehavType, Nest4BehaviourType);
% results_All           = vertcat(results_All, Nest4BehaviourData);


% Create a structure containing our data, wherein each field corresponds to
% a piece of data relating to the mice

for k = 1:size(results_animalData)
    data(k).Mice            =   results_animalData(k, 4);
    data(k).Genotype        =   results_animalData(k, 3);
    data(k).RFID            =   results_animalData(k, 2);
    data(k).ID              =   cell2mat(results_animalData(k,1));
    data(k).BehaviourType   =   results_All_BehavType((results_All(:,3) == k), 1);
    data(k).BehaviourData   =   results_All(results_All(:,3) == k, :);
    
    % Note: BehaviourType and BehaviourData are separate because
    % BehaviourType is a cell array, and BehaviourData is a matrix and this
    % make computations much easier
    
    % Note: BehaviourData has the following structure:
    %       StartFrame-EndFrame-Animal1-Animal2-Animal3-Animal4 (where
    %       animals are the animals involved in the behaviour)
end

%!!!!!!!!!!!!!!!!!!STOP CODE HERE!!!!!!!!!!!!!!!!!!!!!!!!!%
%% 3.  Section 3: Separate data according to genotype (INSERT BREAKPOINT HERE)

% Implementation Note:
    % Before running this next piece of code, inspect the "data" structure
    % to establish which entries of "data" correspond to which mice and
    % change the following code so that mice of the same genotype are
    % segregated into the correct variables.
    
    % Also take care to change the names of these variables to reflect the
    % identity of the data stored in it (GeneticModel_Genotype_ExperimentalDay_MouseBatch)
        % e.g. Shank2_KO_wheel_10339_1 
        % Note that naming the files in this way makes pulling the data
        % relating to different batches of mice and different experimental
        % days much easier
        
L7_TSC1_KO_mouse_12903_2 = [data(2), data(4)];
% this pulls the entries into a variables
save L7_TSC1_KO_mouse_12903_2 L7_TSC1_KO_mouse_12903_2;
% saves the variable in a file of the same name (provided you change this correctly)

L7_TSC1_WT_mouse_12903_2 = [data(1)];
save L7_TSC1_WT_mouse_12903_2 L7_TSC1_WT_mouse_12903_2;

