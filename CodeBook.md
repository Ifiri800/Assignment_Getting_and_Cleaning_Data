## Introductions for assignment

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

You should create one R script called run_analysis.R that does the following.  

- Merges the training and the test sets to create one data set  
- Extracts only the measurements on the mean and standard deviation for each measurement  
- Uses descriptive activity names to name the activities in the data set  
- Appropriately labels the data set with descriptive variable names  
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject  

## Codebook: the work to clean up the data  

#### The `run_analysis.R` script contains the code from downloading the data to the clean up steps, the precedure is described as follows:

### 1. Download and unzip the files

- Create directory `./data` if it doesn't exist.
- Download the `dataset.zip` file if it doesn't exist.
- Unzip the `dataset.zip` file in the `./data` directory.

```R
if (!file.exists("./data")) {
  dir.create("./data")
}

if (!file.exists("./data/dataset.zip")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "./data/dataset.zip", method = "curl")
}

unzip(zipfile = "./data/dataset.zip", exdir = "./data")
```

### 2. Read the files into R

The files that will be used in this assignment are listed as follows:  

- `activity_labels.txt`: names for the six activities  
- `features.txt`: list of all features (variables)  
- `subject_test.txt`: the subject number for each row of test group  
- `X_test.txt`: the data collected of test group  
- `y_test.txt`: the activity number for each row of test group  
- `subject_train.txt`: the subject number for each row of train group  
- `X_train.txt`: the data collected of train group  
- `y_train.txt`: the activity number for each row of train group  

The final data frame will have the following columns and rows:  

- Columns (variables):  
  - Subject: number from 1-30 (30 volunteers)  
  - Activity: number from 1-6 (6 activities)  
  - All the features from `features.txt` file  
- Rows (observations):  
  - Values for each feature: `X_test.txt` and `X_train.txt`  
  - Numbers of subjects: `subject_test.txt` and `subject_train.txt`  
  - Numbers of activities: `y_test.txt` and `y_train.txt`  

The codes in `run_analysis.R` contain the following steps:  

- Read the data of activities from `y_test.txt` and `y_train.txt`  
- Read the data of subjects from `subject_test.txt` and `subject_train.txt`  
- Read the data of features from `X_test.txt` and `X_train.txt`  
- Read the names of features (variables) from `features.txt`  

```R
datafolder <- "./data/UCI HAR Dataset/"

# Read the data of activities
activity_test <- read.table(file.path(datafolder, "test", "y_test.txt"))
activity_train <- read.table(file.path(datafolder, "train", "y_train.txt"))

# Read the data of subjects
subject_test <- read.table(file.path(datafolder, "test", "subject_test.txt"))
subject_train <- read.table(file.path(datafolder, "train", "subject_train.txt"))

# Read the data of features
feature_test <- read.table(file.path(datafolder, "test", "X_test.txt"))
feature_train <- read.table(file.path(datafolder, "train", "X_train.txt"))

# Read the names of features (variables)
feature_name <- read.table(file.path(datafolder, "features.txt"))
```

### 3. Merge all data frames into one data frame

- Merge rows: merge the train and test data of `activity_data`, `subject_data` and `feature_data`, respectively. The results are three data frames:  
  - `activity_data`: 10299 rows and 1 column  
  - `subject_data`: 10299 rows and 1 column  
  - `feature_data`: 10299 rows and 561 columns  
- Merge columns: merge the three data frames obtained from the last step: the result data frame has 10299 rows and 563 columns  
- Set names to variables: subject as `subject`, activity as `activity`, and the feature names from `features.txt`  

```R
# Merge rows
activity_data <- rbind(activity_train, activity_test)
subject_data <- rbind(subject_train, subject_test)
feature_data <- rbind(feature_train, feature_test)

# Merge columns
dataset <- cbind(subject_data, activity_data, feature_data)

# Set names to variables
colnames(dataset) <- c("subject", "activity", feature_name$V2)
```

### 4. Extract only the measurements on the mean and standard deviation

Grep columns which have mean(), std(), subject, or activity in their names  

```R
subdataset <- dataset[, grep("mean\\(\\)|std\\(\\)|subject|activity", names(dataset))]
```

### 5. Use decriptive activity names to name the activities in the data set

Based on the activity names in `activity_labels.txt`, the values in column `activity` are replaced as follows:  

- `1` as `WALKING`   
- `2` as `WALKING_UPSTAIRS`  
- `3` as `WALKING_DOWNSTAIRS`  
- `4` as `SITTING`  
- `5` as `STANDING`  
- `6` as `LAYING`  

```R
subdataset$activity[subdataset$activity == 1] <- "WALKING"
subdataset$activity[subdataset$activity == 2] <- "WALKING_UPSTAIRS"
subdataset$activity[subdataset$activity == 3] <- "WALKING_DOWNSTAIRS"
subdataset$activity[subdataset$activity == 4] <- "SITTING"
subdataset$activity[subdataset$activity == 5] <- "STANDING"
subdataset$activity[subdataset$activity == 6] <- "LAYING"
```

### 6. Appropriately label the data set with dexcriptive variable names  

The names of features will be fixed by the following standards:  

- prefix `t` will be replaced by `time`  
- `Acc` will be replaced by `Accelerometer` 
- `Gyro` will be replaced by `Gyroscope`  
- prefix `f` will be replaced by `frequency`  
- `Mag` will be replaced by `Magnitude`  
- `BodyBody` will be replaced by `Body`  
- `()` will be deleted  
- `-` will be replaced by `_`  

```R
names(subdataset) <- gsub("^t", "time", names(subdataset))
names(subdataset) <- gsub("Acc", "Accelerometer", names(subdataset))
names(subdataset) <- gsub("Gyro", "Gyroscope", names(subdataset))
names(subdataset) <- gsub("^f", "frequency", names(subdataset))
names(subdataset) <- gsub("Mag", "Magnitude", names(subdataset))
names(subdataset) <- gsub("BodyBody", "Body", names(subdataset))
names(subdataset) <- gsub("\\(\\)", "", names(subdataset))
names(subdataset) <- gsub("-", "_", names(subdataset))
```

### 7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

- Group the data frame by subject and activity  
- Calculate the average of each variable by `summarise_all()`  

```R
library(dplyr)
group_subject_activity <- group_by(subdataset, subject, activity)
dataset_ave <- summarise_all(group_subject_activity, mean, na.rm = TRUE)
```

### 8. Export the result data frame as `.txt` file

Export using `write.table()` with `row.names = FALSE`, the file was named as `tidydata_ave.txt`.

```R
write.table(dataset_ave, "./tidydata_ave.txt", row.names = FALSE)
```