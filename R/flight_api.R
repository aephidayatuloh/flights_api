
# Load packages -----------------------------------------------------------

library(plumber)
library(dplyr)
library(nycflights13)


# Global data -------------------------------------------------------------

flight_dt <- flights %>% 
  left_join(weather, by = c("year", "month", "day", "hour", "time_hour", "origin"))


# API ---------------------------------------------------------------------

#* @apiTitle Data Penerbangan NYC 2013 
#* @apiVersion 1.0.0 
#* @apiDescription API untuk mengakses data penerbangan NYC 2013

#* Status API Penerbangan. 
#* @get /ping
status <- function(){
  data.frame(
    code = 200L, 
    status = "Running", 
    time = Sys.time(), 
    version = "1.0.0",
    plumber_version = as.character(packageVersion("plumber")), 
    r_version = substring(R.version.string, 11)
  )
}

#* Mengambil Data Penerbangan.
#* @param Asal Kode bandara asal
#* @param Tujuan Kode bandara tujuan. Default null.
#* @param Bulan Bulan data penerbangan. Nilainya 1-12.
#* @param Hari Tanggal data penerbangan. Nilainya 1-31.
#* @param Jam Jam penerbangan. Nilainya 0-24.
#* @get /penerbangan 
flight_filter <- function(Asal, Tujuan = "", Bulan = "", Hari = "", Jam = ""){
  Asal <- paste(Asal)
  if(Tujuan == ""){
    Tujuan <- unique(flight_dt$dest)
  } else {
    Tujuan <- paste(Tujuan)
  }
  if(Bulan == ""){
    Bulan <- unique(flight_dt$month)
  } else {
    Bulan <- as.numeric(Bulan)
  } 
  if(Hari == ""){
    Hari <- unique(flight_dt$day)
  } else {
    Hari <- as.numeric(Hari)
  } 
  if(Jam == ""){
    Jam <- unique(flight_dt$hour)
  } else {
    Jam <- as.numeric(Jam)
  }
  
  flight_dt %>% 
    filter(origin %in% Asal & dest %in% Tujuan & month %in% Bulan & day %in% Hari & hour %in% Jam) %>% 
    select(origin, dest, month, day, hour, time_hour, sched_dep_time, carrier, flight, tailnum, distance, 
           temp, dewp, humid, wind_dir, wind_speed, wind_gust, precip, pressure, visib)
}

#* Data Cuaca Bandara Asal.
#* @param Bandara Kode bandara.
#* @param Bulan Bulan data cuaca. Nilainya 1-12.
#* @param Hari Tanggal data cuaca. Nilainya 1-31.
#* @param Jam Jam data cuaca. NIlainya 0-24.
#* @get /cuaca
function(Bandara, Bulan = "", Hari = "", Jam = ""){
   if(Bulan == ""){
    Bulan <- unique(flight_dt$month)
  } else {
    Bulan <- as.numeric(Bulan)
  } 
  if(Hari == ""){
    Hari <- unique(flight_dt$day)
  } else {
    Hari <- as.numeric(Hari)
  } 
  if(Jam == ""){
    Jam <- unique(flight_dt$hour)
  } else {
    Jam <- as.numeric(Jam)
  }
  
  weather %>% 
    filter(origin %in% Bandara & month %in% Bulan & day %in% Hari & hour %in% Jam)
}

#* Kode dan Nama Bandara.
#* @param Bandara Kode bandara.
#* @param Nama Teks bagian dari nama bandara.
#* @get /bandara
function(Bandara = "", Nama = ""){
  if(Bandara == "" & Nama == ""){
    result <- airports
  } else if(Bandara != "" & Nama == ""){
    result <- airports %>% 
      filter(faa %in% Bandara)
  } else if(Bandara == "" & Nama != ""){
    result <- airports %>% 
      filter(grepl(Nama, name))
  } else {
    result <- airports %>% 
      filter(faa %in% Bandara | grepl(Nama, name))
  }
  
  return(result)
}

