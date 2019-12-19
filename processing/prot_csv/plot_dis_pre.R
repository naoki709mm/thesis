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

labels <- c("a","b","c","d","e")
instruct <- c("Non-instruct","Bigger","smaller")

pdf("plot_dis_pre.pdf",width=30,height=21) #A4のミリ
par(mfrow=c(2,1))
for(k in 1:5){
  for(l in 0:2){
    pre <- data[,3,l*5+k]
    dis <- data[,2,l*5+k]
    time <- data[,1,l*5+k]
    for(i in 0:1){
	    temp <- 100000/2

	    plot(time,pre,type="l",ylim=c(500,1100),xlim=c((temp*i),(temp*(i+1))),xlab="time",ylab="pre",lwd=1,bty = "o",axes=FALSE)
	 	
	    axis(1)
	    axis(2)
	    par(new=T)
	    plot(time,dis,type="l",ylim=c(10,150),xlim=c((temp*i),(temp*(i+1))),xlab="",ylab="",col="red",lwd=1,bty = "o",axes=FALSE)
	   	
	    mtext("dis",side=4,line=3)
	    axis(4)
	  	legend("topleft", legend=paste(labels[k],"_",instruct[l+1],sep=""),cex=2.0)
	}
  }
}

dev.off()