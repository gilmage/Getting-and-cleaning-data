---
title: "CodeBook.md"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

This describes the data, and any work performed to clean up the data and the variables. 
Contents
-	Origin of the data
-	The initial dataset
-	Transformations applied to the data
-	Transformations applied to the variable names
-	Variables description
-	Match of the old and new variable names


## Origin of the data

The original data and its description is available at this site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

**Abstract**: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

**Source**:
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws
**Citation request**:
Use of this dataset in publications must be acknowledged by referencing the following publication:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

## The initial dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the authors captured 3-axial linear acceleration vector and 3-axial angular velocity vector at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The body acceleration signal was obtained by subtracting the gravity from the total acceleration. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cut-off frequency was used. From each window, a vector of 561 features was obtained by calculating variables from the time and frequency domain.

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/sec2).
- The gyroscope units are radians/sec.
- A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: http://www.youtube.com/watch?v=XOEN9W05_4A

After examination, the files included with the data set included the following information: 

-	**README.txt**: information about the experiment

-	**features_info.txt**: information about the variables in the 'feature' vector.

-	**features.txt**: two lines file with integers from 1 to 561, and 561 'features', i.e. variable names for the data.

-	**activity_labels.txt**: links the integer activity identifiers (from 1 to 6) with their text activity name. Two lines, 6 elements.

-	**train/X_train.txt**: 7352 observations for 561 variables, without variable names, without subject identifiers, without activity identifiers - the "Training set".

-	**train/y_train.txt**: integer activity identifiers (from 1 to 6) for each observation of the "Training set". 7352 observations.

-	**test/X_test.txt**: 2947 observations for 561 variables, without variable names, without subject identifiers, without activity identifiers - the "Test set".

-	**test/y_test.txt**: integer activity identifiers (from 1 to 6)  for each observation of the "Test set". 2947 observations.

-	**train/subject_train.txt**: one row with 7352 integers, which identify the subject who performed the activity for each observation in the "Training set". Integers range from 1 to 30. 
-	**test/subject_test.txt**: one row with 2947 integers, which identify the subject who performed the activity for each observation in the "Test set". Integers range from 1 to 30. 

-	In addition, the files with **Inertial Signals** were available, but were not used, because the data are already included in the 561 variables in the Training and Test sets.


## Transformations applied to the data

We tidied and prepared the dataset for further analysis via the following steps:

1.	Data were pulled together from separate files* to combine the "Training" and "Test" data together (possible because they were separated randomly) and to add to the data respective columns for the activity performed and the subject performing the activity, resulting in 10299 obs. of 563 variables. The variables were also named according to the original 'Feature' list.

2.	The data were trimmed to extract (using grep()) and retain only the Mean and Standard Deviation columns for each variable/measurement type, resulting in 88 variables. The variables "Angle" were also retained because they are the angles with the Mean vector.

3.	The integer activity identifiers in each row were replaced with the respective text labels for ease of interpretation and analysis.

4.	The variables is resulting data set were renamed using regular expression functions with more descriptive variable names and the punctuation marks, such as "()" and "-", were removed, which should improve readability, ease of programming and interpretation.

5.	An additional data set was created from the step above by summarising the averages (using function mean()) of each of the 86 numeric variables grouped by activity and by subject (using group_by() and summarise_all(mean) in dplyr package). A column "Number_observations" was added to count the number of observations (via n()) per activity per study participant over which the above averages were calculated. The resulting data frame "Meansdata" has **180 observations of 89** variables, including a column "Subject_id" (Integer), a column for the "Activity" (character), and the other 86 numeric variables. Each row represents a distinct observation on the full set of variables with identifiable activity and subject. Each column represents a distinct variable type not overlapping or duplicated in the data set. There are no NA values in the data. The data frame includes column names. The column names for numeric variables have been amended with a prefix "AVG_".

6.	See further section for variables description.
7.	See the file run_analysis.R for the script details.

