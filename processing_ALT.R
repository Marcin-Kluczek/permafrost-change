# NetCDF preprocessing ----------------------------------------------------
library(raster)
library(rgdal)
library(sp)
library(ncdf4)

setwd("")

#sciezka na output
export_path <- file.path(paste0(getwd(), "/OUTPUT//"))

#lista plikow w katalogu z rozszerzeniem nc
temp <- list.files(pattern="*.nc$", full.names = TRUE)
for(i in 1:length(temp)){cat(paste0(i, "\t", temp[i]), "\n")}

#otwarcie pierwszego pliku dla testu
j <- 1
nc <- ncdf4::nc_open(temp[j])

#zmienne skrotowe w pliku
variables <- names(nc[['var']])

#atrybuty pliku nc
attributes(nc)$names
#skrotowe nazwy zmiennych
attributes(nc$var)$names

print(paste("The file has",nc$nvars,"variables,",
            nc$ndims,"dimensions and",
            nc$natts,"NetCDF attributes"))


#print variables and explanation
for (i in 1:length(attributes(nc$var)$names)){
  cat(paste0(attributes(nc$var)$names[i], "\t",
             ncatt_get(nc, attributes(nc$var)$names[i])$long_name, "\t",
             ncatt_get(nc, attributes(nc$var)$names[i])$units, "\n"))
}

getNcTime <- function(nc) {
  require(lubridate)
  ncdims <- names(nc$dim) #get netcdf dimensions
  timevar <- ncdims[which(ncdims %in% c("time", "Time", "datetime", "Datetime", "date", "Date"))[1]] #find time variable
  times <- ncvar_get(nc, timevar)
  if (length(timevar)==0) stop("ERROR! Could not identify the correct time variable")
  timeatt <- ncatt_get(nc, timevar) #get attributes
  timedef <- strsplit(timeatt$units, " ")[[1]]
  timeunit <- timedef[1]
  tz <- timedef[5]
  timestart <- strsplit(timedef[4], ":")[[1]]
  if (length(timestart) != 3 || timestart[1] > 24 || timestart[2] > 60 || timestart[3] > 60 || any(timestart < 0)) {
    cat("Warning:", timestart, "not a valid start time. Assuming 00:00:00\n")
    warning(paste("Warning:", timestart, "not a valid start time. Assuming 00:00:00\n"))
    timedef[4] <- "00:00:00"
  }
  if (! tz %in% OlsonNames()) {
    cat("Warning:", tz, "not a valid timezone. Assuming UTC\n")
    warning(paste("Warning:", timestart, "not a valid start time. Assuming 00:00:00\n"))
    tz <- "UTC"
  }
  timestart <- ymd_hms(paste(timedef[3], timedef[4]), tz=tz)
  f <- switch(tolower(timeunit), #Find the correct lubridate time function based on the unit
              seconds=seconds, second=seconds, sec=seconds,
              minutes=minutes, minute=minutes, min=minutes,
              hours=hours,     hour=hours,     h=hours,
              days=days,       day=days,       d=days,
              months=months,   month=months,   m=months,
              years=years,     year=years,     yr=years,
              NA
  )
  suppressWarnings(if (is.na(f)) stop("Could not understand the time unit format"))
  timestart + f(times)
}
time <- getNcTime(nc)
min(time); max(time)



for (i in 1:length(attributes(nc$var)$names)){
  i <- 1
  variable <- as.character(attributes(nc$var)$names[i])
  name <- ncatt_get(nc, attributes(nc$var)$names[i])$long_name
  name <- gsub(" ", "-",  name , fixed = TRUE)
  file <- raster::brick(temp[j], var = variable)
  
  writeRaster(file, filename = name,
              format="GTiff", datatype='FLT4S', overwrite=TRUE)
}


for (j in 1:length(temp)){
  
  nc <- ncdf4::nc_open(temp[j])
  variable <- as.character(attributes(nc$var)$names[2])
  
  time <- getNcTime(nc)
  name <- as.character(format(as.Date(min(time)), "%Y-%m-%d"))
  name <- paste0(variable, "-", name)
  
  file <- raster::brick(temp[j], var = variable)
  nc_close(nc)
  # 
  # file[file < 0.005] <- 0
  # file[file >= 0.005] <- 1
  # 
  file <- raster::calc(file, fun = mean)
  file <- file * 100
  plot(file)
  writeRaster(file, filename = paste0("D:/JECAM_SM_2018_2022/OUTPUT/", name),
              format="GTiff", datatype='INT1U', overwrite=TRUE)
}

setwd(gsub("\\\\",  "/",  readClipboard())); cat("Working directory: ", getwd())
list_files <- list.files(pattern = "*.tif$")

poligony <- rgdal::readOGR("D:/JECAM_SM_2018_2022/OUTPUT/fishnet_25.shp")
file <- raster::brick(list_files[1])
poligony <- spTransform(poligony, file@crs)

dane <- list()
for (i in 1:length(list_files)){
  
  file <- raster::brick(list_files[i])
  data <- raster::extract(file, poligony, small = TRUE, fun = mean, na.rm = TRUE, df = TRUE)[,2]
  name <- substring(list_files[i], 7, 16)
  dane[[i]] <- c(data, name)
  
}

df <- as.data.frame(t(data.frame(dane)))
rownames(df) <- NULL
colnames(df) <- c("swvl1", "date")
df$swvl1 <- as.numeric(df$swvl1)
df$date <- as.Date(df$date)
plot(df$swvl1, type = "l")
write.csv2(df, file = "swvl2.csv", row.names = FALSE)



# Raster preprocessing ----------------------------------------------------

temp <- list.files(pattern="*.tif$")
str(temp)

images_list <- list()
for (i in 1:length(temp)){
  image <- raster::brick(temp[i])
  images_list[[i]] <- image
}

stacked_image <- stack(images_list)

writeRaster(stacked_image, file = "STACK_PERMAFROST_1997_2019.tif", 
            datatype='FLT4S', format="GTiff",
            overwrite=FALSE, progress = "text")



# Raster mean -------------------------------------------------------------


library(raster)
setwd('D:/permafrost-change/')

image <- raster::brick('PERMAFROST_ARCTIC.tif')

outlist <- list() 
nbands <- image@file@nbands

for (i in 1:nbands) { 
  outlist[[i]] <- mean(getValues(image[[i]]) ,na.rm=T) 
  print(nbands - i)
}


df <- as.data.frame(outlist)
df <- t(df)
rownames(df) <- NULL
df <- as.data.frame(df)
df$year <- c(1997:2019)
colnames(df) <- c("ALT", "year")

write.csv(df, file = "perfmafost_Arctic_ATL_mean_1997_2019.csv", row.names = FALSE )

df$ALT <- df$ALT * -1 #reverse values for underground visualistation
loessMod75 <- loess(ALT ~ year, data=df, span=0.75) # 75% smoothing span
smoothed75 <- predict(loessMod10) 

# Plot --------------------------------------------------------------------

svg("ALT.svg")
plot(df$ALT, type = "l", col='blue')
lines(smoothed75, type = "l",col='green', lwd = 3)
dev.off() 

