setwd("./")
csv_list <- list.files(pattern = "*.csv")

data_name <- c("time","dis","pre")

data <- read.csv(csv_list[1])
data2 <- read.csv(csv_list[2])

names(data) <- data_name
names(data2) <- data_name
a=30000/4

par(mfcol=c(4,1))
plot(data$time,data$pre,xlim=c(4000,6000),type="l",xlab=c("TIME(ms)"))
plot(data$time,data$pre,xlim=c(58000,60000),type="l",xlab=c("TIME(ms)"))
plot(data2$time,data2$pre,xlim=c(8000,9000),type="l",xlab=c("TIME(ms)"))
plot(data2$time,data2$pre,xlim=c(58000,68000),type="l",xlab=c("TIME(ms)"))