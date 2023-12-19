
%% loading the data
clc;
tic
clear all;
 close all
toc
[datafile,datapath]=uigetfile
% distinput=string(input('Do you want to see all the distributions? (yes/no) ','s'));
% singlepoint=string(input('Does the data contain single point variables? (yes/no) ','s'));
% multipoint=string(input('Does the data contain multi-point variables? (yes/no) ','s'));
% shuffleinput=string(input('Do you want to wait a lot of time to shuffle the data? (yes/no) ','s'));
distinput="";
singlepoint="yes";
multipoint="";
shuffleinput="";

filename="random10";
folder_name="Whacky_testing";
plot_cor=false;
%% All
%% here, define your colors and shapes of different 
colorsborder=["#0000FF","#0000FF","#0000FF","#0000FF","#FF0000","#FF0000","#FF0000","#FF0000","#AA4499","#AA4499","#AA4499","#AA4499","#117733","#117733","#117733","#117733","#DDCC77","#DDCC77","#DDCC77","#DDCC77","#88CCEE","#88CCEE","#88CCEE","#88CCEE"]; %alter/add colors here
colors=["#0000FF","#FFFFFF","#0000FF","#FFFFFF","#FF0000","#FFFFFF","#FF0000","#FFFFFF",'#AA4499',"#FFFFFF",'#AA4499',"#FFFFFF",'#117733',"#FFFFFF",'#117733',"#FFFFFF",'#DDCC77',"#FFFFFF",'#DDCC77',"#FFFFFF",'#88CCEE',"#FFFFFF",'#88CCEE',"#FFFFFF"];
%colors=["#004D40",'#FFC107',"#004D40","#FFC107","#C412A7","#04D694","#C412A7","#04D694","#EDB120","#D95319","#77AC30"]; %alter/add colors here
shapes=["o","o","d","d","o","o","d","d","o","o","d","d","o","o","d","d","o","o","d","d","o","o","d","d"];
leg=["S2 Wt std F", "S2 Wt std M","S2 Wt EE F", "S2 Wt EE M", "S2 Mut std F", "S2 Mut std M", "S2 Mut EE F", "S2 Mut EE M","T1 Wt std F", "T1 Wt std M","T1 Wt EE F", "T1 Wt EE M", "T1 Mut std F", "T1 Mut std M", "T1 Mut EE F", "T1 Mut EE M","L7T1 Wt std F", "L7T1 Wt std M","L7T1 Wt EE F", "L7T1 Wt EE M","L7T1 Mut std F", "L7T1 Mut std M","L7T1 Mut EE F", "L7T1 Mut EE M"];
%%
datafile=fullfile(datapath,datafile);
if ~exist(folder_name, 'dir')  % check if the folder exists
    mkdir(folder_name);  % create the folder if it doesn't exist
end
filename=fullfile(folder_name,filename);%% extracting single values dataset
if singlepoint=='yes'
[dat, textdata] = xlsread(datafile,'one-point variables');
exptxt=textdata(1,3:end);
txtdata=textdata(2,3:end);
% sorting the data in 2 genotype groups
[~, sorting_index]=sort(dat(:,1),'ascend');
Nclass=max(dat(:,1)); % amount of Classes based on highest index number in data file
NumGenotype=hist(dat(:,1),unique(dat(:,1))); %find numer of samples of each class
Gindex=cumsum([1,NumGenotype]); %create an index set of values for the classes
Grouplabels=[];
for i=1:(length(Gindex)-1)
    Grouplabels=[Grouplabels;repmat([leg(i)],Gindex(i+1)-Gindex(i),1)];
end
numdata=dat(sorting_index,:);
% getting the IDs (and order) for the single point values
IDs_single=textdata(3:end,1);
IDs_single=IDs_single(sorting_index);
else
    numdata=[];
    txtdata="";
    nm=[];
end

%% multiple values extraction
if multipoint=="yes"
[mdat, multtextdata] = xlsread(datafile,'multi-point variables');
% sorting the data in 2 genotype groups
[mgenotypelabels, sorting_index]=sort(mdat(:,1),'ascend');
multdata=mdat(sorting_index,:);
% getting the IDs (and order) for the multiple points values
IDs_multi=multtextdata(3:end,1);
IDs_multi=IDs_multi(sorting_index);
Nclass=max(multdata(:,1)); % amount of Classes based on highest index number in data file
NumGenotype=hist(multdata(:,1),unique(multdata(:,1))); %find numer of samples of each class
Gindex=cumsum([1,NumGenotype]); %create an index set of values for the classes
indexmdata=[find(~cellfun(@isempty,multtextdata(1,:)))-1, length(multdata)+1];
multfeatdata=zeros(size(multdata,1),length(indexmdata)-1);
for num=1:(length(indexmdata)-1)
multfeatdata(:,num)=scatterfit(multdata(:, indexmdata(num):(indexmdata(num+1)-1)))';
end
multfeattxt=multtextdata(1,find(~cellfun(@isempty,multtextdata(1,:))));
else
    multfeattxt="";
    multfeatdata=[];
