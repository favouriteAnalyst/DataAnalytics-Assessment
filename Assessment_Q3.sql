-- Assessment_Q3.sql — Account Inactivity Alert
-- Q3: Identify accounts with no activity in the past 12 months.

SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    t.last_transaction_date,
    DATEDIFF(CURDATE(), t.last_transaction_date) AS inactivity_days
FROM plans_plan p

-- Get last transaction date for each customer
LEFT JOIN (
    SELECT owner_id, MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY owner_id
) t ON p.owner_id = t.owner_id

-- Filter for inactive accounts (more than 365 days or no transactions)
WHERE t.last_transaction_date IS NULL 
   OR DATEDIFF(CURDATE(), t.last_transaction_date) > 365

ORDER BY inactivity_days DESC;
