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

pdf("pre_smooth.pdf",width=210,height=297) #A4のミリ
par(mfrow=c(15,3))
for(k in 1:5){
  for(l in 0:2){
    pre <- data[,3,l*5+k]
    dis <- data[,2,l*5+k]
    time <- data[,1,l*5+k]
    
    under_pre <- 1000
    under_dis <- 65
    
    #距離のタッピング判定
    a <- 0
    temp <- 0
    dis_met <- 0
    reset <- 0 #一度1000以下になるまで
    r_time <- 0 #100ms秒1000以下
    dis_time <- c()
    for(i in 1:length(dis)){
      if(a == 0){
        if(dis[i] <= under_dis){
          dis_time <- append(dis_time,c(time[i]-temp))
          temp <- time[i]
          a <- 20 #100ms以内の判定はしない
          if(i < 1600){
            dis_met <- dis_met+1
          }
        }
      }
      else{
        a<-a-1
      }
    }
    dis_time <- dis_time[-1]
    
    #圧力センサのタッピング判定
    a=0
    temp=0
    pre_met <- 0
    pre_time <- c()
    for(i in 1:length(pre)){
      if(a == 0){
        if(pre[i] <= under_pre){
          pre_time <- append(pre_time,c(time[i]-temp))
          temp <- time[i]
          a <- 20
          if(i < 1600){
            pre_met <- pre_met+1
          }
        }
      }
      else{
        if(pre[i] > under_pre)
          a<-a-1
      }
    }
    pre_time <- pre_time[-1]

    i <- 1
    while(is.na(pre_time[i]) == FALSE){
      if(pre_time[i] <= 300){
        pre_time[i] <- pre_time[i]+pre_time[i+1]
        pre_time <- pre_time[-(i+1)]
      }
      else if(pre_time[i] >= 800){
        pre_time[i] <- pre_time[i]-500
      }
      i <- i+1
    }
    for(i in 1:length(pre_time)){
      pre_time[i] <- pre_time[i]-500
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
    
    smooth_pre <- c()
    for(i in 0:(length(pre_time)-smooth)){
      temp <- 0
      for(j in 0:(smooth-1)){
        temp <- temp+pre_time[(i+j)]
      }
      smooth_pre <- append(smooth_pre,c(temp/smooth)) 
    }
    
    par(mar = c(0,20,20,20))
    plot(smooth_pre,type="l",lwd=10,ylim=c(-50,50))
    par(new=T)
    abline(v=pre_met)
    abline(h=0,col="red")
    abline(h=25,lty=3)
    abline(h=-25,lty=3)
  }
}
dev.off()