# LiveMouseTracker-Analysis

Live Mouse Tracker Analysis tools :mouse:

## Introduction

The analysis tools within this respository process the output of the Live Mouse Tracker, an SQLite file, in light with the experimental set up and design used in the Badura Lab.
These tools are derived from the code made available by Fabrice de Chaumont and Elodie Ey (available at: https://github.com/fdechaumont/lmt-analysis)

The code is currently maintained by [Amy Hassett](https://github.com/AmyRHassett)

## How to use:

The analysis pipelines for LMT data is outlined summarised below. More information on each of these steps can be found in the README files located in the folder associated with each step.

### Step 1: Preprocessing in Python
These [scripts](https://github.com/BaduraLab/LiveMouseTracker-Analysis/tree/main/Step%201:%20Preprocessing%20SQLite%20Database) take the SQLite file produced by the LiveMouseTracker software and process it in light of the changes made to the LMT system and experimental design of the Badura Lab.

Within the README file of this folder, instructions can be found on the final preprocessing step, before moving to processing the data using MATLAB scripts. Note that this step must be completed before moving on to Step 2.

### Step 2: Processing in MATLAB.
Before moving onto analysising LMT data in MATLAB, you must complete the final preprocessing step, for which instructions can be found in the README file associated with Step 1.

These scripts process LMT data in MATLAB, by way of extracting EVENT-related data from the SQL file and saving it as MATLAB variables. More information on these scripts can be found in the README file found in this folder.

### Step 3: Produce Graphs
After organising LMT data into groups, you can plot data using the scripts found in this folder. Each script contains information on how to implement/ modify the codes here.
