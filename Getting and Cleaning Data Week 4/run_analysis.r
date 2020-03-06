if(!file.exists('dataset.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'dataset.zip')
    unzip('dataset.zip')
}

#--------------------------# Merging datasets #--------------------------#

# Setting the colClasses argument will help read.table() twice as fast.
 
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

#--------------------------# Labelling class variables #--------------------------#
library(dplyr)
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')[2]
dataset$type_of_activity <- sapply(dataset$type_of_activity, function(x){activity_labels[x, ]})



