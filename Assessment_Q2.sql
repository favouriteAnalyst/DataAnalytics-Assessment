-- Assessment_Q2.sql — Transaction Frequency Analysis
-- Q2: Segment customers based on their average monthly transaction frequency.
-- Categories: High (>=10), Medium (3–9), Low (<3)

-- Calculate monthly transaction count per customer
WITH monthly_tx AS (
    SELECT 
        owner_id,
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        COUNT(*) AS monthly_tx_count
    FROM savings_savingsaccount
    GROUP BY owner_id, YEAR(transaction_date), MONTH(transaction_date)
),

-- Calculate average monthly transactions per customer
customer_avg_tx AS (
    SELECT 
        owner_id,
        ROUND(AVG(monthly_tx_count), 2) AS avg_tx_per_month
    FROM monthly_tx
    GROUP BY owner_id
),

-- Categorize customers by frequency group
categorized AS (
    SELECT 
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM customer_avg_tx
)

-- Final output: count and average per category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
