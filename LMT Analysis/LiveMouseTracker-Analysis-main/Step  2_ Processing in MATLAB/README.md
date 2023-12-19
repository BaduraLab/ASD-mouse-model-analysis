The scripts in this folder are designed to extract "event" related behaviour from the SQLite files. This is accomplished in three separate steps:

**Note:** The scripts in this folder are written in and for MATLAB.

# Step 2.1 - Extracting Event Data from SQLite files.
The main script in this folder is _"Script1_SQL_Processing.m"_, which will use the other scripts located in this folder. This script must be altered according to the particular file that is being processed, but this is indicated within the script.

# Step 2.1.5 - Extracting Novel Mouse Related Data.
This script is only to be used for processing data from the "Novel Mouse Interaction" day. These scripts are used in extracting data relating to the interaction of the three experimental mice with the fourth novel mouse.  

The script relating to this step is _"Script1.5_ProcessingNovelMouse"_. 

# Step 2.2 - Compile Based on Genotype
This MATLAB script enables users to pull all the animals of a single genotypes/ condition into a single variable. This is important as this variable will be used in later plotting scripts. 

In this step,the relevant script is _"Script2_CompileGenotype"_.
