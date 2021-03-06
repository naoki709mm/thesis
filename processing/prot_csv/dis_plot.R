setwd("./")
csv_list <- list.files(pattern = "*.csv")

temp <- read.csv(csv_list[1])
data <- array(dim=c(length(temp[,1,]),3,length(csv_list)))

for(i in 1:length(csv_list)){
  for(j in 1:3){
    temp <- read.csv(csv_list[i])[,j,]
    data[,j,i] <- temp
  }
}

quat <- 500
pdf("dis.pdf",width=30,height=21) #A4のミリ
par(mfrow=c(3,1)) 
for(k in 1:5){
  for(l in 0:2){
    pre <- data[,3,l*5+k]
    dis <- data[,2,l*5+k]
    time <- data[,1,l*5+k]

    ave_dis <- c()
    for(i in 1:(length(dis)-quat)){
      temp <- quantile(dis[i:(i+quat)])[2]
      ave_dis <- append(ave_dis,temp)
    }

    par(mai = c(10,10,0,0),mgp=c(4.0,1,0))
    plot(dis,type="l",ylim=c(20,140))
    par(new=T)
    abline(v=1600)
    par(new=T)
    plot(ave_dis,type="l",ylim=c(20,140))
    
  }
}

dev.off()