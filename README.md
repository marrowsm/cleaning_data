### run_analysis.R

This code takes data from the UCI HAR data set and tidies it. This data set is described here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

And the data set itself if found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The first section in the script defines the file paths for the data the script loads and it loads the data. This is lines 1 - 45.

The second section joins both the test and the train data sets and returns only the mean and std dev columns as requested.
This section also loads descriptive information into the data (i.e. the activity types). A txt file is written at the end of this section.

Finally, the final part of the script writes a table full of averages by activity type and subject.

