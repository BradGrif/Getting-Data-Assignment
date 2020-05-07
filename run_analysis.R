library(dplyr)

## First, the script reads all the data needed for the project
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "coursedata.zip")
unzip("coursedata.zip")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
testlabels <- read.table("UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainlabels <- read.table("UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

##Second, the pieces of the test and train datasets are merged together

fulltest <- cbind(test,testlabels,subjecttest)
fulltrain <- cbind(train,trainlabels,subjecttrain)

##Then the test and train datasets are pieced together

fullset <- rbind(fulltest,fulltrain)

##The names of the variables are changed in line with the features.txt file
names(fullset) <- colnames[,2]

##And the names for the activity and subject column are added
names(fullset)[562:563] <- c("activity", "subject")


##Only the means and stds are selected. 
##Note that the meanfrequency variables and the means used in the angle function are deliberatly excluded
##- as they were not considered to be mean variables.
## The activity and subject columns were also included
fullmeansd <- fullset[,grepl("mean\\(\\)",names(fullset)) == TRUE|
                      grepl("std\\(\\)",names(fullset)) == TRUE |
                      names(fullset) == "activity"|
                      names(fullset) == "subject"]

## The merge function replaces the activity numbers with the activity names
## After the merge, the previous activity column is removed and the new one renamed

data <- merge(fullmeansd,activities, by.x = "activity", by.y = "V1")
data <- data[,names(data)!="activity"]
data <- rename(data, activity = V2)

##renaming the columns to be more descriptive
names(data) <- gsub("^t", "time domain ", names(data))
names(data) <- gsub("^f", "frequency domain ", names(data))
names(data) <- gsub("BodyAcc", "body acceleration signal", names(data))
names(data) <- gsub("GravityAcc", "gravity acceleration signal", names(data))
names(data) <- gsub("BodyGyro", "body gyroscope signal", names(data))
names(data) <- gsub("signalJerk", "jerk signal", names(data))
names(data) <- gsub("Body", "", names(data))
names(data) <- gsub("Mag", " magnitude", names(data))
names(data) <- gsub("X$", "X direction", names(data))
names(data) <- gsub("Y$", "Y direction", names(data))
names(data) <- gsub("Z$", "Z direction", names(data))

## Generates the second data set - mean ofthe columns by subject and activity
secondset <- data %>%
  group_by(activity,subject) %>%
  summarize_all(mean)

names(secondset) <- sapply(names(secondset), function(x){paste("mean of", x)})
