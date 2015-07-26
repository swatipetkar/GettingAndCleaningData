run_analysis = function()
{
dirPath <- "./UCI HAR Dataset/"
##Merges the training and the test sets to create one data set.

X_train <- read.table(paste(dirPath,"/train/X_train.txt",sep=""), quote="\"")
X_test <- read.table(paste(dirPath,"/test/X_test.txt",sep=""), quote="\"")
X <- rbind(X_train,X_test)

Y_train <- read.table(paste(dirPath,"/train/y_train.txt",sep=""), quote="\"")
Y_test <- read.table(paste(dirPath,"/test/y_test.txt",sep=""), quote="\"") 
Y <- rbind(Y_train,Y_test)

subjectTrain = read.table(paste(dirPath,"/train/subject_train.txt",sep=""))
subjectTest = read.table(paste(dirPath,"/test/subject_test.txt",sep=""))
subject = rbind(subjectTrain,subjectTest)
names(subject) = c("Subject")

#Extracts only the measurements on the mean and standard deviation for each measurement.
featuresData<-read.table(paste(dirPath,"/features.txt", sep=""),quote="\"")
names(featuresData) = c("colId","featureName")
validFeatures = grepl("mean\\(\\)|std\\(\\)",featuresData$featureName)
names(X) = featuresData$featureName
meanStdFeaturesOnly = X[,validFeatures]

##Uses descriptive activity names to name the activities in the data set
labels = read.table(paste(dirPath,"activity_labels.txt",sep=""))
activities = labels[,2]
Activity = activities[Y[,1]]

##Appropriately labels the data set with descriptive variable names. 
names(meanStdFeaturesOnly) = gsub("^t","Time",names(meanStdFeaturesOnly))
names(meanStdFeaturesOnly) = gsub("^f","Frequency",names(meanStdFeaturesOnly))
names(meanStdFeaturesOnly) = gsub("BodyBody","Body",names(meanStdFeaturesOnly))
names(meanStdFeaturesOnly) = gsub("Acc","Accelerometer",names(meanStdFeaturesOnly))
names(meanStdFeaturesOnly) = gsub("Gyro","Gyroscope",names(meanStdFeaturesOnly))
names(meanStdFeaturesOnly) = gsub("Mag","Magnitude",names(meanStdFeaturesOnly))

#combine all the data into one dataset
dataset = cbind(Subject,Activity,meanStdFeaturesOnly)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
require(plyr)
tidyDataset = aggregate(. ~ Subject + Activity, dataset, mean)
write.table(tidyDataset,"./tidyDataset.txt",sep="\t",na="NA",row.names=FALSE)
tidyDataset
}

