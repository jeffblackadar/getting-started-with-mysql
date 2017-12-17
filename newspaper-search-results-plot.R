library(RMySQL)

rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

searchTermUsed="German+Submarine"
#Query a count of the number of stories matching searchTermUsed that were published each month
query<-paste("SELECT (
  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count' 
  FROM tbl_newspaper_search_results 
  WHERE search_term_used='",searchTermUsed,"' 
  GROUP BY YEAR(story_date_published),MONTH(story_date_published) 
  ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")

rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
#Put the results of the query into a time series
qts1 = ts(dbRows$count, frequency = 12, start = c(1914, 8)) 
#Plot the qts1 time series data with line width of 3 in the color red.
plot(qts1, lwd=3,col = "red", 
     xlab="Month of the war",
     ylab="Number of newspaper stories", 
     main=paste("Number of stories in Welsh newspapers matching the search terms listed below.",sep=""),
     sub="Search term legend: Red = German+Submarine. Green = Allotment And Garden.")

searchTermUsed="AllotmentAndGarden"
#Query a count of the number of stories matching searchTermUsed that were published each month
query<-paste("SELECT (
  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count' 
  FROM tbl_newspaper_search_results 
  WHERE search_term_used='",searchTermUsed,"' 
  GROUP BY YEAR(story_date_published),MONTH(story_date_published) 
  ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")

rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)
#Put the results of the query into a time series
qts2 = ts(dbRows$count, frequency = 12, start = c(1914, 8))
#Add this line with the qts2 time series data to the the existing plot 
lines(qts2, lwd=3,col="darkgreen")

dbDisconnect(storiesDb)