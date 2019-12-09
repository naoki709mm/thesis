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

pdf("plot.pdf",width=210,height=297) #A4のミリ
par(mfrow=c(5,3))
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
      else
        a<-a-1
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
      else
        a<-a-1
    }
    pre_time <- pre_time[-1]

    for(i in 1:length(pre_time)){
      if(pre_time[i] <= 300){
        pre_time[i] <- pre_time[i]*2
      }
    }
    
    #ミスしたら+-3の周りの値の平均をとる
    for(i in 1:length(pre_time)){
      if(pre_time[i] >= 650){
        pre_time[i] <- pre_time[i]/2
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
    
    smooth_pre <- c()
    for(i in 0:(length(pre_time)-smooth)){
      temp <- 0
      for(j in 0:(smooth-1)){
        temp <- temp+pre_time[(i+j)]
      }
      smooth_pre <- append(smooth_pre,c(temp/smooth)) 
    }
    
    plot(smooth_pre,type="l",ylim=c(450,550))
    par(new=T)
    abline(v=pre_met)
    abline(h=500)
  }
}
dev.off()