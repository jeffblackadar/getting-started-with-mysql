sqlInsertValueClean<-function(sqlInsertValue){
  sqlInsertValue = gsub("'", "''", sqlInsertValue)
  sqlInsertValue = gsub("’", "''", sqlInsertValue)
  sqlInsertValue = gsub("\\", "/", sqlInsertValue, fixed=TRUE)
  sqlInsertValue = gsub("\"", "''", sqlInsertValue, fixed=TRUE)
  return(sqlInsertValue)
}
library(RMySQL)
library(ggmap)

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
newspapersDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 

setwd("C:/a_orgs/carleton/hist3814/R/getting-started-with-mysql")


#search this page: http://newspapers.library.wales/browse
#For these lines

#<h2 class="result-title">
#<a href="http://newspapers.library.wales/browse/3457718">

#http://newspapers.library.wales/browse/mods/4024370

thepage = readLines("http://newspapers.library.wales/browse")
# get rid of the tabs
thepage = trimws(gsub("\t"," ",thepage))

# find number of results
for (entriesCounter in 1:length(thepage)){
  
  if(thepage[entriesCounter] == '<h2 class="result-title">')  {
    print("")
    #print(thepage[entriesCounter+1])
    tmpline = thepage[entriesCounter+1]
    tmpleft = gregexpr(pattern ='wales/browse/',tmpline)
    tmpright = gregexpr(pattern ='">',tmpline)
    newspaperNumber = substr(tmpline, tmpleft[[1]]+13, tmpright[[1]]-1)
    newspaperNumber = as.numeric(newspaperNumber)
    newspaperDataUrl = paste("http://newspapers.library.wales/browse/mods/",newspaperNumber,sep="")
    print(newspaperDataUrl)
    
    
    theNewspaperDataPage = readLines(newspaperDataUrl)
    # get rid of the tabs
    theNewspaperDataPage = trimws(gsub("\t"," ",theNewspaperDataPage))
    
    #initialize temporary variables
    NewspaperDataTitle=""
    NewspaperDataSubTitle=""
    NewspaperDataCountry=""
    NewspaperDataPlace=""
    
    
    # find number of results
    for (theNewspaperDataPageCounter in 1:length(theNewspaperDataPage)){
      
      
      #Title
      if(theNewspaperDataPage[theNewspaperDataPageCounter] == '<th>Title</th>')  {
        tmpline = theNewspaperDataPage[theNewspaperDataPageCounter+1]
        tmpleft = gregexpr(pattern ='<td>',tmpline)
        tmpright = gregexpr(pattern ='</td>',tmpline)
        NewspaperDataTitle = substr(tmpline, tmpleft[[1]]+4, tmpright[[1]]-1)
        print(paste("Title: ",NewspaperDataTitle),sep="")
      }
      #Title
      if(theNewspaperDataPage[theNewspaperDataPageCounter] == '<th>Subtitle</th>')  {
        tmpline = theNewspaperDataPage[theNewspaperDataPageCounter+1]
        tmpleft = gregexpr(pattern ='<td>',tmpline)
        tmpright = gregexpr(pattern ='</td>',tmpline)
        NewspaperDataSubTitle = substr(tmpline, tmpleft[[1]]+4, tmpright[[1]]-1)
        print(paste("Subtitle: ",NewspaperDataSubTitle),sep="")
      }
      
      #country
      if(theNewspaperDataPage[theNewspaperDataPageCounter] == '<th>Place Term: Code (MARC Country Code)</th>')  {
        tmpline = theNewspaperDataPage[theNewspaperDataPageCounter+1]
        if (tmpline=='<td>wlk</td>'){
          NewspaperDataCountry="Wales"
        } else {
          if (tmpline=='<td>enk</td>'){
            NewspaperDataCountry="England"
            print("English Newspaper")
          } else {
            tmpleft = gregexpr(pattern ='<td>',tmpline)
            tmpright = gregexpr(pattern ='</td>',tmpline)
            NewspaperDataCountry = substr(tmpline, tmpleft[[1]]+4, tmpright[[1]]-1)
            print("Non Welsh Newspaper")
          }
        }
        print(paste("Country: ",NewspaperDataCountry),sep="")
      }
      #place published
      if(theNewspaperDataPage[theNewspaperDataPageCounter] == '<th>Place Term: Text</th>')  {
        tmpline = theNewspaperDataPage[theNewspaperDataPageCounter+1]
        tmpleft = gregexpr(pattern ='<td>',tmpline)
        tmpright = gregexpr(pattern ='</td>',tmpline)
        NewspaperDataPlace = substr(tmpline, tmpleft[[1]]+4, tmpright[[1]]-1)
        print(paste("Place: ",NewspaperDataPlace),sep="")
      }
      if(theNewspaperDataPage[theNewspaperDataPageCounter] == '<tr><th class="table-spacer" colspan="2">Related Item: succeeding</th></tr>'){
        #exit out of loop.  Don't want the succeeding information yet
        theNewspaperDataPageCounter = length(theNewspaperDataPage)
      }
    }
    
    
    
    #save to database
    #NewspaperDataPlaceGeoCode = geocode(paste(NewspaperDataPlace,",",NewspaperDataCountry,sep=""))
    
    NewspaperDataPlaceGeoCode <- tryCatch(
      {
        geocode(paste(NewspaperDataPlace,",",NewspaperDataCountry,sep=""))
      },
      error=function(cond) {
        geocode("Cardif, Wales")
      },
      warning=function(cond) {
        geocode("Cardif, Wales")
      },
      finally={
        #geocode("Cardif, Wales")
      }
    ) 
    
    
    
    NewspaperDataPlaceLat = NewspaperDataPlaceGeoCode[[2]]
    NewspaperDataPlaceLong = NewspaperDataPlaceGeoCode[[1]]
    query<-paste("INSERT INTO `newspaper_search_results`.`tbl_newspapers`(`newspaper_id`,`newspaper_title`,`newspaper_subtitle`,`newspaper_place`,`newspaper_country`,`newspaper_place_lat`,`newspaper_place_long`) VALUES ('",newspaperNumber,"','",sqlInsertValueClean(NewspaperDataTitle),"',LEFT(RTRIM('",sqlInsertValueClean(NewspaperDataSubTitle),"'),255),'",NewspaperDataPlace,"','",NewspaperDataCountry,"',",NewspaperDataPlaceLat,",",NewspaperDataPlaceLong,");",sep="")
    
    
    print (query)
    rsInsert = dbSendQuery(newspapersDb, query)
    
    
    # thanks to https://stackoverflow.com/questions/1174799/how-to-make-execution-pause-sleep-wait-for-x-seconds-in-r
    # wait 2 seconds - don't stress the server
    p1 <- proc.time()
    Sys.sleep(2)
    proc.time() - p1
    
    # <th>Genre ()</th>
    #   <td>English newspapers-Wales, West.</td>
    #   </tr>
    #   <tr>
    #   <th>Genre ()</th>
    #   <td>English newspapers-Wales, Mid.</td>
    #   </tr>
    #   <tr>
    #   <th>Genre ()</th>
    #   <td>English newspapers-Wales, South.</td>
    #   </tr>
    
  }
}



