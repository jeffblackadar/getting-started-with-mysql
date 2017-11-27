library(RMySQL)
#The connection method below uses a password stored in a variable.  To use this set localuserpassword="The password of newspaper_search_results_user" 
#storiesDb <- dbConnect(MySQL(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

#optional - confirms we connected to the database
dbListTables(storiesDb)

#Assemble the query

entryTitle <- "THE LOST LUSITANIA'S RUDDER."

entryPublished <- "21 MAY 1916"
#convert the sting value to a date to store it into the database
entryPublishedDate <- as.Date(entryPublished, "%d %B %Y")

entryUrl <- "http://newspapers.library.wales/view/4121281/4121288/94/"

searchTermsSimple <- "German+Submarine"

query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used) 
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
)

#optional - prints out the query in case you need to troubleshoot it
print (query)

#execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)



