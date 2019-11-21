setwd("./")
csv_list <- list.files(pattern = "*.csv")

data_name <- c("real","true")

data <- read.csv(csv_list[1])
data[length(data)+1] <- 0
names(data) <- data_name
plot(data$true,data$real,xlim=c(-1,15),ylim=c(0,130),col=1,xlab="TRUE(mm)",ylab="cm")

for(i in 2:(length(csv_list))){
  data_1 <- read.csv(csv_list[i])
  data_1[length(data_1)+1] <- i-1
  names(data_1) <- data_name
  par(new = TRUE)
  plot(data_1$true,data_1$real,xlim=c(-1,15),ylim=c(0,130),col=1,xlab="",ylab="")
}
