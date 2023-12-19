# -*- coding: utf-8 -*-
"""
Step 2.1 of LMT Data processing

This script is the first step

@author: amyrh
"""
import pandas as pd
import sqlite3

# Change this to your SQL file location:
db = r'C:\Users\amyrh\Documents\AA_Education\Neuroscience_MSc\MATLAB_Processing\Python\Step 2.1 Extracting Event Data from SQLite\test_mouse.sqlite'
day_type = "mouse"
genotypes = ['L7_TSC1_WT_SH', 'L7_TSC1_KO_SH']
batchName = 'test'
saveLocation = r"C:\Users\amyrh\Documents\AA_Education\Neuroscience_MSc\MATLAB_Processing\Python\Step 2.1 Extracting Event Data from SQLite"
novMouseID = 3 
picklePath = r'C:\Users\amyrh\Documents\AA_Education\Neuroscience_MSc\MATLAB_Processing\Python\Step 2.1 Extracting Event Data from SQLite\12903_2_L7_TSC1_WT.pkl'
pickleName = '12903_2_L7_TSC1_KO'

# there is a problem in this code - because matlab and spyder are giving me different length variables
# e.g. standard analysis of test_mouse, wt (1 mouse) is 109685 cells in matlab, but 109697 in python (diff = 12)
def processSQL(db, day_type):
    """Creates a df containing all the data relating to all mice, but is specific to the type of experiment being analysed (e.g. standard, wheel etc):
         - mouse identity data (ID, RFID code, Genotype, Name)
         - mouse event data (i.e. all event data relating to each mouse)
 
     Parameters:
     db: Path to SQLite file
     day_type: type of day being analysed (options: standard/wheel/object/mouse)
 
     Returns:
     df: Creates dataframe containing all the data
 
    """
    con = sqlite3.connect(db) # connect to SQL
    if day_type == 'standard':
        # Queries to take certain behaviours referring to the standard day
        sqlquery_soloEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA FROM EVENT WHERE NAME IS 'WallJump' OR NAME IS 'Move isolated' OR NAME IS 'Rear isolated' OR NAME IS 'SAP' OR NAME IS 'Stop isolated' OR NAME IS 'Huddling' OR NAME IS 'Move in contact' OR NAME IS 'Rear in contact' OR NAME IS 'Stop in contact' OR NAME IS 'Group 3 make' OR NAME IS 'Group 3 break' OR NAME IS 'Group 4 make' OR NAME IS 'Group 4 break'";
        sqlquery_dyadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB FROM EVENT WHERE NAME IS 'Contact' OR NAME IS 'Oral-oral Contact' OR NAME IS 'Side by side Contact' OR NAME IS 'Side by side Contact, opposite way' OR NAME IS 'Group2' OR NAME IS 'Oral-genital Contact' OR NAME IS 'Approach' OR NAME IS 'Approach contact' OR NAME IS 'Social approach' OR NAME IS 'Approach rear' OR NAME IS 'Break contact' OR NAME IS 'Social escape' OR NAME IS 'FollowZone Isolated' OR NAME IS 'Train2' OR NAME IS 'seq oral geni - oral oral' OR NAME IS 'seq oral oral - oral genital'";
        sqlquery_triadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC FROM EVENT WHERE NAME IS 'Group3' OR NAME IS 'Train3'";
        
        # Pull these behaviours from the SQL file
        results_solo = pd.read_sql(sqlquery_soloEvents,con)
        results_dyadic = pd.read_sql(sqlquery_dyadicEvents,con)
        results_triadic = pd.read_sql(sqlquery_triadicEvents,con)
        
        # Create df from these data
        conc = [results_triadic,results_dyadic, results_solo]
        df = pd.concat(conc)
        
        # Process this data with the TrainBehaviour script and add that in...
        [TrainLeader, TrainFollowers] = TrainBehaviour(df, day_type)
        conc = [df, TrainLeader, TrainFollowers]
        df= pd.concat(conc)

    if day_type == 'wheel':
                # Queries to take certain behaviours referring to the standard day
        sqlquery_soloEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA FROM EVENT WHERE NAME IS 'WallJump' OR NAME IS 'Move isolated' OR NAME IS 'Rear isolated' OR NAME IS 'SAP' OR NAME IS 'Stop isolated' OR NAME IS 'Huddling' OR NAME IS 'Move in contact' OR NAME IS 'Rear in contact' OR NAME IS 'Stop in contact' OR NAME IS 'Group 3 make' OR NAME IS 'Group 3 break' OR NAME IS 'Group 4 make' OR NAME IS 'Group 4 break' OR NAME IS 'Nest3_'OR NAME IS 'Wheel Zone'";
        sqlquery_dyadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB FROM EVENT WHERE NAME IS 'Contact' OR NAME IS 'Oral-oral Contact' OR NAME IS 'Side by side Contact' OR NAME IS 'Side by side Contact, opposite way' OR NAME IS 'Group2' OR NAME IS 'Oral-genital Contact' OR NAME IS 'Approach' OR NAME IS 'Approach contact' OR NAME IS 'Social approach' OR NAME IS 'Approach rear' OR NAME IS 'Break contact' OR NAME IS 'Social escape' OR NAME IS 'FollowZone Isolated' OR NAME IS 'Train2' OR NAME IS 'seq oral geni - oral oral' OR NAME IS 'seq oral oral - oral genital'";
        sqlquery_triadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC FROM EVENT WHERE NAME IS 'Group3' OR NAME IS 'Train3'";

        # Pull these behaviours from the SQL file
        results_solo = pd.read_sql(sqlquery_soloEvents,con)
        results_dyadic = pd.read_sql(sqlquery_dyadicEvents,con)
        results_triadic = pd.read_sql(sqlquery_triadicEvents,con)
                
        # Create df from these data
        conc = [results_triadic,results_dyadic, results_solo]
        df = pd.concat(conc)
        
        # Process this data with the TrainBehaviour script and add that in...
        [TrainLeader, TrainFollowers] = TrainBehaviour(df, day_type)
        conc = [df, TrainLeader, TrainFollowers]
        df= pd.concat(conc)
        
    if day_type == 'object':
                # Queries to take certain behaviours referring to the standard day
        sqlquery_soloEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA FROM EVENT WHERE NAME IS 'WallJump' OR NAME IS 'Move isolated' OR NAME IS 'Rear isolated' OR NAME IS 'SAP' OR NAME IS 'Stop isolated' OR NAME IS 'Huddling' OR NAME IS 'Move in contact' OR NAME IS 'Rear in contact' OR NAME IS 'Stop in contact' OR NAME IS 'Group 3 make' OR NAME IS 'Group 3 break' OR NAME IS 'Group 4 make' OR NAME IS 'Group 4 break' OR NAME IS 'NovObj Interact' OR NAME IS 'NovObj Zone' OR NAME IS 'NovObj Stop'";
        sqlquery_dyadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB FROM EVENT WHERE NAME IS 'Contact' OR NAME IS 'Oral-oral Contact' OR NAME IS 'Side by side Contact' OR NAME IS 'Side by side Contact, opposite way' OR NAME IS 'Group2' OR NAME IS 'Oral-genital Contact' OR NAME IS 'Approach' OR NAME IS 'Approach contact' OR NAME IS 'Social approach' OR NAME IS 'Approach rear' OR NAME IS 'Break contact' OR NAME IS 'Social escape' OR NAME IS 'FollowZone Isolated' OR NAME IS 'Train2' OR NAME IS 'seq oral geni - oral oral' OR NAME IS 'seq oral oral - oral genital'";
        sqlquery_triadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC FROM EVENT WHERE NAME IS 'Group3' OR NAME IS 'Train3'";

        # Pull these behaviours from the SQL file
        results_solo = pd.read_sql(sqlquery_soloEvents,con)
        results_dyadic = pd.read_sql(sqlquery_dyadicEvents,con)
        results_triadic = pd.read_sql(sqlquery_triadicEvents,con)
        
        # Create df from these data
        conc = [results_triadic,results_dyadic, results_solo]
        df = pd.concat(conc)
        
        # Process this data with the TrainBehaviour script and add that in...
        [TrainLeader, TrainFollowers] = TrainBehaviour(df, day_type)
        conc = [df, TrainLeader, TrainFollowers]
        df= pd.concat(conc)
        
    if day_type == 'mouse':
        sqlquery_soloEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA FROM EVENT WHERE NAME IS 'WallJump' OR NAME IS 'Move isolated' OR NAME IS 'Rear isolated' OR NAME IS 'SAP' OR NAME IS 'Stop isolated' OR NAME IS 'Huddling' OR NAME IS 'Move in contact' OR NAME IS 'Rear in contact' OR NAME IS 'Stop in contact' OR NAME IS 'Group 3 make' OR NAME IS 'Group 3 break' OR NAME IS 'Group 4 make' OR NAME IS 'Group 4 break' OR NAME IS 'Nest3_'";
        sqlquery_dyadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB FROM EVENT WHERE NAME IS 'Contact' OR NAME IS 'Oral-oral Contact' OR NAME IS 'Side by side Contact' OR NAME IS 'Side by side Contact, opposite way' OR NAME IS 'Group2' OR NAME IS 'Oral-genital Contact' OR NAME IS 'Approach' OR NAME IS 'Approach contact' OR NAME IS 'Social approach' OR NAME IS 'Approach rear' OR NAME IS 'Break contact' OR NAME IS 'Social escape' OR NAME IS 'FollowZone Isolated' OR NAME IS 'Train2' OR NAME IS 'seq oral geni - oral oral' OR NAME IS 'seq oral oral - oral genital'";
        sqlquery_triadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC FROM EVENT WHERE NAME IS 'Group3' OR NAME IS 'Train3'";
        sqlquery_quadraticEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC, IDANIMALD FROM EVENT WHERE NAME IS 'Group4' OR NAME IS 'Train4' OR NAME IS 'Nest4_'";

        # Pull these behaviours from the SQL file
        results_solo = pd.read_sql(sqlquery_soloEvents,con)
        results_dyadic = pd.read_sql(sqlquery_dyadicEvents,con)
        results_triadic = pd.read_sql(sqlquery_triadicEvents,con)
        results_quadratic = pd.read_sql(sqlquery_quadraticEvents, con)
                
        # Create df from these data
        conc = [results_quadratic, results_triadic,results_dyadic, results_solo]
        df = pd.concat(conc)

        # Process this data with the TrainBehaviour, Group4 and Nest4 script and add that in...
        [TrainLeader, TrainFollowers] = TrainBehaviour(df, day_type)
        Group4 = Group4Behaviours (df)
        Nest4 = Nest4Behaviour (df)
        conc = [df, TrainLeader, TrainFollowers, Group4, Nest4]
        df= pd.concat(conc)
        
    return df

