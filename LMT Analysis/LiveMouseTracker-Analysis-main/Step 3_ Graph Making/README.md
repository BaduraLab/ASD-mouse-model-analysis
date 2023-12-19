# Graph Making:

The codes in this folder outline how to create graphs of the LMT data, once it has been compiled on a group by group basis. For graphing, codes have been written for the following situations:
* Graphing one/two/three "test" datasets, normalised to a "control dataset", showed as mean (+ error bars). 
* Graphing all datapoints of one "test" datasets, normalised to a "control dataset" (+ error bars).

Please see each script for more information on implementation.


**Note**: The compiled LMT data, following on from the previous scripts, contains three main types of behaviour event-related data that we can use in graphing. They are:
* Total number of frames spent in each behaviour
* Total numer of events of each behaviour
* Average event duration of each behaviour

Within in each script, modifications can be made to the code to plot any of these variables.


## Code Guide:
The codes in this folder are divided into functions and graphing scripts.

Functions:
* ComputeGroupData 
* Behaviour Set
* GraphData
* GraphDataThree
* GraphDataTwo

**Graphing Scripts:**
* *OneGroupRainbowGraph:* This code shows the mean for each behaviour of the chosen test variables, plotted in rainbow colours, with errorbars, normalised to a control set, which is depicted as a grey shaded region in the background.
* *OneGroupIndividualPoints:* This code shows the datapoints for each behaviour of the chose test variable, with errorbars, normalised to a control set, which is depicted as a grey shaded region in the background.
* *TwoGenotyestoOne / ThreeGenotypestoOne:* These codes show two/three test datasets, in different colours, plotted with errorbars, normalised to a control set, which is depicted as a grey shaded region in the background.

Please see each script for implementation instructions
