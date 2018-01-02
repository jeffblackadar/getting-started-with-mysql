library(RMySQL)
library(ggmap)
#D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2. The R Journal, 5(1), 144-161. URL
#http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
newspapersDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

setwd("C:/a_orgs/carleton/hist3814/R/getting-started-with-mysql")

query="SELECT `newspaper_title`,`newspaper_place_lat`,`newspaper_place_long` FROM `tbl_newspapers`;"
rs = dbSendQuery(newspapersDb,query)
dbRows<-dbFetch(rs)
df <- data.frame(x=dbRows$newspaper_place_long, y=dbRows$newspaper_place_lat,newspaperTitle=dbRows$newspaper_title)

#opens a map of Wales
mapWales <- get_map(location = c(lon = -4.08292, lat = 52.4153),color = "color",source = "google",maptype = "roadmap",zoom = 8)

library(ggrepel)
ggmap(mapWales, base_layer = ggplot(aes(x = x, y = y, size = 3), data = df))  + geom_point(color="blue", alpha=0.3) + geom_text_repel(aes(x = x, y = y, size = 3, label=""), data = df,box.padding = unit(0.5, "lines"))
dbDisconnect(newspapersDb)

# will want to use this to get plot newspapers we have used in a search
#SELECT tbl_newspapers.newspaper_title as newspaper_title,tbl_newspapers.newspaper_place,tbl_newspapers.newspaper_country , tbl_newspaper_search_results.newspaper_id as newspaper_id  FROM tbl_newspaper_search_results left join tbl_newspapers on tbl_newspaper_search_results.newspaper_id = tbl_newspapers.newspaper_id where true group by newspaper_id order by newspaper_title;
