#Coursera's Getting and Cleaning Data asignment, week 4


#Get data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/data.zip", mode = 'wb')
unzip(zipfile = "./data/data.zip", exdir = "./data")

#Reading files
XTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")   #training set
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")   #training labels
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt") #train subjects

XTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")      #test set
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")      #test labels
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt") #test subjects

features <- read.table("./data/UCI HAR Dataset/features.txt")              #features
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt") #activity labels


#Assign column headers to data sets 
colnames(XTrain) <- features[,2]      
colnames(yTrain) <- "activityId"
colnames(subjectTrain) <- "subjectId"

colnames(XTest) <- features[,2] 
colnames(yTest) <- "activityId"
colnames(subjectTest) <- "subjectId"

#Combine files into one training and one test data set
trainData <- cbind(yTrain, subjectTrain, XTrain) #training data
testData <- cbind(yTest, subjectTest, XTest)     #test data
View(trainData)
View(testData)
dim(trainData)                                   #expected dim is 7352x563
dim(testData)                                    #expected dim is 2947x563

#Merge training and test data sets
mergedData <- rbind(testData, trainData)
View(mergedData)
dim(mergedData)                                  #expected dim is 10299x563

#Extract only the measurements on the mean and sd for each measurement
library(dplyr)
mergedDataMeanSTD <- mergedData[grepl('mean|std', names(mergedData))]

#Add back the activityId and subjectId
mergedDataMeanSTDAdd <- cbind(activityId = mergedData$activityId, 
                         subjectId = mergedData$subjectId, 
                         mergedDataMeanSTD)
View(mergedDataMeanSTDAdd)

#Replace activityId by descriptive activity names
View(activityLabels)
activityLabels <- as.character(activityLabels[,2])
mergedDataMeanSTDAdd$activityId <- activityLabels[mergedDataMeanSTDAdd$activityId]

#Assign descriptive variable names
names(mergedDataMeanSTDAdd) <- gsub("activityId", "Activity", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("^t", "time", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("^f", "frequency", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("Acc", "Accelerometer", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("Gyro", "Gyroscope", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("Mag", "Magnitude", names(mergedDataMeanSTDAdd))
names(mergedDataMeanSTDAdd) <- gsub("BodyBody", "Body", names(mergedDataMeanSTDAdd))

names(mergedDataMeanSTDAdd) #confirm changes

#New data set with the average of each activity and each subject
#Subset based on activity and subject

averageDataSet <- (mergedDataMeanSTDAdd %>%
                           group_by(subjectId, Activity) %>%
                           summarise_each(funs( mean)))
View(averageDataSet)

#Write new tidy data table
write.table(averageDataSet, file = "./data/averagedataset.txt", row.name = FALSE)
