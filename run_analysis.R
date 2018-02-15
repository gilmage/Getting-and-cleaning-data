############  run_analysis.R #############

### This is the R script that prepares two data sets as described below.
### The goal is to prepare tidy data that can be used for later analysis. 

### The original data set collected from the smartphone sensors is available at this site :
  
  # http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##  This script does the following:

#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement.
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names.
#   5. From the data set in step 4, creates a second, independent tidy data set 
#      with the average of each variable for each activity and each subject.


library(dplyr)

### Step 1
### 1. Merges the training and the test sets to create one data set.

url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
download.file(url, "FinalProgAssignment-data.zip")
unzip("FinalProgAssignment-data.zip", exdir = "W4project")

file_path <- "./W4project/UCI HAR Dataset/train/X_train.txt"

## Reading training data   
traindata <- read.table(file_path, header = F) 
dim(traindata)
#[1] 7352  561

## Reading variables names for training and test data
features <- read.table("./W4project/UCI HAR Dataset/features.txt", header = F)
dim(features)
#[1] 561   2

## Reading labels for activities - text names and corresponding integers from 1 to 6 
## to be used to link rows in "traindata" with activities
activity_labels <- read.table("./W4project/UCI HAR Dataset/activity_labels.txt", header = F)
dim(activity_labels)
#[1] 6 2
activity_labels
#  V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING 

## Reading file y_train.txt, which contains the column with integer codes for activities for each row in the "traindata"
#  i.e. would be column linking each row with activities
activitytrain <- read.table("./W4project/UCI HAR Dataset/train/y_train.txt", header = F)
dim(activitytrain)
#[1] 7352    1


## Reading file subject_train.txt, which contains the column with integer codes for the subject
## i.e. would be column with subject id
subjecttrain <- read.table("./W4project/UCI HAR Dataset/train/subject_train.txt", header = F)
dim(subjecttrain) 
#[1] 7352    1

## Adding subject id and activity codes to "traindata"
traindata <- cbind(subjecttrain,activitytrain, traindata)
dim(traindata)
#[1] 7352  563



## Reading test data
testdata <- read.table("./W4project/UCI HAR Dataset/test/X_test.txt", header = F)
View(testdata)
dim(testdata)
#[1] 2947  561

## Reading file y_test.txt, which contains the column with codes for activities for each row in the "testdata""
# - numbers from 1 to 6, , i.e. would be column linking each row with activities
activitytest <- read.table("./W4project/UCI HAR Dataset/test/y_test.txt", header = F)
dim(activitytest)
#[1] 2947    1


## Reading file subject_test.txt, which contains the column with codes for the subject
## for each row in the "testdata"", i.e. would be column with subject id
subjecttest <- read.table("./W4project/UCI HAR Dataset/test/subject_test.txt", header = F)
dim(subjecttest) 
#[1] 2947    1


## Adding subject id and activity codes to "traindata"
testdata <- cbind(subjecttest,activitytest, testdata)
dim(testdata)
#[1] 2947  563

## Joining train and test data
joineddata <- rbind(traindata, testdata)
dim(joineddata)
#[1] 10299   563

## Adding column names to "joineddata"
colnames(joineddata) <- c("Subject_id", "Activity", as.character(features[,2]))


### Step 2
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- as.character(features[,2])

my_pattern <- "mean|std"
extracted <- grep(my_pattern, features, ignore.case = TRUE)
Columns <- c("Subject_id", "Activity", features[extracted])
length(Columns)
#[1] 88

data <- joineddata[, Columns]
dim(data)
#[1] 10299    88


## Step 3
## 3. Uses descriptive activity names to name the activities in the data set


# (Automatic merging of Activity with activity txt labels did not work on my system due to memory requirements)

# 'Manual' change of activity names
data %>%
  group_by(Activity) %>%
  summarise(n = n())
#Activity   n 
#<int>    <int>
#1	       1722			
#2	       1544			
#3	       1406			
#4	       1777			
#5	       1906			
#6	       1944	

