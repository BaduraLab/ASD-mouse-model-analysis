function [NovMouseData] = NovelMouse(MouseData, NovMouse)
    
BehavioursA = BehaviourSet('NM non-directional');       % Set text in brackets to 'Std1'/'Std2'/'Wheel'/'Object'/'Mouse'
BehavioursB = BehaviourSet('NM Directional Dyadic');    % Set text in brackets to 'Std1'/'Std2'/'Wheel'/'Object'/'Mouse'
Behaviours1 = vertcat(BehavioursA, BehavioursB);
Behaviours2 = BehaviourSet('NM Triadic');
Behaviours3 = BehaviourSet('NM Quadratic');

    for k = 1:size(MouseData,2)
        NovMouseData(k).Mice            =   MouseData(k).Mice;
        NovMouseData(k).Genotype        =   MouseData(k).Genotype;
        NovMouseData(k).RFID            =   MouseData(k).RFID;
        NovMouseData(k).ID              =   MouseData(k).ID;
        NovMouseData(k).BehaviourType   =   [];
        NovMouseData(k).BehaviourData   =   [];
    end
    
    for k= 1:size(MouseData, 2) % for each mouse
        for n= 1:numel(Behaviours1) % for each behaviour in our list
            idx = strcmp(MouseData(k).BehaviourType, Behaviours1(n)); % give a list of values 
            idx2 = MouseData(k).BehaviourData(:,4) == NovMouse;   % make an idx (index) where the behaviour type == behaviour (logical array of 0/1
            idx3 = idx.*idx2;
            idx3 = idx3 == 1;
            temp = MouseData(k).BehaviourType(idx3);
            NovMouseData(k).BehaviourType = vertcat(NovMouseData(k).BehaviourType, temp);
            temp1 = MouseData(k).BehaviourData(idx3, :);
            NovMouseData(k).BehaviourData = vertcat(NovMouseData(k).BehaviourData, temp1);
        end
    end
     
    for k= 1:size(MouseData, 2) 
        for n= 1:numel(Behaviours2)
            idx = strcmp(MouseData(k).BehaviourType, Behaviours2(n));
            idx2 = (MouseData(k).BehaviourData(:,4) == NovMouse) | (MouseData(k).BehaviourData(:,5) == NovMouse) | (MouseData(k).BehaviourData(:,6) == NovMouse);             
            idx3 = idx.*idx2;
            idx3 = idx3 == 1;
            temp = MouseData(k).BehaviourType(idx3);
            NovMouseData(k).BehaviourType = vertcat(NovMouseData(k).BehaviourType, temp);
            temp1 = MouseData(k).BehaviourData(idx3, :);
            NovMouseData(k).BehaviourData = vertcat(NovMouseData(k).BehaviourData, temp1);
        end
    end
    
     for k= 1:size(MouseData, 2) 
        for n= 1:numel(Behaviours3)
            idx = strcmp(MouseData(k).BehaviourType, Behaviours3(n));
            temp = MouseData(k).BehaviourType(idx);
            NovMouseData(k).BehaviourType = vertcat(NovMouseData(k).BehaviourType, temp);
            temp1 = MouseData(k).BehaviourData(idx, :);
            NovMouseData(k).BehaviourData = vertcat(NovMouseData(k).BehaviourData, temp1);
        end
    end   
     
    
end
