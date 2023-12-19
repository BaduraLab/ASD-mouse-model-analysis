function[results_All_BehavType, results_All, results_animalData] = ProcessSQL_obj(dbfile)
% This function processes the SQL file and organises the data relating to each mouse

% Connect to the file
conn            =       sqlite(dbfile);

% Extract data from SQL (runs and SQL query on the database)
sqlquery_soloEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA FROM EVENT WHERE NAME IS 'WallJump' OR NAME IS 'Move isolated' OR NAME IS 'Rear isolated' OR NAME IS 'SAP' OR NAME IS 'Stop isolated' OR NAME IS 'Huddling' OR NAME IS 'Move in contact' OR NAME IS 'Rear in contact' OR NAME IS 'Stop in contact' OR NAME IS 'Group 3 make' OR NAME IS 'Group 3 break' OR NAME IS 'Group 4 make' OR NAME IS 'Group 4 break' OR NAME IS 'NovObj Interact' OR NAME IS 'NovObj Zone' OR NAME IS 'NovObj Stop'";
sqlquery_dyadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB FROM EVENT WHERE NAME IS 'Contact' OR NAME IS 'Oral-oral Contact' OR NAME IS 'Side by side Contact' OR NAME IS 'Side by side Contact, opposite way' OR NAME IS 'Group2' OR NAME IS 'Oral-genital Contact' OR NAME IS 'Approach' OR NAME IS 'Approach contact' OR NAME IS 'Social approach' OR NAME IS 'Approach rear' OR NAME IS 'Break contact' OR NAME IS 'Social escape' OR NAME IS 'FollowZone Isolated' OR NAME IS 'Train2' OR NAME IS 'seq oral geni - oral oral' OR NAME IS 'seq oral oral - oral genital'";
sqlquery_triadicEvents = "SELECT NAME, STARTFRAME, ENDFRAME, IDANIMALA, IDANIMALB, IDANIMALC FROM EVENT WHERE NAME IS 'Group3' OR NAME IS 'Train3'";

% Fetching data, and adding columns of "0"s so that we can concatenate the data
    %%% Explanation: MATLAB only concatenates matrices if they have the
    %%% same number of columns, which, by adding columns of 0's, they will be
results_solo                =   fetch(conn, sqlquery_soloEvents);
results_solo_BehavType      =   results_solo(:,1);
results_solo                =   cell2mat(results_solo(:, 2:end));
results_solo                =   [results_solo, zeros(size(results_solo,1),3)];

results_dyadic              =   fetch(conn, sqlquery_dyadicEvents);
results_dyadic_BehavType    =   results_dyadic(:,1);
results_dyadic              =   cell2mat(results_dyadic(:, 2:end));
results_dyadic              =   [results_dyadic, zeros(size(results_dyadic,1),2)];

results_triadic             =   fetch(conn, sqlquery_triadicEvents);
results_triadic_BehavType   =   results_triadic (:,1);
results_triadic             =   cell2mat(results_triadic(:, 2:end));
results_triadic             =   [results_triadic, zeros(size(results_triadic,1),1)];


% Concatenate all data
results_All = vertcat(results_solo, results_dyadic, results_triadic);
results_All_BehavType = vertcat(results_solo_BehavType, results_dyadic_BehavType, results_triadic_BehavType);

% Extract data concerning animal identity
AnimalData                  =   'SELECT ID, RFID, GENOTYPE, NAME FROM ANIMAL';
results_animalData          =   fetch(conn , AnimalData);

end
