library(RMySQL)
library(ggmap)

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
newspapersDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

setwd("C:/a_orgs/carleton/hist3814/R/getting-started-with-mysql")

query="SELECT `newspaper_title`,`newspaper_place_lat`,`newspaper_place_long` FROM `tbl_newspapers`;"
rs = dbSendQuery(newspapersDb,query)
dbRows<-dbFetch(rs)
df <- data.frame(x=dbRows$newspaper_place_long, y=dbRows$newspaper_place_lat,newspaperTitle=dbRows$newspaper_title)

#Thanks to: https://rpubs.com/jiayiliu/ggmap_examples

mapWales <- get_map(location = c(lon = -4.08292, lat = 52.4153),color = "color",source = "google",maptype = "roadmap",zoom = 8)

#D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2. The R Journal, 5(1), 144-161. URL
#http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf

#m <- get_map("New York City",zoom=14,maptype="toner",source="stamen")

ggmap(mapWales, base_layer = ggplot(aes(x = x, y = y, size = 3), data = df))  + geom_point(color="blue", alpha=0.3)
