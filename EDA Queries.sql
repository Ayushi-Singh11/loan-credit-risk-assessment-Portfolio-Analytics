##EDA  (exploratory data analysis)

Description:
This script performs exploratory data analysis (EDA) and generates
business insights related to loan portfolio performance, borrower
behavior, and credit risk.
--KPI 1 Total Borrowers

SELECT COUNT(*) AS total_borrowers
FROM borrower_profiles;

Result-500

--KPI 2: Total Loan Applications

SELECT COUNT(*) AS total_loans
FROM loan_applications_clean;

Result-601

--KPI 3: Total Loan Amount

SELECT
ROUND(SUM(loan_amount),2) AS total_loan_amount
FROM loan_applications_clean;

Result-13311100.00

--KPI 4: Average Loan Amount

SELECT
ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM loan_applications_clean;

Result-22148.25

-- KPI 5: Average Interest Rate

SELECT
ROUND(AVG(interest_rate),2) AS avg_interest_rate
FROM loan_applications_clean;

Result-10.64

-- KPI 6: Total Defaulted Loans

SELECT
COUNT(*) AS defaulted_loans
FROM loan_applications_clean
WHERE defaulted = TRUE;

Result-146

-- KPI 7: Default Rate

SELECT
ROUND(
COUNT(*) FILTER (WHERE defaulted = TRUE)*100.0/
COUNT(*),
2
) AS default_rate_percentage
FROM loan_applications_clean;

Result-24.29

-- KPI 8: Delinquency Rate

SELECT
ROUND(
COUNT(*) FILTER (WHERE days_delinquent > 0)*100.0/
COUNT(*),
2
) AS delinquency_rate_percentage
FROM loan_applications_clean;

Result-36.11

--##Portfolio Analysis
Loan Amount by Purpose
--Portfolio Analysis 1

SELECT
loan_purpose,
ROUND(SUM(loan_amount),2) AS total_loan_amount
FROM loan_applications_clean
GROUP BY loan_purpose
ORDER BY total_loan_amount DESC;

Average Loan Amount by Purpose
-- Portfolio Analysis 2

SELECT
loan_purpose,
ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM loan_applications_clean
GROUP BY loan_purpose
ORDER BY avg_loan_amount DESC;

Loan Status Distribution
-- Portfolio Analysis 3

SELECT
loan_status,
COUNT(*) AS total_loans
FROM loan_applications_clean
GROUP BY loan_status
ORDER BY total_loans DESC;

Monthly Loan Applications
-- Portfolio Analysis 4

SELECT
DATE_TRUNC('month',application_date)::date AS application_month,
COUNT(*) AS total_loans
FROM loan_applications_clean
GROUP BY application_month
ORDER BY application_month;

##Borrower Analysis
Average Credit Score by Loan Purpose
-- Borrower Analysis 1

SELECT
l.loan_purpose,
ROUND(AVG(b.credit_score),0) AS avg_credit_score
FROM loan_applications_clean l
JOIN borrower_profiles b
ON l.borrower_id=b.borrower_id
GROUP BY l.loan_purpose
ORDER BY avg_credit_score DESC;

Average Income by Employment Status
-- Borrower Analysis 2

SELECT
employment_status,
ROUND(AVG(annual_income),2) AS avg_income
FROM borrower_profiles
GROUP BY employment_status
ORDER BY avg_income DESC;

Home Ownership Distribution
-- Borrower Analysis 3

SELECT
home_ownership,
COUNT(*) AS total_borrowers
FROM borrower_profiles
GROUP BY home_ownership
ORDER BY total_borrowers DESC;

Average Loan Amount by Education Level
-- Borrower Analysis 4

SELECT
b.education_level,
ROUND(AVG(l.loan_amount),2) AS avg_loan_amount
FROM borrower_profiles b
JOIN loan_applications_clean l
ON b.borrower_id=l.borrower_id
GROUP BY b.education_level
ORDER BY avg_loan_amount DESC;

##Risk Analysis

Default Rate by Loan Purpose
-- Risk Analysis 1

SELECT
loan_purpose,
ROUND(
COUNT(*) FILTER(WHERE defaulted=TRUE)*100.0/
COUNT(*),
2
) AS default_rate
FROM loan_applications_clean
GROUP BY loan_purpose
ORDER BY default_rate DESC;

Default Rate by Employment Status
-- Risk Analysis 2

SELECT
b.employment_status,
ROUND(
COUNT(*) FILTER(WHERE l.defaulted=TRUE)*100.0/
COUNT(*),
2
) AS default_rate
FROM borrower_profiles b
JOIN loan_applications_clean l
ON b.borrower_id=l.borrower_id
GROUP BY b.employment_status
ORDER BY default_rate DESC;

Top States by Default Rate
-- Risk Analysis 3

SELECT
b.state,
ROUND(
COUNT(*) FILTER(WHERE l.defaulted=TRUE)*100.0/
COUNT(*),
2
) AS default_rate
FROM borrower_profiles b
JOIN loan_applications_clean l
ON b.borrower_id=l.borrower_id
GROUP BY b.state
ORDER BY default_rate DESC;

Average Credit Score of Defaulted Borrowers
-- Risk Analysis 4

SELECT
ROUND(AVG(b.credit_score),0) AS avg_credit_score_defaulted
FROM borrower_profiles b
JOIN loan_applications_clean l
ON b.borrower_id=l.borrower_id
WHERE l.defaulted=TRUE;

Average DTI by Loan Status
-- Risk Analysis 5

SELECT
loan_status,
ROUND(AVG(dti_ratio),2) AS avg_dti
FROM loan_applications_clean
GROUP BY loan_status
ORDER BY avg_dti DESC;
--------------------------------------------------------------------
##Advanced_SQL
--Borrowers With Multiple Loans

SELECT
borrower_id,
COUNT(*) AS total_loans
FROM loan_applications_clean
GROUP BY borrower_id
HAVING COUNT(*) > 1
ORDER BY total_loans DESC;

--Top 10 Highest Loans
SELECT
loan_id,
borrower_id,
loan_amount,
RANK() OVER(ORDER BY loan_amount DESC) AS loan_rank
FROM loan_applications_clean;

--Credit Score Segmentation
SELECT
borrower_id,
credit_score,
CASE
WHEN credit_score >= 750 THEN 'Excellent'
WHEN credit_score >= 700 THEN 'Good'
WHEN credit_score >= 650 THEN 'Fair'
ELSE 'Poor'
END AS credit_category
FROM borrower_profiles;

--High Risk Borrowers
SELECT
b.borrower_id,
b.credit_score,
b.annual_income,
l.loan_amount,
l.dti_ratio
FROM borrower_profiles b
JOIN loan_applications_clean l
ON b.borrower_id=l.borrower_id
WHERE b.credit_score < 650
AND l.dti_ratio > 40
ORDER BY b.credit_score;