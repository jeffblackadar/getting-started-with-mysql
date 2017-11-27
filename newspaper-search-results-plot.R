library(RMySQL)

rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

searchTermUsed="German+Submarine"
query<-paste("SELECT (concat('1 ',month(story_date_published),' ',year(story_date_published))) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results WHERE search_term_used='",searchTermUsed,"' GROUP BY year(story_date_published),month(story_date_published) ORDER BY year(story_date_published),month(story_date_published);",sep="")
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
dbRows$month = as.Date(dbRows$month,"%d %m %Y")
qts1 = ts(dbRows$count, frequency = 12, start = c(1914, 8)) 
plot(qts1, lwd=3,col = "red", xlab="Month of the war",ylab="Number of newspaper stories", main=paste("Number of stories in Welsh Newspapers matching the search ",searchTermUsed,sep=""),sub="For each month of World War I.")

searchTermUsed="AllotmentAndGarden"
query<-paste("SELECT (concat('1 ',month(story_date_published),' ',year(story_date_published))) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results WHERE search_term_used='",searchTermUsed,"' GROUP BY year(story_date_published),month(story_date_published) ORDER BY year(story_date_published),month(story_date_published);",sep="")
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
dbRows$month = as.Date(dbRows$month,"%d %m %Y")
qts2 = ts(dbRows$count, frequency = 12, start = c(1914, 8)) 
lines(qts2, lwd=3,col="darkgreen")

dbDisconnect(storiesDb)

#query<-"select count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results group by year(story_date_published),month(story_date_published) order by year(story_date_published),month(story_date_published);"
# query<-paste("SELECT (((year(story_date_published)-1914)*12)+month(story_date_published)) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) FROM tbl_newspaper_search_results WHERE search_term_used='",searchTermUsed,"' GROUP BY year(story_date_published),month(story_date_published) order by year(story_date_published),month(story_date_published);",sep="")
# rs = dbSendQuery(storiesDb,query)
# dbRows<-dbFetch(rs)
# dbRows
# 
# #plot(dbRows, type="l",(((dbRows[1]-1)%%12)+1))
# #plot(dbRows, xlab="Month of the war",ylab="Number of newspaper stories", main=paste("Number of stories in Welsh Newspapers matching the search ",searchTermUsed,sep=""),sub="For each month of World War I.",type="l")





