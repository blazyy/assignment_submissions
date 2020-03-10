# setwd("Getting and Cleaning Data Week 4/")
if(!file.exists('dataset.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'dataset.zip')
    unzip('dataset.zip')
}

# Merging datasets
feature_names <- as.character(read.table('UCI HAR Dataset/features.txt')[2][, 1])

subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', colClasses = "integer", col.names = "subject_number")
X_train <- read.table('UCI HAR Dataset/train/X_train.txt', colClasses = 'numeric', col.names = feature_names)
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', colClasses = 'numeric', col.names = 'type_of_activity')
train_set <- cbind(subject_train, X_train, y_train)

subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', colClasses = 'integer', col.names = 'subject_number')
X_test <- read.table('UCI HAR Dataset/test/X_test.txt', colClasses = 'numeric', col.names = feature_names)
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', colClasses = 'numeric', col.names = 'type_of_activity')
test_set <- cbind(subject_test, X_test, y_test)

dataset <- rbind(train_set, test_set)

# Removing other dataframes since they just take up unnecessary memory
rm(list = subset(ls(), ls() != "dataset"))

# Labelling class variables 
library(dplyr)
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')[2]
dataset$type_of_activity <- sapply(dataset$type_of_activity, function(x){activity_labels[x, ]})

# Extracting columns that use mean or standard deviation 
mean_and_std_cols <- grep("mean|std", names(dataset))
mean_and_std_dataset <- dataset[, c(1, mean_and_std_cols, ncol(dataset))]

# Creating tidy data set which shows average of each variable grouped by the activity and by the subject
grouped_by_activity <- group_by(mean_and_std_dataset, type_of_activity, subject_number)
avg_by_activity <- summarize_each(grouped_by_activity, mean)
dim(avg_by_activity) # The tidy dataset, with dimensions 190 x 81. 180 since there are 30 subjects with 6 activites each. (30 * 6)

write.table(avg_by_activity, "tidy_data.txt", row.names = FALSE)