data <- arrange(data, Activity, Subject_id)

data[c(1, 1722, 1723, 1722+1544, 1723+1544, 1722+1544+1406, 1723+1544+1406, 1722+1544+1406+1777, 1723+1544+1406+1777, 1722+1544+1406+1777+1906, 1723+1544+1406+1777+1906, 10299),1:2]
#      Subject_id Activity
#1              1        1
#1722          30        1
#1723           1        2
#3266          30        2
#3267           1        3
#4672          30        3
#4673           1        4
#6449          30        4
#6450           1        5
#8355          30        5
#8356           1        6
#10299         30        6

data$Activity[1:1722] <- "WALKING"
data$Activity[1723:3266] <- "WALKING_UPSTAIRS"
data$Activity[3267:4672] <- "WALKING_DOWNSTAIRS"
data$Activity[4673:6449] <- "SITTING"
data$Activity[6450:8355] <- "STANDING"
data$Activity[8355:10299] <- "LAYING"
data[c(1, 1722, 1723, 1722+1544, 1723+1544, 1722+1544+1406, 1723+1544+1406, 1722+1544+1406+1777, 1723+1544+1406+1777, 1722+1544+1406+1777+1906, 1723+1544+1406+1777+1906, 10299),1:2]

#      Subject_id           Activity
#1              1            WALKING
#1722          30            WALKING
#1723           1   WALKING_UPSTAIRS
#3266          30   WALKING_UPSTAIRS
#3267           1 WALKING_DOWNSTAIRS
#4672          30 WALKING_DOWNSTAIRS
#4673           1            SITTING
#6449          30            SITTING
#6450           1           STANDING
#8355          30           STANDING
#8356           1             LAYING
#10299         30             LAYING



## Step 4
## 4. Appropriately labels the data set with descriptive variable names.

oldnames <- names(data)

## Changing variable names

# Removing brackets
newnames <- gsub("\\(\\)", "", oldnames)
# Removing hyfens
newnames <- gsub("\\-", "_", newnames)
# Removing "Body"
newnames <- gsub("Body", "", newnames)
# Removing "t" at the begining
newnames <- gsub("^t", "", newnames)
# Adding an underscore after "f" at the begining
newnames <- gsub("^f", "f_", newnames)
# Changing "Jerk" to "_Surge"
newnames <- gsub("Jerk", "_Surge", newnames)
# Changing "Acc" to "Accel"
newnames <- gsub("Acc", "Accel", newnames)
# Changing "mean" to "MEAN"
newnames <- gsub("mean", "MEAN", newnames)
# changing "std" to "STD"
newnames <- gsub("std", "STD", newnames)
# Adding an underscore before "Freq"
newnames <- gsub("Freq", "_Freq", newnames)

# Replacing "Mag" in the middle with "Magnitude" at the begining
newnames3 <- grep("Mag", newnames, value = FALSE)
newnames3
#[1] 33 34 35 36 37 38 39 40 41 42 70 71 72 73 74 75 76 77 78 79 80 81


# paste0() to paste together strings a & b without spaces
a <- "Magnitude_"    #string a
newnames[newnames3] <- paste0(a, newnames[newnames3]) 
newnames <- gsub("Magnitude_f_", "f_Magnitude_", newnames)
newnames <- gsub("Mag_", "_", newnames)

# Changing "angle" variables
newnames <- gsub("\\(", "_", newnames)
newnames <- gsub("_t", "_", newnames)
newnames <- gsub(",", "_vs_", newnames)
newnames <- gsub("\\)", "", newnames)
newnames <- gsub("^a", "A", newnames)
#newnames

# Renaiming columns in data
colnames(data) <- newnames
str(data)
#'data.frame':	10299 obs. of  88 variables:
#  $ Subject_id                          : int  1 1 1 1 1 1 1 1 1 1 ...
#  $ Activity                            : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
#  $ Accel_MEAN_X                        : num  0.282 0.256 0.255 0.343 0.276 ...
# ...
#  $ Angle_Z_vs_gravityMean              : num  0.0441 0.0446 0.0394 0.0397 0.0414 ...

