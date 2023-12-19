The script "Script1_SQL_Processing" is the script that you must run in order to extract event-related data from the SQLite file. This script contains instructions for how exactly to do this. 

**Note:** that this script cannot be run in one go as there are a few variables that need to be modified to store the data correctly. Please see the “README” section at the top of this script for further instructions. 

_In brief:_

* Sections 1 and 2 load the SQL file into MATLAB and create a “data” structure which has the following structure:
1. Mice
2. Genotype
3. RFID
4. ID
5. BehaviourType (cell array!!)
6. BehaviourData (matrix array, with the following columns: )
a. Start Frame
b. End Frame
c. Animal 1
d. Animal 2
e. Animal 3
f. Animal 4

* This “data” structure has multiple entries, one corresponding to each animal, they can be accessed by the following syntax: “data(1)”.

* Section 3 breaks up the “data” structure into two .mat variables, corresponding to the genotype of the mice. Before running this section you must alter the code to ensure that the right “data” entries are inserted into the correct variables and you must rename these for later scripts. More instructions can be found in the .m file. At the end of this script you should have two .mat variable files e.g. _L7_TSC1_KO_mouse_12903_2_ and _L7_TSC1_WT_mouse_12903_2_. Note that the naming convention here will be useful later in pooling data relating different batches of mice and experimental days much easier.

**Notes on this script:**
This script also does a little behaviour processing which was difficult to programme in Jupyter. These behaviours were:
* Nest4
* Group4
* Train behaviours
The functions which compute these behaviours contain information on the justification for the modifications of these events. Check this for further detail on this.
