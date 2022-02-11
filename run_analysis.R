library(dplyr)

Xtest<-read.table("X_test.txt")
Xtrain<-read.table("X_train.txt")
Ytrain<-read.table("Y_train.txt")
Ytest<-read.table("Y_test.txt")
Subtest<-read.table("subject_test.txt")
Subtrain<-read.table("Subject_train.txt")
features<-read.table("features.txt")

df<-full_join(Xtrain, Xtest)

Ytrain<-rename(Ytrain, activity = V1)
Subtrain<-rename(Subtrain, subject = V1)
Subtest<-rename(Subtest, subject = V1)
Ytest<-rename(Ytest, activity = V1)

train<-cbind(Ytrain,Subtrain)
test<-cbind(Ytest,Subtest)
col12<-full_join(train,test)
newdf<-cbind(col12,df)

x<-c("activity","subject", features[,2])
colnames(newdf)<-x
cleandf<-newdf[,grepl("activity|subject|mean|std",colnames(newdf))]
cleandf[,1]<-lapply(cleandf,function(x) sub(1, "walking",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(2, "walking upstairs",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(3, "walking downstairs",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(4, "sitting",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(5, "standing",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(6, "laying",x))

finaldf<-cleandf 
order_data<-finaldf[order(finaldf[,2], finaldf[,1]),] ##orders by subject

##Our means! 
statsdf<-aggregate(order_data,list(order_data[,1],order_data[,2]), mean)

##Now we clear out the excess columns and we have our tidy data :D
statsdf<-subset(statsdf, select = -c(3,4))
statsdf<-rename(statsdf, activity = Group.1)
statsdf<-rename(statsdf, subject = Group.2)

tidydata<-statsdf