# Assignment for Course Getting and Cleaning Data

This repository is created for the submission of **Getting and Cleaning Data** course assignment.  

The assignment is about collecting and cleaning a data set from [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

Files in the repository:  

- `run_analysis.R`: this R script contains all the codes that are needed in this assignment:  
  - Step 1: download and unzip the files  
  - Step 2: read the files into R  
  - Step 3: merge all data frames into one data frame  
  - Step 4: grep columns which have mean(), std(), subject, or activity in their names  
  - Step 5: replace the values in `activity` column as decriptive activity names  
  - Step 6: fix the variable names  
  - Step 7: group the data frame by `subject` and `activity`, then calculate the average of each variable  
  - Step 8: export the result data frame to `tidydata_ave.txt` file  
- `CodeBook.Rmd`: this codebook contains the variables, the data, and any transformations or work that I performed to clean up the data  
- `tidydata_ave.txt`: the final data that is exported by `run_analysis.R`  

