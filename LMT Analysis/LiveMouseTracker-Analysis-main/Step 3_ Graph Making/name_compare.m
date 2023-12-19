Data = readtable('/mnt/Data1/Arun/LMT/LMT_data/Not_processed/Compiling3/LMT_Data_newSqlite.xlsx');
Data2 = readtable('/mnt/Data1/Arun/LMT/LMT_data/Excels2/LMT_Data_Frames.xlsx');
%%
names1=Data.MouseNumber;
names2=Data2.MouseNumber;
setxor(names1,names2)