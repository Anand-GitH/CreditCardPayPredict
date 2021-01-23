###########################################################################
#Ensemble v/s Non-Ensemble(simplistic) methods
#Dataset: CreditCard Clients Dataset
#https://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients
#
#Modified By: Anand
#Modified Date: 12-02-2020
###########################################################################

rm(list=ls())

set.seed(122)

library("adabag")
library("randomForest")
library("caret")
library("gbm")
library("MASS")
library("glmnet")
library("class")

creditdet<-read.csv("CreditCardDetails.csv",header = TRUE)
names(creditdet)[names(creditdet) == "ï..LIMIT_BAL"] <- "CREDIT_LMT_BAL"
names(creditdet)
dim(creditdet)

#Defualt Next Payment - Yes = 1 and No=0
table(creditdet$NPT_DFLT)

########################################################################

trainidx<-sample(1:nrow(creditdet),0.70*nrow(creditdet),replace = FALSE)
traindat<-creditdet[trainidx,]
testdat<-creditdet[-trainidx,]

dim(traindat)
dim(testdat)

table(traindat$NPT_DFLT)
table(testdat$NPT_DFLT)

#Ensemble Methods
###########################################################################
#Random Forest
###########################################################################
traindat$NPT_DFLT<-as.factor(traindat$NPT_DFLT)
testdat$NPT_DFLT<-as.factor(testdat$NPT_DFLT)
rf.fit <- randomForest(NPT_DFLT~., data = traindat, n.tree = 1000, type="classification")

x11()
varImpPlot(rf.fit)

importance(rf.fit)

ypred <- predict(rf.fit, newdata = testdat, type = "response")

rf.conf<-confusionMatrix(ypred,testdat$NPT_DFLT)
rf.conf

###########################################################################
#Bagging
###########################################################################

bag.fit <- randomForest(NPT_DFLT~., data = traindat, n.tree = 1000, mtry = 10, type="classification")

x11()
varImpPlot(bag.fit)

importance(bag.fit)

ypred <- predict(bag.fit, newdata = testdat, type = "response")

bag.conf<-confusionMatrix(ypred,testdat$NPT_DFLT)
bag.conf

###########################################################################
#Boosting
###########################################################################

boost.fit <- gbm(NPT_DFLT~., data = traindat, n.trees = 1000, shrinkage = .1, interaction.depth = 3, distribution = "adaboost")
boost.fit2 <- gbm(NPT_DFLT~., data = traindat, n.trees = 1000, shrinkage = .6, interaction.depth = 3, distribution = "adaboost")

x11()
summary(boost.fit)
x11()
summary(boost.fit2)

# Look at the error for shrinkage = .1
ypred <- predict(boost.fit, newdata = testdat, n.trees = 1000, type = "class")
boost.conf<-confusionMatrix(ypred,testdat$NPT_DFLT)
boost.conf

# Look at the error for shrinkage = .6
ypred <- predict(boost.fit2, newdata = testdat, n.trees = 1000, type = "class")
boost.conf2<-confusionMatrix(ypred,testdat$NPT_DFLT)
boost.conf2

###########################################################################
#Non Ensemble Methods
###########################################################################
#Linear Discriminant Analysis

testdat$NPT_DFLT<-as.factor(testdat$NPT_DFLT)
cprior<-as.numeric(table(creditdet$NPT_DFLT))/nrow(creditdet)
cprior

lda.fit <- lda(NPT_DFLT ~ ., testdat, prior = cprior)
ypred<-predict(lda.fit, testdat)$class

lda.conf<-confusionMatrix(ypred,testdat$NPT_DFLT)
lda.conf

##########################################################################
#Logistic Regression
logit <- glm(NPT_DFLT ~ ., family=binomial(link="logit"), data=traindat) 

ypred<-predict(logit,testdat, type="response")
ypred<-as.factor(round(ypred))

logit.conf<-confusionMatrix(ypred,testdat$NPT_DFLT)
logit.conf

##########################################################################
#k-Nearest Neighbors

applyknn<-function(k,tdata,testdata,responsevar){
  knn(train=tdata,
      test=testdata,
      cl=as.factor(responsevar),
      k=k)
} 

predict.knn.test<-applyknn(10,traindat,testdat,traindat$NPT_DFLT)

confknn<-confusionMatrix(predict.knn.test,testdat$NPT_DFLT)
confknn

##########################################################################