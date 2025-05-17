-- Assessment_Q4.sql — Customer Lifetime Value (CLV) Estimation
-- Q4: Estimate CLV based on average transaction value and monthly frequency.

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,

    -- CLV = (Monthly frequency * 12) * Avg transaction value
    ROUND(
        (
            COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1)
        ) * 12 * (0.001 * AVG(s.confirmed_amount) / 100.0), 2
    ) AS estimated_clv

FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id

GROUP BY u.id, name, tenure_months
ORDER BY estimated_clv DESC;
