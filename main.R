
# sudo apt-get install libudunits2-dev
# sudo apt-get install -y  libudunits2-dev libgdal-dev libgeos-dev libproj-dev
# sudo apt-get install -y libjq-dev
# sudo apt install default-jdk gdal-bin
#renv::install("rStrava")
# renv::install("leaflet)
#renv::install("googlePolylines")


source("passwords.R")
#https://www.strava.com/settings/api

library(rStrava)
library(leaflet)
library(googlePolylines)

library(httr)
library(httpuv)
library(jsonlite)
library(xlsx)
library(magrittr)

stoken <- httr::config(token = strava_oauth(app_name, app_client_id, app_secret, app_scope="activity:read_all"))


rides_df <- read.csv(file="activities.csv") %>% 
  na.omit()
ids <- gsub(".*/(\\d+$)","\\1", rides_df$id)
ids <- ids[ids!=""]

#rides_df[52:57,]
extra <-  get_activity_list(stoken, id = ids[52:57])
load("strava_data.Rds")

my_acts <-c(my_acts, extra) 
# There may be a limit to the number of requests,  but can break it up into shorter ones.

#my_acts <- get_activity_list(stoken, id = ids)


#act_data <- compile_activities(my_acts) 

coords_list <- lapply( my_acts, function(x){ decode(x$map$polyline)})

save(my_acts, coords_list, file="strava_data.Rds")

m <- leaflet() %>% 
  addTiles()

for( df in coords_list){
  m <- addPolylines(m, data=df[[1]], lat=~lat,lng=~lon)
  
}
m

