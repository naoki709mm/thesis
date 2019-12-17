setwd("./")
csv_list <- list.files(pattern = "*.csv")

temp <- read.csv(csv_list[1]) #サイズ確認
data <- array(dim=c(length(temp[,1,]),3,length(csv_list))) #最初の8小説を削除

for(i in 1:length(csv_list)){
  for(j in 1:3){
    temp <- read.csv(csv_list[i])[,j,]
    data[,j,i] <- temp
  }
}

#平滑化の数
smooth <- 10
quat <- 500
pdf("dis_time.pdf",width=210,height=297) #A4のミリ
par(mfrow=c(5,3))
for(k in 1:5){
  for(l in 0:2){
    pre <- data[,3,l*5+k]
    dis <- data[,2,l*5+k]
    time <- data[,1,l*5+k]
    
    #距離のタッピング判定
    ave_dis <- c()
    for(i in 1:(length(dis)-quat)){
      temp <- quantile(dis[i:(i+quat)])[2]
      ave_dis <- append(ave_dis,temp)
    }

    a <- 0
    temp <- 0
    dis_met <- 0
    dis_time <- c()
    for(i in 1:length(ave_dis)){
      if(a == 0){
        if(dis[i] <= ave_dis[i]){
          dis_time <- append(dis_time,c(time[i]-temp))
          temp <- time[i]
          a <- 20 #100ms以内の判定はしない
          if(i < 1600){
            dis_met <- dis_met+1
          }
        }
      }
      else{
        if(dis[i] < ave_dis[i]){
          a<-a-1
        }
      }
    }
    dis_time <- dis_time[-1]

    for(i in 1:length(dis_time)){
      if(dis_time[i] <= 350){
        dis_time[i] <- dis_time[i]-250
      }
      else if(dis_time[i] >= 650){
        dis_time[i] <- dis_time[i]-1000
      }
      else{
        dis_time[i] <- dis_time[i]-500
      }
    }
    
    #平滑化
    smooth_dis <- c()
    for(i in 0:(length(dis_time)-smooth)){
      temp <- 0
      for(j in 0:(smooth-1)){
        temp <- temp+dis_time[(i+j)]
      }
      smooth_dis <- append(smooth_dis,c(temp/smooth)) 
    }
    
    plot(dis_time,type="l",ylim=c(-150,150))
    par(new=T)
    abline(v=dis_met)
    abline(h=0)
  }
}
dev.off()