# Getting a table of old and new names for record
var_names <- cbind(newnames, oldnames)
colnames(var_names) <- c("New names", "Old names")
var_names

#     New names                              Old names                             
#[1,] "Subject_id"                           "Subject_id"                          
#[2,] "Activity"                             "Activity"                            
#[3,] "Accel_MEAN_X"                         "tBodyAcc-mean()-X"                   
#[4,] "Accel_MEAN_Y"                         "tBodyAcc-mean()-Y"                   
#[5,] "Accel_MEAN_Z"                         "tBodyAcc-mean()-Z"                   
#[6,] "Accel_STD_X"                          "tBodyAcc-std()-X"                    
#[7,] "Accel_STD_Y"                          "tBodyAcc-std()-Y"                    
#[8,] "Accel_STD_Z"                          "tBodyAcc-std()-Z"                    
#[9,] "GravityAccel_MEAN_X"                  "tGravityAcc-mean()-X"                
#[10,] "GravityAccel_MEAN_Y"                  "tGravityAcc-mean()-Y"                
#[11,] "GravityAccel_MEAN_Z"                  "tGravityAcc-mean()-Z"                
#[12,] "GravityAccel_STD_X"                   "tGravityAcc-std()-X"                 
#[13,] "GravityAccel_STD_Y"                   "tGravityAcc-std()-Y"                 
#[14,] "GravityAccel_STD_Z"                   "tGravityAcc-std()-Z"                 
#[15,] "Accel_Surge_MEAN_X"                   "tBodyAccJerk-mean()-X"               
#[16,] "Accel_Surge_MEAN_Y"                   "tBodyAccJerk-mean()-Y"               
#[17,] "Accel_Surge_MEAN_Z"                   "tBodyAccJerk-mean()-Z"               
#[18,] "Accel_Surge_STD_X"                    "tBodyAccJerk-std()-X"                
#[19,] "Accel_Surge_STD_Y"                    "tBodyAccJerk-std()-Y"                
#[20,] "Accel_Surge_STD_Z"                    "tBodyAccJerk-std()-Z"                
#[21,] "Gyro_MEAN_X"                          "tBodyGyro-mean()-X"                  
#[22,] "Gyro_MEAN_Y"                          "tBodyGyro-mean()-Y"                  
#[23,] "Gyro_MEAN_Z"                          "tBodyGyro-mean()-Z"                  
#[24,] "Gyro_STD_X"                           "tBodyGyro-std()-X"                   
#[25,] "Gyro_STD_Y"                           "tBodyGyro-std()-Y"                   
#[26,] "Gyro_STD_Z"                           "tBodyGyro-std()-Z"                   
#[27,] "Gyro_Surge_MEAN_X"                    "tBodyGyroJerk-mean()-X"              
#[28,] "Gyro_Surge_MEAN_Y"                    "tBodyGyroJerk-mean()-Y"              
#[29,] "Gyro_Surge_MEAN_Z"                    "tBodyGyroJerk-mean()-Z"              
#[30,] "Gyro_Surge_STD_X"                     "tBodyGyroJerk-std()-X"               
#[31,] "Gyro_Surge_STD_Y"                     "tBodyGyroJerk-std()-Y"               
#[32,] "Gyro_Surge_STD_Z"                     "tBodyGyroJerk-std()-Z"               
#[33,] "Magnitude_Accel_MEAN"                 "tBodyAccMag-mean()"                  
#[34,] "Magnitude_Accel_STD"                  "tBodyAccMag-std()"                   
#[35,] "Magnitude_GravityAccel_MEAN"          "tGravityAccMag-mean()"               
#[36,] "Magnitude_GravityAccel_STD"           "tGravityAccMag-std()"                
#[37,] "Magnitude_Accel_Surge_MEAN"           "tBodyAccJerkMag-mean()"              
#[38,] "Magnitude_Accel_Surge_STD"            "tBodyAccJerkMag-std()"               
#[39,] "Magnitude_Gyro_MEAN"                  "tBodyGyroMag-mean()"                 
#[40,] "Magnitude_Gyro_STD"                   "tBodyGyroMag-std()"                  
#[41,] "Magnitude_Gyro_Surge_MEAN"            "tBodyGyroJerkMag-mean()"             
#[42,] "Magnitude_Gyro_Surge_STD"             "tBodyGyroJerkMag-std()"              
#[43,] "f_Accel_MEAN_X"                       "fBodyAcc-mean()-X"                   
#[44,] "f_Accel_MEAN_Y"                       "fBodyAcc-mean()-Y"                   
#[45,] "f_Accel_MEAN_Z"                       "fBodyAcc-mean()-Z"                   
#[46,] "f_Accel_STD_X"                        "fBodyAcc-std()-X"                    
#[47,] "f_Accel_STD_Y"                        "fBodyAcc-std()-Y"                    
#[48,] "f_Accel_STD_Z"                        "fBodyAcc-std()-Z"                    
#[49,] "f_Accel_MEAN_Freq_X"                  "fBodyAcc-meanFreq()-X"               
#[50,] "f_Accel_MEAN_Freq_Y"                  "fBodyAcc-meanFreq()-Y"               
#[51,] "f_Accel_MEAN_Freq_Z"                  "fBodyAcc-meanFreq()-Z"               
#[52,] "f_Accel_Surge_MEAN_X"                 "fBodyAccJerk-mean()-X"               
#[53,] "f_Accel_Surge_MEAN_Y"                 "fBodyAccJerk-mean()-Y"               
#[54,] "f_Accel_Surge_MEAN_Z"                 "fBodyAccJerk-mean()-Z"               
#[55,] "f_Accel_Surge_STD_X"                  "fBodyAccJerk-std()-X"                
#[56,] "f_Accel_Surge_STD_Y"                  "fBodyAccJerk-std()-Y"                
#[57,] "f_Accel_Surge_STD_Z"                  "fBodyAccJerk-std()-Z"                
#[58,] "f_Accel_Surge_MEAN_Freq_X"            "fBodyAccJerk-meanFreq()-X"           
#[59,] "f_Accel_Surge_MEAN_Freq_Y"            "fBodyAccJerk-meanFreq()-Y"           
#[60,] "f_Accel_Surge_MEAN_Freq_Z"            "fBodyAccJerk-meanFreq()-Z"           
#[61,] "f_Gyro_MEAN_X"                        "fBodyGyro-mean()-X"                  
#[62,] "f_Gyro_MEAN_Y"                        "fBodyGyro-mean()-Y"                  
#[63,] "f_Gyro_MEAN_Z"                        "fBodyGyro-mean()-Z"                  
#[64,] "f_Gyro_STD_X"                         "fBodyGyro-std()-X"                   
#[65,] "f_Gyro_STD_Y"                         "fBodyGyro-std()-Y"                   
#[66,] "f_Gyro_STD_Z"                         "fBodyGyro-std()-Z"                   
#[67,] "f_Gyro_MEAN_Freq_X"                   "fBodyGyro-meanFreq()-X"              
#[68,] "f_Gyro_MEAN_Freq_Y"                   "fBodyGyro-meanFreq()-Y"              
#[69,] "f_Gyro_MEAN_Freq_Z"                   "fBodyGyro-meanFreq()-Z"              
#[70,] "f_Magnitude_Accel_MEAN"               "fBodyAccMag-mean()"                  
#[71,] "f_Magnitude_Accel_STD"                "fBodyAccMag-std()"                   
#[72,] "f_Magnitude_Accel_MEAN_Freq"          "fBodyAccMag-meanFreq()"              
#[73,] "f_Magnitude_Accel_Surge_MEAN"         "fBodyBodyAccJerkMag-mean()"          
#[74,] "f_Magnitude_Accel_Surge_STD"          "fBodyBodyAccJerkMag-std()"           
#[75,] "f_Magnitude_Accel_Surge_MEAN_Freq"    "fBodyBodyAccJerkMag-meanFreq()"      
#[76,] "f_Magnitude_Gyro_MEAN"                "fBodyBodyGyroMag-mean()"             
#[77,] "f_Magnitude_Gyro_STD"                 "fBodyBodyGyroMag-std()"              
#[78,] "f_Magnitude_Gyro_MEAN_Freq"           "fBodyBodyGyroMag-meanFreq()"         
#[79,] "f_Magnitude_Gyro_Surge_MEAN"          "fBodyBodyGyroJerkMag-mean()"         
#[80,] "f_Magnitude_Gyro_Surge_STD"           "fBodyBodyGyroJerkMag-std()"          
#[81,] "f_Magnitude_Gyro_Surge_MEAN_Freq"     "fBodyBodyGyroJerkMag-meanFreq()"     
#[82,] "Angle_AccelMean_vs_gravity"           "angle(tBodyAccMean,gravity)"         
#[83,] "Angle_Accel_SurgeMean_vs_gravityMean" "angle(tBodyAccJerkMean),gravityMean)"
#[84,] "Angle_GyroMean_vs_gravityMean"        "angle(tBodyGyroMean,gravityMean)"    
#[85,] "Angle_Gyro_SurgeMean_vs_gravityMean"  "angle(tBodyGyroJerkMean,gravityMean)"
#[86,] "Angle_X_vs_gravityMean"               "angle(X,gravityMean)"                
#[87,] "Angle_Y_vs_gravityMean"               "angle(Y,gravityMean)"                
#[88,] "Angle_Z_vs_gravityMean"               "angle(Z,gravityMean)" 




