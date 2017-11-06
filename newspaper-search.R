library(RMySQL)
mydb = dbConnect(MySQL(), user='newspaper_search_results_user', password=localuserpassword, dbname='newspaper_search_results', host='localhost')
dbListTables(mydb)

src_mysql_cnf(dbname = "newspaper_search_results_user", groups = "rs-dbi")

if (mysqlHasDefault()) {
  print("there is a default")
}


library(DBI)
con <- dbConnect(RMySQL::MySQL(), group = "newspapersearchresults")
