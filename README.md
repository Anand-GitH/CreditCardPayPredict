# CreditCardPayPredict
Credit Card Payment Prediction Model 

-Understand the Business
Defaulting the payment is a risk for financial institutions. So using previous history 
and payment trends of the customers we will build a predictive model which can predict the 
whether the customer will pay or default the next installment.

-Data Understand
24 attributes – Credit limit, age, education, sex, marriage, payment history details
30000 observations
Default Next Payment - Yes = 1 and No = 0

-Data Preparation - Identify and clean data and stage data 
Divided data into test and train
Training Data: 21000
Test Data: 9000

-Modelling - We here use for classifying algorithms like 
Ensemble Methods:
Random forest,Bagging,Boosting

Non Ensemble Methods:
LDA,Logistic and k-NN

Conclusion:

Ensemble methods are computationally intensive as multiple trees to be built and the results are
averaged from different models we can’t really explain how the model derives the value just by looking
variable importance we could figure out which feature is more prominent and along with that the
complexity parameters for these methods we have to run multiple trails to identify optimal value to tune
the model’s complexity parameter.

Non-ensemble methods are simplistic and less complexity parameters mainly depends on the
feature selection and building model with features correlated with the response variable for better
performance. LDA is simple enough just with all features, mean and covariance calculated form data it
could differentiate classes nearly to ensemble methods. If LDA is used with subset of features it would
have performed better than ensemble methods.

Its not always wise to choose the ensemble methods over simplistic non-ensemble methods. The
methods should be evaluated for performance and simple interpretable models which are easy to tune
parameters of the models and easy to scale for the dataset in hand. Non-ensemble methods always
provide a go-to option due to its simplistic and interpretable nature.


