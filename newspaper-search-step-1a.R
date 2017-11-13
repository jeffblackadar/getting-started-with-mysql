library(RMySQL)
#The connection method below uses a password stored in a variable.  To use this set localuserpassword="The password of newspaper_search_results_user" 
storiesDb <- dbConnect(MySQL(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

#optional - confirms we connected to the database
dbListTables(storiesDb)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)




