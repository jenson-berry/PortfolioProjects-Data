libname loan '/home/u63638540/Logistic Regression/';
data loan.train;
infile "/home/u63638540/Logistic Regression/train.csv" DSD MISSOVER FIRSTOBS=2;
input Loan_ID$ Gender$ Married$ Dependents$ Education$ Self_Employed$ Applicant Co_Applicant Loan_Amount L_Amount_Term Credit_History Property_Area$ Loan_Status$;
run;

data loan.test;
infile "/home/u63638540/Logistic Regression/test.csv" DSD MISSOVER FIRSTOBS=2;
input Loan_ID$ Gender$ Married$ Dependents$ Education$ Self_Employed$ Applicant Co_Applicant Loan_Amount L_Amount_Term Credit_History Property_Area$;
run;

proc contents data=loan.train;
run;

proc print data = loan.train;

proc gchart data=loan.train;
vbar Gender;
run;

proc univariate data=loan.train;
var Applicant;
histogram/normal;
run;

proc sgplot data=loan.train;
vbox Applicant / group=Education;
run;

proc gchart data=loan.train;
vbar Gender/subgroup=Loan_Status type=percent;
run;

data appandco;
set loan.train;
Total_Income = Applicant + Co_Applicant;
run;

proc datasets library=loan;
modify train;
run;

proc format;
value incomegrp
	0 -< 2750 = 'Low'
	2750 -< 4000 = 'Average'
	4000 -< 6000 = 'High'
6000 - high = 'Very High'
;
run;

proc gchart data=loan.train;
format Applicant incomegrp.;
	vbar Applicant / 
	coutline=black
	subgroup=Loan_Status
	legend=legend1
	type=freq
	width=8
	maxis=axis1
	raxis=axis2
	discrete;
run;

/* Combining applicant and co-applicant income */

proc format;
value incomegrp
	0 -< 2750 = 'Low'
	2750 -< 4000 = 'Average'
	4000 -< 6000 = 'High'
6000 - high = 'Very High'
;
run;

legend1 label=('Loan_Status') frame;
axis2 label=('Percentage' angle=90) order=(0 to .25 by .05) value=('0.0' '0.2' '0.4' '0.6' '0.8' '1.0');
axis1 label=('Applicant');

pattern1 V=msolid C=lightblue;
pattern2 V=msolid C=orange;



proc gchart data=appandco;
format Total_Income incomegrp.;
	vbar Loan_Amount/
	coutline=black
	subgroup=Loan_Status
	legend=legend1
	type=freq
	width=8
	maxis=axis1
	raxis=axis2
	discrete;
run;


data traint;

set loan.train (rename=(Loan_Status=L_Status));

if L_Status = 'N' then L_Status = 0; else L_Status = 1;

Lo_Status = input(L_Status, 8.);

drop L_Status;

N_Dependents = compress(dependents, '+');

drop Dependents;

Loan_Amount=log(Loan_Amount);

drop Loan_ID;

run;

data testd;

set loan.test;

N_Dependents = compress(dependents, '+');

drop Dependents;

Loan_Amount=log(Loan_Amount);

drop Loan_ID;

run;

data traind valid;

set traint;

if ranuni(7) <=.6 then output traind; else output valid;

run;