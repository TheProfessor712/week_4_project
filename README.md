# week_4_project

In this document we will review the code and what it does. See the code book for information regarding the variables.

library(dplyr)

This loads the dplyr package of which we will make copious use! Now we load in all the tables with straightforward names.

Xtest<-read.table("X_test.txt")
Xtrain<-read.table("X_train.txt")
Ytrain<-read.table("Y_train.txt")
Ytest<-read.table("Y_test.txt")
Subtest<-read.table("subject_test.txt")
Subtrain<-read.table("Subject_train.txt")
features<-read.table("features.txt")

And then join them together!

df<-full_join(Xtrain, Xtest)

Now we rename those pesky single column files that contain the activity and subject lables...

Ytrain<-rename(Ytrain, activity = V1)
Subtrain<-rename(Subtrain, subject = V1)
Subtest<-rename(Subtest, subject = V1)
Ytest<-rename(Ytest, activity = V1)

And then merge them together with their respective partner, and concatenate all of it together!

train<-cbind(Ytrain,Subtrain)
test<-cbind(Ytest,Subtest)
col12<-full_join(train,test)
newdf<-cbind(col12,df)

Here we add in the names of all the variables stored in the second column of the features data frame, and then go through and
change all of the activity lables (1 - 6) with the name of the activity they represent.

x<-c("activity","subject", features[,2])
colnames(newdf)<-x
cleandf<-newdf[,grepl("activity|subject|mean|std",colnames(newdf))]
cleandf[,1]<-lapply(cleandf,function(x) sub(1, "walking",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(2, "walking upstairs",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(3, "walking downstairs",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(4, "sitting",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(5, "standing",x))
cleandf[,1]<-lapply(cleandf,function(x) sub(6, "laying",x))

Now I order it (for personal taste, not necessary)
finaldf<-cleandf 
order_data<-finaldf[order(finaldf[,2], finaldf[,1]),] ##orders by subject

Then compute our means,

statsdf<-aggregate(order_data,list(order_data[,1],order_data[,2]), mean)


and now we clear out the excess columns and we have our tidy data :D

statsdf<-subset(statsdf, select = -c(3,4))
statsdf<-rename(statsdf, activity = Group.1)
statsdf<-rename(statsdf, subject = Group.2)

tidydata<-statsdf (again this is just for personal taste, changing the name).

The more unscrupulous of you coders may deride my rustic and perhaps a touch barbaric manner of coding, but it works! :D
