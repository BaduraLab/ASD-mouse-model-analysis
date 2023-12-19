%% README %%
%======================== Script 2: Genotype Grouping ========================%

clc
clear

%% Section 0: settings
% Change these to correspond to your directory and where your files are
% located. Note: this will not change the original files, only create new
% ones
filenames = dir('/mnt/Data1/Arun/LMT/LMT_data/Not_processed/std1/**/std1/*.mat'); %the set of directories we look for files
exp_day="std1"; %experiment day of choice
other_f=["sex","housing"]; %other factors we want to examine for differences outside of genotype
excelname = 'LMT_Data'; %name of the excelfile to write to, be careful to no override existing files
%ye=cell(length(filenames),length(factors));
save_dir="/mnt/Data1/Arun/LMT/LMT_data/Not_processed/Compiling5"
if ~exist(save_dir,'dir') mkdir(save_dir); end
factors=["MouseNumber","RFID","name","exp_day","genotype",other_f]; %total list of factors, do not change!
ye=cell(1,length(factors));
%% Section 1: Load files into MATLAB:
jj=1;
for i=1:length(filenames)
    file = filenames(i).folder +"/"+ filenames(i).name;
    files=load(file);
    files=struct2cell(files);
    files=files{1};
    for j=1:length(files)
    ye(jj,3)={filenames(i).name(1:(end-4))};
    ye(jj,2)={files(j).RFID};
    ye(jj,4)={exp_day};
    ye(jj,5)={files(j).Genotype};
    ye(jj,1)={files(j).Mice};
    jj=jj+1;
    end
end
%% Section 2: generate excel
 
tab=cell2table(ye)
tab.Properties.VariableNames=factors
save_loc=save_dir+"/"+excelname+".xlsx"
writetable(tab,save_loc,'Sheet',1,'Range','A1')

