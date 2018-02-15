---
title: "README.md"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Getting and Cleaning data - final project 

This describes the set of files resulting from the work done as part of Coursera course "Getting and Cleaning data" by John Hopkins University.


The original data and its original description is available at this site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

**Abstract**: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

**Authors citation request**:
Use of this dataset in publications must be acknowledged by referencing the following publication:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

## The tidy dataset

The tidy data are available in the file **"datafile.txt"**.

Data were pulled together from separate files to combine the "Training" and "Test" data together and to add the respective columns for the activity performed and the subject performing the activity. Humanly comprehensble activity descriptions and variable names were added to the data. The mean and standard deviation variables were extracted from the original set and further summarised as the averages (i.e. means) for each of the 86 numeric variables grouped by activity and by subject. A column was added to count the number of observations per activity per particupant over which these averages were calculated. The column names for numeric variables have been amended with a prefix "AVG_".

The resulting data frame has 180 obs. of  89 variables, including a column "Subject_id" (Integer), a column for the "Activity" (character), a column "Number_observations", and the other 86 numeric variables. Each row represents a distinct observation on the full set of variables with identifiable activity and subject (i.e. test participant). Each column represents a distinct variable type not overlapping or duplicated in the data set. There are no NA values in the data. The data frame includes column names.

These data therefore satisfy the principle criteria for tidy data as discussed in the following articles:
Hadley Wickham.Tidy data.The Journal of Statistical Software, vol. 59, 2014.
http://www.stat.wvu.edu/~jharner/courses/stat623/docs/tidy-dataJSS.pdf
David Hood
https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

They data can be viewed using this code:
```{r}
address <- "###"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```

## Run_analysis.R

This is the R script file that performs the cleaning and tidying of the dataset as per the excercise and as described below. The tidy dataset was processed using R version 3.4.3 and RStudio on Windows 10.

1.	Pulling together data from separate files* to combine the "Training" and "Test" data together (possible because they were separated randomly) and to add to the data respective columns for the activity performed and the subject performing the activity. The variables were also named according to the original 'Feature' list.

2.	Trimming the data to extract (using grep()) and retain only the Mean and Standard Deviation columns for each variable/measurement type. The variables "Angle" were also retained because they are the angles with the Mean vector. The data frame had 10299 obs. of  88 variables.

3.	Replacing the integer activity identifiers in each row with the respective text labels for ease of interpretation and analysis.

4.	Renaming the variables is resulting data set using regular expression functions with more descriptive variable names and removing the punctuation marks, such as "()" and "-", which should improve readability, ease of programming and interpretation.

5.	Creates an additional data set from the step above by summarising the averages (using function mean()) of each of the 86 numeric variables grouped by activity and by subject (using group_by() and summarise_all(mean) in dplyr package). A column "Number_observations" was added to count the number of observations (via n()) per activity per study particupant/subject over which the above averages were calculated. 

The resulting data frame has 180 observations of 89 variables, including a column "Subject_id" (Integer), a column for the "Activity" (character), and the other 86 numeric variables. Each row represents a distinct observation on the full set of variables with identifiable activity and subject. Each column represents a distinct variable type not overlapping or duplicated in the data set. There are no NA values in the data. The data frame includes column names. The column names for numeric variables have been amended with a prefix "AVG_". See the code book for variable names and descriptions.

6.	The script generates a tidy data text file that meets the principles of Hadley Wickham's article on tidy data.
http://www.stat.wvu.edu/~jharner/courses/stat623/docs/tidy-dataJSS.pdf.

*More detailed breakdown of step 1:
a)	We downloaded and unzipped the original dataset into a local folder.
b)	We read data text files into R using read.table().
c)	We obtained the "Training set" data frame of 7352 observations for 561 unnamed variables from train/X_train.txt. 
d)	We appended using cbind() to the left of the data a column, later named "Activity", containing integer activity identifiers for each observation of the "Training set" from the file y_train.txt. 
e)	Then we appended using cbind() to the left of the data resulting from previous step the column, later named "Subject_id", containing the integer identifiers of the subject who performed the activity for each observation in the "Training set" (from file subject_train.txt).
f)	We obtained a data frame with 7352 observations for 563 variables.
g)	We repeated steps c) to e) for the "Test set" resulting in 2947 observations of 563 variables.
h)	We appended the "Test set" to the bottom of "Training set" using rbind().
i)	We named the columns in resulting dataset data using variable names from features.txt, naming the first column "Subject_id", and the second "Activity".


## CodeBook.md

This describes the data, and any work performed to tidy up the data and rename the variables. 

It modifies and updates the codebook supplied with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information:

-	Origin of the data
-	The initial dataset
-	Transformations applied to the data
-	Transformations applied to the variable names
-	Variables description
-	Match of the old and new variable names