def animalData (db, df, day_type):
    con = sqlite3.connect(db) # connect to SQL
    """Creates a data structure that contains all data relating to each mouse including:
         - mouse identity data (ID, RFID code, Genotype, Name)
         - mouse event data (i.e. all event data relating to each mouse)
 
     Parameters:
     db: Path to SQLite file
     df: df created using the "ProcessSQL" function
     day_type: type of day being analysed (options: standard/wheel/object/mouse)
 
     Returns:
     Data: Creates dataframe containing mouse data
 
    """

    AnimalData = "SELECT ID, RFID, GENOTYPE, NAME FROM ANIMAL"; # Pull this identity data
    Animals = pd.read_sql_query(AnimalData, con)
    
    if day_type == "standard" or day_type == "wheel" or day_type == "object":
        # Standard/wheel/object day experiments should only contain 3 animals,  so this code creates separate entries for each mouse 
        
        Event1 = df.loc[df['IDANIMALA'] == 1]
        Event2 = df.loc[df['IDANIMALA'] == 2]
        Event3 = df.loc[df['IDANIMALA'] == 3]
        AnimalEventData = pd.DataFrame({'idx':[0,1,2], 'dfs':[Event1, Event2, Event3]})
        AnimalEventData.drop('idx', inplace=True, axis=1)

        
    if day_type == "mouse":
        # Same as above, but mouse experiments have 4 mice, so this code allows for this
        Event1 = df.loc[df['IDANIMALA'] == 1]
        Event2 = df.loc[df['IDANIMALA'] == 2]
        Event3 = df.loc[df['IDANIMALA'] == 3]
        Event4 = df.loc[df['IDANIMALA'] == 4]
        AnimalEventData = pd.DataFrame({'idx':[0,1,2,3], 'dfs':[Event1, Event2, Event3, Event4]})
        AnimalEventData.drop('idx', inplace=True, axis=1)

    
    conc = [Animals, AnimalEventData]
    Data = pd.concat(conc, axis=1) # Concatenate the two databases into one data structure
    return Data
    
