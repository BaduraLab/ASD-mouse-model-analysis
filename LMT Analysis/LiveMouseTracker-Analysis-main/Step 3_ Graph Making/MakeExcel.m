clc
clear
%%
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/Genotypes5/*.mat');
Behaviours = BehaviourSet('Std1');
save_dir="/mnt/Data1/Arun/LMT/LMT_data/Excels3";
if ~exist(save_dir,'dir') mkdir(save_dir); end

excelname = 'LMT_Data';
%%
Movement=Behaviours(1:6);
immobility=Behaviours(7:9);
Novel=Behaviours(10);
GroupDynamics=Behaviours(11:18);
Social=Behaviours(19:end);
%%
rawtablenames=["MouseNumber","Group",Behaviours'];
tablenames=["MouseNumber","Group","Motor score","Novel Score","Group Score","Social Score"];
TotalEventsArr=[];
TotalFramesArr=[];
nameslist=[];
groupslist=[];
for i=1:length(filenames)
    file = strcat(filenames(i).folder,"/", filenames(i).name);
    test=load(file);
    fieldname=fieldnames(test);
    fieldname=string(fieldname(1));
    names=[test.(fieldname).MouseNumber]';
    group=repmat(fieldname,size(names));
    nameslist=[nameslist;string(names)];
    groupslist=[groupslist;group];
    fieldname=string(fieldname(1));
   [~,~,~,TotalFrames,TotalEvents]=ComputeGroupData(test.(fieldname), Behaviours);
   TotalEventsArr=[TotalEventsArr;TotalEvents];
   TotalFramesArr=[TotalFramesArr;TotalFrames];
   disp(fieldname+" added")
end
%%
TotalEv=TotalEventsArr;
TotalEv(:,7:9)=-TotalEv(:,7:9);
TotalEventsArr_norm=normalize(TotalEv,1,"range");
MovementscoreEv=mean(TotalEventsArr_norm(:,1:9),2);
NovelscoreEv=mean(TotalEventsArr_norm(:,10),2);
GroupscoreEv=mean(TotalEventsArr_norm(:,11:18),2);
SocialscoreEv=mean(TotalEventsArr_norm(:,19:end),2);
save_loc=save_dir+"/"+excelname+"_Events.xlsx";
EvScoreTable=[nameslist,groupslist,MovementscoreEv,NovelscoreEv,GroupscoreEv,SocialscoreEv];
tab=array2table(EvScoreTable,variablenames=tablenames);
writetable(tab,save_loc,'Sheet',1,'Range','A1')
%%
TotalF=TotalFramesArr;
TotalF(:,7:9)=-TotalF(:,7:9);
TotalFramesArr_norm=normalize(TotalF,1,"range");
MovementscoreF=mean(TotalFramesArr_norm(:,1:9),2);
NovelscoreF=mean(TotalFramesArr_norm(:,10),2);
GroupscoreF=mean(TotalFramesArr_norm(:,11:18),2);
SocialscoreF=mean(TotalFramesArr_norm(:,19:end),2);
save_loc=save_dir+"/"+excelname+"_Frames.xlsx";
FScoreTable=[nameslist,groupslist,MovementscoreF,NovelscoreF,GroupscoreF,SocialscoreF];
tab=array2table(FScoreTable,variablenames=tablenames);
writetable(tab,save_loc,'Sheet',1,'Range','A1')

%% Write raw behaviour data to excel
TotalEventsTable=[nameslist,groupslist,TotalEventsArr];
tab=array2table(TotalEventsTable,variablenames=rawtablenames);
save_loc=save_dir+"/"+excelname+"_Events_Raw.xlsx";
writetable(tab,save_loc,'Sheet',1,'Range','A1')
TotalFramesTable=[nameslist,groupslist,TotalFramesArr];
tab=array2table(TotalFramesTable,variablenames=rawtablenames);
save_loc=save_dir+"/"+excelname+"_Frames_Raw.xlsx";
writetable(tab,save_loc,'Sheet',1,'Range','A1')

