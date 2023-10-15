# NetCDF preprocessing ----------------------------------------------------

library(raster)
library(rgdal)
library(sp)
library(ncdf4)

setwd("")

# get list of files
temp <- list.files(pattern="*.nc$", full.names = TRUE)
for(i in 1:length(temp)){cat(paste0(i, "\t", temp[i]), "\n")}

# check first file
j <- 1
nc <- ncdf4::nc_open(temp[j])

# check variables of nc file
variables <- names(nc[['var']])

# attributes of nc file
attributes(nc)$names
# shortnames of nc file variables
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

#function to retrieve NetCDF time
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

# get time of file and get start and end
time <- getNcTime(nc)
min(time); max(time)


for (j in 1:length(temp)){
  nc <- ncdf4::nc_open(temp[j])
  
  # get second variable Active layer thickness
  variable <- as.character(attributes(nc$var)$names[2])
  
  # get time
  time <- getNcTime(nc)
  name <- as.character(format(as.Date(min(time)), "%Y-%m-%d"))
  
  # create file name
  name <- paste0(variable, "-", name)
  
  # read as raster
  file <- raster::brick(temp[j], var = variable)
  nc_close(nc)

  # write as raster GeoTiff
  writeRaster(file, filename = name,
              format="GTiff", datatype='FLT4S', overwrite=TRUE)
}


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

# read raster stack with years
image <- raster::brick('STACK_PERMAFROST_1997_2019.tif')

# read polygons with Arctic
poly <- rgdal::readOGR("arctic_poly.shp")

# Check CRS and crop image by polygon to get Arctic area data
image <- projectRaster(image, crs = crs(poly))
image <- crop(image, extent(poly))
image <- mask(image, poly)

# Prepare list to store data
outlist <- list() 

# Get number of bands should be same as number of years 1997-2019 
nbands <- image@file@nbands

# Loop over years and get mean value of ALT for each of year
for (i in 1:nbands) { 
  outlist[[i]] <- mean(getValues(image[[i]]) ,na.rm=T) 
  print(nbands - i)
}

# Transform values to convenient data frame
df <- as.data.frame(outlist)
df <- t(df)
rownames(df) <- NULL
df <- as.data.frame(df)
df$year <- c(1997:2019)
colnames(df) <- c("ALT", "year")

#Write table of ALT values to csv
write.csv(df, file = "perfmafost_Arctic_ATL_mean_1997_2019.csv", row.names = FALSE )

df$ALT <- df$ALT * -1 #reverse values for underground visualistation

# Smoothing of time series by LOESS
loessMod75 <- loess(ALT ~ year, data=df, span=0.75) # 75% smoothing span
smoothed75 <- predict(loessMod10) 

# Plot --------------------------------------------------------------------

# Plot image and export as SVG
svg("ALT.svg")
plot(df$ALT, type = "l", col='blue')
lines(smoothed75, type = "l",col='green', lwd = 3)
dev.off() 

