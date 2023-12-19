%%===== This function  defines the behaviours that we can pull out of the
%%LMT data, depending on which experimental day is being analysed=====%

function [Behaviours] = BehaviourSet(DayType)

    %Standard 1/2 Behaviours
    if strcmpi(DayType, 'Std1') || strcmpi(DayType,'Std2')
        Behaviours = ["WallJump"; "Move isolated"; "Rear isolated"; "SAP"; "Stop isolated";
                "Huddling"; "Move in contact"; "Rear in contact";  "Stop in contact";   
                "Group 3 make"; "Group 3 break"; "Contact";  "Oral-oral Contact";
                "Side by side Contact"; "Side by side Contact, opposite way"; "Group2";
                "Oral-genital Contact"; "Approach"; "Approach contact"; "Social approach";  
                "Approach rear"; "Break contact"; "Social escape"; "FollowZone Isolated"; 
                "seq oral geni - oral oral"; "seq oral oral - oral genital"; "Group3"; "TrainLeader"; "TrainFollower" ];

    %Wheel Behaviours
    elseif strcmpi(DayType, 'Wheel')
        Behaviours = ["WallJump"; "Move isolated"; "Rear isolated"; "SAP"; "Stop isolated";
                "Huddling"; "Move in contact"; "Rear in contact";  "Stop in contact";   
                "Group 3 make"; "Group 3 break"; "Contact";  "Oral-oral Contact";
                "Side by side Contact"; "Side by side Contact, opposite way"; "Group2";
                "Oral-genital Contact"; "Approach"; "Approach contact"; "Social approach";  
                "Approach rear"; "Break contact"; "Social escape"; "FollowZone Isolated";
                "seq oral geni - oral oral"; "seq oral oral - oral genital"; "Group3"; "TrainLeader"; "TrainFollower";
                "Wheel Zone" ];
            
    %Novel Object Behaviours      
    elseif strcmpi(DayType, 'Object')
        Behaviours = ["WallJump"; "Move isolated"; "Rear isolated"; "SAP"; "Stop isolated";
                "Huddling"; "Move in contact"; "Rear in contact";  "Stop in contact";   
                "Group 3 make"; "Group 3 break"; "Contact";  "Oral-oral Contact";
                "Side by side Contact"; "Side by side Contact, opposite way"; "Group2";
                "Oral-genital Contact"; "Approach"; "Approach contact"; "Social approach";  
                "Approach rear"; "Break contact"; "Social escape"; "FollowZone Isolated"; 
                "seq oral geni - oral oral"; "seq oral oral - oral genital"; "Group3";  "TrainLeader"; "TrainFollower";
                "NovObj Zone"; "NovObj Interact"; "NovObj Stop"];
    
    %Novel Mouse Behaviours
    elseif strcmpi(DayType, 'Mouse')
         Behaviours = ["WallJump"; "Move isolated"; "Rear isolated"; "SAP"; "Stop isolated";
            "Huddling"; "Move in contact"; "Rear in contact";  "Stop in contact";   
            "Group 3 make"; "Group 3 break";  "Group 4 make"; "Group 4 break"; "Nest3_"; 
            "Contact";  "Oral-oral Contact"; "Side by side Contact"; "Side by side Contact, opposite way";
            "Group2"; "Oral-genital Contact"; "Approach"; "Approach contact"; "Social approach";  
            "Approach rear"; "Break contact"; "Social escape"; "FollowZone Isolated"; 
            "seq oral geni - oral oral"; "seq oral oral - oral genital"; "Group3";  "TrainLeader"; "TrainFollower"; 
            "Group4"; "Nest4"];
        
   % Motor/ Individual animal behaviours    
    elseif strcmpi(DayType, 'Motor') % Look at motor behaviours only (solo behaviours)
          Behaviours = ["WallJump"; "Move isolated"; "Stop isolated"; "Rear isolated"; "SAP"; 
            "Huddling"];
        
   % Social behaviours (with all animals in the cage
    elseif strcmpi(DayType, 'Social') % Look at social behaviours only (groups: contact, approach, group behaviours)
         Behaviours = ["Contact"; "Move in contact"; "Rear in contact"; "Stop in contact"; 
                "Side by side Contact"; "Side by side Contact, opposite way";
                "Oral-oral Contact"; "Oral-genital Contact"; "seq oral geni - oral oral"; "seq oral oral - oral genital";
                 "Group2"; "Group3"; "FollowZone Isolated"; "TrainLeader"; "TrainFollower"
                "Approach"; "Social approach"; "Approach rear"; "Approach contact"; "Group 3 make";
                "Social escape"; "Break contact"; "Group 3 break" ];
    
    % Wheel behaviour
    elseif strcmpi(DayType, 'Wheel Only') % Wheel behaviour only
                Behaviours = ["Wheel Zone" ];
       
    % Object interaction behaviours
    elseif strcmpi(DayType, 'Object Only') % Object behaviour only
                Behaviours = ["NovObj Zone"; "NovObj Interact"; "NovObj Stop"];
    
    %Novel Mouse behaviours (to be used with the SCRIPT ______)
    elseif strcmpi(DayType, 'NM non-directional') % Behaviours involving the novel mouse
                Behaviours = ["Contact"; "Side by side Contact"; "Side by side Contact, opposite way";
                "Oral-oral Contact"; "Group2"] %; "Group4"; "Nest4"];
    
    elseif strcmpi(DayType, 'NM Directional Dyadic') % Behaviours involving the novel mouse
                Behaviours = ["Oral-genital Contact"; "seq oral geni - oral oral"; "seq oral oral - oral genital";
                "Approach"; "Approach contact"; "Social approach"; 
                "Approach rear"; "Break contact"; "Social escape"; "FollowZone Isolated"];
    
    elseif strcmpi(DayType, 'NM Triadic') % Behaviours involving the novel mouse
                Behaviours = ["Group3"];
    
    elseif strcmpi(DayType, 'NM Quadratic') % Behaviours involving the novel mouse
                Behaviours = ["Group4"];
    
    % Novel Mouse Behaviours            
    elseif strcmpi(DayType, 'Novel Mouse Only') % To graph novel mouse related behaviours
                Behaviours = ["Contact";  "Side by side Contact"; "Side by side Contact, opposite way";
                     "Oral-oral Contact"; "Oral-genital Contact"; "seq oral geni - oral oral"; "seq oral oral - oral genital";
                      "Group2"; "Group3"; "Group4"; "FollowZone Isolated";  "Approach"; "Social approach"; "Approach rear";
                      "Approach contact"; "Break contact"; "Social escape"; ]
   
    % Behaviours that exactly match the original LMT paper (and order!) and
    % can be used to compute rainbow plots
    elseif strcmpi (DayType, 'Elodie') % for computing the rainbow plot
        Behaviours = ["Huddling"; "WallJump"; "SAP"; "Move isolated"; "Stop isolated"; "Rear isolated"; 
                "Move in contact"; "Rear in contact"; "Contact"; "Side by side Contact"; "Side by side Contact, opposite way";
                "Oral-oral Contact"; "Oral-genital Contact"; "Group2"; "Group3"; "TrainFollower"; "FollowZone Isolated";
                "Social approach"; "Approach rear"; "Approach contact"; "Group 3 make"; 
                "Social escape"; "Break contact"; "Group 3 break"; "seq oral geni - oral oral"; "seq oral oral - oral genital";]
    
    % Behaviours for computing rainbow plot of all Motor and Social
    % behaviours
    elseif strcmpi(DayType, 'MotorSocial') % Look at social behaviours only (groups: contact, approach, group behaviours)
         Behaviours = ["WallJump"; "Move isolated"; "Stop isolated"; "Rear isolated"; "SAP"; 
            "Huddling"; "Contact"; "Move in contact"; "Rear in contact"; "Stop in contact"; 
                "Side by side Contact"; "Side by side Contact, opposite way";
                "Oral-oral Contact"; "Oral-genital Contact"; "seq oral geni - oral oral"; "seq oral oral - oral genital";
                 "Group2"; "Group3"; "FollowZone Isolated"; "TrainLeader"; "TrainFollower"
                "Approach"; "Social approach"; "Approach rear"; "Approach contact"; "Group 3 make";
                "Social escape"; "Break contact"; "Group 3 break" ];         
    end
end

