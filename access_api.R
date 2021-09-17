library(jsonlite)

base_api <- "http://192.168.8.109:8080"

tryCatch(
  fromJSON(paste0(base_api, "/status")), 
  error = function(e){
    return(as.character(e))
    }
  )

cuaca <- fromJSON(paste0(base_api, "/cuaca?Bandara=JFK"))
head(cuaca)

penerbangan <- fromJSON(paste0(base_api, "/penerbangan?Asal=JFK&Tujuan=IAH&Bulan=10&Hari=12"))
head(penerbangan)

bandara <- fromJSON(paste0(base_api, "/bandara?Bandara=IAH"))
head(bandara)

fromJSON(paste0(base_api, "/bandara?Nama=George"))
