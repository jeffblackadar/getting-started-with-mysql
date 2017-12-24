library(httr)

# start the authorisation process

myapp = oauth_app("twitter", key=consKey, secret=consSecret)



# sign using token and token secret

sig = sign_oauth1.0(myapp, token=token, token_secret=tokenSecret)



timeline=GET("https://api.twitter.com/1.1/search/tweets.json?q=%23cmhc&result_type=mixed", sig)



library(jsonlite)

json1 = content(timeline)

json2 = jsonlite::fromJSON(toJSON(json1))



library(ggmap)

#df<-data.frame(1,1,"place")
#names(df)<-c("x","y", "place")

for(counter in 1:length(json1$statuses)){
  print(json1$statuses[[counter]]$text)
  print(json1$statuses[[counter]]$user$name)
  print(json1$statuses[[counter]]$user$screen_name)
  print(json1$statuses[[counter]]$user$location)
  tweetPlaceGeoCode= geocode(json1$statuses[[counter]]$user$location)
  NewspaperDataPlaceLat = tweetPlaceGeoCode[[2]]
  NewspaperDataPlaceLong = tweetPlaceGeoCode[[1]]
  if(counter==1){
    df<-data.frame(NewspaperDataPlaceLong,NewspaperDataPlaceLat,json1$statuses[[counter]]$user$location)
    names(df)<-c("x","y", "place")
  }else{
  de<-data.frame(NewspaperDataPlaceLong,NewspaperDataPlaceLat,json1$statuses[[counter]]$user$location)
  names(de)<-c("x","y", "place")
  df <- rbind(df, de) 
  }
}

#opens a map of Wales
mapCanada <- get_map(location = c(lon = -95.08292, lat = 49.4153),color = "color",source = "google",maptype = "roadmap",zoom = 3)

ggmap(mapCanada, base_layer = ggplot(aes(x = x, y = y,size = 3), data = df)) + geom_point(color="blue", alpha=0.3)




