%===== This function creates creates a Nest4 event for each mouse=====%

function[Nest4BehaviourType, Nest4BehaviourData] = Nest4Behaviour(results_All_BehavType, results_All)
n = 1;
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Nest4_') == 1
            Nest4BehaviourType{n}= 'Nest4';
            Nest4BehaviourData(n, :) = results_All(i, [1 2 4 3 5 6]);
            Nest4BehaviourData(n,3) = 1;
            n=n+1;
        end
    end

    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Nest4_') == 1
            Nest4BehaviourType{n}= 'Nest4';
            Nest4BehaviourData(n, :) = results_All(i, [1 2 5 3 4 6]);
            Nest4BehaviourData(n,3) = 2;
            n=n+1;
        end
    end

    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Nest4_') == 1
            Nest4BehaviourType{n}= 'Nest4';
            Nest4BehaviourData(n, :) = results_All(i, [1 2 6 3 4 5]);
            Nest4BehaviourData(n,3) = 3;
            n=n+1;
        end
    end
    
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Nest4_') == 1
            Nest4BehaviourType{n}= 'Nest4';
            Nest4BehaviourData(n, :) = results_All(i, [1 2 6 3 4 5]);
            Nest4BehaviourData(n, 3) = 4;
            n=n+1;
        end
    end

Nest4BehaviourType = Nest4BehaviourType';
end

% Justification for this script

% In the SQLite file, Nest4 behaviours are encoded as "Nest4_"  and,
% because they involve all the animals in cage, do not have any mouse
% identities (i.e. IDANIMALA - D is 0). Therefore this script takes
% instances where this behaviour occurs and computes a new behaviour "Nest
% 4" and adds an entry for every mouse for every instance of this
% behaviour, making it simpler to segregate the data for each animal.