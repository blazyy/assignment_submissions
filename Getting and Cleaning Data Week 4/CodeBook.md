# CodeBook

[link to dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Intro

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

## Data

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

## For each record: 

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Notes

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## Tidy Data Conversion

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

4) Group this new dataset by activity and subject and summarize each variable using the mean so that in the tidy dataset, there are only 180 rows, 6 activities x 30 subjects.

```r
grouped_by_activity <- group_by(mean_and_std_dataset, type_of_activity, subject_number)
avg_by_activity <- summarize_each(grouped_by_activity, mean)
```
