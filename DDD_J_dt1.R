library(rpart)
library(rpart.plot)
library(caret)

setwd("~/LIC_2023/LICENCJAT_SGH_2023")

studentInfo_DDDJ_v1 = read.csv2('../data/studentInfo_DDDJ_v1_2.csv', sep=',')
selected_colnames = c('final_result','region',
                      'highest_education', 'imd_band', 'age_band',
                      'studied_credits', 'date_submitted', 
                      'code_presentation_2014J', 'gender_M', 'disability_Y', 'score')

studentInfo_DDDJ_v1 = subset(studentInfo_DDDJ_v1, select = selected_colnames)

sapply(studentInfo_DDDJ_v1, class)
studentInfo_DDDJ_v1$highest_education = as.integer(studentInfo_DDDJ_v1$highest_education)
studentInfo_DDDJ_v1$age_band = as.integer(studentInfo_DDDJ_v1$age_band)
studentInfo_DDDJ_v1$imd_band = as.integer(studentInfo_DDDJ_v1$imd_band)
studentInfo_DDDJ_v1$date_submitted = as.integer(studentInfo_DDDJ_v1$date_submitted)
studentInfo_DDDJ_v1$final_result = as.factor(studentInfo_DDDJ_v1$final_result)
#studentInfo_DDDJ_v1$region = as.factor(studentInfo_DDDJ_v1$region)
studentInfo_DDDJ_v1$score = as.numeric(studentInfo_DDDJ_v1$score)
sapply(studentInfo_DDDJ_v1, class)

colnames(studentInfo_DDDJ_v1)

#model.1 = lm(score ~ ., data=studentInfo_DDDJ_v1)
#summary(model.1)

ggplot(studentInfo_DDDJ_v1)   +  
  geom_point( 
    aes( x = region, y = age_band,
         col = final_result ))



set.seed(42)
train_indexes = createDataPartition(studentInfo_DDDJ_v1$final_result, p=.9, list=FALSE)
studentInfo_train = studentInfo_DDDJ_v1[train_indexes,]
studentInfo_test = studentInfo_DDDJ_v1[-train_indexes,]

nrow(studentInfo_DDDJ_v1)
nrow(studentInfo_train)
nrow(studentInfo_test)

summary(studentInfo_train)

source('useful_things.R')
get_freq_plot(data = studentInfo_train,
              resp_name = '',
              pred_name = colnames(studentInfo_DDDJ_v1)[0])

# -----------------------------

# nie tykać bo się wytrenowało długo
tree.0.1 = rpart(final_result ~  region, #'highest_education', 'imd_band', 'age_band', 'studied_credits', 'date_submitted', 'code_presentation_2014J', 'gender_M', 'disability_Y'
                  data=studentInfo_train)#, control = list(maxdepth=20))

rpart.plot(tree.0.1, box.palette="blue")
#, under=FALSE, tweak=1.3, fallen.leaves=TRUE)

