## Set working directory
setwd("C:\Users\Dick\Documents\GitHub\GettingNCleaningData\GettingNCleaningData")


library(plyr)
library(reshape)
library(reshape2)

## Download the file to ./data and unzip it


## fileUr1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## temp <- "C://Users//Dick//Desktop//R-Working Data//data//Proj"
## download.file(fileUr1,temp)
## fileUr2 <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.dat"
## con <- unz(temp, fileUr2)
## data <- matrix(scan(con),ncol=4,byrow=TRUE)
## unlink(temp)
## close(con)

## Read the files in both the test and train directories

featurestxt <- read.table("./data/Proj/UCI HAR Dataset/features.txt")
activitytxt <- read.table("./data/Proj/UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("./data/Proj/UCI HAR Dataset//train/X_train.txt")
y_train <- read.table("./data/Proj/UCI HAR Dataset//train/y_train.txt")
subject_train <- read.table("./data/Proj/UCI HAR Dataset//train/subject_train.txt")

X_test <- read.table("./data/Proj/UCI HAR Dataset//test/X_test.txt")
y_test <- read.table("./data/Proj/UCI HAR Dataset//test/y_test.txt")
subject_test <- read.table("./data/Proj/UCI HAR Dataset//test/subject_test.txt")

## Merge the training and the test sets to create three data tables

totaltrain <- cbind(y_train, subject_train, X_train)
totaltest <-  cbind(y_test, subject_test, X_test)

total <- rbind(totaltest, totaltrain)



## COMPLETED REQUIREMENT 1 - MERGES THE TRAINING AND THE TEST SETS INTO ONE DATASET
## the combined data is the the variable: "total"
## "total has 10299 rows and 563 columns
## -------------------------------------------------------------------------------------

## Next, select only the measurements on the mean and the standard deviation for each measurement
## NOTE: In order to select the means and the standard deviation, I went to the features.txt
##       file and selected only those rows that had "mean" and "std" in column V2

meancols <- grep("mean", featurestxt$V2)
stdcols <- grep("std", featurestxt$V2)
mycols1 <- c(meancols)+2                                        ## this jumps the first two cols
mycols2 <- c(stdcols)+2                                         ## this jumps the first two cols

meandata <- total[ ,c(1,2, mycols1)]                            ## added cols 1 and 2 for 
                                                                ## activity and subject columns.  This is
                                                                ## important for item 3 below
stddata <- total[  ,c(mycols2)]
alldata <- cbind(meandata, stddata)

## At this point, I've extracted all the critical measurements from the columns that contain
## the words "mean" and "std" from the features.txt data

## COMPLETED REQUIREMENT 2 EXTRACTING ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEAUREMENT
## The two files "meandata" and stddata have all the critical information on means and standard deviations
## The two files "meancols" and "stdcols" list the rows that contain the appropriate variable
## names that will be required in step 4

## The combined data is in "alldata"
## "alldata" has 10299 rows and 81 columns
## -----------------------------------------------------------------------------------------


Rows <- c(WALKING=1, WALKING_UPSTAIRS=2,WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)
alldata$V1 <- names(Rows)[match(alldata$V1,Rows)]

## The first column now has the activities, e.g. standing, walking, etc.

## COMPLETED REQUIREMENT 3 DESCRIPTIVE ACTIVITY NAMES THE ACTIVITIES FOR THE DATA IN THE SET
## The combined data is in "alldata"
## "alldata" has 10299 rows and 81 columns and alldata$V1 contains all the activities ordered by
## the original variables in the V1 column
## -----------------------------------------------------------------------------------------

## grab the column names from featurestxt and row-bind them together

meandataname <- featurestxt[meancols, ]
stddataname <- featurestxt[stdcols, ]

vardatanames <- rbind(meandataname, stddataname)

## this is a short program to add the Activity and Subject as column names
## before attaching them to the data frame

df1 <- rbind(data.frame(V1 = 0, V2 = "Subject"),vardatanames)
alldatanames <- rbind(data.frame(V1 = 0, V2 = "Activity"), df1)

## Now, i had to cbind the data names to the appropriate rows in the data set from above

colnames(alldata) <- alldatanames[,2]                             ## adding the column names

## At this point, all the columns are named starting with col1 = Activity, col2 = Participant
## and the rest of the columns are in two blocks, the "means" data and the "standard deviation" data

## COMPLETED REQUIREMENT 4 PUTTING APPROPRIATE LABELS IN THE DATASET WITH DESCRIPTIVE VARIABLE NAMES
## The combined data is in "alldata"
## "alldata" still contains 10299 rows and 81 columns
## -------------------------------------------------------------------------------------------

## Now, the data needs to create a second, independent tidy data set with the average of each variable for 
## each activity and each subject

## Basically, I'd like to see a data set that I can view as:
##
##  Activity    Subject         t.....X         t......Y
##  STANDING    2               ##.####         ##.####   where these values are the subject's average
##  STANDAING   3               ##.####         ##.####         ETC.    
##
##
## So, I need to take the average by activity and subject for each variable
## and I will probably have to apply that function through the entire dataset
##
##


x <- alldata
x$idvar <- rownames(x)

d <- colnames(x)

newx <- xmelt <- melt(x, id=c("idvar","Activity","Subject"),measure.vars=d[3:81])
datameans <- dcast(newx, Activity ~ variable, mean)

## the dataframe "datameans" now contains the averages, for all the variables, for
## all the subjects broken down by activities

## COMPLETED REQUIREMENT 5 CREATING A SECOND, INDEPENDENT TIDY DATA SET WITH THE 
## AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACY SUBJECT
## The combined data is in "datameans"
## "datameans" contains 6 rows of data and 80 columns
## -----------------------------------------------
## Export the file 'datameans' as 'tidydata'

tidydata <- datameans
write.table(tidydata, "tidydata.txt", sep="\t") 

## Enjoy!


