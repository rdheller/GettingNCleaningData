Datacleanup
=========== For project in the Data Cleanup Coursera


run_analysis.R discussion:

This project broke downinto 5 sections, based on the 5 questions asked in the introduction.
As a result, there are 5 sections to the program.

Section 1 - Merge the training and data sets

        Following a download and unzipping the data, the program loads the appropriate
        libraries and reads the data from the directory containing the data.

        Merging the data sets is a straight forward operation using cbind
        or rbind as appropriate.  The elements include:

                1. binding the columns of the Y data (both test and training)
                2. binding the columns of the X data (both test and training)
                3. binding the rows of the two data sets

        For this section, I labeled the final data set as "total" with 10299 rows and
        563 columns

Section 2 - Extracting only the relevant mean and standard deviation data

        In order to select the appropriate means and standard deviation data, I
        went to the features.txt file and identified those rows that had "mean"
        or "std" in column V2.  This used the grep function and resulted in two
        more dataframes: "meandata" and "stddata."
        
        I did and columns 1 and 2 for activity and subject as this would be important
        later, but seemed easier to incorporate that step in this section.

        Finally, I did a cbind operation on the "meandata" and "stddata" dataframes

        For this section, I labeled the final data set as "alldata" with 10299 rows 
        and 81 columns

Section 3 - Using the descriptive activities (Walking, walking upstairs, etc.) in
        place of the coded data (1, 2, 3, 4, 5, 6) in the "Subject" column

        This step consisted of simply substituting the data names in the activites.txt
        dataframe into the first column of "alldata" using the names/match command
        

        "alldata" continued to have 10299 rows and 81 columns, with alldata$V1 
        containing all the activities ordered by the original variables in the 
        alldata$V1 column

Section 4 - Appropriately naming the data set with the descriptive variables names

        For this section, I grabbed the column names from featurestxt and 
        did an rbind to put them together them together into a list named
        vardatanames

        Then, I added the Activity and Subject titles to create a data frame called
        alldatanames.  

        With that list of names, I just had to do a colnames command to attach 
        them to "alldata" dataset.  The data set consisted of the first two
        columns as the "Activity" and the "Subject", followed by a block of
        data containing the means data, and a final block of the standard deviation
        data.

        "alldata continued to have 10299 rows and 81 columns, only now alldata 
        contained both the activity labels in the rows and the descriptive varialbe
        names as column labels

Section 5 - Take the averages of the variables by activity over all the subjects

        This was, perhaps the most difficult problem to attack, but fortunately
        I was able to crack it.  I started by trying to conceptualize what the 
        outcome would look like and came up with the model below:

  Activity.......tXXXXXX-X.......tXXXXXXX-Y..........tXXXXXXX-Z..........ETC.    
  STANDING........##.####..........##.####.............##.####...........ETC.       
  WALKING.........##.####..........##.####.............##.####...........ETC.    


        Because this was to be a new data set, I copied "alldata" into a temporary
        file, "x" and picked off the row and column names into new variables

        From there, I did a melt on the rownames, the activity and subuject columns.
        Then, I did a dcast against the activity and the variables, summarizing 
        by the average.  This resulted in a table of 6 rows (one for each activity)
        and 80 columns (one column for each of the variables.)

        I stored the result in the data frame, "datameans" which had 6 rows and 
        80 columns.

        Finally, I exported the data to 'tidydata' as a text file.

## ----------------------------------------------------