end
%% visualizing the datapoints  
if singlepoint=='yes'
nm=numdata(:, 2:end);
figure("Name","single point values")
[n,m]=subplotratio(length(txtdata)); %ISSUE: high amount of classes might make the data with large amount of subplots unreadable
%Proposed solution to implement: make multiple figures if num exceed a
%certain amount (using for the loop limit something like
%length(txtdata)/30)
for num=1:length(txtdata)
    
    subplot(m, n,num)
     hold on
    for i=1:Nclass
        scatter(nm((Gindex(i)):Gindex(i+1)-1,num),1:NumGenotype(i),shapes(i),'MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i)) %pick a better array of colors later
        
    end
    title(char(txtdata(num))) 
    hold off
end
end

if multipoint=='yes'
figure("Name","multipoint slope values")
[n,m]=subplotratio(length(multfeattxt));
for num=1:length(multfeattxt)
    subplot(m, n,num)
    hold on
    for i=1:Nclass
        scatter(multfeatdata((Gindex(i)):Gindex(i+1)-1,num),1:NumGenotype(i),'MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i))
    end 
    title(char(multfeattxt(num)))
    hold off
end
end
%% concating the single points with the slopes

txtdata=[txtdata,multfeattxt];
if singlepoint=='yes'
    genotypelabels=numdata(:, 1); %the genotype label
else 
    genotypelabels=multdata(:,1);
end
nmdata=[nm,multfeatdata];%the actual data
txtdata=txtdata(find(~cellfun(@isempty,txtdata)));%remove empty cell arrays in case of empty string addition
%% deleting faulty variables
delete=false;
%%
nmdata_copy=nmdata; %made a copy so, I can keep the original data and make a dataset without outliers
% the 2 classes
Classes=cell(1,Nclass);
for i=1:Nclass
Classes{i}=nmdata(Gindex(i):Gindex(i+1)-1,:);
end
% scatter(nmdata(1:15,4),1:15,"#0000FF")
% hold on
% scatter(nmdata(16:end,4),1:15,"#FF0000")
% hold off
% toc
[subrows, subcollumns]=subplotratio(length(txtdata)); % setting the ratio for subplots
[length_c,length_r]=size(nmdata);
%distributions before outlier filtering
yes='yes';

distbool=convertCharsToStrings(distinput);
if distbool==yes
    for i=1:Nclass
    classdistplot(zscore_omit_nan(Classes{i}),txtdata,i,'',subrows, subcollumns);
    end
    classdistplot(zscore_omit_nan(nmdata),txtdata,12,'',subrows, subcollumns);
end
%% Outlier plot

figure('Name','outlier plot','Position', get(0, 'Screensize')); 

%make an outlier matrix for every class (1==outlier)
outliermatrix=cell(size(Classes));
for i=1:Nclass
outliermatrix{i}=isoutlier(zscore_omit_nan(Classes{i}));
end
outliers=cat(1,outliermatrix{:}); %overall outlier matrix from the generalized method
%plotting the outliers for every class
for i=1:Nclass
subplot(Nclass,1,i)
colormap([1 1 1
    1 0 0.5]);
imagesc(outliermatrix{i});
set(gca,'XTick', 1:length(txtdata), 'xticklabel', txtdata,'YTick',1:length(genotypelabels));
xtickangle(45);
ylabel ('Mice ID');
grid on;
title('Outliers genotype '+string(i));
end

%% setting outliers to NaN generalized
for i=1:Nclass
Classes{i}(outliermatrix{i})=NaN;
end
%% calculating z-score
% zscore and interpolation with mean, to be used for outlier visualisation
% and distribution
%zscoredClass1=interpolateNaN(zscore_omit_nan(Classes(:,:,i)));
zscoredClasses=cell(size(Classes));
for i=1:Nclass
zscoredClasses{i}=interpolateNaN(zscore_omit_nan(Classes{i}));
end
zscored_outliers=cat(1,zscoredClasses{:}); %concating them

%zscore over the whole variable
zscoreddata=zscore_omit_nan(cat(1,Classes{:}));
%interpolation of the mean of the class, this is the data you will use
for i=1:Nclass
zscored_interp_data(Gindex(i):(Gindex(i+1)-1),:)=interpolateNaN(zscoreddata(Gindex(i):(Gindex(i+1)-1),:));
end
%zscore of the data with outliers, just in case you want to use the ouliers
zscore_rawdata=zscore_omit_nan(nmdata);


%t-score of the data, if one chooses to use it
tscored_data_filtered=(zscored_interp_data*10)+50;
tscored_data=(zscore_rawdata*10)+50;

%% normplots of the data without the outliers
%%distributions after outlier filtering
if distbool==yes
    for i=1:Nclass
    classdistplot(zscoredClasses{i},txtdata,i,' without outliers',subrows, subcollumns)
    end
end
%% choosing the data to do LDA on
% outlier filtering and z score
Classes=cell(1,Nclass);
for i=1:Nclass
    Classes{i}=zscored_interp_data(Gindex(i):(Gindex(i+1)-1),:);
end

%%

[txtsorted,txtI]=sort(txtdata);
if plot_cor==true
for i=1:Nclass
figure('Name','correlation matrix of class '+string(i));
heatmap(txtsorted',txtsorted',corrcoef(Classes{i}(:,txtI)));
colormap(jet);
end
%%
figure('Name','correlation matrix of the whole variable');
heatmap(txtsorted',txtsorted',(corrcoef(zscored_interp_data(:,txtI))));
colormap(jet);
%%
%get back to this: can this be cleaner with less loops?
for i=1:(Nclass-1)
    for j=(i+1):Nclass
figure('Name','correlation matrix of Class '+string(j)+' - Class '+string(i));
heatmap(txtsorted',txtsorted',corrcoef(Classes{j}(:,txtI))-corrcoef(Classes{i}(:,txtI)));
colormap(jet);
    end 
end
end
%%

% [B, within]=scattermat2(Classes)
% score=(abs(mean(Class1)-mean(Class2))')./(std(Class1)'+std(Class2)')
% meandiff=abs(mean(Class1)-mean(Class2))'
% results=[meandiff,std(Class1)',std(Class2)',score]
% figure("Name","scores of the variables")
% heatmap({'meandifference', 'std1','std2','score: (m1-m2)/(s1+s2)'},txtdata',results)
% [scoresorted,scoreI]=sort(score,'descend')
% disp('The best scores')
% scorechosen=txtdata(scoreI(1:10));

%%

toc

%% LDA
%LDA on the data
[LD1_proj,LD2_proj,Proj_Vector,LDs,sorted_eigenvalues,bartext_LDA,bardata_LDA,LDA_summary,indexorder]=LDA3(Classes,txtdata);
%%Save data to xcel
relevant_LDA=LDA_summary(:,1:7);
excel_LDAresult=[Grouplabels,relevant_LDA];
writematrix(excel_LDAresult,filename+"LDAtotal.xlsx")

%plotting the LDA
LDAplot2(LD1_proj,LD2_proj,bartext_LDA,bardata_LDA,sorted_eigenvalues,Gindex,colors,colorsborder,shapes);
legend(leg)
title('LDA plot on the whole data without outliers')
toc
LDAorder=flip(indexorder); %need to flip it, because in the barplots its ascending
%% LDA VS plot
datafull=cat(1,Classes{:});
LD3_proj=(datafull*Proj_Vector(3,:)')';
LDvsLDplot(LD1_proj,LD2_proj,LD3_proj,txtdata(LDAorder),Gindex,colors,colorsborder,shapes);
legend(leg)
%%
LDAorder=flip(indexorder); %need to flip it, because in the barplots its ascending
%% LDA on 10 features

n_LDA=10; % 10D LDA
if length(LDAorder)<=n_LDA
    n_LDA=length(LDAorder)
end
LDA10order=LDAorder(1:n_LDA); % 10 best variables
Classes10=cell(size(Classes));
for i=1:Nclass
    Classes10{i}=Classes{i}(:,LDA10order);
end
LD10_text=txtdata(LDA10order);  %text data of thr 10 best variables

[LD1_proj10,LD2_proj10,Proj_Vector10,D10,sorted_D10,bartext_LDA10,bardata_LDA10,LDA_sumary10,indexorder10]=LDA3(Classes10,LD10_text);

LDAplot2(LD1_proj10,LD2_proj10,bartext_LDA10,bardata_LDA10,sorted_D10,Gindex,colors,colorsborder,shapes);
legend(leg)
title('LDA plot on '+string(n_LDA)+' best components')

toc
%% LDA 10 VS plot
LDA_txt={'LD1','LD2','LD3'};
data10=cat(1,Classes10{:});
LD3_proj10=(data10*Proj_Vector10(3,:)')';
LDvsLDplot(LD1_proj10,LD2_proj10,LD3_proj10,LDA_txt,Gindex,colors,colorsborder,shapes);
title('LDA plot on only the 10 best components')
legend(leg)
%% LDA 3 features

%LDAorder=flip(indexorder);
%n_LDA3=3; %3 dimensional LDA
%LDA3order=LDAorder(1:n_LDA3); % 3 best variables
%Classes3=cell(size(Classes));
%for i=1:Nclass
%    Classes3{i}=Classes{i}(:,LDA3order);
%end
%LD123_text=txtdata(LDA3order); %text data of thr 3 best variables

%[LD1_proj3,LD2_proj3,Proj_Vector3,D3,sorted_D3,bartext_LDA3,bardata_LDA3,LDA_sumary3,~]=LDA3(Classes3,LD123_text);

%LDAplot2(LD1_proj3,LD2_proj3,bartext_LDA3,bardata_LDA3,sorted_D3,Gindex,colors,shapes);
%legend(leg)
%title('LDA plot on only the 3 best components')
%% plotting the 3 most weighting components vs eachother
%data123=cat(1,Classes3{:});
%LDvsLDplot(data123(:,1),data123(:,2),data123(:,3),LD123_text,Gindex,colors,shapes);
%legend(leg)
%title('The 3 best components plotted vs eachother')    
%% heatmaps contributions of features per LD
Contributions=real(LDs)./sum(abs(real(LDs)))*100;
for i=1:length(txtdata)
    LDtxt{i}=strcat('LD',num2str(i));
end

%%
% heatmap of contribution percentage of every feature per LD
figure('Name', 'heatmap features per LD')
heatmap(LDtxt(1:end),txtdata(txtI),abs(Contributions(txtI,1:end)));
colormap(hot);
title('absolute contribution percentage of every feature per LD')
%% Contribution plot LDA
% [orderedtxt,txtorder]=sort(txtdata(LDA10order));
% txtordering=LDA10order(txtorder);
% figure('Name', 'heatmap features per LD')
% heatmap(LDtxt(1:n_LDA),txtdata(txtordering),abs(Contributions(txtordering,1:n_LDA)));
% colormap(hot);
% title('absolute contribution percentage of the '+string(n_LDA)+ ' best features per LD')
%% LD1 vs LD2
% contr_eigevalues=sorted_eigenvalues/sum(abs(sorted_eigenvalues))*100;
% figure ('Position', get(0, 'Screensize'), 'color',"#FFFFFF");
% biplot(Contributions(:,1:2), 'Color', "#FF0000",'VarLabel',txtdata);
% grid on;
% % xlim ([-0.45 0.45]); ylim ([-0.45 0.45]);
% %if you want to see the outliers, you can use these limits
% %xlim ([min(coeff(:,1)) max(coeff(:,1))]); ylim ([min(coeff(:,2)) max(coeff(:,2))]);
% xlabel(sprintf('LD1 (%1.1f%%)',contr_eigevalues(1)));
% ylabel(sprintf('LD2 (%1.1f%%)',contr_eigevalues(2)));
% title({'LDA Loading Plot for all variables'});

%% LD1 vs LD2 for 10
% if length(LDAorder)>=n_LDA
% Contributions10_1=bardata_LDA10(1,:)./sum(abs(bardata_LDA10(1,:)))*100;
% Contributions10_2=bardata_LDA10(2,:)./sum(abs(bardata_LDA10(2,:)))*100;
% Contributions10=[Contributions10_1;Contributions10_2];
% contr_eigevalues=sorted_D10/sum(abs(sorted_D10))*100;
% figure ('Position', get(0, 'Screensize'), 'color',"#FFFFFF");
% %biplot(Contributions10', 'Color', "#FF0000",'VarLabel',bartext_LDA10);
% biplot(Contributions10', 'Color', "#FF0000");
% grid on;
% % xlim ([-0.45 0.45]); ylim ([-0.45 0.45]);
% %if you want to see the outliers, you can use these limits
% %xlim ([min(coeff(:,1)) max(coeff(:,1))]); ylim ([min(coeff(:,2)) max(coeff(:,2))]);
% xlabel(sprintf('LD1 (%1.1f%%)',contr_eigevalues(1)));
% ylabel(sprintf('LD2 (%1.1f%%)',contr_eigevalues(2)));
% title({'LDA Loading Plot for the 10 best variables'});
% end
%% PCA
[coeff_f,score_f,latent_f, TSQUARED, EXPLAINED] = pca(zscored_interp_data); %ALS uses least-square approx. to fill the missing data, apparently with a lot of randomness
%%
% %PCA classes
% %for first 3 PCA's
% n_LDA3=3;
% PCAclasses=cell(size(Classes));
% for i=1:Nclass
% PCAclasses{i}=score_f(Gindex(i):(Gindex(i+1)-1),1:n_LDA3);
% end
% txt_data123=txtdata(1:3);
% % 
%% for first 10 PCA's
%n_PCA= find(cumsum(EXPLAINED)>95,1,'first');
n_PCA=10;
PCA10classes=cell(size(Classes));
if size(EXPLAINED,1)<n_PLCA
for i=1:Nclass
PCA10classes{i}=score_f(Gindex(i):(Gindex(i+1)-1),1:end);
end
else
for i=1:Nclass
PCA10classes{i}=score_f(Gindex(i):(Gindex(i+1)-1),1:n_PCA);
end
end



txt_data10="PCA"+string(1:n_PCA);
PCAdata10=cat(1,PCA10classes{:});
%% PCA plot for PC1
PC1=coeff_f(:,1);
[sorted_PC1,PC1_I]=sort(abs(PC1),'ascend');
PC_txt=txtdata(PC1_I);
 figure ('Position', get(0, 'Screensize'), 'color',"#FFFFFF");
    bar(abs(100*(sorted_PC1/sum(abs(sorted_PC1)))));
    for i=1:length(sorted_PC1)
        h=bar(i,sorted_PC1(i));
        if  PC1(i)<0
            set(h,'FaceColor','k');
        else
            set(h,'FaceColor',"#FFFFFF");
        end
        hold on
    end
    hold on
    set(gca,'xticklabel',PC_txt);
    xtickangle(20)
    xticks(1:length(PC_txt));
    grid on;
    ylabel('Contribution to PC1 (%)');
    title('PCA contribution plot for PC1');
    hold off
 %% LDA on PCA first 3 PCA
% [LD1_proj_PCA,LD2_proj_PCA,Proj_VectorPCA,D,sorted_D,bartext_LDA_PCA,bardata_LDA_PCA,LDA_sumaryPCA,~]=LDA3(PCAclasses,txt_data123);
% [bartext_LDA_PCA,bardata_LDA_PCA]=LDAPCAconv(Proj_VectorPCA,coeff_f,txtdata); %converting the weights
% LDAplot2(LD1_proj_PCA,LD2_proj_PCA,bartext_LDA_PCA,bardata_LDA_PCA,sorted_D,Gindex,colors,colorsborder,shapes);
% title('LDA plot on first 3 PCA')
%% LDA on first 10 PCA
[LD1_proj_PCA10,LD2_proj_PCA10,Proj_VectorPCA10,D,sorted_D,bartext_LDA_PCA10,bardata_LDA_PCA10,LDA_summaryPCA10,~]=LDA3(PCA10classes,txt_data10);
[bartext_LDA_PCA10,bardata_LDA_PCA10,text_LD10s,value_LD10s,text_index]=LDAPCAconv(Proj_VectorPCA10,coeff_f,txtdata); %converting the weights
LDAplot2(LD1_proj_PCA10,LD2_proj_PCA10,bartext_LDA_PCA10,bardata_LDA_PCA10,sorted_D,Gindex,colors,colorsborder,shapes);
title('LDA plot on first '+string(n_PCA)+' PCA')
legend(leg)
file_name=filename+"_2DLDA";
file_format= ".emf";
saveas(gcf,file_name+file_format);

%% calculate value per experiment
if Nclass>size(text_LD10s,2)
    Nclass=size(text_LD10s,2)
end
text_LD10s=text_LD10s(:,1:Nclass-1);
value_LD10s=value_LD10s(:,1:Nclass-1);
eigenvaluesPCA10=sorted_D/sum(abs(sorted_D))*100;
eigenvaluesPCA10=eigenvaluesPCA10(1:Nclass-1)';
exp_values=value_LD10s.*eigenvaluesPCA10;
exptxtmat=string(exptxt(text_index));
exptxtmat=exptxtmat(:,1:Nclass-1);
allexp=unique(exptxtmat);
for i=1:size(allexp,1)
   expindex=exptxtmat==allexp(i) ;
   exp_contribution(i)=sum(exp_values(expindex));
   
end
[exp_contribution,exp_index]=sort(exp_contribution);
figure()
bar(exp_contribution,'black')
set(gca,'xticklabel',allexp(exp_index))
ylabel('eigenvalue contribution (%)')
title('Contribution per experiment')
file_name=filename+"_Exp_Con";
file_format= ".emf";
saveas(gcf,file_name+file_format);

%% PC1vsPC2vsPC3 plot
PCA_txt={'PC1','PC2','PC3'};
PCA10data=cat(1,PCA10classes{:});
PCA3_proj10=(PCAdata10*Proj_VectorPCA10(3,:)')';
LDvsLDplot(LD1_proj_PCA10,LD2_proj_PCA10,PCA3_proj10,PCA_txt,Gindex,colors,colorsborder,shapes);
title('LDA plot on '+string(n_PCA)+' PCA features')
legend(leg)
file_name=filename+"_3DLDA";
file_format= ".emf";
saveas(gcf,file_name+file_format);
%LDvsLDplot(score_f(:,1),score_f(:,2),score_f(:,3),PCA_txt,Gindex,colors,shapes);
%title('The LDA of the 3 PCA plotted vs eachother')
%toc
% end
%% LDA
%%Save data to xcel
if (Nclass-1)<size(LDA_summaryPCA10,2)
relevant_LDAPCA=LDA_summaryPCA10(:,1:(Nclass-1));
else
relevant_LDAPCA=LDA_summaryPCA10;

end
excel_LDAPCAresult=[Grouplabels,relevant_LDAPCA];
writematrix(excel_LDAPCAresult,filename+"PCAtotal.xlsx")
%% variance per LDA
figure()
bar(eigenvaluesPCA10,'black')
title("Eigenvalue Contribution per LD")
xtext="LD"+string(1:size(eigenvaluesPCA10,2))
set(gca,'xticklabel',xtext)
ylabel("percentage contribution eigenvalue (%)")
file_name=filename+"_LD_Con";
file_format= ".emf";
saveas(gcf,file_name+file_format);
%% pre-processing functions
%function to interpolate all NaN with the mean of the column


%calculating the z-score on data with NaN values
function zscored_outliers=zscore_omit_nan(Class)
    %z-score in matlab gives NaN for the whole column if there is one NaN
    %present, so made loop to only zscore over the non-NaN values 

    %mean and std omitting the NaN's per column
    M1 = mean(Class, 'omitnan');
    S1 = std(Class, 'omitnan');

    %own z-score omitting the NaN's
    [length_c,length_r]=size(Class);
    zscored_outliers=zeros(length_c,length_r);


    for j=1:length_r
    n=size(Class,1)-length(find(isnan(Class(:,j))));
    %         n=size(Class,1)
        for i=1:length_c
            if isnan(Class(i,j))
                zscored_outliers(i,j)=Class(i,j); % the NaN stay in the z-score matrix, because pca can handle NaN
            else
                zscored_outliers(i,j)=sqrt(n)*(Class(i,j)-M1(j))/S1(j);  %only values get z scored
            end
        end
    end


end

function Class=interpolateNaN(Class)
    [length_c,length_r]=size(Class);
    %interpolate the NaN's
    for i=1:length_c
        for j=1:length_r
            if isnan(Class(i,j))
                % maybe interpolating with the mean of the z-score?
                Class(i,j)=mean(Class(:,j), 'omitnan');
            end
        end
    end
end

% plot function to show the distribution and the outliers
function classdistplot(Class,txtdata,n,outlier,subrows, subcollumns)
% figure('Name',strcat(sprintf('normplot for Class %d',n),outlier),'Position', get(0, 'Screensize'))
% for i=1:size(Class,2)
%     subplot(subrows, subcollumns, i) ;
%     x=Class(:,i);
%     normplot(x)
%     title(char(txtdata(i)));
%     grid
% end

figure('Name',strcat(sprintf('distribution for Class %d',n),outlier),'Position', get(0, 'Screensize'))

for i=1:size(Class,2)
    subplot(subrows, subcollumns, i) ;
    x=Class(:,i);
    [xsort,I]=sort(x);
    outliers=isoutlier(xsort);
    y=linspace(-max(x),max(x),length(x));
    cm=zeros(size(Class,1),3);
    for j=1:size(Class,1)
        cm(j,:)=[0,0.5,0.5];
        if outliers(j)
            cm(j,:)=[1,0,0.5];
        else
            cm(j,:)=[0,0.5,0.5];
        end
    end
    for j=1:size(Class,1)
        scatter(xsort(j),y(j),'filled','MarkerFaceColor',cm(j,:),'MarkerEdgeColor','k')
%         text(xsort(j)-0.5,y(j)+0.2,num2str(I(j)));
        hold on
    end
    % making the normal distribution line
    r = normrnd(0,1,[1,1000]);
    plot(sort(r),linspace(-max(x),max(x),1000),'--k')
    title(char(txtdata(i)));
    grid
    hold off

end
end

% calculating the row collumn ratio for the subplots
function [subrows, subcollumns]=subplotratio(classsize)
    mvec=zeros(classsize,1);
    for i=1:classsize
        m=mod(classsize,i);
        if m==0 
            mvec(i)=i;
        end
    end
    div=nonzeros(mvec);
    dom1=div(ceil(length(div)/2));
    dom2=classsize/dom1;
    subrows=max(dom1,dom2);
    subcollumns=min(dom1,dom2);
    if subrows/subcollumns<=2
        subrows=max(dom1,dom2);
        subcollumns=min(dom1,dom2);
    else
        [subrows, subcollumns]=subplotratio(classsize+1);
    end
end

% fit the data with a slope
function slopes=scatterfit(data)
    amount=size(data,2);
    for i=1:size(data,1)
        x=linspace(0,amount,amount);
        P=polyfit(x,data(i,:),1);
        slope = P(1);
        slopes(i)=slope;
    end
end
%% main LDA functions
% main LDA function
function [LD1_proj,LD2_proj,Proj_Vector,V_sorted,sorted_D,bartext_LDA,bardata_LDA,LDA_summary,text_I_1]=LDA3(Classes,txt_data)
  
    [B, W]=scattermat2(Classes);

    LD1=pinv(W)*B;
    argument=LD1;
    [V,D]=eig(argument);
    %projection should be  made on eigenvector with the highest (real) eigenvalue
    %this means, the vectors that seperates the classes the best
    [sorted_D,I]=sort(abs(diag(D)),'descend');
    V_sorted=V(:,I);
    
    %sort also the arguments by their eigenvalue right?

    LD1=LD1(:,I);
    for i=1:size(D,1)
        cumulative_value(i)=sum(sorted_D(1:i))/sum(abs(sorted_D))*100; %cumulative value of the eigenvalues

    end

    % Get the 2 highest contributing vectors to plot (LD1 and LD2)
%     Proj_Vector=[LD1(:,1),LD1(:,2)]';
    Proj_Vector=real(V_sorted)';

    %getting the sorting indices for the bar plots
    [LD1_sort,text_I_1]=sort(abs(Proj_Vector(1,:)),'ascend');
    [LD2_sort,text_I_2]=sort(abs(Proj_Vector(2,:)),'ascend');
    [LD_sort,text_I]=sort(abs(Proj_Vector(:,:)),2,'ascend');
    LD1_sorted=Proj_Vector(1,text_I_1);
    LD2_sorted=Proj_Vector(2,text_I_2);
    LD_sorted=Proj_Vector(text_I);


    %getting the contribution percentage per feature and
    %sorting the text of the features for LD1
    contribution_value_LD1=LD1_sorted/sum(abs(LD1_sort))*100;
    sorted_features_LD1=txt_data(text_I_1);
    %getting the contribution percentage per feature and
    %sorting the text of the features for LD2
    contribution_value_LD2=LD2_sorted/sum(abs(LD2_sort))*100;
    sorted_features_LD2=txt_data(text_I_2);

    
    %formatting the text and data, to reduce the outputs
    bartext_LDA=[sorted_features_LD1;sorted_features_LD2];
    bardata_LDA=[contribution_value_LD1;contribution_value_LD2];
    

    % dot product of the projection vector and the data to map the data
    data=cat(1,Classes{:}); % to get the size of both classes combined
    for i=1:length(text_I_1)
        LDA_summary(:,i)=data*Proj_Vector(i,:)';        
    end
    
    % dot product of the projection vector and the data to map the data but
    % now with the sorted vectors
    LD1_proj=(data*Proj_Vector(1,:)')';
    LD2_proj=(data*Proj_Vector(2,:)')';
end
% main plot function for LDA

function LDAplot2(LD1_proj,LD2_proj,bartext_LDA,bardata_LDA,sorted_eigenvalues,Gindex,colors,colorsborder,shapes)
    

    eigenvalues=sorted_eigenvalues/sum(abs(sorted_eigenvalues))*100;


    %unpacking the text and data for the bar plots
    
    sorted_features_LD1=bartext_LDA(1,:);
    sorted_features_LD2=bartext_LDA(2,:);
    
    %non-absolute contributions
    magn_contr_LD1=bardata_LDA(1,:);
    magn_contr_LD2=bardata_LDA(2,:);
    
    %absolute contributions
    contribution_value_LD1=abs(magn_contr_LD1);
    contribution_value_LD2=abs(magn_contr_LD2);

    %contribution bar plot for LD2
    %setting the locus of 10 variable line
       n_10_LDA=10;
    if n_10_LDA>length(contribution_value_LD1)
    n_10_LDA=length(contribution_value_LD1);
    end
    loc_10_line=max(0,length(contribution_value_LD1)-n_10_LDA+0.5);

    %setting the locus of 3 variable line
    n_3_LDA=3;
    if n_3_LDA>length(contribution_value_LD1)
    n_3_LDA=length(contribution_value_LD1);
    end
    loc_3_line=max(0,length(contribution_value_LD1)-n_3_LDA+0.5);

    
    figure ('Name','LDA plot','Position', get(0, 'Screensize'), 'color',"#FFFFFF")
    set(gca, 'FontName', 'Myriad Pro','Fontsize',8)
    subplot(4,4,[1,5,9])
    hold on
   
    for i=1:size(contribution_value_LD2,2)
        h=barh(i,abs(magn_contr_LD2(i)));
        if  magn_contr_LD2(i)<0
            set(h,'FaceColor','k');
        else
            set(h,'FaceColor',"#FFFFFF");
        end
    end
    
    %plotting the lines and text
    plot([0 max(contribution_value_LD2)],[loc_10_line loc_10_line],'--k')
    text(max(contribution_value_LD2)-3,loc_10_line+0.4, sprintf('%1.1f%% cumulative contribution', sum(contribution_value_LD2(end-n_10_LDA+1:end))/sum(abs(contribution_value_LD2))*100),'Color','k');
    hold on
    plot([0 max(contribution_value_LD2)],[loc_3_line loc_3_line],'--k')
    text(max(contribution_value_LD2)-3,loc_3_line+0.4, sprintf('%1.1f%% cumulative contibution', sum(contribution_value_LD2(end-n_3_LDA+1:end))/sum(abs(contribution_value_LD2))*100),'Color','k');
  
    %contribution label of the whole bargraph
    hold on
    ytickangle(45)
    yticks(1:length(bartext_LDA(1,:)));
    set(gca,'yticklabel',sorted_features_LD2(:));
    grid on;
    xlabel(strcat(sprintf('Contribution to LD%s (%%);\n_ ', num2str(2)),sprintf(' Eigenvalue contributes %1.1f%%', eigenvalues(2))));
    hold off



    %contribution bar plot for LD1
    %setting the locus of 10 variable line
    n_10_LDA=10;
    if n_10_LDA>length(contribution_value_LD1)
    n_10_LDA=length(contribution_value_LD1);
    end
    loc_10_line=max(0,length(contribution_value_LD1)-n_10_LDA+0.5);

    %setting the locus of 3 variable line
    n_3_LDA=3;
    if n_3_LDA>length(contribution_value_LD1)
    n_3_LDA=length(contribution_value_LD1);
    end
    loc_3_line=max(0,length(contribution_value_LD1)-n_3_LDA+0.5);

    subplot(4,4,[14,16])
    hold on
    for i=1:size(contribution_value_LD1,2)
    h=bar(i,abs(magn_contr_LD1(i)));
    if  magn_contr_LD1(i)<0
        set(h,'FaceColor','k');
    else
        set(h,'FaceColor',"#FFFFFF");
    end
    end
    hold on
    
    %plotting the lines and text
    plot([loc_10_line loc_10_line],[0 max(contribution_value_LD1)],'--k')
    text(loc_10_line-0.1, max(contribution_value_LD1)+2, sprintf('%1.1f%% cumulative contribution', sum(contribution_value_LD1(end-n_10_LDA+1:end))/sum(abs(contribution_value_LD1))*100),'Color','black');
    hold on
    plot([loc_3_line loc_3_line],[0 max(contribution_value_LD1)],'--k')
    text(loc_3_line-0.1, max(contribution_value_LD1)+2, sprintf('%1.1f%% cumulative contribution', sum(abs(contribution_value_LD1(end-n_3_LDA+1:end)))/sum(contribution_value_LD1)*100),'Color','black');
    hold on
    set(gca,'xticklabel',sorted_features_LD1);
    xtickangle(20)
    xticks(1:length(bartext_LDA(1,:)));
    grid on;
    ylabel(strcat(sprintf('Contribution to LD%s (%%);\n_ ', num2str(2)),sprintf(' Eigenvalue contributes %1.1f%%', eigenvalues(1))));

    %LDA plot 
    subplot(4,4,[2,4,10])
    for i=1:(length(Gindex)-1)
        scatter(LD1_proj(Gindex(i):(Gindex(i+1)-1)), LD2_proj(Gindex(i):(Gindex(i+1)-1)),shapes(i),'filled','MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i))
        ax = gca;
        %putting the origin in the middle
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
        
        %these 2 only work in matlab 2020
%         xline(0,'--k');
%         yline(0,'--k');
        
        hold on
%%uncomment for the number labels
%        dx=abs(mean(LD1_proj(Class_size))/10);
%        dy=abs(mean(LD2_proj(Class_size))/10);
%        text(LD1_proj(i)-dx,LD2_proj(i)+dy,num2str(i));

%        dx=abs(mean(LD1_proj(Class_size+i))/10);
%        dy=abs(mean(LD2_proj(Class_size+i))/10);
%        text(LD1_proj(Class_size+i)-dx,LD2_proj(Class_size+i)+dy,num2str(i));
        hold on
    end
    slope=eigenvalues(1)/eigenvalues(2);

    ylimits=ylim;
    line(ylimits/slope,ylimits,'LineStyle','--')
    line(-ylimits/slope,ylimits,'LineStyle','--')
    xlabel('LD1');
    ylabel('LD2');
    hold off
    
    
end
% plotting the scores of the first 3 LD's vs eachother
function LDvsLDplot(LD1,LD2,LD3,txt_data,Gindex,colors,colorsborder,shapes)
    LD1_text=char(txt_data(1));
    LD2_text=char(txt_data(2));
    LD3_text=char(txt_data(3));
    figure ('Name','LDvsLD plot','Position', get(0, 'Screensize'), 'color',"#FFFFFF")
    title('LD1 vs LD2 vs LD3')
    subplot (3,3,1);
    for i=1:(length(Gindex)-1)
    scatter(LD1(Gindex(i):Gindex(i+1)-1), LD2(Gindex(i):Gindex(i+1)-1),shapes(i),'MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i))
    hold on
    end
    xlabel(LD1_text);
    ylabel(LD2_text);
    hold off
    
    subplot (3,3,2);
    for i=1:(length(Gindex)-1)
    scatter(LD1(Gindex(i):Gindex(i+1)-1), LD3(Gindex(i):Gindex(i+1)-1),shapes(i),'MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i))
    hold on
    end
    xlabel(LD1_text);
    ylabel(LD3_text);
    hold off
    
    subplot (3,3,3);
    for i=1:(length(Gindex)-1)
    scatter(LD2(Gindex(i):Gindex(i+1)-1), LD3(Gindex(i):Gindex(i+1)-1),shapes(i),'filled','MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i))
    hold on
    end
    xlabel(LD2_text);
    ylabel(LD3_text);
    hold off
    
    subplot(3,3,[4,5,6,7,8,9]); 
    for i=1:(length(Gindex)-1)
    scatter3(LD1(Gindex(i):Gindex(i+1)-1),LD2(Gindex(i):Gindex(i+1)-1), LD3(Gindex(i):Gindex(i+1)-1),shapes(i),'filled','MarkerFaceColor',colors(i),'MarkerEdgeColor',colorsborder(i));
    hold on
    end
    xlabel('LD1');
    ylabel('LD2');
    zlabel('LD3')
    hold off
end

%% LDA on PCA function (converting)
% converting the weights for doing LDA on PCA
function [bartext_LDA,bardata_LDA,text_LDs,value_LDs,text_I]=LDAPCAconv(Proj_Vector,coef,txt_data)
    %setting how many PC's
    coeff=coef(:,1:size(Proj_Vector,2));
    %multiply in every PC dimension the weights of that PC
    weight_matrixcell=cell(1,size(Proj_Vector,1));
    for j=1:size(Proj_Vector,1)
        weight_matrix=[];
    for i=1:size(coeff,2)
        weight_matrix(:,i)=Proj_Vector(j,i)*coeff(:,i);
    end
    weight_vector=sum(weight_matrix,2);
    weight_vecmat(:,j)=weight_vector;
    end
    [LDs_sorted,text_I]=sort(abs(weight_vecmat));
    contribution_value_LDs=LDs_sorted./sum(LDs_sorted);
    sorted_features_LDs=txt_data(text_I);
    %summing up all the PC weights per feature 
    %formatting the text and data, to reduce the outputs
    bartext_LDA=[sorted_features_LDs(:,1)';sorted_features_LDs(:,2)'];
    bardata_LDA=[contribution_value_LDs(:,1)';contribution_value_LDs(:,2)'];
    value_LDs=contribution_value_LDs;
    text_LDs=sorted_features_LDs;
end

function [B ,W]=scattermat2(Classes)
    %FUNCTION THAT CALCULATES SCATTER MATRIX:
    % Classes=dataset for all Classes
    % B:BETWEEN CLASS SCATTER MATRIX
    % W:WITHIN CLASS SCATTER MATRIX
    %
    Nclass=length(Classes); %Total amount of Classes
    Totaldata=cat(1,Classes{:});
    overallmean=mean(Totaldata);
    l=size(Totaldata,2);
    W=zeros(l);, B=W;
    for i=1:Nclass
        mci=mean(Classes{i});
        total_length=size(Classes{i},1);
        xi=Classes{i}-repmat(mci,size(Classes{i},1),1);
        W=W+(xi'*xi);     
        %B=B+(length(Classes)./total_length)*size(Classes{i},2)*(mci-overallmean)'*(mci-overallmean);
        Bi=mci-overallmean;
        B=B+total_length*Bi'*Bi;;
    end
end

