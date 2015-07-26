# GettingAndCleaningData
Lines starting with '+' are the code lines
Lines starting with '+#' are comment lines within the submitted code
The text above a section of these code lines are descriptions of the code lines

run_analysis = function()
{
Set directory path to the downloaded dataset directory
+dirPath <- "./UCI HAR Dataset/"

I. Merge training and test datasets
I.A) Merge training and Test data for feature values
+##Merges the training and the test sets to create one data set.
+X_train <- read.table(paste(dirPath,"/train/X_train.txt",sep=""), quote="\"")
+X_test <- read.table(paste(dirPath,"/test/X_test.txt",sep=""), quote="\"")
+X <- rbind(X_train,X_test)

I.B) Merge training and Test data for Activity
+Y_train <- read.table(paste(dirPath,"/train/y_train.txt",sep=""), quote="\"")
+Y_test <- read.table(paste(dirPath,"/test/y_test.txt",sep=""), quote="\"") 
+Y <- rbind(Y_train,Y_test)

I.C) Merge training and Test data for Subject
+subjectTrain = read.table(paste(dirPath,"/train/subject_train.txt",sep=""))
+subjectTest = read.table(paste(dirPath,"/test/subject_test.txt",sep=""))
+subject = rbind(subjectTrain,subjectTest)
+names(subject) = c("Subject")

II) Extract only features that have mean() and std() in them
+#Extracts only the measurements on the mean and standard deviation for each measurement.

II.A) Read all the features from the features file
+featuresData<-read.table(paste(dirPath,"/features.txt", sep=""),quote="\"")
II.B) Assign column names to this file so that it is easy to refer to featureNames column
+names(featuresData) = c("colId","featureName")

II.C) Use grepl to get TRUE/FALSE if the feature name has mean() or std() in their names
+validFeatures = grepl("mean\\(\\)|std\\(\\)",featuresData$featureName)

II.D) Assign column names to the merged X data so that it is easy to filter columns corresponding to features which have mean() or std() in their names
+names(X) = featuresData$featureName

II.E) Keep only those columns that correspond to features which have mean() or std() in them
+meanStdFeaturesOnly = X[,validFeatures]


III. Use Descriptive names activities instead of their number code
+##Uses descriptive activity names to name the activities in the data set
III.A) Read activity labels
+labels = read.table(paste(dirPath,"activity_labels.txt",sep=""))
+activities = labels[,2]
III.B) Convert the number codes to the Activity labels
+Activity = activities[Y[,1]]

IV. Rename the headers to give more descriptive names
+##Appropriately labels the data set with descriptive variable names. 
IV.A) for features starting with 't', replace 't' with Time
+names(meanStdFeaturesOnly) = gsub("^t","Time",names(meanStdFeaturesOnly))
IV.B) for features starting with 'f', replace it with 'Frequency'
+names(meanStdFeaturesOnly) = gsub("^f","Frequency",names(meanStdFeaturesOnly))
IV.C) for features containing 'BodyBody', replace it with 'Body' 
+names(meanStdFeaturesOnly) = gsub("BodyBody","Body",names(meanStdFeaturesOnly))
IV.D) for features containing  'Acc', replace it with 'Accelerometer'
+names(meanStdFeaturesOnly) = gsub("Acc","Accelerometer",names(meanStdFeaturesOnly))
IV.E) for features containing  'Gyro', replace it with 'Gyroscope'
+names(meanStdFeaturesOnly) = gsub("Gyro","Gyroscope",names(meanStdFeaturesOnly))
IV.F) for features containing  'Mag', replace it with 'Magnitude'
+names(meanStdFeaturesOnly) = gsub("Mag","Magnitude",names(meanStdFeaturesOnly))

V.)#combine all the data into one dataset
+dataset = cbind(Subject,Activity,meanStdFeaturesOnly)

VI. Aggregate into Tidy Dataset
+#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
+require(plyr)
+tidyDataset = aggregate(. ~ Subject + Activity, dataset, mean)

VII. Write output to a txt file without row names
+write.table(tidyDataset,"./tidyDataset.txt",sep="\t",na="NA",row.names=FALSE)

VIII. Make sure that tidyDataset is returned as output
+tidyDataset
}