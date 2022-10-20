
###############################################################################
#                           Data Massaging                                    #
###############################################################################

#Importing data set
library(readxl)
cancer_data_frame <- read_excel("Desktop/Data Science R/A2.Individual Assign/Cancer.xlsx")
View(cancer_data_frame)


#Creating a new data frame for analysis
cancer_df <- cancer_data_frame

#Exploring the data to identify potential issues
summary(cancer_df)
table(cancer_df$Cell.size)
table(cancer_df$Normal.nucleoli)
table(cancer_df$Bare.nuclei) #has NA
table(cancer_df$Cl.thickness)
table(cancer_df$Cell.shape)
table(cancer_df$Marg.adhesion)
table(cancer_df$Epith.c.size)
table(cancer_df$Bl.cromatin)
table(cancer_df$Mitoses)
table(cancer_df$Class)

table(cancer_df$Cell.size,cancer_df$Normal.nucleoli)

#Determining which columns have missing values
colSums(is.na(cancer_df)) #no missing values

#Replace all the "NA" in Bare.nuclei" to "0"
cancer_df$`Bare.nuclei_clean`<- as.numeric(gsub("NA","1", cancer_df$Bare.nuclei))

#Removing pre-cleaned 'Bare.nuclei' column
library(dplyr)
cancer_df <- select(cancer_df, -Bare.nuclei)

#Assessing size of the data (observations)
num_obs <- nrow(cancer_df) #699 observations
num_var <- ncol(cancer_df) #11 variables
print(num_obs)
print(num_var)

#Binary variables: for "Class" Benign(0) and Malignant (1)
cancer_df$class_binary <- gsub("benign", "0", cancer_df$Class)
cancer_df$class_binary <- gsub("malignant", "1", cancer_df$class_binary)
cancer_df$class_binary <- as.numeric(cancer_df$class_binary)

table(cancer_df$class_binary) #validation

###############################################################################
#           Q1 Histogram for cell.size and normal.nucleoi                     #
###############################################################################

#1.FREQUENCY HISTOGRAM for cell.size
cell_size <- cancer_df$Cell.size
hist(cell_size)

mean(cell_size) #3.13
table(cell_size)

##Incorporating "class_binary" into the chart 
chart1 <- hist(cell_size[cancer_df$class_binary=="1"],
               main="Histogram of Cell Size",
               xlab="Cell Size",
               col=rgb(1,0,0,0.5),
               xlim=c(1,10),
               ylim=c(0,400),
               freq=TRUE)

hist(cell_size[cancer_df$class_binary=="0"],
     col=rgb(0,0,1,0.5),
     add=TRUE)


##validation 
table(cell_size[cancer_df$class_binary=="1"])
mean(cell_size[cancer_df$class_binary=="1"]) #6.57
table(cell_size[cancer_df$class_binary=="0"])
mean(cell_size[cancer_df$class_binary=="0"]) #1.33

csize_malign <- (cell_size[cancer_df$class_binary=="1"])
csize_benign <- (cell_size[cancer_df$class_binary=="0"])
mean(c(csize_malign,csize_benign)) #3.13


#2.FREQUENCY HISTOGRAM for normal.nucleoi
normal_nucleoli <- cancer_df$Normal.nucleoli
hist(normal_nucleoli)

mean(normal_nucleoli) #2.87
table(normal_nucleoli)

##Incorporating "class_binary" into the chart 
chart2 <- hist(normal_nucleoli[cancer_df$class_binary=="1"],
     main="Histogram of Normal Nucleoli",
     xlab="Normal Nucleoli",
     col=rgb(1,0,0,0.5),
     xlim=c(1,10),
     ylim=c(0,450),
     freq=TRUE)

hist(normal_nucleoli[cancer_df$class_binary=="0"],
     col=rgb(0,0,1,0.5),
     add=TRUE)

##validation 
table(normal_nucleoli[cancer_df$class_binary=="1"])
mean(normal_nucleoli[cancer_df$class_binary=="1"]) #5.863
table(normal_nucleoli[cancer_df$class_binary=="0"])
mean(normal_nucleoli[cancer_df$class_binary=="0"]) #1.29

normal_malign <- (normal_nucleoli[cancer_df$class_binary=="1"])
normal_benign <- (normal_nucleoli[cancer_df$class_binary=="0"])
mean(c(normal_malign,normal_benign)) #2.867


###############################################################################
#                       Q2 UDF range, mean, and sd                            #
###############################################################################
#Creating UDF for range, mean, and sd

