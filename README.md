# loan-credit-risk-assessment-Portfolio-Analytics
End-to-End Credit Risk Analytics Project using PostgreSQL and Power BI
# **Project Overview
**
This project demonstrates an end-to-end Credit Risk Analytics solution using PostgreSQL and Power BI. The objective was to clean raw loan application data, perform exploratory data analysis (EDA), generate business insights using SQL, and develop interactive dashboards for portfolio monitoring and borrower segmentation.
# Business Problem

Financial institutions require continuous monitoring of loan portfolios to identify high-risk borrowers, understand lending patterns, and support data-driven decision-making.

This project addresses key business questions such as:

What is the overall health of the loan portfolio?
Which borrower segments contribute the highest default risk?
Which loan purposes have higher default rates?
How do borrower demographics influence lending patterns?
# Dataset
| Metric                 |  Value |
| ---------------------- | -----: |
| Total Borrowers        |    500 |
| Total Loans            |    601 |
| Total Loan Amount      | 13.31M |
| Average Loan Amount    | 22.15K |
| Average Interest Rate  | 10.64% |
| Portfolio Default Rate | 24.29% |
# Tools & Technologies
1.PostgreSQL

2.Power BI

3.DAX

4.GitHub

# SQL Workflow

1.Imported raw loan application data(csv) into PostgreSQL.
2.Performed data cleaning by handling null values, duplicates, and inconsistent records.
3.Conducted exploratory data analysis (EDA).
4.Created SQL views for reporting and dashboarding.
5.Generated business insights using SQL aggregations and analytical queries.
# Dashboard Overview

#The Power BI dashboard consists of three interactive pages:

1. Executive Overview

Provides an overview of portfolio performance through KPIs, monthly loan trends, loan purpose analysis, and loan status distribution.

2. Risk Analysis

Highlights portfolio risk using default rates across states, employment categories, and loan purposes, along with borrower-level investigation.

3. Borrower Segmentation

Analyzes borrower demographics including education, home ownership, employment status, and average loan amounts across borrower groups.

# Key Business Insights

1.Portfolio consists of 500 borrowers across 601 loans, with a total exposure of 13.31M.

2.Overall portfolio default rate is 24.29%, representing 146 defaulted loans.

3.Virginia (58.33%), California (50.00%), and Missouri (41.94%) recorded the highest observed default rates.

4.Part-Time employees (27.69%) showed the highest default rate among employment categories.

5.Unknown (33.33%) and Wedding (28.57%) loan purposes exhibited the highest default rates.

6.Mortgage holders (216 borrowers | 43.2%) formed the largest borrower segment.

7.Bachelor's degree holders (190 borrowers) represented the largest education group.

8.Borrowers with Master's degrees had the highest average loan amount (25K).

# Business Recommendations

1.Prioritize periodic monitoring of states with higher observed default rates to identify emerging portfolio risks.

2.Perform additional analysis of high-default loan purposes to understand contributing factors before adjusting lending strategies.

3.Monitor borrower segments with higher average DTI ratios during portfolio reviews.

4.Use borrower segmentation (education, employment, and home ownership) to support targeted portfolio monitoring and customer engagement.

5.Leverage interactive dashboards for ongoing portfolio performance tracking and management reporting.

