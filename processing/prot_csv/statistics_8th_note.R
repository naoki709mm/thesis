setwd("./")
csv_list <- list.files(pattern = "*.csv")

temp <- read.csv(csv_list[1]) #サイズ確認
data <- array(dim=c(length(temp[,1,])-1600,3,length(csv_list))) #最初の8小説を削除

for(i in 1:length(csv_list)){
  for(j in 1:3){
    temp <- read.csv(csv_list[i])[,j,]
    data[,j,i] <- temp[-1:-1600] #最初の8小説を削除
  }
}

par(mfrow=c(2,2)) 
for(k in 0:2){
  
  i=5
  pre <- data[,3,k*5+i]
  dis <- data[,2,k*5+i]
  time <- data[,1,k*5+i]
  
  under_pre <- 1000
  under_dis <- 65
  
  #距離のタッピング判定
  a=0
  temp=0
  dis_time <- c()
  for(i in 1:length(dis)){
    if(a == 0){
      if(dis[i] <= under_dis){
        dis_time <- append(dis_time,c(time[i]-temp))
        temp <- time[i]
        a <- 20 #100ms以内の判定はしない
      }
    }
    else
      a<-a-1
  }
  dis_time <- dis_time[-1]
  
  #圧力センサのタッピング判定
  a=0
  temp=0
  pre_time <- c()
  for(i in 1:length(pre)){
    if(a == 0){
      if(pre[i] <= under_pre){
        pre_time <- append(pre_time,c(time[i]-temp))
        temp <- time[i]
        a <- 20
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
      temp <- 0
      for(j in 1:3){
        temp <- temp+pre_time[i-j]+pre_time[i+j]
      }
      pre_time[i] <- temp/6
    }
  }
  
  #平滑化
  smooth_dis <- c()
  for(i in 1:length(dis_time)-10){
    temp <- 0
    for(j in 0:9){
      temp <- temp+dis_time[i+j]
    }
    smooth_dis <- append(smooth_dis,c(temp/10)) 
  }
  
  smooth_pre <- c()
  for(i in 1:length(pre_time)-10){
    temp <- 0
    for(j in 0:9){
      temp <- temp+pre_time[i+j]
    }
    smooth_pre <- append(smooth_pre,c(temp/10)) 
  }
  
  print(length(pre_time))
  plot(smooth_pre,type="l")
}