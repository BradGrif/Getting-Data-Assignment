The script creates a merged dataset with the averages and standard deviations for the accelerometer and gyroscope data.

The script first runs downloads the file, unzips the directory and downloads the required files - the pieces of the test and train
datasets, as well as the names of the activities and names of the variables.

The components of the test and train datasets are merged together - the data, the subject number and the activity number.

Then the test and train datasets are combined to create one complete dataset.

The features.txt file is used to add the variable names to the dataset.

The means and standard deviation variables are pulled out using the grepl command. Only variables that include mean() and std() are included
This deliberately excludes the meanfrequency variables and the angle variables including mean - these were not deemed consistent with the exercise instructions

The merge command is used to include the descripted activity names rather than the numbers in the dataset.

FInally, the names of the variables are changed to be more descriptive.

The data variable contains the completed dataset.

A second dataset is created with the average of the variables sorted by activity and subject. This dataset is called secondset.

These datasets can be written into R using the write.table command



