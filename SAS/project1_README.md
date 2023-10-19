#  Initial Project - Data Input and Basic Wrangling
To demonstrate basic proficiency using SAS, I used a sample dataset from the course that I took. It is a dataset containing records of patients. Below is the .csv contents:

Below is an image of the initial csv dataset and the dataset following some basic data preparation:

![Image of wrangled CSV file](https://github.com/jenson-berry/PortfolioProjects-Data/blob/main/SAS/SAS01.png)
In this repository is a file containing the code I have written to perform the data wrangling performed. 

Below is a breakdown of the code.
### 1. Libraries
- I create a library pointing to my home directory.

### 2. Data Import
- I read data in from an external cdv file ('casestudy.csv')
- I use the DSD flag to handle double quotes in the data
- I use MISSOVER to prevent input errors from raising exceptions
- I use FIRSTOBS2 to skip over the first obervation as it is a header row

### 3. Headers
- I use the INPUT command to define header / variable names. I use the $ symbol to denote variables which I wish to be interpreted as strings.
- The DOB variable is read as a date with a specific format (ddmmyy10.)

### 4. Sorting
- The data from the library is sorted by the ID variable.
- The sorted data is saved as perm.identifyconditionstwo

### 5. Print Procedure
- The sorted data (perm.identifyconditionstwo) is printed with the DOB variable formatted as a date

### 6. Data Transformation
- I use the LENGTH statement to define the length of the character variables
- I use the RETANI statement to initialise the variables as empty strings
- A loop is used to check for diagnosis codes (Pdx, Dx_2, Dx_3, Dx_4) and updates the corresponding condition variables if certain conditions are met (e.g. the diagnosis matches a specific code)
- At the end of processing each ID group (last.ID), the total number of conditions is calculated and creates a comma-delimited list of conditions. The results are written to the output dataset
- The KEEP statement specifies which variables I'd like to include in the output dataset

### 7. Final Output
- The last step is to print the final dataset. I format the DOB variable as a date

In summary, the code reads in medical data from a csv file, calculates the count of medical conditions for each patient and creates a summary dataset which is formatted.

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

### Response / Dependent Variable:
In this example, the loan status is our dependent variable. (Y / N for eligible or not) based on a number of independent variables. 


## Problem / Request Statement
Identify the customers most likely to be eligible for a loan so that the bank can target these customers with focused advertising. 


