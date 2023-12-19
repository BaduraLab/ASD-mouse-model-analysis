# -*- coding: utf-8 -*-
"""
Step 2.1 of LMT Data processing

This script is the first step

@author: amyrh
"""
import pandas as pd
import sqlite3

novMouseID = 1 
picklePath = r'C:\Users\amyrh\Documents\AA_Education\Neuroscience_MSc\MATLAB_Processing\Python\Step 2.1 Extracting Event Data from SQLite\12903_2_L7_TSC1_KO.pkl'

   
def animalData (db, df, day_type):

    con = sqlite3.connect(db)
    
    AnimalData = "SELECT ID, RFID, GENOTYPE, NAME FROM ANIMAL";
    Animals = pd.read_sql_query(AnimalData, con)
    
    if day_type == "standard" or day_type == "wheel" or day_type == "object":
        Event1 = df.loc[df['IDANIMALA'] == 1]
        Event2 = df.loc[df['IDANIMALA'] == 2]
        Event3 = df.loc[df['IDANIMALA'] == 3]
        AnimalEventData = pd.DataFrame({'idx':[0,1,2,], 'dfs':[Event1, Event2, Event3]})


    if day_type == "mouse":
        Event1 = df.loc[df['IDANIMALA'] == 1]
        Event2 = df.loc[df['IDANIMALA'] == 2]
        Event3 = df.loc[df['IDANIMALA'] == 3]
        Event4 = df.loc[df['IDANIMALA'] == 4]
        AnimalEventData = pd.DataFrame({'idx':[0,1,2,3], 'dfs':[Event1, Event2, Event3, Event4]})
    
    conc = [Animals, AnimalEventData]
    Data = pd.concat(conc, axis=1)
    return Data
    
def SeparateGenotype(Data, genotypes, batchName, saveLocation):
    # want to just say if genotype is this then save it here, and if this genotype save here
    genotype_1 = Data[Data['GENOTYPE'] == genotypes[0]]
    genotype_2 = Data[Data['GENOTYPE'] == genotypes[1]]    

    genotype_1.to_pickle(saveLocation + "/" + batchName + genotypes[0] + ".pkl")
    genotype_2.to_pickle(saveLocation + "/" + batchName + genotypes[1] + ".pkl")  

def TrainBehaviour(df, day_type):
    if day_type == "mouse":
    # This is the code that will create Train Leader events (will only be given to one animal later)    
        TrainLeader =df.query("NAME == 'Train2'" or "NAME == 'Train3'" or "NAME == 'Train4'")
        TrainLeader = TrainLeader.replace(['Train2', 'Train3', 'Train4'],'TrainLeader')
    
    # This is the code to create the Train follower behaviours, first follower
        TrainFollower_1 = df.query("NAME == 'Train2'" or "NAME == 'Train3'" or "NAME == 'Train4'")
        TrainFollower_1= TrainFollower_1.replace(['Train2', 'Train3', 'Train4'],'TrainFollower')
        order = [0, 1, 2, 4, 3, 5, 6]
    
        TrainFollower_2 = df.query("NAME == 'Train3'" or "NAME == 'Train4'")
        TrainFollower_2= TrainFollower_2.replace(['Train3', 'Train4'],'TrainFollower')
        
        order= [0, 1, 2, 5, 4, 3, 6]
        TrainFollower_2 = TrainFollower_2[[df.columns[i] for i in order]]
    
        TrainFollower_3 = df.query("NAME == 'Train4'") # This will only be for databases including 4 mice, hence mention of extra column
        TrainFollower_3= TrainFollower_3.replace(['Train4'],'TrainFollower')
        
        order= [0, 1, 2, 6, 5, 3, 4]
        TrainFollower_3 = TrainFollower_3[[df.columns[i] for i in order]]
        
        conc = [TrainFollower_1, TrainFollower_2, TrainFollower_3]
        TrainFollowers = pd.concat(conc)
    
    else:
        TrainLeader =df.query("NAME == 'Train2'" or "NAME == 'Train3'" or "NAME == 'Train4'")
        TrainLeader = TrainLeader.replace(['Train2', 'Train3', 'Train4'],'TrainLeader')
    
    # This is the code to create the Train follower behaviours, first follower
        TrainFollower_1 = df.query("NAME == 'Train2'" or "NAME == 'Train3'" or "NAME == 'Train4'")
        TrainFollower_1= TrainFollower_1.replace(['Train2', 'Train3', 'Train4'],'TrainFollower')
        order = [0, 1, 2, 4, 3, 5]
    
        TrainFollower_2 = df.query("NAME == 'Train3'" or "NAME == 'Train4'")
        TrainFollower_2= TrainFollower_2.replace(['Train3', 'Train4'],'TrainFollower')
        
        order= [0, 1, 2, 5, 4, 3]
        TrainFollower_2 = TrainFollower_2[[df.columns[i] for i in order]]
        
        conc = [TrainFollower_1, TrainFollower_2]
        TrainFollowers = pd.concat(conc)
        
    return TrainLeader, TrainFollowers

