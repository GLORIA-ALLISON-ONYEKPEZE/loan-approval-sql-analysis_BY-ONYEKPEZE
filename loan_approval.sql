-- =========================================
-- Loan Approval & Risk Analysis
-- Author: Gloria Allison-Onyekpeze
-- =========================================

-- insight 1: TOTAL NUMBER OF LOAN APPLICANT 20,000
 
SELECT COUNT(*) FROM loan_approval_data;

--Insight 2: EMPLOYMENT DISTRIBUTION AMONG APPLICANTS
SELECT 
     employmentstatus,
	 COUNT(*) as total_applicants
FROM loan_approval_data
GROUP BY employmentstatus
ORDER BY total_applicants DESC;

--Insight 3: Loan Approval Distribution Across Employment Categories

SELECT 
    employmentstatus,
    SUM(loanapproved::int) AS approved,
    COUNT(*) - SUM(loanapproved::int) AS not_approved
FROM loan_approval_data
GROUP BY employmentstatus
ORDER BY approved DESC;


--insight 4: APPLICANT WHO MET IMPORTANT CRITERIA AND WHERE DENIED

SELECT
employmentstatus,
age,
annualincome,
loanpurpose,
creditscore,
debttoincomeratio,
loanapproved,
riskscore,
networth
FROM loan_approval_data
WHERE creditscore >= 650
   AND debttoincomeratio <= 0.40
   AND bankruptcyhistory = 'false'
   AND previousloandefaults = 0
   AND employmentstatus IN ('Employed', 'Self-Employed')
   AND networth >= 50000
   AND loanapproved = 'false'
   ORDER BY AGE DESC;

--Insight 5:COUNTS OF APPLICANT WHO MET ALL CRITERIA AND WERE DENIED (80)
SELECT COUNT(*)
FROM loan_approval_data
WHERE creditscore >= 650
   AND debttoincomeratio <= 0.40
   AND bankruptcyhistory = 'false'
   AND previousloandefaults = 0
   AND employmentstatus IN ('Employed', 'Self-Employed')
   AND networth >= 50000
   AND loanapproved = 'false';

 --Insight 6:TOTAL APPLICANTS WHOSE LOAN WAS NOT APPROVED(15220)
 SELECT 
      COUNT(*)
FROM loan_approval_data
WHERE loanapproved = 'false';

--Insight 7: total applicant whose loan was approved (4780)
SELECT 
      COUNT(*)
FROM loan_approval_data
WHERE loanapproved = 'True';

--Insight 8: APPLICANT WHO DID NOT MET IMPORTANT CRITERIA AND WAS APPROVED
	 
SELECT
employmentstatus,
age,
annualincome,
loanpurpose,
creditscore,
debttoincomeratio,
loanapproved,
riskscore,
networth,
loanamount
FROM loan_approval_data
WHERE loanapproved = 'True'
AND (creditscore < 650
   OR debttoincomeratio > 0.40
   OR bankruptcyhistory = 'TRUE'
   OR previousloandefaults = 1
   OR employmentstatus IN ('Unemployed')
   OR loanamount < networth)
   ORDER BY AGE DESC;

--Insight 9: COUNT OF TOTAL APPLICANT WHO DID MEET ALL CRITERIA AND WAS APPROVED(4714)
SELECT 
   COUNT(*)
FROM loan_approval_data
WHERE loanapproved = 'True'
AND (creditscore < 650
   OR debttoincomeratio > 0.40
   OR bankruptcyhistory = 'TRUE'
   OR previousloandefaults = 1
   OR employmentstatus IN ('Unemployed')
   OR loanamount < networth);

--Insight 10: Loan Purpose and Applicant Approval Count
SELECT 
    employmentstatus,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN loanapproved = TRUE THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN loanapproved = FALSE THEN 1 ELSE 0 END) AS not_approved
FROM loan_approval_data
GROUP BY employmentstatus
ORDER BY approved DESC;

-- insight 11: Default Rate by Loan Purpose

SELECT 
    loanpurpose,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN previousloandefaults > 0 THEN 1 ELSE 0 END) AS defaulters,
    ROUND(
        SUM(CASE WHEN previousloandefaults > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS default_rate_percentage
FROM loan_approval_data
GROUP BY loanpurpose
ORDER BY default_rate_percentage DESC

--Insight 12: Top Risky Age Groups (Based on Defaults)

SELECT 
    age,
    COUNT(*) AS total_customers,
    SUM(previousloandefaults) AS total_defaults
FROM loan_approval_data
GROUP BY age
ORDER BY total_defaults DESC
LIMIT 10;

--Insight 13: NUM OF APPLICANT WITH BANKRUPTCY HISTORY(1048)
SELECT 
    COUNT(*)
FROM loan_approval_data
WHERE bankruptcyhistory = 'True';

--Insight 14: Are we approving high-risk applicants with bankruptcy history?
 SELECT 
    COUNT(*) AS approved_with_bankruptcy
FROM loan_approval_data
WHERE bankruptcyhistory = TRUE
  AND loanapproved = TRUE;
