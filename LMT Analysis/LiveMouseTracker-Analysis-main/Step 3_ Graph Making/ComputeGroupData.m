function [Mouse_meanDur, Mouse_NoEvents, Mouse_TotalFrames, Mouse_TotalFrames_PerMouse, Mouse_events_PerMouse] = ComputeDataAll(MouseData, Behaviours)
% This code function computes a number of parameters relating to our
% genotype data, as follows:
% 1. Mouse_meanDur = mean duration of each behaviour of all mice of a given
%    genotype
% 2. Mouse_NoEvents = mean number of events of each behaviour of all mice
%    of a given genotype
% 3. Mouse_TotalFrames = mean total frames of each behaviour of all mice of
%    a given genotype
% 4. Mouse_TotalFrames_PerMouse = total frames of each behaviour PER MOUSE
% 5. Mouse_events_PerMouse = number of events of each behaviour PER MOUSE

% Note: in this code we also threshold our data, such that events that last
% less than three frames long are removed!!! (But this only applies for
% behaviours that, per definition, are not one frame long (e.g. Make Group
% 3 behaviour is always a single frame event), so these are unaffected).

    %%% Compute duration of each event
    for k = 1:size(MouseData,2)                           % for each mouse do:
        for i = 1:size(MouseData(k).BehaviourData, 1)     % for each row do:
            MouseData(k).BehaviourData(i,7)      =       (MouseData(k).BehaviourData(i,2) - MouseData(k).BehaviourData(i,1))+1; % Calculate the duration of each behavioural event (and add as new column (column 7)
        end
    end

    %%% Compute total # frames spent in each behaviour
            % Makes a matrix of behaviours wherein '0' = not that behaviour and >'0' indicates the duration of that behaviour
    for k = 1 :size(MouseData,2)                               % for each mouse
        for n = 1:numel(Behaviours)                                 % for each behaviour
            idx = strcmp(MouseData(k).BehaviourType, Behaviours(n));   % make an idx (index) where the behaviour type == behaviour (logical array of 0/1)
            tmp = int64(idx);                                       % make this an integer array (easier for computation)
            tmp = tmp.*MouseData(k).BehaviourData(:,7);        % multiple all values of this tmp by the event duration (to get array of event duration)
            MouseData(k).EventDuration(:,n) = tmp;             % make a field where each column corresponds to a behaviour

            %threshold our data (for events that are not single frame events)
            for i = 1:size(MouseData(k).EventDuration, 2)      % threshold data
                if max(MouseData(k).EventDuration(:,n)) > 1    % ensures thresholding is only for behaviours that are not 1 frame events per definition
                  if MouseData(k).EventDuration(i,n) < 3       % replace all events less than 3 frames long with a 0 (THRESHOLDING)
                    MouseData(k).EventDuration(i,n) = 0;
                  end
              end
            end
        end
    end

            % Sum the total frames in each behaviour, each mouse
    for k= 1:size(MouseData,2)                                 % for each mouse
        for n= 1:numel(Behaviours)                                  % for each behaviour    
            MouseData(k).TotalFrames(n) = sum(MouseData(k).EventDuration(:,n));  % sum the total number of frames spent in each behaviour 
        end
    end

            % Put totals of each mouse into 1 matrix
    for k = 1:size(MouseData,2)
        Mouse_TotalFrames_PerMouse(k, :) = MouseData(k).TotalFrames; % put sum of animals in one matrix
    end

    Mouse_TotalFrames = mean(Mouse_TotalFrames_PerMouse,1);                    % mean to get true mean


    %%% Compute average number of events over genotype
     for k=1:size(MouseData,2)
         for n= 1:numel(Behaviours)
             Mouse_events_PerMouse(k, n) = nnz(MouseData(k).EventDuration(:,n));
         end
     end

    Mouse_NoEvents = mean(Mouse_events_PerMouse,1);

     %%% Compute mean duration of events over genotype
     for k=1:size(MouseData,2)
         for n= 1:numel(Behaviours)
             Mouse_meanDur (k,n) = mean(nonzeros(MouseData(k).EventDuration(:,n)));
         end
     end

     Mouse_meanDur = mean(Mouse_meanDur,1);

     
     %%%Group 3 behaviours are double counted in the database (b/c 1>2>3,
        %1>3>2, are both coded). So we need to divide TotalFrames and NoEvents
        %by 2. Otherwise, it will appear as though each mouse is making more of these events and spending longer 
        %in these behaviours than is the case. MeanDur does not need to be changed.
        
      for n = strcmp(Behaviours, 'Group3')
         Mouse_TotalFrames(n) = Mouse_TotalFrames(n)/2;   
         Mouse_NoEvents(n)    = Mouse_NoEvents(n)/2;
        
      end
      
end