range_mu_sigma <- function(ver){
  my_range <- max(ver)-min(ver)
  my_mu <- mean(ver)
  my_sd <- sd(ver)
  return(c(my_range, my_mu, my_sd))
}#closing range_mu_sigma 

range_mu_sigma(ver=cancer_df$Cell.size) #(9.000000, 3.134478, 3.051459)
range_mu_sigma(ver=cancer_df$Normal.nucleoli) #(9.000000, 2.866953, 3.053634)
range_mu_sigma(ver=csize_malign) #(9.000000 6.572614 2.719512)
range_mu_sigma(ver=csize_benign) #(8.0000000 1.3253275 0.9076941)
range_mu_sigma(ver=normal_malign) #(9.000000 5.863071 3.350672)
range_mu_sigma(ver=normal_benign) #(8.000000 1.290393 1.058856)


###############################################################################
#                       Q3 Logistic Regression                                #
##############################################################################
#Summary of potential variables to be used in the model 
summary(cancer_df$Cl.thickness)
summary(cancer_df$Cell.size)
summary(cancer_df$Cell.shape)
summary(cancer_df$Marg.adhesion)
summary(cancer_df$Epith.c.size)
summary(cancer_df$Bare.nuclei_clean)
summary(cancer_df$Bl.cromatin)
summary(cancer_df$Normal.nucleoli)
summary(cancer_df$Mitoses)


#Random Sampling: (before predictive modeling)
training_idx <- sample(1:num_obs, num_obs*0.8)
#training: 
cancer_df_train <- cancer_df[training_idx,]
#testing:
cancer_df_test <- cancer_df[-training_idx,]

#Designing a logistic regression
my_logit <- glm(class_binary~Cl.thickness+Cell.size+Cell.shape+Marg.adhesion+Epith.c.size+Bare.nuclei_clean+
                  Bl.cromatin+Normal.nucleoli+Mitoses,
                data=cancer_df_train, family="binomial")
                  
summary(my_logit)
##cleaning up the model.Removing those with high p-values
###Cl.thickness #keep
###Cell.size #xxxx
###Cell.shape #keep
###Marg.adhesion #keep
###Epith.c.size #xxxx
###Bare.nuclei_clean #keep
###Bl.cromatin #keep
###Normal.nucleoli #xxxx
###Mitoses #xxxx

##Removed Cell size because of its high p-value. Removing the variable affected the p-value of Cell shape which turned into p<0.05, 
##and other the p values of other variables became more significant (except for Normal.nucleoli)

my_logit_clean <- glm(class_binary~Cl.thickness+Cell.shape+Marg.adhesion+Bare.nuclei_clean+
                  Bl.cromatin,
                data=cancer_df_train, family="binomial")

summary(my_logit_clean)

#Business insights
##Cl.thickness 
exp(0.6889)-1
##For every additional unit of Cl thickness, the odds of an individual having a 
##malignant cancer ("business success") increases by 99.15%.

##Cell.shape 
exp(0.6359)-1
##For every additional unit of Cell shape, the odds of an individual having a 
##malignant cancer ("business success") increases by 88.87%.

##Marg.adhesion
exp(0.3576)-1
##For every additional unit of Marg. adhesion, the odds of an individual having a 
##malignant cancer ("business success") increases by 42.99%.

##Bare.nuclei_clean 
exp(0.3536)-1
##For every additional unit of Bare.nuclei, the odds of an individual having a 
##malignant cancer ("business success") increases by 42.42%.

##Bl.cromatin 
exp(0.5185)-1
##For every additional unit of Bl.cromatin, the odds of an individual having a 
##malignant cancer ("business success") increases by 67.95%.


#Building confusion matrix for TESTING DATA
library(caret)

my_prediction_test <- predict(my_logit_clean, cancer_df_test,
                              type = "response")

confusionMatrix(data= as.factor(as.numeric(my_prediction_test>0.5)) , 
                reference= as.factor(as.numeric(cancer_df_test$class_binary)))
##94.29% accuracy   


#Plot the ROCR chart to evaluate TPR and FPR 
library(ROCR)
pred_val_logit <- prediction(my_prediction_test, cancer_df_test$class_binary)

perf_logit <- performance(pred_val_logit, "tpr", "fpr")
plot(perf_logit)

#Calculating the actual AUC value:
other_perf <- performance(pred_val_logit, measure="auc")
other_perf@y.values
#0.9903529
