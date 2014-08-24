#Reading in the files of the dataset. The R file should sit in the same folder as the test and train folders

xTrain <- read.table("./train/X_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")
yTrain <- read.table("./train/y_train.txt")

xTest <- read.table("./test/X_test.txt")
subjectTest <- read.table("./test/subject_test.txt")
yTest <- read.table("./test/y_test.txt")

features <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")
#############################################################################

#Binding the train, test x data together, and assigning names from the features file
xy <- rbind(xTest,xTrain)
names(xy) <- features$V2

#Filtering the mean and standard deviation columns
meanCols <- grep(".*mean().*", features$V2)
stdCols <- grep(".*std().*", features$V2)

meanStdCols <- union(meanCols, stdCols)
meanStdData <- xy[,meanStdCols]

#############################################################################

#Appending the subject and Activity columns
subject <- rbind(subjectTest,subjectTrain)
y <- rbind(yTest,yTrain)
tidy1 <- cbind(meanStdData,subject,y)


colnames(tidy1) [80] <- "Subject"
colnames(tidy1) [81] <- "Activity"

#Replacing the activity numbers with descriptive activity names
tidy1$Activity <- activityLabels[tidy1$Activity, 2]

#Melting and casting the data to have mean values for every subject + activity
tidy1Melt <- melt(tidy1, id = c("Subject","Activity"))
tidy1Cast <- dcast(tidy1Melt, Subject + Activity ~ variable, mean)
#############################################################################

#Appropriately labeling the variable names(columns)

tidyNames <- names(tidy1Cast)
tidyNames <- gsub("-X", " on X Axis", tidyNames)
tidyNames <- gsub("-Y", " on Y Axis", tidyNames)
tidyNames <- gsub("-Z", " on Z Axis", tidyNames)
tidyNames <- gsub("-mean\\(\\)", " Average value", tidyNames)
tidyNames <- gsub("-std\\(\\)", " Std Deviation", tidyNames)
tidyNames <- gsub("^t", "", tidyNames)
tidyNames <- gsub("^f", "", tidyNames)
tidyNames <- gsub("Acc", " Accelaration", tidyNames)
tidyNames <- gsub("Jerk", " Jerk", tidyNames)
tidyNames <- gsub("BodyBody", "Body", tidyNames)
tidyNames <- gsub("BodyGyro", "Body Gyroscope", tidyNames)
tidyNames <- gsub("meanFreq\\(\\)", "Mean Frequency", tidyNames)
tidyNames <- gsub("Mag", " Magnitude", tidyNames)

names(tidy1Cast) <- tidyNames
#############################################################################

#Writing the result
write.table(tidy1Cast,file = "./tidyData.txt", row.name =FALSE)

#verifyData <- read.table("tidyData.txt")