rm(list = ls())
options(stringsAsFactors = F)
library(preprocessCore)
library(parallel)
library(e1071)


load(file = 'input.Rdata')
Y[1:4,1:4]
X[1:4,1:4]
dim(X)
dim(Y)

Ylist <- as.list(data.matrix(Y))
yr <- as.numeric(Ylist[ sample(length(Ylist),dim(X)[1]) ])

yr <- (yr - mean(yr)) / sd(yr)
boxplot(yr)

out=svm(X,yr)
out
out$SV


svn_itor <- 3

y=yr
res <- function(i){
  if(i==1){nus <- 0.25}
  if(i==2){nus <- 0.5}
  if(i==3){nus <- 0.75}
  model<-svm(X,y,type="eps-regression",kernel="linear",nu=nus,scale=F,cost=3,epsilon = 1.20356403968038e-05)
  model
}

#Execute In a parallel way the SVM
if(Sys.info()['sysname'] == 'Windows') {
  
  out <- mclapply(1:svn_itor, res, mc.cores=1) 
}else {
  out <- mclapply(1:svn_itor, res, mc.cores=svn_itor)
}

out
#Initiate two variables with 0
nusvm <- rep(0,svn_itor)
corrv <- rep(0,svn_itor)


t <- 1
while(t <= svn_itor) {
  
  mySupportVectors <- out[[t]]$SV
  
  myCoefficients <- out[[t]]$coefs
  weights = t(myCoefficients) %*% mySupportVectors

  weights[which(weights<0)]<-0
  w<-weights/sum(weights)

  u <- sweep(X,MARGIN=2,w,'*')

  k <- apply(u, 1, sum)
  nusvm[t] <- sqrt((mean((k - y)^2))) 
  corrv[t] <- cor(k, y)
  t <- t + 1
}
#pick best model
rmses <- nusvm
corrv
mn <- which.min(rmses)
mn  
model <- out[[mn]]


#get and normalize coefficients

q <- t(model$coefs) %*% model$SV 

q[which(q<0)]<-0

w <- (q/sum(q))

mix_rmse <- rmses[mn]
mix_r <- corrv[mn]


newList <- list("w" = w, "mix_rmse" = mix_rmse, "mix_r" = mix_r)
newList


u <- sweep(X,MARGIN=2,w,'*') 
k <- apply(u, 1, sum)
plot(y,k)
sqrt((mean((k - y)^2))) 
cor(k, y)





CoreAlg <- function(X, y){
  

  svn_itor <- 3
  
  res <- function(i){
    if(i==1){nus <- 0.25}
    if(i==2){nus <- 0.5}
    if(i==3){nus <- 0.75}
    model<-e1071::svm(X,y,type="eps-regression",kernel="linear",nu=nus,scale=F,cost = 3, epsilon = 1.20356403968038e-05)
    model
  }
  
  if(Sys.info()['sysname'] == 'Windows') out <- parallel::mclapply(1:svn_itor, res, mc.cores=1) else
    out <- parallel::mclapply(1:svn_itor, res, mc.cores=svn_itor)
  
  nusvm <- rep(0,svn_itor)
  corrv <- rep(0,svn_itor)
  

  t <- 1
  while(t <= svn_itor) {
    weights = t(out[[t]]$coefs) %*% out[[t]]$SV
    weights[which(weights<0)]<-0
    w<-weights/sum(weights)
    u <- sweep(X,MARGIN=2,w,'*')
    k <- apply(u, 1, sum)
    nusvm[t] <- sqrt((mean((k - y)^2)))
    corrv[t] <- cor(k, y)
    t <- t + 1
  }
  
  rmses <- nusvm
  mn <- which.min(rmses)
  model <- out[[mn]]
  

  q <- t(model$coefs) %*% model$SV
  q[which(q<0)]<-0
  w <- (q/sum(q))
  
  mix_rmse <- rmses[mn]
  mix_r <- corrv[mn]
  
  newList <- list("w" = w, "mix_rmse" = mix_rmse, "mix_r" = mix_r)
  
}

