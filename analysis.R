# set the seed so another person can run this and get the same results
set.seed(101)

# analysis will consist of determining if the GRAD_DEBT_MDN is greater than $25,000 or not
data.debtfactor<-data.clean
# create a new column with the binary classification for this debt threshold
data.debtfactor$debtgt25k <- data.debtfactor$GRAD_DEBT_MDN > 25000.0

# this split is shown to be a fair one as it splits the factoring into almost 50/50 TRUE/FALSE
prop.table(table(data.debtfactor$debtgt25k))

# get a set of values to use for the testing set
testset<-sample(nrow(data.debtfactor), round(0.3*nrow(data.debtfactor)), replace=FALSE)

# get the training and testing data
traindata<-data.debtfactor[-testset,]
testdata<-data.debtfactor[testset,]

## let us first try logistic regression, then onto the next algo

# use all the features for logistic regression formula
glm.model <- glm(debtgt25k ~ TUITFTE + ADM_RATE_ALL + SATVRMID + SATWRMID + SATMTMID, data=traindata, family="binomial")
summary(glm.model)

## P-value for SAT score values are >0.05 so we do not reject the null hypothesis
## Null deviance, Residual deviance, and AIC are also high. This is not indication alone that the model is bad, but let us try to improve.

# check the Anova and Wald test to try to improve model
library(aod)
require(aod)

wald.test(b = coef(glm.model), Sigma = vcov(glm.model), Terms = 1:5)
anova(glm.model, test="Chisq")

# use just the admissions rate for logistic regression formula
glm.model.admission <-glm(debtgt25k ~ ADM_RATE_ALL, data=traindata, family="binomial")
summary(glm.model.admission)

## P-value is < 0.05 so we reject the null hypothesis
## Residual Deviance and AIC also decreased which is a good sign

# perform predictions on the model using only admission rate
predicted<-predict(glm.model.admission, testdata, type="response")
predicted
auc<-prediction(predicted, testdata$debtgt25k)
perform<-performance(auc, measure="tpr", x.measure="fpr")
plot(perform, main="Debt after Graduation prediction glm - plot(perform)")

## the AUC curve shows the model did not perform well on the test set since it has an almost linear slope (AUC curve having half the area under it is not good)

# use just the tuition for logistic regression formula
glm.model.tution <-glm(debtgt25k ~ TUITFTE, data=traindata, family="binomial")
summary(glm.model.tuition)

## P-value is > 0.05 so we do not reject the null hypothesis

## Logistic Regression is not a useful algorithm to learn about the debt after graduation for this dataset.
## Try Random Forests

# Random Forests need factors for the fields, so get the factors
extractFeatures <- function(data) {
  features <- c("TUITFTE",
                "ADM_RATE_ALL",
                "SATVRMID",
                "SATWRMID",
                "SATMTMID"
                # ,"SAT_AVG_ALL"
                )
  fea <- data[,features]
  return(fea)
}

set.seed(101) # reset the seed

# run the randomForest algo
randomForest.model <- randomForest(extractFeatures(traindata), as.factor(traindata$debtgt25k), ntree=100, importance=TRUE)

# look at the importance of the variables
varImpPlot(randomForest.model)