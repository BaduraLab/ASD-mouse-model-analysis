%===== This function creates our TrainLeader/ TrainFollower behaviour====%

% Motivation: within the SQLite file, Train 2 behaviours, have the "leading
% mouse" as IDANIMALA and the following mouse as IDANIMALB. The same goes
% for Train3 (IDANIMAL=1st mouse, IDANIMALB = 2nd mouse, IDANIMALC = 3rd
% mouse). When we pull this data, normally we only ascribe these events to
% the the leading mouse but this script creates two new event types:
% TrainLeader (where IDANIMALA/ column 3 = leader mouse) and TrainFollower
% (where IDANIMALA/ column 3 = a follower mice)

% For graphing, we just need to graph TrainLeader and TrainFollower instead.
function[TrainBehaviourType, TrainBehaviourData] = TrainBehaviour(results_All_BehavType, results_All)
% Train Leader
    n=1;
    
    for i = 1:size(results_All_BehavType,1) % For each mouse...
        if strcmp(results_All_BehavType{i},'Train2') == 1 % if the behaviour in row i is "Train 2"
            TrainBehaviourType{n}= 'TrainLeader';         % add "Train leader" behaviour to this vector
            TrainBehaviourData(n, :) = results_All(i, :); % ... and add the corresponding behavioural data to this array
            n=n+1;                                        % n = row that we are adding to
        end
    end

    % repeat above code for Train 3:
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train3') == 1
            TrainBehaviourType{n}= 'TrainLeader';
            TrainBehaviourData(n, :) = results_All(i, :);
            n=n+1;
        end
    end

    % repeat above code for Train 4:
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train4') == 1
            TrainBehaviourType{n}= 'TrainLeader';
            TrainBehaviourData(n, :) = results_All(i, :);
            n=n+1;
        end
    end

    %Train Follower
    
    for i = 1:size(results_All_BehavType,1)                           % for each animal
        if strcmp(results_All_BehavType{i},'Train2') == 1             % if behavious is train 2
            TrainBehaviourType{n}= 'TrainFollower';                   % make a "train follower" behaviour
            TrainBehaviourData(n, :) = results_All(i,[1 2 4 3 5 6]);  % add data to this array BUT swap columns 3 and 4 (see below for why)
            n=n+1;
        end
    end

    % repeat above code for train 3, first follower
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train3') == 1
            TrainBehaviourType{n}= 'TrainFollower';
            TrainBehaviourData(n, :) = results_All(i, [1 2 4 3 5 6]);
            n=n+1;
        end
    end

    % repeat above code for train 3, second follower
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train3') == 1
            TrainBehaviourType{n}= 'TrainFollower';
            TrainBehaviourData(n, :) = results_All(i, [1 2 5 3 4 6]);
            n=n+1;
        end
    end

    % repeat above code for train 4, first follower
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train4') == 1
            TrainBehaviourType{n}= 'TrainFollower';
            TrainBehaviourData(n, :) = results_All(i, [1 2 4 3 5 6]);
            n=n+1;
        end
    end

    % repeat above code for train 4, second follower
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train4') == 1
            TrainBehaviourType{n}= 'TrainFollower';
            TrainBehaviourData(n, :) = results_All(i, [1 2 5 3 4 6]);
            n=n+1;
        end
    end

    % repeat above code for train 4, third follower
    for i = 1:size(results_All_BehavType,1)
        if strcmp(results_All_BehavType{i},'Train4') == 1
            TrainBehaviourType{n}= 'TrainFollower';
            TrainBehaviourData(n, :) = results_All(i, [1 2 6 3 4 5]);
            n=n+1;
        end
    end

    % Make a column vector
    TrainBehaviourType = TrainBehaviourType';

end


% Justification for swapping columns:
        % Column 1 and 2 are Start and End frame (respectively)
        % Columns 3-6 are the mice identities (This is the column that we
        % will use to pull data regarding each mouse0
            % 3 == Animal A == Leader mouse (in train behaviour)
            % 4 == Animal B == First follower
            % 5 == Animal C == Second follower
            % 6 == Animal D == Third follower
            
        % We pull data from this based on the identity of Animal A,
        % therefore by switching columns 4/5/6 with column 3, in the case
        % of Train follower events, we can more easily pull this data later
