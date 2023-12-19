%===== This function creates our Group4 events for each animal====%

function[Group4BehaviourType, Group4BehaviourData] = Group4Behaviour(results_All_BehavType, results_All)
n = 1;
    for i = 1:size(results_All_BehavType,1) % for each row
        if strcmp(results_All_BehavType{i},'Group4') == 1 % if the behaviour is Group4
            Group4BehaviourType{n}= 'Group4';
            Group4BehaviourData(n, :) = results_All(i, [1 2 4 3 5 6]); % pull the data from this, IN THIS ORDER!!! (THIS IS INTENTIONAL!!)
            n=n+1;
        end
    end

    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Group4') == 1
            Group4BehaviourType{n}= 'Group4';
            Group4BehaviourData(n, :) = results_All(i, [1 2 5 3 4 6]); % pull the data from this, IN THIS ORDER!!! (THIS IS INTENTIONAL!!)
            n=n+1;
        end
    end

    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Group4') == 1
            Group4BehaviourType{n}= 'Group4';
            Group4BehaviourData(n, :) = results_All(i, [1 2 6 3 4 5]); % pull the data from this, IN THIS ORDER!!! (THIS IS INTENTIONAL!!)
            n=n+1;
        end
    end

Group4BehaviourType = Group4BehaviourType';
end

% Justification for the process in this code:

% In the SQLite file, only one entry for the Group 4 behaviour is entered
% for each instance of this behaviour. Moreover it always has the format:
% IDANIMALA = 1, IDANIMALB = 2, IDANIMALC = 3, IDANIMALD = 4. Therefore, if
% we want to have an entry for each animal, we must insert more events for
% each animal. In this code, to do this we rearrange the order of the
% columns and functionally duplicate this behaviour. This makes the
% analysis of this much easier.