*More detailed description of step 1:
a)	We downloaded and unzipped the original dataset into a local folder.
b)	We read data text files into R using read.table().
c)	We obtained the "Training set" data frame of 7352 observations for 561 unnamed variables from train/X_train.txt. 
d)	We appended using cbind() to the left of the data a column, later named "Activity", containing integer activity identifiers for each observation of the "Training set" from the file y_train.txt. 
e)	Then we appended using cbind() to the left of the data resulting from previous step the column, later named "Subject_id", containing the integer identifiers of the subject who performed the activity for each observation in the "Training set" (from file subject_train.txt).
f)	We obtained a data frame with 7352 observations for 563 variables.
g)	We repeated steps c) to e) for the "Test set" resulting in 2947 observations of 563 variables.
h)	We appended the "Test set" to the bottom of "Training set" using rbind().
i)	We named the columns in resulting dataset data using variable names from features.txt, naming the first column "Subject_id", and the second "Activity".


## Transformations applied to the variable names

We modified the variable names to improve their readability and usability in programming and to facilitate interpretation. The following describes the changes:
1.	The variable names are composed of a number of elements.

2.	The variables saved in file "datafile.txt" have the prefix **"AVG_"** at the beginning to denote the averages (i.e. means) per activity and per test participant. Additional column "Number_observations" contains the number of observations per activity per study participant over which the above averages were calculated.

3.	The original data come from the accelerometer and gyroscope 3-axial raw signals. The measurements coming from the accelerometer are denoted **"Accel"** that stands for acceleration. This seems to be a more intuitive abbreviation for a variable name. 

4.	The measurements from a gyroscope are denoted **"Gyro"**, they measure angular velocity.

5.	The 3-axial raw signal is registered using 3 separate measurements on each of the 3 axes: X, Y and Z. The name of the respective axis is denoted in the variable names **"X"**, **"Y"**, and **"Z"**.

6.	The body acceleration signal was obtained by subtracting the gravity from the total acceleration. Given that most variables in the original data set are already calculated variables pertaining to the measures of body acceleration or gyration, we **omit the word "body"** from those variables. It is understood that unless specified otherwise in the name, all variables relate to the body motion component of the measures / features.

7.	We **keep the word "Gravity"** in the names of the variables measuring specifically gravity parameters and gravity components of the measures.

8.	Given all raw data and most original variables are "time domain signals" and have the prefix 't' to denote time at the beginning of the variable name, we will **omit this "t" label**. It is understood that unless specified otherwise in the variable names, the measurements pertain to time domain signals.

9.	Part of the original variables have a prefix **'f' at the beginning to indicate "frequency domain signals"**. These variables result from applying a Fast Fourier Transformation (FFT) to the time signals. We will keep the prefix "f" to identify these variables. This will also enable fast selection based on "f" when analysing the data.

