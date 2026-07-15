FILE :Views.sql

PURPOSE :

This script creates business-ready SQL Views that will be directly imported
into Power BI for dashboard development.

--View 1
Borrower Risk Summary
Business Purpose:

(Management wants one dataset containing
Borrower information &Loan information Instead of importing two tables into Power BI,we'll 
already join them.)

-- View 1 : Borrower Risk Summary
-------------------------------------------------------

CREATE OR REPLACE VIEW borrower_risk_summary AS

SELECT

    b.borrower_id,
    b.age,
    b.state,
    b.education_level,
    b.employment_status,
    b.years_employed,
    b.annual_income,
    b.credit_score,
    b.home_ownership,
    b.dependents,
    b.existing_monthly_debt,

    l.loan_id,
    l.application_date,
    l.loan_purpose,
    l.loan_amount,
    l.term_months,
    l.interest_rate,
    l.monthly_payment,
    l.dti_ratio,
    l.loan_status,
    l.days_delinquent,
    l.defaulted

FROM borrower_profiles b

INNER JOIN loan_applications_clean l
ON b.borrower_id = l.borrower_id;

--Result : View is created


SELECT *
FROM borrower_risk_summary
LIMIT 10;
---------------------------------------------------------------------------------------------
View 2 - Loan Portfolio Summary
Question:Which loan purpose contributes the most to the portfolio and has the highest default rate?


CREATE OR REPLACE VIEW loan_portfolio_summary AS

SELECT

    loan_purpose,

    COUNT(*) AS total_loans,

    ROUND(SUM(loan_amount),2) AS total_loan_amount,

    ROUND(AVG(loan_amount),2) AS avg_loan_amount,

    ROUND(AVG(interest_rate),2) AS avg_interest_rate,

    ROUND(AVG(dti_ratio),2) AS avg_dti,

    COUNT(*) FILTER (WHERE defaulted = TRUE) AS defaulted_loans,

    ROUND(
        COUNT(*) FILTER (WHERE defaulted = TRUE) * 100.0
        / COUNT(*),
        2
    ) AS default_rate

FROM loan_applications_clean

GROUP BY loan_purpose;

Result: View created successfully.

SELECT *
FROM loan_portfolio_summary;
------------------------------------------------------------------------
View 3 - State Risk Summary

Business question:
Which states have the highest loan defaults?


CREATE OR REPLACE VIEW state_risk_summary AS

SELECT

    b.state,

    COUNT(*) AS total_loans,

    ROUND(SUM(l.loan_amount),2) AS total_loan_amount,

    COUNT(*) FILTER (WHERE l.defaulted = TRUE) AS defaulted_loans,

    ROUND(
        COUNT(*) FILTER (WHERE l.defaulted = TRUE) * 100.0
        / COUNT(*),
        2
    ) AS default_rate,

    ROUND(AVG(l.dti_ratio),2) AS avg_dti,

    ROUND(AVG(b.credit_score),0) AS avg_credit_score

FROM borrower_profiles b

JOIN loan_applications_clean l
ON b.borrower_id = l.borrower_id

GROUP BY b.state;
-----------------------------------------------------------------
View 4 - Employment Risk Summary

Business question:
Which employment category has the highest default rate?


CREATE OR REPLACE VIEW employment_risk_summary AS

SELECT

    b.employment_status,

    COUNT(*) AS total_loans,

    ROUND(AVG(b.annual_income),2) AS avg_income,

    ROUND(AVG(b.credit_score),0) AS avg_credit_score,

    ROUND(AVG(l.loan_amount),2) AS avg_loan_amount,

    COUNT(*) FILTER (WHERE l.defaulted = TRUE) AS defaulted_loans,

    ROUND(
        COUNT(*) FILTER (WHERE l.defaulted = TRUE) *100.0
        / COUNT(*),
        2
    ) AS default_rate

FROM borrower_profiles b

JOIN loan_applications_clean l
ON b.borrower_id = l.borrower_id

GROUP BY b.employment_status;

---------------------------------------------------------------------------------
View 5 - Monthly Loan Trend

Business question:
Is loan demand increasing or decreasing over time?

-------------------------------------------------------
-- View 5 : Monthly Loan Trend
-------------------------------------------------------

CREATE OR REPLACE VIEW monthly_loan_trend AS

SELECT

    DATE_TRUNC('month', application_date)::DATE AS application_month,

    COUNT(*) AS total_loans,

    ROUND(SUM(loan_amount),2) AS total_loan_amount,

    ROUND(AVG(loan_amount),2) AS avg_loan_amount,

    COUNT(*) FILTER (WHERE defaulted = TRUE) AS defaulted_loans

FROM loan_applications_clean

GROUP BY DATE_TRUNC('month', application_date)

ORDER BY application_month;

