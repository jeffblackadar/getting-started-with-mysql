library(RMySQL)

#setwd("C:/a_orgs/carleton/hist3814/R/graham_fellowship")

#R needs a full path to find the settings file
rmysql.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 5.7\\newspaper_search_results.cnf"

rmysql.db<-"newspaper_search_results"
storiesDb<-dbConnect(RMySQL::MySQL(),default.file=rmysql.settingsfile,group=rmysql.db) 


# to run this, in your R working directory make a directory that matches the variable "workingSubDirectory" (or change below)

setwd("C:/a_orgs/carleton/hist3814/R/getting-started-with-mysql")
newspaperArchiveName = "National Library of Wales, Welsh Newspapers Online"
searchBaseURL <- "http://newspapers.library.wales/"
searchDateRangeMin <- "1914-08-03"
searchDateRangeMax <- "1918-11-20"
searchDateRange <- paste("&range%5Bmin%5D=",searchDateRangeMin,"T00%3A00%3A00Z&range%5Bmax%5D=",searchDateRangeMax,"T00%3A00%3A00Z",sep="")

# searchTerms = paste("search?alt=full_text%3A%22","allotment","%22+","AND","+full_text%3A%22","society","%22+","OR","+full_text%3A%22","societies","%22",sep="")
# searchURL = paste(searchBaseURL,searchTerms,searchDateRange,sep="")
# print(searchURL) 
# workingSubDirectory = "wales2"
#?alt=full_text%3A"Food+Production+society"+OR+full_text%3A"Food+Production+societies"
#searchTerms <- paste("search?alt=full_text%3A","%22Food+Production+society%22","OR","+full_text%3A","%22Food+Production+societies%22",sep="")


#German Submarine
searchTerms <- paste("search?alt=full_text%3A","%22German+Submarine%22",sep="")
searchTermsSimple <- "German+Submarine"
searchURL <- paste(searchBaseURL,searchTerms,searchDateRange,sep="")
print(searchURL)
workingSubDirectory <- "working"


#Allotment Garden
#?alt=full_text%3A"Allotment"+AND+full_text%3A"Garden"
#searchTerms <- paste("search?alt=full_text%3A","%22Allotment%22+AND+full_text%3A%22Garden%22",sep="")
#searchTermsSimple <- "AllotmentAndGarden"
#searchURL <- paste(searchBaseURL,searchTerms,searchDateRange,sep="")
#print(searchURL)
#workingSubDirectory <- "allotment-garden"




#hist4500-royal-horticultural-society
# searchTerms = paste("search?alt=full_text%3A","%22royal+horticultural+society%22",sep="")
# searchURL = paste(searchBaseURL,searchTerms,searchDateRange,sep="")
# print(searchURL) 
# workingSubDirectory = "hist4500-royal-horticultural-society"


### functions
# function generates a footnote close to the Chicago style - each footnote will need editing for italics, spelling and punctuation.
generateFootNote<-function(articleTitle,newspaperName, editionDate, ArchiveName, articleURL){
  
  # Example from 
  # Chicago-Style Citation for Assignments in History: Notes & Bibliography Format (2015-2016)
  #“The Coming of Calgary: The Future Chicago of Western Canada,” The Times, January 25,
  #1912, The Times Digital Archive 1785-1985.
  
  return(paste(articleTitle,", ",newspaperName,", ", editionDate,", ", ArchiveName,", ",articleURL,", Accessed ", format(Sys.Date(), "%b %d %Y"),sep=""))
}


outputFileCsv <- paste(workingSubDirectory,"/1",workingSubDirectory,"_papers.csv",sep="")
outputFileCsvCon<-file(outputFileCsv, open = "w")
lineOut<-paste("\"Entry Number","\",\"","Entry Id","\"","Entry Url","\",\"", "Newspaper Title","\",\"","Article Title","\",\"","Entry Updated","\",\"","Date Published","\",\"","Page Number","\",\"","Citation","\",\"","Article start","\",\"","Notice Text","\"",sep="")
writeLines(lineOut,outputFileCsvCon)

sampleDataFileCsv <- paste(workingSubDirectory,"/1",workingSubDirectory,"_sample_data.csv",sep="")
sampleDataFileCsvCon<-file(sampleDataFileCsv, open = "w")
lineOut<-paste("\"story_title\",\"story_date_published\",\"story_url\",\"search_term_used\"",sep="")
writeLines(lineOut,sampleDataFileCsvCon)


outputFileHTMLList <- paste(workingSubDirectory,"/1",workingSubDirectory,"_papers.html",sep="")
outputFileHTMLListCon<-file(outputFileHTMLList, open = "w")

#thanks to
#https://statistics.berkeley.edu/computing/r-reading-webpages


thepage = readLines(searchURL)
# get rid of the tabs
thepage = trimws(gsub("\t"," ",thepage))

# find number of results
for (entriesCounter in 1:600){
  #print(paste(entriesCounter,thepage[entriesCounter],sep=""))
  if(thepage[entriesCounter] == '<input id=\"fl-decade-0\" type=\"checkbox\" class=\"facet-checkbox\" name=\"decade[]\" value=\"1910\"  facet />')  {
    print(thepage[entriesCounter+1])
    tmpline = thepage[entriesCounter+1]
    tmpleft = gregexpr(pattern ='"1910',tmpline)
    tmpright = gregexpr(pattern ='</span>',tmpline)
    numberResults = substr(tmpline, tmpleft[[1]]+8, tmpright[[1]]-2)
    numberResults = trimws(gsub(",","",numberResults))
    numberResults = as.numeric(numberResults)
  }
}

