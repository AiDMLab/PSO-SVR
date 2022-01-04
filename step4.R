rm(list = ls())
options(stringsAsFactors = F)
load(file = 'input.Rdata')
Y[1:4,1:4]
X[1:4,1:4]
dim(X)
dim(Y)
library(preprocessCore)
library(parallel)
library(e1071)

header <- c('Mixture',colnames(X),"P-value","Correlation","RMSE")
print(header)
load(file = 'nulldist_perm_1000.Rdata')

output <- matrix()
itor <- 1
mix <- dim(Y)[2]
pval <- 9999

P=1000


while(itor <= mix){
  
  
  y <- Y[,itor]
  
  y <- (y - mean(y)) / sd(y)
  

  result <- CoreAlg(X, y)
  

  w <- result$w
  mix_r <- result$mix_r
  mix_rmse <- result$mix_rmse
  

  if(P > 0) {pval <- 1 - (which.min(abs(nulldist - mix_r)) / length(nulldist))}
  
 
  out <- c(colnames(Y)[itor],w,pval,mix_r,mix_rmse)
  if(itor == 1) {output <- out}
  else {output <- rbind(output, out)}
  itor <- itor + 1
  
}
head(output)


write.table(rbind(header,output), file="psosvr-Results.txt", sep="\t", row.names=F, col.names=F, quote=F)


obj <- rbind(header,output)
obj <- obj[,-1]
obj <- obj[-1,]
obj <- matrix(as.numeric(unlist(obj)),nrow=nrow(obj))
rownames(obj) <- colnames(Y)
colnames(obj) <- c(colnames(X),"P-value","Correlation","RMSE")
obj
save(obj,file = 'output_obj.Rdata')

