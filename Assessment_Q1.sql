-- Assessment_Q1.sql — High-Value Customers with Multiple Products
-- Q1: Identify customers who have both savings and investment products
-- and rank them based on total deposits in their savings accounts.

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    sp.savings_count,
    ip.investment_count,
    ROUND(sd.total_deposits / 100.0, 2) AS total_deposits  -- Convert to base currency (assumes stored in kobo)
FROM users_customuser u

-- Subquery to count number of savings products
JOIN (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
) sp ON u.id = sp.owner_id

-- Subquery to count number of investment products
JOIN (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
) ip ON u.id = ip.owner_id

-- Subquery to calculate total deposits per customer
JOIN (
    SELECT owner_id, SUM(COALESCE(confirmed_amount, 0)) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
) sd ON u.id = sd.owner_id

ORDER BY total_deposits DESC;
