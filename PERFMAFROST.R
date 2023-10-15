setwd(gsub("\\\\",  "/",  readClipboard()))
cat("Working directory: ", getwd())

obraz <- raster::brick('PERMAFROST_ARCTIC.tif')

outlist <- list() 
liczba_kanalow <- obraz@file@nbands
for (i in 1:liczba_kanalow ) { 
  outlist[[i]] <- mean(getValues(obraz[[i]]) ,na.rm=T) 
  print(liczba_kanalow  - i)
}
df <- as.data.frame(outlist)
df <- t(df)
rownames(df) <- NULL
df <- as.data.frame(df)
df$year <- c(1997:2019)
colnames(df) <- c("ALT", "year")

df$ALT <- df$ALT * -1
loessMod10 <- loess(ALT ~ year, data=df, span=0.75) # 10% smoothing span
smoothed10 <- predict(loessMod10) 

plot(df$ALT, type = "l", col='blue')
lines(smoothed10, type = "l",col='red', lwd = 3)
lines(smoothed10, type = "l",col='green', lwd = 3)


library(zoo)
df <- read.csv('Perfmafost_Arctic_ATL.csv')
plot(data$ALT, type = "l", main='Simple Moving Average (SMA)',ylab='')
lines(rollmean(data$ALT,5), col='blue')
lines(rollmean(data$ALT,2),col='red')

