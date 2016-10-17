# Getting-and-Cleaning-Data-Course-Project
Project assignment for the Getting and Cleaning Data Course from Coursera.org 

This repository contains:
run_analysis.R:     R script to transform raw data set in a tidy one
averagedataset.txt: an independent tidy data set with the average of each variable for each activity and each subject
CodeBook.md:        describes the code for run_analysis.R and lists the variables in the averagedataset.txt file. 
README.md:          this file


The R script, run_analysis.R, does the following:

1. Downloads a zip file containing the project data sets.
2. Merges the training and the test sets to create one data set.
3. Extracts only the measurements on the mean and standard deviation for each measurement.
4. Uses descriptive activity names to name the activities in the data set
5. Appropriately labels the data set with descriptive variable names.
6. Creates an independent tidy data set with the average of each variable for each activity and each subject named averagedataset.txt


To open the averagedataset.txt file:
data <- read.table("/averagedataset.txt", header = TRUE)
View(data)



