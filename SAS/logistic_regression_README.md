
# SAS Predictive Modelling - Logistic Regression
In this example, I create a logistic regression model in SAS to determine the factors / variables that have the most effect on whether or not a person is approved for a loan or not. 

## The Dataset
The dataset was again taken from the course that I took on SAS. 
I split the dataset into two parts: a training set and a test set using the typical 80/20 split. 
The dataset consists of a number of variables:
- Loan_ID
- Gender
- Married
- Dependents
- Education
- Self_Employed
- ApplicantIncome
- CoapplicantIncome
- LoanAmount
- Loan_Amount_Term
- Credit_History
- Property_Area

I will consider all of these factors when determining whether or not an individual is likely to be eligible for the requested loan amount.

### Response / Dependent Variable
In this example, the loan status is our dependent variable. (Y / N for eligible or not) based on a number of independent variables. 


## Problem / Request Statement
Identify the customers most likely to be eligible for a loan so that the bank can target these customers with focused advertising. 


# 1.1 EDA:
The dataset is clean so I do not need to do any prior cleaning.

In order to perform my initial EDA, I used the gchart procedure with vbar. I found that:
- 80% of the applicants are male
- Around 65% are married
- Around 15% are self-employed
- Around 85% have repaid their debts

![Image of gender column chart ](https://github.com/jenson-berry/PortfolioProjects-Data/blob/main/SAS/log_reg_EDA01.png)

## 1.2 Univariate Analysis
One of the most important numeric variables in the dataset is the applicant income variable. As this is numeric, we will look at its distribution. 

![Image of gender column chart ](https://github.com/jenson-berry/PortfolioProjects-Data/blob/main/SAS/log_reg_EDA02.png)

The data is far from being normally distributed. It is also worth nothing that there are a couple of outliers which could affect our model; we may need to tune our model later. However, it could be that this isn't an outlier and the fact that we're only considering income isn't painting the full picture.
Let's look at a box plot of education level and income. 

![Image of gender column chart ](https://github.com/jenson-berry/PortfolioProjects-Data/blob/main/SAS/log_reg_EDA03.png)

We can see from this that though we do have a couple of outliers, we do have a mostly normal distribution. 

## 1.3 Bivariate Analysis
- Gender makes a marginal difference to loan decision outcome
- Married applicants get more approved loans
- Self-employed / employment status makes little to no difference
- People with a higher credit rating are more likely to get approved
- People living in semi-urban areas are more likely to get approved 





