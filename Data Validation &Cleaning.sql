
CREATE TABLE borrower_profiles (
borrower_id VARCHAR(20) PRIMARY KEY,
    age INT NOT NULL,
    state VARCHAR(50) NOT NULL,
    education_level VARCHAR(50),
    employment_status VARCHAR(30),
    years_employed INT,
    annual_income NUMERIC(12,2),
    credit_score INT,
    home_ownership VARCHAR(30),
    dependents INT,
    existing_monthly_debt NUMERIC(12,2)
);

CREATE TABLE loan_applications_raw (
    loan_id VARCHAR(20),
    borrower_id VARCHAR(20),
    application_date DATE,
    loan_purpose VARCHAR(100),
    loan_amount NUMERIC(12,2),
    term_months INT,
    interest_rate NUMERIC(5,2),
    monthly_payment NUMERIC(12,2),
    dti_ratio NUMERIC(5,2),
    loan_status VARCHAR(30),
    days_delinquent NUMERIC(5,1),
    defaulted BOOLEAN
);
-----------------------------------------------------------------------------------------
##import data in both tabels

COPY borrower_profiles
FROM 'C:\borrower_profiles.csv'
DELIMITER ','
CSV HEADER

SELECT * FROM borrower_profiles;


COPY loan_applications_raw
FROM 'C:\loan_applications_raw.csv'
DELIMITER ','
CSV HEADER

------------------------------------------------------------------------
##Data Validation
Query 1: Check total records

SELECT COUNT(*) AS total_borrowers
FROM borrower_profiles;

Result-500

SELECT COUNT(*) AS total_loan_records
FROM loan_applications_raw;

Result-609

Query 2: Preview Data

SELECT *
FROM loan_applications_raw
LIMIT 10;

Query 3: Check NULL Values

SELECT COUNT(*) AS null_interest_rate
FROM loan_applications_raw
WHERE interest_rate IS NULL;

Result-3

SELECT COUNT(*) AS null_loan_purpose
FROM loan_applications_raw
WHERE loan_purpose IS NULL;

Result-3

SELECT COUNT(*) AS null_days_delinquent
FROM loan_applications_raw
WHERE days_delinquent IS NULL;

Result-3

Query 4: Find Duplicate Loan IDs
SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM loan_applications_raw
GROUP BY loan_id
HAVING COUNT(*) > 1;

Query 5: Count Total Duplicate Record
SELECT
SUM(duplicate_count - 1) AS total_duplicate_rows
FROM
(
    SELECT
        loan_id,
        COUNT(*) AS duplicate_count
    FROM loan_applications_raw
    GROUP BY loan_id
    HAVING COUNT(*) > 1
);
Result-8

Query 6: Check Loan Status Inconsistencies
SELECT DISTINCT loan_status
FROM loan_applications_raw
ORDER BY loan_status;

Query 7: Check Loan Purpose Inconsistencies
SELECT DISTINCT loan_purpose
FROM loan_applications_raw
ORDER BY loan_purpose;

Query 8: Verify Borrower IDs Exist

This checks referential integrity before creating a foreign key.

SELECT
l.borrower_id
FROM loan_applications_raw l
LEFT JOIN borrower_profiles b
ON l.borrower_id=b.borrower_id
WHERE b.borrower_id IS NULL;

Result-0 rows
-----------------------------------------------------------------
##Now we'll create a clean table from the raw data.

CREATE TABLE loan_applications_clean AS
SELECT *
FROM loan_applications_raw;
------------------------------------------------------------------------------
##Data Cleaning
---Step 1: Standardize Loan Status

UPDATE loan_applications_clean
SET loan_status = INITCAP(TRIM(loan_status));

Verify:

SELECT DISTINCT loan_status
FROM loan_applications_clean
ORDER BY loan_status;

---Step 2: Standardize Loan Purpose

UPDATE loan_applications_clean
SET loan_purpose = INITCAP(TRIM(loan_purpose))
WHERE loan_purpose IS NOT NULL;

Verify:
SELECT DISTINCT loan_purpose
FROM loan_applications_clean
ORDER BY loan_purpose;

---Step 3: Handle NULL Loan Purpose

UPDATE loan_applications_clean
SET loan_purpose='Unknown'
WHERE loan_purpose IS NULL;

---Step 4: Handle NULL Interest Rate
We'll replace NULLs with the dataset average.

UPDATE loan_applications_clean
SET interest_rate=
(
SELECT ROUND(AVG(interest_rate),2)
FROM loan_applications_clean
)
WHERE interest_rate IS NULL;

---Step 5: Handle NULL Days Delinquent
UPDATE loan_applications_clean
SET days_delinquent=0
WHERE days_delinquent IS NULL;
---Step 6: Remove Duplicates

DELETE FROM loan_applications_clean
WHERE ctid IN
(
SELECT ctid
FROM
(
SELECT
ctid,
ROW_NUMBER() OVER(PARTITION BY loan_id ORDER BY loan_id) AS rn
FROM loan_applications_clean
)t
WHERE rn>1
);
--Verify Cleaning

SELECT COUNT(*)
FROM loan_applications_clean;

Result-601

SELECT COUNT(*)
FROM loan_applications_clean
WHERE interest_rate IS NULL;

Result-0

SELECT COUNT(*)
FROM loan_applications_clean
WHERE loan_purpose IS NULL;

Result-0

SELECT COUNT(*)
FROM loan_applications_clean
WHERE days_delinquent IS NULL;

Result-0

SELECT
loan_id,
COUNT(*)
FROM loan_applications_clean
GROUP BY loan_id
HAVING COUNT(*)>1;

Result-0 rows
---------------------------------------------------------------------------------------
