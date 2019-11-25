setwd("./")
csv_list <- list.files(pattern = "*.csv")

data_name <- c("time","dis","pre")

data <- read.csv(csv_list[13])

names(data) <- data_name

a=30000/4

par(mfcol=c(4,1))
for(i in 1:4){
   plot(data$time,data$pre,xlim=c(8000+(i-1)*a,8000+i*a),ylim=c(400,1024),type="l")
}