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

loessMod10 <- loess(ALT ~ year, data=df, span=0.20) # 10% smoothing span
smoothed10 <- predict(loessMod10) 

plot(df$ALT, type = "l")
plot(smoothed10, type = "l")
