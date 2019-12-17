detect.peaks <- function(res,thres,pwidth,type="min") {
  len <- length(res)
  if (type == "min") {
    res[res>thres] <- thres
  } else {
    res[res<thres] <- thres
  }
  dif <- res[2:len]-res[1:(len-1)]
  ddif <- dif[2:(len-1)]*dif[1:(len-2)]
  print(dif)
  plot(dif,type="l")
  ppos <- c()
  while (TRUE) {
    p <- which.min(ddif)
    if (ddif[p] == 0) break
    if (length(ppos)>0) {
      q <- abs(ppos-p)
      if (min(q) > pwidth) {
        ppos <- c(ppos,p)
      }
    } else {
      ppos <- c(ppos,p)
    }
    ddif[p] <- 0
  }
  ppos+1
}