clc
clear
%%
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/Genotypes5/*.mat');
Behaviours = BehaviourSet('Std1');
save_dir="/mnt/Data1/Arun/LMT/LMT_data/transition_Final";
if ~exist(save_dir,'dir') mkdir(save_dir); end
%%
num_states=length(Behaviours);

for j=1: length(filenames)
   file = strcat(filenames(j).folder,"/", filenames(j).name);
   test=load(file);
   grouping=string(fields(test));
   data=test.(grouping);
   [~,~,~,TotalFrames,TotalEvents]=ComputeGroupData(data, Behaviours);
   EventCounts=sum(TotalEvents);
   counts=table(Behaviours,EventCounts', 'VariableNames',["# syllable id","counts"]);
   writetable(counts,save_dir+"/"+grouping+"_counts.csv")

   transition_count=zeros(num_states);

   for jj=1:length(data);
   Behaviourlist=data(jj).BehaviourType;
   Behaviourorder=data(jj).BehaviourData;
   [~,index]=sort(Behaviourorder(:,1));
   Behaviourlist=Behaviourlist(index);
   Behaviourlist=cellstr(Behaviourlist);
   Behaviourlist=Behaviourlist(~strcmp(Behaviourlist, 'Train2'));
   Behaviourlist=Behaviourlist(~strcmp(Behaviourlist, 'Train3'));
   unique_states =unique(cellstr(Behaviours));
   
   state_map= containers.Map(unique_states, 1:num_states);
   
   for i=2:length(Behaviourlist)
   A=state_map(Behaviourlist{i-1});
   B=state_map(Behaviourlist{i});
   transition_count(A,B)=transition_count(A,B)+1;
   end
   end
   CountsFilter=sum(sum(transition_count-diag(diag(transition_count))));
   transition_prob = bsxfun(@rdivide,transition_count,CountsFilter);
   transition_prob=transition_prob - diag(diag(transition_prob));
   csvwrite(save_dir+"/"+grouping+"_bigram_transition_matrix.csv",transition_prob)
end
freqmat=zeros(length(Behaviours));

