library(RMySQL)
#The connection method below uses a password stored in a variable.  To use this set localuserpassword="The password of newspaper_search_results_user" 
#storiesDb <- dbConnect(MySQL(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

#optional - confirms we connected to the database
dbListTables(storiesDb)

query<-"INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used) 
VALUES('THE LOST LUSITANIA.',
       '1915-05-21',
       LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
       'German+Submarine');"

#optional - prints out the query in case you need to troubleshoot it
print (query)

#execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)



rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 
#query<-"select (((year(story_date_published)-1914)*12)+month(story_date_published)) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) from tbl_newspaper_search_results group by year(story_date_published),month(story_date_published) order by year(story_date_published),month(story_date_published);"
query<-"SELECT (concat('1 ',month(story_date_published),' ',year(story_date_published))) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results WHERE search_term_used='German+Submarine' GROUP BY year(story_date_published),month(story_date_published) ORDER BY year(story_date_published),month(story_date_published);"
#query<-"select count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results group by year(story_date_published),month(story_date_published) order by year(story_date_published),month(story_date_published);"

rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

dbRows$month = as.Date(dbRows$month,"%d %m %Y")

ts2 = ts(dbRows$count, frequency = 12, start = c(1914, 8)) 

#plot(ts2, "Month of the war","Number of newspaper stories")
plot(ts2, xlab="Month of the war",ylab="Number of newspaper stories", main="Number of stories in Welsh Newspapers matching the search German+Submarine",sub="For each month of World War I.")

query<-"SELECT (((year(story_date_published)-1914)*12)+month(story_date_published)) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) FROM tbl_newspaper_search_results WHERE search_term_used='German+Submarine' GROUP BY year(story_date_published),month(story_date_published) order by year(story_date_published),month(story_date_published);"
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
dbRows

#plot(dbRows, type="l",(((dbRows[1]-1)%%12)+1))
plot(dbRows, "Month of the war","Number of newspaper stories",type="l")


dbDisconnect(storiesDb)


