run_analysis.R tidy's up the data in the UCI HAR Dataset provided and then performs the five required steps.

Preparation:
The file is saved on the local machine and I used setwd() to navigate to the directory where the file is present so I can access it. Then all the seperate data file are read in, i.e. features.txt, activity_labels.txt and the subject, X and Y versions of Test and Train with appropriate column names.
activities: rows:6 cols:2
features: rows:561 cols:2
subject_test: rows:2947 cols:1
x_test: rows:2947 cols:561
y_test: rows:2947 cols:1
subject_train:7352 rows: cols:1
x_train: rows:7352 cols:561
y_train: rows:7352 cols:1

-the first instance of final is the data frame that combines data of train and test versions
-measure is used to store the mean and std data
-the second instance of final stores the mean of data on the basis of subject and activity

Column names:
-features.txt: n, functions
-activity_labels.txt: code, activity
-subject_test and subject_train: subject
-y_test and y_train: code
-x_test and x_train: all the features from features.txt which are stored in the functions column in features.txt

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