def SeparateGenotype(Data, genotypes, batchName, saveLocation):

    """Separate mouse data based on their genotype
     
     Parameters:
     Data: Data structure created using the animalData code
     genotype: list of genotypes of mouse (i.e. the parameter based on which the mice will be separated)
     batchName: str of batch of mice
     saveLocation: path to save location
     
     
     Returns:
     pickle files
    """
    # Pulls data based on genotype of mouse, as specified in genotype variable
    genotype_1 = Data[Data['GENOTYPE'] == genotypes[0]] # Pulls data based on first genotype
    genotype_2 = Data[Data['GENOTYPE'] == genotypes[1]] # Pulls data based on second genotype
    
    # Saves pickle files of data, with name in following format: batchName_genotype.pkl
    genotype_1.to_pickle(saveLocation + "/" + batchName + genotypes[0] + ".pkl")
    genotype_2.to_pickle(saveLocation + "/" + batchName + genotypes[1] + ".pkl")
    
def TrainBehaviour(df, day_type):
    """Code to modify the "Train2" and "Train 3" in the df
    
    Motivation: within the SQLite file, Train 2 behaviours, have the "leading
    mouse" as IDANIMALA and the following mouse as IDANIMALB. The same goes
    for Train3 (IDANIMAL=1st mouse, IDANIMALB = 2nd mouse, IDANIMALC = 3rd
    mouse). When we pull this data, normally we only ascribe these events to
    the the leading mouse but this script creates two new event types:
    TrainLeader (where IDANIMALA/ column 3 = leader mouse) and TrainFollower
    (where IDANIMALA/ column 3 = a follower mice)
     
    For graphing, we just need to graph TrainLeader and TrainFollower instead.
     
     
    Parameters:
    df: df created using the "ProcessSQL" function
    day_type: type of day being analysed (options: standard/wheel/object/mouse)
    
    Returns:
    TrainLeader/ TrainFollower: dfs containing only these two behaviour types, that will be added to the df in the ProcessSQL code
    
    """
    # This is the code that will create Train Leader events (will only be given to one animal later)    
    TrainLeader =df.query("(NAME == 'Train2') or (NAME == 'Train3') or (NAME == 'Train4')")
    TrainLeader = TrainLeader.replace(['Train2', 'Train3', 'Train4'],'TrainLeader')
    
    if day_type == "mouse":
    
    # This is the code to create the Train follower behaviours, first follower
       TrainFollower_1 = df.query("(NAME == 'Train2') or (NAME == 'Train3') or (NAME == 'Train4')")
       TrainFollower_1= TrainFollower_1.replace(['Train2', 'Train3', 'Train4'],'TrainFollower')
       TrainFollower_1 = TrainFollower_1[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALB', 'IDANIMALA', 'IDANIMALC']]
       TrainFollower_1 = TrainFollower_1.rename(columns = {'IDANIMALB': 'IDANIMALA', 'IDANIMALA': 'IDANIMALB'}, inplace = False)

    # Second follower
       TrainFollower_2 = df.query("(NAME == 'Train3') or (NAME == 'Train4')")
       TrainFollower_2= TrainFollower_2.replace(['Train3', 'Train4'],'TrainFollower')
       TrainFollower_2 = TrainFollower_2[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALC', 'IDANIMALB', 'IDANIMALA']]
       TrainFollower_2 = TrainFollower_2.rename(columns = {'IDANIMALC': 'IDANIMALA', 'IDANIMALA': 'IDANIMALC'}, inplace = False)

    # Third follower (only in db with 4 mice)
       TrainFollower_3 = df.query("NAME == 'Train4'") # This will only be for databases including 4 mice, hence mention of extra column
       TrainFollower_3= TrainFollower_3.replace(['Train4'],'TrainFollower')
    
       TrainFollower_3 = TrainFollower_3[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALD', 'IDANIMALA', 'IDANIMALB', 'IDANIMALC' ]]
       TrainFollower_3 = TrainFollower_3.rename(columns = {'IDANIMALD': 'IDANIMALA', 'IDANIMALA': 'IDANIMALD'}, inplace = False)

    # Bring all data together
       conc = [TrainFollower_1, TrainFollower_2, TrainFollower_3]
       TrainFollowers = pd.concat(conc)
    
    else:
    # This is the code to create the Train follower behaviours, first follower
       TrainFollower_1 = df.query("(NAME == 'Train2') or (NAME == 'Train3') or (NAME == 'Train4')")
       TrainFollower_1= TrainFollower_1.replace(['Train2', 'Train3', 'Train4'],'TrainFollower')
       TrainFollower_1 = TrainFollower_1[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALB', 'IDANIMALA', 'IDANIMALC']]
       TrainFollower_1 = TrainFollower_1.rename(columns = {'IDANIMALB': 'IDANIMALA', 'IDANIMALA': 'IDANIMALB'}, inplace = False)

    # Second follower
       TrainFollower_2 = df.query("(NAME == 'Train3') or (NAME == 'Train4')")
       TrainFollower_2= TrainFollower_2.replace(['Train3', 'Train4'],'TrainFollower')
       TrainFollower_2 = TrainFollower_2[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALC', 'IDANIMALB', 'IDANIMALA']]
       TrainFollower_2 = TrainFollower_2.rename(columns = {'IDANIMALC': 'IDANIMALA', 'IDANIMALA': 'IDANIMALC'}, inplace = False)

    
       conc = [TrainFollower_1, TrainFollower_2]
       TrainFollowers = pd.concat(conc)
    
    return TrainLeader, TrainFollowers

def Group4Behaviours(df):
    """Code to modify the "Group4" behaviour

        Justification for the process in this code: In the SQLite file, only one entry for the 
        Group 4 behaviour is entered for each instance of this behaviour. Moreover it always 
        has the format: IDANIMALA = 1, IDANIMALB = 2, IDANIMALC = 3, IDANIMALD = 4. Therefore, if
        we want to have an entry for each animal, we must insert more events for each animal. 
        In this code, to do this we rearrange the order of the columns and functionally duplicate 
        this behaviour. This makes the analysis of this much easier.
    
    
    Parameters:
    df: df created using the "ProcessSQL" function
 
    Returns:
    Group4: df containing only this behaviour types, that will be added to the df in the ProcessSQL code (if day_type = mouse)
 
    """
    # Pull Group 4 behaviours and rearrange the order because we are duplicating these events to create entries specific to each mouse)
    Group4Behaviour =df.query("NAME == 'Group4'") # pull all Group 4 behaviours
    Group4Behaviour_2 = Group4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALB', 'IDANIMALA', 'IDANIMALC', 'IDANIMALD']]  
    Group4Behaviour_2 = Group4Behaviour_2.rename(columns = {'IDANIMALB': 'IDANIMALA', 'IDANIMALA':'IDANIMALB'})
    Group4Behaviour_3 = Group4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALC', 'IDANIMALB', 'IDANIMALA', 'IDANIMALD']]
    Group4Behaviour_3 = Group4Behaviour_3.rename(columns = {'IDANIMALC': 'IDANIMALA', 'IDANIMALA':'IDANIMALC'})
    Group4Behaviour_4 = Group4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALD', 'IDANIMALC', 'IDANIMALA', 'IDANIMALB']]
    Group4Behaviour_3 = Group4Behaviour_3.rename(columns = {'IDANIMALD': 'IDANIMALA', 'IDANIMALC':'IDANIMALB', 'IDANIMALA':'IDANIMALC', 'IDANIMALB':'IDANIMALD'})

    conc = [Group4Behaviour_2, Group4Behaviour_3, Group4Behaviour_4]
    Group4 = pd.concat(conc)
    
    return Group4
        
def Nest4Behaviour(df):
    """Code to modify the "Nest4"
     
     Justification for the process in this code: In the SQLite file, Nest4 behaviours are encoded as "Nest4_"  and,
     because they involve all the animals in cage, do not have any mouse identities (i.e. IDANIMALA - D is 0). Therefore 
     this script takes instances where this behaviour occurs and computes a new behaviour "Nest 4" and adds an entry for 
     every mouse for every instance of this behaviour, making it simpler to segregate the data for each animal.
     
     
     Parameters:
         df: df created using the "ProcessSQL" function
 
    Returns:
        Nest4: df containing only this behaviour types, that will be added to the df in the ProcessSQL code (if day_type = mouse)
    """
    Nest4Behaviour = df.query("NAME == 'Group4'") # pull all Nest 4 behaviours
    
    # WORTH CHECKING THIS TOMORROW TO MAKE SURE ITS ON TRACK
    Nest4Behaviour_1 = Nest4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALA', 'IDANIMALB', 'IDANIMALC', 'IDANIMALD']]
    Nest4Behaviour_1['IDANIMALA'] = Nest4Behaviour_1['IDANIMALA'].fillna(value=1)  
    Nest4Behaviour_2 = Nest4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALA', 'IDANIMALB', 'IDANIMALC', 'IDANIMALD']]
    Nest4Behaviour_2['IDANIMALA'] = Nest4Behaviour_2['IDANIMALA'].fillna(value=2)  
    Nest4Behaviour_3 = Nest4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALA', 'IDANIMALB', 'IDANIMALC', 'IDANIMALD']]
    Nest4Behaviour_3['IDANIMALA'] = Nest4Behaviour_3['IDANIMALA'].fillna(value=3)  
    Nest4Behaviour_4 = Nest4Behaviour[['NAME', 'STARTFRAME', 'ENDFRAME', 'IDANIMALA', 'IDANIMALB', 'IDANIMALC', 'IDANIMALD']]
    Nest4Behaviour_4['IDANIMALA'] = Nest4Behaviour_4['IDANIMALA'].fillna(value=4)
    
    conc = [Nest4Behaviour_1, Nest4Behaviour_2, Nest4Behaviour_3, Nest4Behaviour_4]
    Nest4 = pd.concat(conc)  

def NovelMouseBehaviours(picklePath, novMouseID, saveLocation, pickleName):
    """Creates a data structure that contains all data relating to interactions of each mouse with the novel mouse
    It is a little clunkier than I'm happy with but I'll come back to it another time
    
    Parameters:
    picklepath: Path to pickle file to be processed
    novMouseID: identity of the novel mouse in the SQL database (open using DB Browser to find this)
    
    Returns:
    Data: Creates dataframe containing mouse data
    
    """
    
    df = pd.read_pickle(picklePath) # take in pkl file
    
    if len(df) == 2:# if has two mice do this
        df_firstMouse = df.iloc[0,5]
        
        ## First mouse
        # look for dyadic behaviours if the second mouse is the novel mouse
        tempBehaviours = ["Contact", "Side by side Contact", "Side by side Contact, opposite way", "Oral-oral Contact", "Group2", "Oral-genital Contact", "seq oral geni - oral oral", "seq oral oral - oral genital","Approach", "Approach contact", "Social approach","Approach rear", "Break contact", "Social escape", "FollowZone Isolated"]    
        novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j]) & (df_firstMouse['IDANIMALB'] == novMouseID)]
            novMouseBehaviour.append(temp)
        
        # look for triadic behaviours if either the second or third mouse is the novel mouse
        tempBehaviours = ['Group3']
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j]) & ((df_firstMouse['IDANIMALB'] == novMouseID)|(df_firstMouse['IDANIMALC'] == novMouseID))] #|(df_firstMouse['IDANIMALD'] == novMouseID))]
            novMouseBehaviour.append(temp)
        
        # look for quadratic behaviours if any of the mice is the novel mouse
        tempBehaviours = ['Group4']
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j])]
            novMouseBehaviour.append(temp)
        
        dataFrameFirstMouse = pd.concat(novMouseBehaviour) # concat these pulled behaviours into one dataframe
        
        ## Second mouse - process is the same as above
        df_secondMouse = df.iloc[1,5]
        
        tempBehaviours = ["Contact", "Side by side Contact", "Side by side Contact, opposite way", "Oral-oral Contact", "Group2", "Oral-genital Contact", "seq oral geni - oral oral", "seq oral oral - oral genital","Approach", "Approach contact", "Social approach","Approach rear", "Break contact", "Social escape", "FollowZone Isolated"]    
        novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = df_secondMouse[(df_secondMouse.iloc[:,0] == tempBehaviours[j]) & (df_secondMouse['IDANIMALB'] == novMouseID)]
            novMouseBehaviour.append(temp)
        
        tempBehaviours = ['Group3']
        for j in range(len(tempBehaviours)):
            temp = df_secondMouse[(df_secondMouse.iloc[:,0] == tempBehaviours[j]) & ((df_secondMouse['IDANIMALB'] == novMouseID)|(df_secondMouse['IDANIMALC'] == novMouseID))] #|(df_secondMouse['IDANIMALD'] == novMouseID))]
            novMouseBehaviour.append(temp)
            
        tempBehaviours = ['Group4']
        for j in range(len(tempBehaviours)):
            temp = df_secondMouse[(df_secondMouse.iloc[:,0] == tempBehaviours[j])]
            novMouseBehaviour.append(temp)
        
        dataFrameSecondMouse = pd.concat(novMouseBehaviour)
        
        # pull both mice into a dataframe
        df_NovelMice = pd.DataFrame({'idx': [0,1], 'dfs':[dataFrameFirstMouse, dataFrameSecondMouse]})
        
        # Creates a df in the same format as the imported pkl file, but just changes the dataframe of behaviour data
        temp_identity= df.iloc[:, 0:4]
        temp_data= df_NovelMice.iloc[:,1]
        
        NovelMice= pd.concat([temp_identity.reset_index(drop=True), temp_data.reset_index(drop=True)], axis=1)
        # return NovelMice # show novel mice
        NovelMice.to_pickle(saveLocation + "/" + pickleName + "_novelMouse.pkl") # Save pickle
        
    else:
        # Same process as above, so see there for comments
        df_firstMouse = df.iloc[0,5]
        
        tempBehaviours = ["Contact", "Side by side Contact", "Side by side Contact, opposite way", "Oral-oral Contact", "Group2", "Oral-genital Contact", "seq oral geni - oral oral", "seq oral oral - oral genital","Approach", "Approach contact", "Social approach","Approach rear", "Break contact", "Social escape", "FollowZone Isolated"]    
        novMouseBehaviour = []
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j]) & (df_firstMouse['IDANIMALB'] == novMouseID)]
            novMouseBehaviour.append(temp)
        
        tempBehaviours = ['Group3']
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j]) & ((df_firstMouse['IDANIMALB'] == novMouseID)|(df_firstMouse['IDANIMALC'] == novMouseID))] #|(df_firstMouse['IDANIMALD'] == novMouseID))]
            novMouseBehaviour.append(temp)
            
        tempBehaviours = ['Group4']
        for j in range(len(tempBehaviours)):
            temp = df_firstMouse[(df_firstMouse.iloc[:,0] == tempBehaviours[j])]
            novMouseBehaviour.append(temp)
        
        dataFrameFirstMouse = pd.concat(novMouseBehaviour)
        
        
        df_NovelMice = pd.DataFrame({'idx': [0], 'dfs':[dataFrameFirstMouse]})
        
        temp_identity= df.iloc[:, 0:4]
        temp_data= df_NovelMice.iloc[:,1]
        
        NovelMice= pd.concat([temp_identity.reset_index(drop=True), temp_data.reset_index(drop=True)], axis=1)
        # return NovelMice # show novel mice
        NovelMice.to_pickle(saveLocation + "/" + pickleName + "_novelMouse.pkl") # Save pickle


