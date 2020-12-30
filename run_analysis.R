# 1.Download and unzip the files

if (!file.exists("./data")) {
  dir.create("./data")
}
if (!file.exists("./data/dataset.zip")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "./data/dataset.zip", method = "curl")
}
unzip(zipfile = "./data/dataset.zip", exdir = "./data")

# 2.Read the files into R

datafolder <- "./data/UCI HAR Dataset/"
activity_test <- read.table(file.path(datafolder, "test", "y_test.txt"))
activity_train <- read.table(file.path(datafolder, "train", "y_train.txt"))
subject_test <- read.table(file.path(datafolder, "test", "subject_test.txt"))
subject_train <- read.table(file.path(datafolder, "train", "subject_train.txt"))
feature_test <- read.table(file.path(datafolder, "test", "X_test.txt"))
feature_train <- read.table(file.path(datafolder, "train", "X_train.txt"))
feature_name <- read.table(file.path(datafolder, "features.txt"))

# 3.Merge all data frames into one data frame

activity_data <- rbind(activity_train, activity_test)
subject_data <- rbind(subject_train, subject_test)
feature_data <- rbind(feature_train, feature_test)
dataset <- cbind(subject_data, activity_data, feature_data)
colnames(dataset) <- c("subject", "activity", feature_name$V2)

# 4.Extract only the measurements on the mean and standard deviation

subdataset <- dataset[, grep("mean\\(\\)|std\\(\\)|subject|activity", names(dataset))]

# 5.Use decriptive activity names to name the activities in the data set

subdataset$activity[subdataset$activity == 1] <- "WALKING"
subdataset$activity[subdataset$activity == 2] <- "WALKING_UPSTAIRS"
subdataset$activity[subdataset$activity == 3] <- "WALKING_DOWNSTAIRS"
subdataset$activity[subdataset$activity == 4] <- "SITTING"
subdataset$activity[subdataset$activity == 5] <- "STANDING"
subdataset$activity[subdataset$activity == 6] <- "LAYING"

# 6.Appropriately label the data set with dexcriptive variable names

names(subdataset) <- gsub("^t", "time", names(subdataset))
names(subdataset) <- gsub("Acc", "Accelerometer", names(subdataset))
names(subdataset) <- gsub("Gyro", "Gyroscope", names(subdataset))
names(subdataset) <- gsub("^f", "frequency", names(subdataset))
names(subdataset) <- gsub("Mag", "Magnitude", names(subdataset))
names(subdataset) <- gsub("BodyBody", "Body", names(subdataset))
names(subdataset) <- gsub("\\(\\)", "", names(subdataset))
names(subdataset) <- gsub("-", "_", names(subdataset))

# 7.Creates a second, independent tidy data set 
# with the average of each variable 
# for each activity and each subject

library(dplyr)
group_subject_activity <- group_by(subdataset, subject, activity)
dataset_ave <- summarise_all(group_subject_activity, mean, na.rm = TRUE)

# 8.Export the result data frame as .txt file

write.table(dataset_ave, "./tidydata_ave.txt", row.names = FALSE)














