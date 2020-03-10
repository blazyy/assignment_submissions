The following steps highlight the exacts steps done to transform the given raw dataset to tidy data.

1) Merge train and test datasets to form one cohesive dataset. In each step below, the column/variables names are taken from *features.txt* and are used to name the columns by passing the list to the `col.names` argument in the `read.table()` function. Subject number and activity columns are named manually. The steps taken to merge the datasets are as follows:
    i) Combine 3 training datasets (*subject_train.txt*, *X_train.txt*, *y_train.txt*) using `cbind()` to form entire training set.
    ii) Combine 3 testing datasets (*subject_test.txt*, *X_test.txt*, *y_yest.txt*) using `cbind()` to form entire testing set.
    iii) Combine testing and training sets using rbind() to create combined dataset.
    
    ```r
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
    ```
    
2) Use labels from *activity_labels.txt* to convert variables values (currently ranging from 1 to 6) to meaningful text like walking, standing, etc.

```r
library(dplyr)
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')[2]
dataset$type_of_activity <- sapply(dataset$type_of_activity, function(x){activity_labels[x, ]})
```

3) Extract only the columns that use either the mean or standard deviation by selecting the columns names which either have `mean` or `std` in their names using `grep()`. 

```r
mean_and_std_cols <- grep("mean|std", names(dataset))
mean_and_std_dataset <- dataset[, c(1, mean_and_std_cols, ncol(dataset))]
```

4) Group this new dataset by activity and subject and summarize each variable using the mean so that in the tidy dataset, there are 180 rows, i.e. 6 activities for each of the 30 subjects.

```r
grouped_by_activity <- group_by(mean_and_std_dataset, type_of_activity, subject_number)
avg_by_activity <- summarize_each(grouped_by_activity, mean)
```