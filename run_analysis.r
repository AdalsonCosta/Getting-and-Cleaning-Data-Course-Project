
setwd("C:/Temp/Fontes R/Files")
library(dplyr)

# Verificando se o arquivo existe.
#
Filename <- "getdata_projectfiles_UCI HAR Dataset"
if (!file.exists("getdata_projectfiles_UCI HAR Dataset")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}

# Verificando se a pasta existe
#
if (!file.exists("getdata_projectfiles_UCI HAR Dataset")) {
  unzip(filename)
}

activity_labels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "Activity"))
features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", col.names = c("n", "features"))

# conjunto de dados de treinamento
#
subject_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "code")

# conjunto de dados de teste
#
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "code")

# 1 -  Mesclar os conjuntos de treinamento e teste para criar um conjunto de dados.
#
X <- rbind(X_train, X_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# 2 - Extrair mediÃ§Ãµes em mÃ©dia e desvio padrÃ£o para cada mediÃ§Ã£o
#
Data <- Merged_Data%>% select(subject, code, contains("mean"), contains("std"))

# 3  - Usa nomes descritivos de atividades para nomear as atividades no conjunto de dados
#
Data$code <- activity_labels[Data$code, 2]

# 4  - RÃ³tulos apropriados do conjunto de dados com nomes descritivos de variÃ¡veis
#
names(Data)[2] = "activity"
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("^t", "Time", names(Data))
names(Data) <- gsub("^f", "Frequency", names(Data))
names(Data) <- gsub("tBody", "TimeBody", names(Data))
names(Data) <- gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data) <- gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data) <- gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data) <- gsub("angle", "Angle", names(Data))
names(Data) <- gsub("gravity", "Gravity", names(Data))

# 5  - A partir dos dados, crie um segundo conjunto de dados organizado e independente com a mÃ©dia de cada variÃ¡vel
#      para cada atividade e cada assunto
#
FinalData <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))

write.table(FinalData, "getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/FinalData.txt", row.name=FALSE)
