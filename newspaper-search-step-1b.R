library(RMySQL)
#The connection method below uses a password stored in a variable.  To use this set localuserpassword="The password of newspaper_search_results_user" 
#storiesDb <- dbConnect(MySQL(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

#optional - confirms we connected to the database
dbListTables(storiesDb)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)




