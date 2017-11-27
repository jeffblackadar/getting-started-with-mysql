library(RMySQL)
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

searchTermUsed="AllotmentAndGarden"
query<-paste("SELECT (concat('1 ',month(story_date_published),' ',year(story_date_published))) as 'month',count(concat(month(story_date_published),' ',year(story_date_published))) as 'count' from tbl_newspaper_search_results WHERE search_term_used='",searchTermUsed,"' GROUP BY year(story_date_published),month(story_date_published) ORDER BY year(story_date_published),month(story_date_published);",sep="")
print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
dbRows$month = as.Date(dbRows$month,"%d %m %Y")
qts1 = ts(dbRows$count, frequency = 12, start = c(1914, 8)) 
plot(qts1, lwd=3,col = "darkgreen", xlab="Month of the war",ylab="Number of newspaper stories", main=paste("Number of stories in Welsh Newspapers matching the search Allotment and Garden",sep=""),sub="For each month of World War I.")

dbDisconnect(storiesDb)