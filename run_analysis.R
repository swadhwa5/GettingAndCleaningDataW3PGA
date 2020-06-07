library(dplyr)
setwd("/Users/shreyawadhwa/Desktop/Shreya/R/Coursera")
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x_bind <- rbind(x_train, x_test)
y_bind <- rbind(y_train, y_test)
subject_bind <- rbind(subject_train, subject_test)
final <- cbind(subject_bind, y_bind, x_bind)

measure <- select(final,subject, code, contains("mean"), contains("std"))


names(measure)[2] = "activity"
names(measure)<-gsub("Acc", "Accelerometer", names(measure))
names(measure)<-gsub("Gyro", "Gyroscope", names(measure))
names(measure)<-gsub("BodyBody", "Body", names(measure))
names(measure)<-gsub("Mag", "Magnitude", names(measure))
names(measure)<-gsub("^t", "Time", names(measure))
names(measure)<-gsub("^f", "Frequency", names(measure))
names(measure)<-gsub("tBody", "TimeBody", names(measure))
names(measure)<-gsub("-mean()", "Mean", names(measure), ignore.case = TRUE)
names(measure)<-gsub("-std()", "STD", names(measure), ignore.case = TRUE)
names(measure)<-gsub("-freq()", "Frequency", names(measure), ignore.case = TRUE)
names(measure)<-gsub("angle", "Angle", names(measure))
names(measure)<-gsub("gravity", "Gravity", names(measure))


final <- group_by(measure, subject, activity)
final <- summarise_all(final, funs(mean))
write.table(final, "FinalPGAW3.txt", row.name=FALSE)
