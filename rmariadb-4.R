
library(RMariaDB)
rmariadb.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\newspaper_search_results.cnf"

rmariadb.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 

setwd("C:\\a_orgs\\carleton\\hist3814\\R\\getting-started-with-mysql")

# read in the sample data from a newspaper search of Allotment And Garden
sampleGardenData <- read.csv(file="sample-data-allotment-garden.csv", header=TRUE, sep=",")

dbWriteTable(storiesDb, value = sampleGardenData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 

# read in the sample data from a newspaper search of German+Submarine
sampleSubmarineData <- read.csv(file="sample-data-submarine.csv", header=TRUE, sep=",")

dbWriteTable(storiesDb, value = sampleSubmarineData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE ) 

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)

