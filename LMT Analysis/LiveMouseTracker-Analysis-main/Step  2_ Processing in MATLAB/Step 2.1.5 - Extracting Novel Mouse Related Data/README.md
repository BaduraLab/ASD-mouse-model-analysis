This script enables us to extract data relating to the interaction of the mice with the novel mouse, on a database per database basis (i.e. each separate SQL file). It is necessary to do this separately for each batch of mice as the identity of the novel mouse will change (i.e. in some databases it will be animal 2, and others it will be animal 3 etc.).

Correctly executing this script requires you to look at the ANIMAL table in the SQLite file you are processing to work out the identity of the novel mouse (this will be a number between 1-4), and amend the code in section 2 accordingly.

**Note:** When saving these variables I add the suffix “_mouse” to the end of the variable to denote that this variable contains the data pertaining only to the interaction of the mice with the novel animal (rather than the full set of behaviours displayed by the mice over experiment).