10.	The variable **"Magnitude"** represents the length of these three-dimensional vector signals calculated using the Euclidean norm (denoted as "Mag" in the original dataset). The Euclidean norm, or Euclidean length, or magnitude of a vector measures the length of the vector. It gives the ordinary distance from the origin to the point X, a consequence of the Pythagorean theorem. (source: https://en.wikipedia.org/wiki/Euclidean_distance , https://en.wikipedia.org/wiki/Norm_(mathematics))

11.	We replaced the term "Jerk" with the term **"Surge"**.
In physics, jerk, also known as jolt, surge, or lurch, is the rate of change of acceleration; that is, the derivative of acceleration with respect to time. It is a vector. The SI units of jerk are m/s3 (or m·s-3); jerk can also be expressed in standard gravity per second (g/s).(Source: Wikipedia)
The Jerk variables in the original dataset were derived from the body linear acceleration and the body angular velocity, themselves calculated from the row data.
The surge in Acceleration variables denotes changes in body linear acceleration.
The surge in Gyro variables denotes changes of direction.

12.	In this dataset we extract only the variables of the mean and of the standard deviation estimated by the authors based on raw signals and present in the 561 "features". It is not clear from the original description from how many data points are these means calculated. More information can be obtained by contacting: activityrecognition@smartlab.ws. 
The variables will be denoted in the variable names as follows: 
**"MEAN"**: Mean value
**"STD"**: Standard deviation

13.	The variable Freqmean() are replaced with **"MEAN_Freq"**, mean frequency variables, calculated as weighted average of the FFT frequency components.

14.	We used capital letter in **"Angle_"**: the angle between two vectors, obtained by averaging the signals in a signal window sample.

15.	To make the variable names more tidy and easier to use in programming, we **removed all the punctuation marks**, such as "-", and "()" from the original variables.

The table with the old and new variable names is at the bottom of this document.


## Description of the variables

Units for the acceleration, the "Accel_" variables are gravity, as gravity of earth 9.80665 m/sec2, (g).
Units for the "Gyro_" variables are radians per second (rad/s).
Units for "Surge_" variables are m/s3 (m·s-3) or gravity per second (g/s) 
"FFT" stands for Fast Fourier Transform, variables of frequency domain signals
Non FFT variables are time domain signals.
"num" stands for "numeric" values.

**Variables**:

1.	**Subject_id** :  int,  Integer between 1 and 30, identifying test participant.
2.	**Activity** :  chr,  WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
3.	**AVG_Accel_MEAN_X**  : num,  Mean body acceleration on X axis, (g)
4.	**AVG_Accel_MEAN_Y**  : num,  Mean body acceleration on Y axis, (g)
5.	**AVG_Accel_MEAN_Z**  : num,  Mean body acceleration on Z axis, (g).
6.	**AVG_Accel_STD_X** : num,  Standard deviation of body acceleration on X axis, (g).
7.	**AVG_Accel_STD_Y** : num,  Standard deviation of body acceleration on Y axis, (g).
8.	**AVG_Accel_STD_Z** : num,  Standard deviation of body acceleration on Z axis, (g).
9.	**AVG_GravityAccel_MEAN_X** : num,  Mean gravity component of acceleration on X axis, (g)
10.	**AVG_GravityAccel_MEAN_Y** : num,  Mean gravity component of acceleration on Y axis, (g)
11.	**AVG_GravityAccel_MEAN_Z** : num,  Mean gravity component of acceleration on Z axis, (g)
12.	**AVG_GravityAccel_STD_X** : num,  Standard deviation of gravity component of acceleration on X, (g)
13.	**AVG_GravityAccel_STD_Y** : num,  Standard deviation of gravity component of acceleration on Y, (g)
14.	**AVG_GravityAccel_STD_Z** : num,  Standard deviation of gravity component of acceleration on Z, (g)
15.	**AVG_Accel_Surge_MEAN_X** : num,  Mean rate of change of body acceleration on X axis,  (g/s)
16.	**AVG_Accel_Surge_MEAN_Y** : num,  Mean rate of change of body acceleration on Y axis,  (g/s)
17.	**AVG_Accel_Surge_MEAN_Z** : num,  Mean rate of change of body acceleration on Z axis,  (g/s)
18.	**AVG_Accel_Surge_STD_X** :  num,  Standard deviation of rate of change of body acceleration on X,  (g/s)
19.	**AVG_Accel_Surge_STD_**:  num, Standard deviation of rate of change of body acceleration on Y,  (g/s)
20.	**AVG_Accel_Surge_STD_Z**  :  num,  Standard deviation of rate of change of body acceleration on Z,  (g/s)
21.	**AVG_Gyro_MEAN_X** : num,  Mean body angular velocity on X axis,  (rad/s)
22.	**AVG_Gyro_MEAN_Y** : num,  Mean body angular velocity on Y axis,   (rad/s)
23.	**AVG_Gyro_MEAN_Z** : num,  Mean body angular velocity on Z axis,   (rad/s)
24.	**AVG_Gyro_STD_X** : num,  Standard deviation of body angular velocity on X axis,  (rad/s)
25.	**AVG_Gyro_STD_Y** : num,  Standard deviation of body angular velocity on Y axis,  (rad/s)
26.	**AVG_Gyro_STD_Z** : num,  Standard deviation of body angular velocity on Z axis,  (rad/s)
27.	**AVG_Gyro_Surge_MEAN_X**  :   num, Mean rate of change of body angular velocity, change of direction on X (rad/s2)
28.	**AVG_Gyro_Surge_MEAN_Y**  :   num, Mean rate of change of body angular velocity, change of direction on Y (rad/s2)
29.	**AVG_Gyro_Surge_MEAN_Z**  :   num, Mean rate of change of body angular velocity , change of direction on Z, (rad/s2)
30.	**AVG_Gyro_Surge_STD_X**: num, Standard deviation of rate of change of body angular velocity , change of direction on X, (rad/s2)
31.	**AVG_Gyro_Surge_STD_Y**: num, Standard deviation of rate of change of body angular velocity , change of direction on Y, (rad/s2)
32.	**AVG_Gyro_Surge_STD_Z**: num, Standard deviation of rate of change of body angular velocity , change of direction on Z, (rad/s2)
33.	**AVG_Magnitude_Accel_MEAN** :  num, Mean magnitude, lengths of vector of body acceleration, (g)
34.	**AVG_Magnitude_Accel_STD** :  num, Standard deviation of magnitude of vector of body acceleration, (g)
35.	**AVG_Magnitude_GravityAccel_MEAN** :  num, Mean magnitude of gravity component of acceleration, (g)
36.	**AVG_Magnitude_GravityAccel_STD** :  num , Standard deviation of magnitude of gravity component of acceleration, (g)
37.	**AVG_Magnitude_Accel_Surge_MEAN** :  num, Mean magnitude of rate of change of body acceleration, (g/s)
38.	**AVG_Magnitude_Accel_Surge_STD** :  num  Standard deviation of magnitude of rate of change of body acceleration, (g/s)
39.	**AVG_Magnitude_Gyro_MEAN** :  num, Mean magnitude of body angular velocity, (rad/s)
40.	**AVG_Magnitude_Gyro_STD** :  num, Standard deviation of magnitude of body angular velocity, (rad/s)
41.	**AVG_Magnitude_Gyro_Surge_MEAN** :  num, Mean magnitude of rate of change of body angular velocity,  change of direction (rad/s2)
42.	**AVG_Magnitude_Gyro_Surge_STD** :  num  Standard deviation of rate of change of magnitude of body angular velocity, change of direction (rad/s2)
43.	**AVG_f_Accel_MEAN_X** :  num, Mean Fast Fourier Transformation (FFT) of body acceleration on X
44.	**AVG_f_Accel_MEAN_Y** :  num,  Mean FFT of mean body acceleration on Y axis
45.	**AVG_f_Accel_MEAN_Z **:  num,  Mean FFT of mean body acceleration on Z axis
46.	**AVG_f_Accel_STD_X** :  num, Standard deviation of FFT of body acceleration on X
47.	**AVG_f_Accel_STD_Y** :  num, Standard deviation of FFT of body acceleration on Y
48.	**AVG_f_Accel_STD_Z** :  num, Standard deviation of FFT of body acceleration on Z
49.	**AVG_f_Accel_MEAN_Freq_X** :  num, Mean frequency of FFT of body acceleration on X. (Weighted average of the frequency components to obtain a mean frequency) 
50.	**AVG_f_Accel_MEAN_Freq_Y** :  num, Mean frequency of FFT of body acceleration on Y. (Weighted average of the frequency components to obtain a mean frequency)
51.	**AVG_f_Accel_MEAN_Freq_Z** :  num, Mean frequency of FFT of body acceleration on Z. (Weighted average of the frequency components to obtain a mean frequency)
52.	**AVG_f_Accel_Surge_MEAN_X** :  num, Mean FFT of rate of change of body acceleration on X
53.	**AVG_f_Accel_Surge_MEAN_Y** :  num, Mean FFT of rate of change of body acceleration on Y
54.	**AVG_f_Accel_Surge_MEAN_Z** :  num, Mean FFT of rate of change of body acceleration on Z
55.	**AVG_f_Accel_Surge_STD_X** :  num, Standard deviation of FFT of rate of change of body acceleration on X
56.	**AVG_f_Accel_Surge_STD_Y** :  num, Standard deviation of FFT of rate of change of body acceleration on Y
57.	**AVG_f_Accel_Surge_STD_Z** :  num, Standard deviation of FFT of rate of change of body acceleration on Z
58.	**AVG_f_Accel_Surge_MEAN_Freq_X** : num, Mean frequency of FFT of rate of change of body acceleration on X. (Weighted average of the frequency components to obtain a mean frequency)
59.	**AVG_f_Accel_Surge_MEAN_Freq_Y** : num, Mean frequency of FFT of rate of change of body acceleration on Y. (Weighted average of the frequency components to obtain a mean frequency)
60.	**AVG_f_Accel_Surge_MEAN_Freq_Z** : num,  Mean frequency of FFT of rate of change of body acceleration on Z. (Weighted average of the frequency components to obtain a mean frequency)
61.	**AVG_f_Gyro_MEAN_X** :  num,  Mean FFT of body angular velocity on X axis
62.	**AVG_f_Gyro_MEAN_Y** :  num,  Mean FFT of mean body angular velocity on Y axis
63.	**AVG_f_Gyro_MEAN_Z** :  num,  Mean FFT of mean body angular velocity on Z axis
64.	**AVG_f_Gyro_STD_X** :  num,  Standard deviation of FFT of body angular velocity on X axis
65.	**AVG_f_Gyro_STD_Y** :  num,  Standard deviation of FFT of body angular velocity on Y axis
66.	**AVG_f_Gyro_STD_Z** :  num,  Standard deviation of FFT of body angular velocity on Z axis
67.	**AVG_f_Gyro_MEAN_Freq_X** :  num,  Mean frequency of  FFT of body angular velocity on X axis. (Weighted average of the frequency components to obtain a mean frequency)
68.	**AVG_f_Gyro_MEAN_Freq_Y** :  num,  Mean frequency of  FFT of body angular velocity on Y axis. (Weighted average of the frequency components to obtain a mean frequency)
69.	**AVG_f_Gyro_MEAN_Freq_Z** :  num,  Mean frequency of  FFT of body angular velocity on Z axis. (Weighted average of the frequency components to obtain a mean frequency)
70.	**AVG_f_Magnitude_Accel_MEAN** :  num,  Mean FFT magnitude of body acceleration
71.	**AVG_f_Magnitude_Accel_STD** :  num,  Standard deviation of FFT of magnitude of body acceleration
72.	**AVG_f_Magnitude_Accel_MEAN_Freq** :  num,  Mean frequency of  FFT of magnitude of body acceleration. (Weighted average of the frequency components to obtain a mean frequency)
73.	**AVG_f_Magnitude_Accel_Surge_MEAN** : num,  Mean FFT magnitude of rate of change of body acceleration. 
74.	**AVG_f_Magnitude_Accel_Surge_STD** :  num,  Standard deviation of FFT of magnitude of rate of change of body acceleration
75.	**AVG_f_Magnitude_Accel_Surge_MEAN_Freq** :  num,  Mean frequency of  FFT of magnitude of rate of change of body acceleration. (Weighted average of the frequency components to obtain a mean frequency)
76.	**AVG_f_Magnitude_Gyro_MEAN** :  num,  Mean FFT magnitude of body angular velocity
77.	**AVG_f_Magnitude_Gyro_STD** :  num,  Standard deviation of FFT of magnitude of body angular velocity
78.	**AVG_f_Magnitude_Gyro_MEAN_Freq** :  num,  Mean frequency of FFT of magnitude of body angular velocity. (Weighted average of the frequency components to obtain a mean frequency)
79.	**AVG_f_Magnitude_Gyro_Surge_MEAN** :  num,  Mean FFT magnitude of rate of change of body angular velocity, of change of direction
80.	**AVG_f_Magnitude_Gyro_Surge_STD** :  num,  Standard deviation of FFT of magnitude of rate of change of body angular velocity, of change of direction
81.	**AVG_f_Magnitude_Gyro_Surge_MEAN_Freq** :  num,  Mean frequency of FFT of magnitude of rate of change of body angular velocity. (Weighted average of the frequency components to obtain a mean frequency)
82.	**AVG_Angle_AccelMean_vs_gravityMean** :  num,  angle between two vectors: body acceleration mean and gravityMean vectors, obtained by averaging the signals in a signal window sample 
83.	**AVG_Angle_Accel_SurgeMean_vs_gravityMean**: num, angle between two vectors: body acceleration_SurgeMean and gravityMean, obtained by averaging the signals in a signal window sample
84.	**AVG_Angle_GyroMean_vs_gravityMean** :  num  angle between two vectors: GyroMean and gravityMean, obtained by averaging the signals in a signal window sample
85.	**AVG_Angle_Gyro_SurgeMean_vs_gravityMean** :  num,  angle between two vectors: Gyro_SurgeMean and gravityMean, obtained by averaging the signals in a signal window sample
86.	**AVG_Angle_X_vs_gravityMean** :  num,  angle between two vectors:  X axis and gravityMean, obtained by averaging the signals in a signal window sample
87.	**AVG_Angle_Y_vs_gravityMean** :  num,  angle between two vectors:  Y axis and gravityMean obtained by averaging the signals in a signal window sample
88.	**AVG_Angle_Z_vs_gravityMean** :  num,  angle between two vectors: Z axis and gravityMean, obtained by averaging the signals in a signal window sample
89.	**Number_observations** : num, Number of observations per activity per study participant over which the averages "AVG" were calculated, not the number of observations for the "MEANS" and "STD" variables.


## Match of the old and new variable names

```{r}
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
```