def Group4Behaviours(df):
    Group4Behaviour =df.query("NAME == 'Group4'") # pull all Group 4 behaviours
    order = [0, 1, 2, 4, 3, 5, 6]
    Group4Behaviour_2 = Group4Behaviour[[df.columns[i] for i in order]]  
    order= [0, 1, 2, 5, 4, 3, 6]
    Group4Behaviour_3 = Group4Behaviour[[df.columns[i] for i in order]]
    order= [0, 1, 2, 6, 5, 3, 4]
    Group4Behaviour_4 = Group4Behaviour[[df.columns[i] for i in order]]
    conc = [Group4Behaviour_2, Group4Behaviour_3, Group4Behaviour_4]
    Group4 = pd.concat(conc)
    
    return Group4
        
def Nest4Behaviour(df):
    
    Nest4Behaviour = df.query("NAME == 'Nest4_'") # pull all Group 4 behaviours
    order= [0, 1, 2, 3, 4, 5, 6]
    Nest4Behaviour_1 = Nest4Behaviour[[df.columns[i] for i in order]]
    Nest4Behaviour_1['IDANIMALA'] = Nest4Behaviour_1['IDANIMALA'].fillna(1)  
    Nest4Behaviour_2 = Nest4Behaviour[[df.columns[i] for i in order]]
    Nest4Behaviour_2['IDANIMALA'] = Nest4Behaviour_2['IDANIMALA'].fillna(2)  
    Nest4Behaviour_3 = Nest4Behaviour[[df.columns[i] for i in order]]
    Nest4Behaviour_3['IDANIMALA'] = Nest4Behaviour_3['IDANIMALA'].fillna(3)  
    Nest4Behaviour_4 = Nest4Behaviour[[df.columns[i] for i in order]]
    Nest4Behaviour_4['IDANIMALA'] = Nest4Behaviour_4['IDANIMALA'].fillna(4)  
    conc = [Nest4Behaviour_1, Nest4Behaviour_2, Nest4Behaviour_3, Nest4Behaviour_4]
    Nest4 = pd.concat(conc)  
    return Nest4

def NovelMouseBehaviours(picklePath, novMouseID):
    df = pd.read_pickle(picklePath)
    
    for i in range(len(df)):
        tempBehaviours = ["Contact", "Side by side Contact", "Side by side Contact, opposite way", "Oral-oral Contact", "Group2", "Oral-genital Contact", "seq oral geni - oral oral", "seq oral oral - oral genital","Approach", "Approach contact", "Social approach","Approach rear", "Break contact", "Social escape", "FollowZone Isolated"]    
        dataTemp = df.iloc[i][5]
        novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = dataTemp[(dataTemp.iloc[:,0] == tempBehaviours[j]) & (dataTemp['IDANIMALB'] == novMouseID)]
            novMouseBehaviour.append(temp)
        dataFrame = pd.concat(novMouseBehaviour)
    
    
    for i in range(len(df)):
    tempBehaviours = ['Group3']
    dataTemp = df.iloc[i][5]
    novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = dataTemp[(dataTemp.iloc[:,0] == tempBehaviours[j]) & ((dataTemp['IDANIMALB'] == novMouseID)|(dataTemp['IDANIMALC'] == novMouseID))] #|(dataTemp['IDANIMALD'] == novMouseID))]
            novMouseBehaviour.append(temp)
        dataFrame = pd.concat(novMouseBehaviour)
    
    for i in range(len(df)):
    tempBehaviours = ['Group4']
    dataTemp = df.iloc[i][5]
    novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = dataTemp[(dataTemp.iloc[:,0] == tempBehaviours[j])]
            novMouseBehaviour.append(temp)
        dataFrame = pd.concat(novMouseBehaviour)
       
    # Pseudocode for what is left: I have written code that extracts the novel mouse behaviours on different rules
    # Now need to pull those into one big variables, and then pull that into a variable/pkl for all the mousejes (Friday)
    # Next week - stop coding and start writing comments.....
