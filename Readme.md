Peer-graded Assignment: Getting and Cleaning Data Course Project

This is Shreya Wadhwa's submission. 

-run_analysis.R contains the script for tidying the data and performing analysis on it
-CodeBook.md describes the procedure for each step and gives information about the data frames obtained in the process.
-FinalPGAW3.txt is the exported form of the required data.

1.Merges the training and the test sets to create one data set.
I used rbind to bind the train and test versions of subject, X and Y seperately and then used column bind, i.e. cbind to the subjects, X and Y.

2.Extracts only the measurements on the mean and standard deviation for each measurement.
measure <- select(final,subject, code, contains("mean"), contains("std"))
the select function is used to extract the first basic columns, i.e subject and activity code, and the all those columns that mention mean or std.

3.Uses descriptive activity names to name the activities in the data set
teh activity names are associated with codes and this info is in activity_labels.txt. So we extract the info from there and put it in our main data frame using these commands:
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
measure$activity <- activity.labels[measure$activity]

4.Appropriately labels the data set with descriptive variable names.
Now to name the data properly, we identify textual information and use certain conditions to find specific words and replace them with more descriptive names: gsub substitues the appearance of the first argument with the second argument.
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

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
To do this, we first group the data frame on the basis of subject and then activity, and then take the mean of those values.
final <- group_by(measure, subject, activity)
final <- summarise_all(final, funs(mean))

Finally, we save our data: write.table(final, "FinalPGAW3.txt", row.name=FALSE)