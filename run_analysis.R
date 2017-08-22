# - Load packages and data 
if (1) {
# - Define Libraries
library("dplyr")
library("reshape")
library("reshape2")

filename <- "getdata_dataset.zip"
  
## Download and unzip the dataset:
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, mode = "wb")
}  
if (!file.exists("UCI HAR Dataset")) { 
unzip(filename) 
}

setwd("./UCI HAR Dataset")
# - Define File Paths
fp_activity_labels <- "activity_labels.txt"
fp_features <- "features.txt"
fp_train_x <- "./train/X_train.txt"
fp_train_label <- "./train/Y_train.txt"
fp_train_subject <- "./train/subject_train.txt"

fp_test_x <- "./test/X_test.txt"
fp_test_label <- "./test/Y_test.txt"
fp_test_subject <- "./test/subject_test.txt"

# - load activity labels
activity_labels <- read.table(fp_activity_labels) 
names(activity_labels) <- c("label","activity_desc")
features <- read.table(fp_features) 

# - Load training data set
train_x <- read.table(fp_train_x) 
names(train_x) <-  features$V2
train_subject <- read.table(fp_train_subject) 
names(train_subject) <- "subject"
train_label <- read.table(fp_train_label)
names(train_label) <- "label"

train_data <- cbind(train_label,train_subject,train_x)
train_data$data_type <- "train"

# - Load test data set
test_x <- read.table(fp_test_x) 
names(test_x) <-  features$V2
test_subject <- read.table(fp_test_subject) 
names(test_subject) <- "subject"
test_label <- read.table(fp_test_label)
names(test_label) <- "label"

test_data <- cbind(test_label,test_subject,test_x)
test_data$data_type <- "test"
}

# - Join train and test data sets
data_set <- as.data.frame(rbind(test_data,train_data)) 
data_set <- merge(data_set,activity_labels)

# - Extract mean and std dev columns only
mean_cols <- grep("mean", names(data_set) )
std_cols  <-grep("std", names(data_set) )
desc_cols <- which(names(data_set) %in% c("label","subject","activity_desc") ) 
reduced_data_set <- data_set[,c(desc_cols,mean_cols,std_cols)] 
names(reduced_data_set) <- gsub('-mean', 'Mean',names(reduced_data_set))
names(reduced_data_set) <- gsub('-std', 'Std',names(reduced_data_set))
names(reduced_data_set) <- gsub('[-()]', '',names(reduced_data_set))

write.table(reduced_data_set,"./tidy_data.txt",row.name=FALSE)

# - Creating independent tidy data set with the average 
# of each variable for each activity and each subject.
col_list <- names(reduced_data_set[,4:82])

metlted_data <- melt(reduced_data_set, id=c("subject","activity_desc"),
              measure.vars=col_list)

averages <- reshape2::dcast(metlted_data, subject + activity_desc ~ variable,fun.aggregate=mean)

write.table(averages,"./averages.txt",row.name=FALSE)
