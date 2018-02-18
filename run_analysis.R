#download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'UCI HAR Dataset.zip')
#unzip('UCI HAR Dataset.zip')

features <- read.table('UCI HAR Dataset/features.txt', sep=' ', header = FALSE)
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt', sep=' ', header = FALSE)

tidyup <- function(featuresFileName, activitiesFileName, subjectsFileName)
{
  test_features <- read.table(featuresFileName, header = FALSE)
  test_activities <- read.table(activitiesFileName, header = FALSE)
  test_subjects <- read.table(subjectsFileName, header = FALSE)
  
  activities <- merge(test_activities, activity_labels, by.x = "V1", by.y = "V1", all = TRUE)['V2']
  colnames(activities)[1] <- 'Activity'
  colnames(test_subjects)[1] <- 'Subject'
  colnames(test_features) <- features[['V2']]
  
  cbind(test_subjects, activities, test_features)  
}

trainingSet <- tidyup('UCI HAR Dataset/train/X_train.txt', 'UCI HAR Dataset/train/y_train.txt', 'UCI HAR Dataset/train/subject_train.txt')
testSet <- tidyup('UCI HAR Dataset/test/X_test.txt', 'UCI HAR Dataset/test/y_test.txt', 'UCI HAR Dataset/test/subject_test.txt')
totalSet <- rbind(testSet, trainingSet)

meanColumns <- colnames(totalSet)[grepl("mean\\(\\)", colnames(totalSet))]
stdColumns <- colnames(totalSet)[grepl("std\\(\\)", colnames(totalSet))]
meanAndStdSet <- totalSet[,c('Subject', 'Activity', meanColumns, stdColumns)]

result <- aggregate(meanAndStdSet[,-2:-1], list(meanAndStdSet$Subject, meanAndStdSet$Activity), mean)
colnames(result)[1] <- 'Subject'
colnames(result)[2] <- 'Activity'

write.table(result, file = 'tidydata.txt', row.name=FALSE)