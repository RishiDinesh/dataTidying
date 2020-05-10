#read files
activities<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("label","activity"))
features<-read.table("UCI HAR Dataset/features.txt",col.names=c("SI.No","feature"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject_id")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names=features$feature)
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt",col.names="label")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject_id")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt",col.names=features$feature)
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt",col.names="label")

#Merge the training and the test sets to create one data set.
x<-rbind(x_test,x_train)
y<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)
dataFrame<-cbind(subject,y,x)

#Extract only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
dataSubset<-select(dataFrame,subject_id,label,contains("mean"),contains("std"))
#Use descriptive activity names to name the activities in the data set
dataSubset$label<-activities[dataSubset$label,2]

#Appropriately label the data set with descriptive variable names.
library(mgsub)
names(dataSubset)<-gsub("label","activity",names(dataSubset))
find=c("Acc","Gyro","BodyBody","Mag","^t","^f","tBody","-mean()","-std()","-freq()")
replace=c("Accelerometer","Gyroscope","Body","Magnitude","Time","Frequency","TimeBody","Mean","STD","Frequency")
names(dataSubset)<-mgsub(names(dataSubset),find,replace)

#create a data set with the average of each variable for each activity and each subject.
final<-dataSubset%>%group_by(subject_id,activity)%>%summarise_all(funs(mean))
write.table(final, "Final.txt", row.name=FALSE)
