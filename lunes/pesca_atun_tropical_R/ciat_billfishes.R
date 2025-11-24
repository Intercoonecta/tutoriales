library(satin)
 data(dmap)
detach(package:satin)

library(sp)
library(lubridate)
library(PBSmapping)

pic <- read.csv("PublicPSBillfishSetType.csv")
pic <- pic[pic$Year > 2017, ]
pic$fecha <- strptime(paste(pic$Year, pic$Month, 1, sep ="-"), format = "%Y-%m-%d")
pic$qtr <- quarter(pic$fecha)

# agregar tipos de indicador
pic2 <- aggregate(pic[, 6:13], by = list(Year = pic$Year, Month = pic$Month, 
                                         LatC1 = pic$LatC1, LonC1 = pic$LonC1), sum)
pic2$fecha <- strptime(paste(pic2$Year, pic2$Month, 1, sep ="-"), format = "%Y-%m-%d")
pic2$qtr <- quarter(pic2$fecha)

# agregar por trimestre
pic3 <- aggregate(pic2[, 5:12], by = list(Year = pic2$Year, qtr = pic2$qtr, 
                                          LatC1 = pic2$LatC1, LonC1 = pic2$LonC1), sum)






spp <- names(pic)[7:13]
spp

library(maps)

for(sp in spp){  
 x11()
 plot(pic$LonC1[pic[, sp] > 0], pic$LatC1[pic[, sp] > 0], asp = 1, main = sp)
 plot(dmap, axes = TRUE, ylim = c(22, 28), xlim = c(-115, -109), 
      col = "grey90", main = "", las = 1, lwd = 0.5, border = "grey", add = TRUE)
 #, xaxt = xaxs[i-2017], yaxt = yaxs[i-2017])
 box()
}




x11()
plot(dmap, axes = TRUE, ylim = c(22, 28), xlim = c(-115, -109), 
     col = "grey90", main = "", las = 1, lwd = 0.5, border = "grey")
     #, xaxt = xaxs[i-2017], yaxt = yaxs[i-2017])
box()
points(pic$LonC1[pic$MLS > 0], pic$LatC1[pic$MLS > 0])



attach(pic3)

cyq <- expand.grid(1:4, 2018:2024)
names(cyq) <- c("qtr", "year")

xaxs2 <- c("n", "n", "n", "n",
           "n", "n", "n", "n",
           "n", "n", "n", "n",
           "n", "n", "n", "n",
           "n", "n", "n", "n",
           "n", "n", "n", "n",
           "s", "n", "s", "n")

yaxs2 <- c("s", "n", "n", "n",
           "n", "n", "n", "n",
           "s", "n", "n", "n",
           "n", "n", "n", "n",
           "s", "n", "n", "n",
           "n", "n", "n", "n",
           "s", "n", "n", "n")

## Esfuerzo
x11(height = 10, width = 7)
layout(matrix(1:28, ncol = 4, byrow = TRUE))
par(oma = c(4.5, 4.5, 1, 3), mar = c(0, 0, 0, 0))


for(i in 1:28){
  plot(dmap, axes = TRUE, ylim = c(22, 28), xlim = c(-115, -109), 
       col = "grey90", main = "", las = 1, lwd = 0.5, border = "grey",
       xaxt = xaxs2[i], yaxt = yaxs2[i])
  box(); text(-114, 23, paste(cyq$year[i], "_Q", cyq$qtr[i], sep =""))
  
  dat <- pic3[pic3$Year == cyq$year[i] & pic3$qtr == cyq$qtr[i], c('LonC1', 'LatC1', 'NumSets')]
  names(dat) <- c("X", "Y", "Z")
  n <- nrow(dat)
  if(n > 0){
    dat <- data.frame(EID = 1:n, dat)
    class(dat) <- c("EventData", "data.frame")
    addBubbles(dat, legend.pos = NULL, z.max = 369, max.size = 0.8)
  }
}

## MLS
x11(height = 10, width = 7)
layout(matrix(1:28, ncol = 4, byrow = TRUE))
par(oma = c(4.5, 4.5, 1, 3), mar = c(0, 0, 0, 0))


for(i in 1:28){
  plot(dmap, axes = TRUE, ylim = c(22, 28), xlim = c(-115, -109), 
       col = "grey90", main = "", las = 1, lwd = 0.5, border = "grey",
       xaxt = xaxs2[i], yaxt = yaxs2[i])
  box(); text(-114, 23, paste(cyq$year[i], "_Q", cyq$qtr[i], sep =""))
  
  dat <- pic3[pic3$Year == cyq$year[i] & pic3$qtr == cyq$qtr[i], c('LonC1', 'LatC1', 'MLS')]
  names(dat) <- c("X", "Y", "Z")
  n <- nrow(dat)
  if(n > 0){
    dat <- data.frame(EID = 1:n, dat)
    class(dat) <- c("EventData", "data.frame")
    addBubbles(dat, legend.pos = NULL, z.max = 63, max.size = 0.6, symbol.bg = rgb(1,0,0,0.3))
  }
}


## BIL
x11(height = 10, width = 7)
layout(matrix(1:28, ncol = 4, byrow = TRUE))
par(oma = c(4.5, 4.5, 1, 3), mar = c(0, 0, 0, 0))


for(i in 1:28){
  plot(dmap, axes = TRUE, ylim = c(22, 28), xlim = c(-115, -109), 
       col = "grey90", main = "", las = 1, lwd = 0.5, border = "grey",
       xaxt = xaxs2[i], yaxt = yaxs2[i])
  box(); text(-114, 23, paste(cyq$year[i], "_Q", cyq$qtr[i], sep =""))
  
  dat <- pic3[pic3$Year == cyq$year[i] & pic3$qtr == cyq$qtr[i], c('LonC1', 'LatC1', 'SWO')]
  names(dat) <- c("X", "Y", "Z")
  n <- nrow(dat)
  if(n > 0){
    dat <- data.frame(EID = 1:n, dat)
    if(sum(dat[, 4]) == 0){
      dat <- rbind(dat, data.frame(EID = n + 1, X = 0, Y = 0, Z = 1))
    }
    class(dat) <- c("EventData", "data.frame")
    addBubbles(dat, legend.pos = NULL, z.max = 63, max.size = 0.6, symbol.bg = rgb(1,0,0,0.3))
  }
}