## Step 5
## 5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.

Meansdata <- data %>%
  group_by(Activity, Subject_id) %>%
  mutate(Number_observations = n()) %>%  # number of observations per activity per subject for which the average is calculated
  summarise_all(mean)

dim(Meansdata)
#[1] 180  89

b <- "AVG_"    #string b
newnames4 <- newnames
newnames4[3:88] <- paste0(b, newnames[3:88])
colnames(Meansdata)[3:88] <- newnames4[3:88]

names(Meansdata)
#[1] "Activity"                                 "Subject_id"                              
#[3] "AVG_Accel_MEAN_X"                         "AVG_Accel_MEAN_Y"                        
#[5] "AVG_Accel_MEAN_Z"                         "AVG_Accel_STD_X"                         
#[7] "AVG_Accel_STD_Y"                          "AVG_Accel_STD_Z"                         
#[9] "AVG_GravityAccel_MEAN_X"                  "AVG_GravityAccel_MEAN_Y"                 
#[11] "AVG_GravityAccel_MEAN_Z"                  "AVG_GravityAccel_STD_X"                  
#[13] "AVG_GravityAccel_STD_Y"                   "AVG_GravityAccel_STD_Z"                  
#[15] "AVG_Accel_Surge_MEAN_X"                   "AVG_Accel_Surge_MEAN_Y"                  
#[17] "AVG_Accel_Surge_MEAN_Z"                   "AVG_Accel_Surge_STD_X"                   
#[19] "AVG_Accel_Surge_STD_Y"                    "AVG_Accel_Surge_STD_Z"                   
#[21] "AVG_Gyro_MEAN_X"                          "AVG_Gyro_MEAN_Y"                         
#[23] "AVG_Gyro_MEAN_Z"                          "AVG_Gyro_STD_X"                          
#[25] "AVG_Gyro_STD_Y"                           "AVG_Gyro_STD_Z"                          
#[27] "AVG_Gyro_Surge_MEAN_X"                    "AVG_Gyro_Surge_MEAN_Y"                   
#[29] "AVG_Gyro_Surge_MEAN_Z"                    "AVG_Gyro_Surge_STD_X"                    
#[31] "AVG_Gyro_Surge_STD_Y"                     "AVG_Gyro_Surge_STD_Z"                    
#[33] "AVG_Magnitude_Accel_MEAN"                 "AVG_Magnitude_Accel_STD"                 
#[35] "AVG_Magnitude_GravityAccel_MEAN"          "AVG_Magnitude_GravityAccel_STD"          
#[37] "AVG_Magnitude_Accel_Surge_MEAN"           "AVG_Magnitude_Accel_Surge_STD"           
#[39] "AVG_Magnitude_Gyro_MEAN"                  "AVG_Magnitude_Gyro_STD"                  
#[41] "AVG_Magnitude_Gyro_Surge_MEAN"            "AVG_Magnitude_Gyro_Surge_STD"            
#[43] "AVG_f_Accel_MEAN_X"                       "AVG_f_Accel_MEAN_Y"                      
#[45] "AVG_f_Accel_MEAN_Z"                       "AVG_f_Accel_STD_X"                       
#[47] "AVG_f_Accel_STD_Y"                        "AVG_f_Accel_STD_Z"                       
#[49] "AVG_f_Accel_MEAN_Freq_X"                  "AVG_f_Accel_MEAN_Freq_Y"                 
#[51] "AVG_f_Accel_MEAN_Freq_Z"                  "AVG_f_Accel_Surge_MEAN_X"                
#[53] "AVG_f_Accel_Surge_MEAN_Y"                 "AVG_f_Accel_Surge_MEAN_Z"                
#[55] "AVG_f_Accel_Surge_STD_X"                  "AVG_f_Accel_Surge_STD_Y"                 
#[57] "AVG_f_Accel_Surge_STD_Z"                  "AVG_f_Accel_Surge_MEAN_Freq_X"           
#[59] "AVG_f_Accel_Surge_MEAN_Freq_Y"            "AVG_f_Accel_Surge_MEAN_Freq_Z"           
#[61] "AVG_f_Gyro_MEAN_X"                        "AVG_f_Gyro_MEAN_Y"                       
#[63] "AVG_f_Gyro_MEAN_Z"                        "AVG_f_Gyro_STD_X"                        
#[65] "AVG_f_Gyro_STD_Y"                         "AVG_f_Gyro_STD_Z"                        
#[67] "AVG_f_Gyro_MEAN_Freq_X"                   "AVG_f_Gyro_MEAN_Freq_Y"                  
#[69] "AVG_f_Gyro_MEAN_Freq_Z"                   "AVG_f_Magnitude_Accel_MEAN"              
#[71] "AVG_f_Magnitude_Accel_STD"                "AVG_f_Magnitude_Accel_MEAN_Freq"         
#[73] "AVG_f_Magnitude_Accel_Surge_MEAN"         "AVG_f_Magnitude_Accel_Surge_STD"         
#[75] "AVG_f_Magnitude_Accel_Surge_MEAN_Freq"    "AVG_f_Magnitude_Gyro_MEAN"               
#[77] "AVG_f_Magnitude_Gyro_STD"                 "AVG_f_Magnitude_Gyro_MEAN_Freq"          
#[79] "AVG_f_Magnitude_Gyro_Surge_MEAN"          "AVG_f_Magnitude_Gyro_Surge_STD"          
#[81] "AVG_f_Magnitude_Gyro_Surge_MEAN_Freq"     "AVG_Angle_AccelMean_vs_gravity"          
#[83] "AVG_Angle_Accel_SurgeMean_vs_gravityMean" "AVG_Angle_GyroMean_vs_gravityMean"       
#[85] "AVG_Angle_Gyro_SurgeMean_vs_gravityMean"  "AVG_Angle_X_vs_gravityMean"              
#[87] "AVG_Angle_Y_vs_gravityMean"               "AVG_Angle_Z_vs_gravityMean"
#[89] "Number_observations"

write.table(Meansdata, file = "datafile.txt", append = FALSE, quote = FALSE, sep = " ", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"), fileEncoding = "")
