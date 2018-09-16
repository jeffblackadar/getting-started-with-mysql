library(RMariaDB)
# The connection method below uses a password stored in a variable.  
# To use this set localuserpassword="The password of newspaper_search_results_user" 
# storiesDb <- dbConnect(RMariaDB::MariaDB(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

#R needs a full path to find the settings file
rmariadb.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

# optional - confirms we connected to the database
dbListTables(storiesDb)

# Create the query statement
query<-"INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used) 
VALUES('THE LOST LUSITANIA.',
'1915-05-21',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'German+Submarine');"

# optional - prints out the query in case you need to troubleshoot it
print(query)

#execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# Clear the result
dbClearResult(rsInsert)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)