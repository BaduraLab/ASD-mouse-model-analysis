clear
clc
factororder=["genotype","exp_day","sex","housing"]
Data = readtable('/mnt/Data1/Arun/LMT/LMT_data/Not_processed/Compiling5/LMT_Data.xlsx');
[files,index]=unique(Data.name);
UniqueData=Data(index,:)
UniqueData=sortrows(UniqueData,"name")
files=sortrows(files)
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/Not_processed/std1/**/std1/*.mat')
save_dir="/mnt/Data1/Arun/LMT/LMT_data/Genotypes5" %location to store the genotypes, change to your own folder
if ~exist(save_dir,'dir') mkdir(save_dir); end
allfiles=struct2cell(filenames);
[~,uniquedex]=unique(allfiles(1,:));
filenames=filenames(uniquedex);
allfiles=struct2cell(filenames);
%usedfiles = table2cell(files);
usedfilenames=strcat(files,".mat");
fileindex=ismember(allfiles(1,:),usedfilenames);
filenames=filenames(fileindex);
T=struct2table(filenames);
filesorted=sortrows(T,"name");
filenames=table2struct(filesorted);
mousenumbers=true; %add mousenumbers to the structure
%% 
%for i=1:size(UniqueData,1)
%    RFIDindex{i}=strcmp(Data.name,UniqueData.name{i});
%end
%%
if size(factororder,2)> 1
    bestr=Data.(factororder(1));
    for i=2:(size(factororder,2))
       bestr= strcat(bestr,"_",Data.(factororder(i)));
    end
    Data(:,4:end)=[];
    Data.groups=bestr;
else
    bestr=Data.(factororder(1));
    Data(:,4:end)=[];
    Data.groups=bestr  ;
end
%% 
Allgroups=unique(Data.groups)
for i=1:length(Allgroups)
    %UniqueData.groups(UniqueData.groups==Allgroups(i))=i
    groupdata.(string(Allgroups(i)))=struct([]);
end
%%
%embarrassingly inefficient, future coder please optimize 
for i=1:length(filenames)
    file = filenames(i).folder +"/"+ filenames(i).name;
    datafile=load(file); %load in one of the files which is 
    fielddata=string(fields(datafile)); %get the name of the file
    micedata=datafile.(fielddata); %
    indexdata=strcmp(Data.name,fielddata);
    RFIDlist=Data.RFID(indexdata);
    grouplist=Data.groups((indexdata));
    if mousenumbers==true
    MouseNumberlist=Data.MouseNumber((indexdata));
    end
    for j = 1:sum(indexdata)
    RFIDs=[micedata.RFID];
    if mousenumbers==true
    micedata(strcmp(RFIDs,RFIDlist(j))).MouseNumber=MouseNumberlist(j);
    end
    groupdata.(string(grouplist(j)))=[groupdata.(string(grouplist(j))) micedata(strcmp(RFIDs,RFIDlist(j)))]  ;

    end

    %groupdata.(string(UniqueData.groups(i)))=[groupdata.(string(UniqueData.groups(i))) datafile.(fielddata)]
    %groupdata.(UniqueData.groups(i))=[groupdata.(UniqueData.groups(i)) eval(string(usedfiles(i)))]
    %grouparray{str2num(UniqueData.groups(i))}={[grouparray(str2num(UniqueData.groups(i))) load(file)]};
end
%%
%save the groups in a structure that the 
for i=1:length(Allgroups)
    assignin("base", string(Allgroups(i)),groupdata.(string(Allgroups(i))))
    savestring=save_dir+"/"+string(Allgroups(i))+".mat";
    save(savestring,string(Allgroups(i)))
end