entriesProcessed = 0
# go through each page of search results
for(gatherPagesCounter in 1:(floor(numberResults/12)+1)){
  #for(gatherPagesCounter in 1:3){
  
  thepage = readLines(paste(searchURL,"&page=",gatherPagesCounter,sep=""))
  # get rid of the tabs
  thepage = trimws(gsub("\t"," ",thepage))
  
  for (entriesCounter in 500:length(thepage)){
    #print(paste(entriesCounter,thepage[entriesCounter],sep=""))
    if(thepage[entriesCounter] == '<h2 class=\"result-title\">')  {
      # url
      entryId = trimws(gsub("\"","",gsub("\">","",gsub("<a href=","",thepage[entriesCounter+1]))))
      print(entryId)
      entryUrl <- paste("http://newspapers.library.wales/",entryId,sep="")
      # title
      entryTitle = trimws(gsub("</a>","",thepage[entriesCounter+2]))
      print(entryTitle)
    }
    
    if(thepage[entriesCounter] == '<ul class=\"result-meta row\">')  {
      print(thepage[entriesCounter+2])
      # title
      entryPaperTitle = trimws(gsub("</a>","",thepage[entriesCounter+3]))
      print(entryPaperTitle)
      
    }
    if(thepage[entriesCounter] == '<li id="result-meta-date" class="col-xs-6 col-sm-2 no-padding">')  {
    
      # date
      entryPublished = trimws(gsub("\"","",gsub("</span>","",thepage[entriesCounter+2])))
      print(entryPublished)
      
      # page
      entryPage=trimws(gsub("\"","",gsub("</li>","",thepage[entriesCounter+7])))
      print(entryPage)
      entryUpdated=""
      
      noticeText=""
      entriesProcessed = entriesProcessed+1
      
      #processArticleReturn=processArticleWebPage(entryUrl, entryTitle, entryId,entryPublished)
      #articleFile=processArticleReturn[1]
      
      tmpleft = gregexpr(pattern='  ',entryPublished)
      entryPublishedNumberPronounciation = substr(entryPublished, tmpleft[[1]]-2, tmpleft[[1]]-1)
      entryPublishedDate = as.Date(entryPublished, paste("%d",entryPublishedNumberPronounciation,"     %B     %Y",sep="") )
      print (entryPublishedDate)
      
      #clean up entryTitle
      entryTitle = gsub("'", "&apos;", entryTitle)
      entryTitle = gsub("’", "&apos;", entryTitle)
      entryTitle = gsub("\\", "/", entryTitle, fixed=TRUE)
      entryTitle = gsub("\"", "&quote;", entryTitle, fixed=TRUE)

      #csv of data
      footNote=generateFootNote(entryTitle,entryPaperTitle, entryPublishedDate, newspaperArchiveName, entryUrl)
      lineOut<-paste("\"",entriesProcessed,"\",\"",entryId,"\",\"",entryUrl,"\",\"",entryPaperTitle,"\",\"",entryTitle,"\",\"",entryUpdated,"\",\"",entryPublishedDate,"\",\"",entryPage,"\",\"",footNote,"\",\"",noticeText,"\"",sep="")
      print (lineOut)
      writeLines(lineOut,outputFileCsvCon)
      
      #sample data
      lineOut<-paste("\"",entryTitle,"\",\"",entryPublishedDate,"\",\"",entryUrl,"\",\"",searchTermsSimple,"\"",sep="")
      writeLines(lineOut,sampleDataFileCsvCon)
      
      #html file
      writeLines(paste(entriesProcessed,"<a href=\"",entryUrl," ","\">","web","</a> ",entryTitle,"  <br>",sep=""),outputFileHTMLListCon)

      
      query<-paste(
        "INSERT INTO tbl_newspaper_search_results (story_title,story_date_published,story_url,search_term_used) VALUES(LEFT(RTRIM('",entryTitle,"'),99),'",entryPublishedDate,"',LEFT(RTRIM('",
        entryUrl,
        "'),99),'",searchTermsSimple,"')",
        sep = ''
      )
      print (query)
      rsInsert = dbSendQuery(storiesDb, query)

    }
  }
  
  # thanks to https://stackoverflow.com/questions/1174799/how-to-make-execution-pause-sleep-wait-for-x-seconds-in-r
  # wait 3 seconds - don't stress the server
  p1 <- proc.time()
  Sys.sleep(3)
  proc.time() - p1
  
  
}

close(outputFileCsvCon)
close(outputFileHTMLListCon)
close(sampleDataFileCsvCon)
dbDisconnect(storiesDb)

#select year(tbl_newspaper_search_result_date_published),month(tbl_newspaper_search_result_date_published),count(concat(month(tbl_newspaper_search_result_date_published)," ",year(tbl_newspaper_search_result_date_published))) from tbl_newspaper_search_results group by year(tbl_newspaper_search_result_date_published),month(tbl_newspaper_search_result_date_published) order by year(tbl_newspaper_search_result_date_published),month(tbl_newspaper_search_result_date_published);
