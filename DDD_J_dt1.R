library(rpart)
library(rpart.plot)
library(caret)

studentInfo_DDDJ_v1 = read.csv2('../data/studentInfo_DDDJ_v1.csv', sep=',')

studentInfo_DDDJ_v1 = subset(studentInfo_DDDJ_v1, selecct = -c(score))
colnames(studentInfo_DDDJ_v1)

set.seed(42)
train_indexes = createDataPartition(studentInfo_DDDJ_v1$"final_result", p=.9, list=FALSE)
studentInfo_train = studentInfo_DDDJ_v1[train_indexes,]
studentInfo_test = studentInfo_DDDJ_v1[-train_indexes,]

nrow(studentInfo_DDDJ_v1)
nrow(studentInfo_train)+nrow(studentInfo_test)

# nie tykać bo się wytrenowało długo
tree.0.1 = rpart(final_result ~ ., data=studentInfo_train, control = list(maxdepth=20))

rpart.plot(tree.0.1, under=FALSE, tweak=1.3, fallen.leaves=TRUE)

