# DataAnalytics-Assessment

This repository contains solutions to the four SQL-based data analysis questions provided as part of the Data Analytics Assessment. Each SQL file contains one query that directly answers the corresponding question.

---

The assessment began with a SQL dump used to initialize the database. The dump created the following four tables:

1. **users_customuser** – Contains customer demographic data  
2. **plans_plan** – Stores product plan information (savings and investments)  
3. **savings_savingsaccount** – Holds transaction and savings records  
4. **cards_card** – Contains credit card details

## Question 1 – High-Value Customers with Multiple Products

**Approach:** 
- Joined `savings_savingsaccount`, `plans_plan`, and `users_customuser` to identify regular savings and investment plans.
- Filtered plans with both `is_regular_savings = 1` and `is_a_fund = 1`.
- Aggregated the number of savings and investment plans per user.
- Summed deposits for all related accounts.
- Filtered for customers with both plan types and at least ₦1,000,000 total deposit.
- Sorted by total deposit amount in descending order.

**Challenges:**  
- Needed to correct the join logic to accurately relate accounts with their plan types.
- Used `COALESCE` to handle cases where deposit totals were NULL.

---

## Question 2 – Transaction Frequency Analysis

**Approach:**  
- Joined `savings_savingsaccount` and `savings_transaction`.
- Used `TIMESTAMPDIFF` to calculate account age in months.
- Counted total transactions per user.
- Calculated average monthly transaction frequency.
- Categorized users:
  - High: ≥ 5 transactions/month
  - Moderate: 2–4
  - Low: < 2

**Challenges:**  
- Initially used a non-existent column `created_at`; replaced with `transaction_date`.
- Ensured that users with zero months since account opening were excluded to prevent division errors.

---

## Question 3 – Account Inactivity Alert

**Approach:**  
- Queried `savings_transaction` to find the latest `transaction_date` per plan for inflow transactions.
- Joined with `plans_plan` and `users_customuser`.
- Filtered for accounts with last transaction older than 365 days using `DATEDIFF(CURDATE(), last_inflow) > 365`.

**Challenges:**  
- Faced MySQL error `2013: Lost connection`. The query was optimized and restructured using proper joins and indexing assumptions.

---

## Question 4 – Customer Lifetime Value (CLV) Estimation

**Approach:**  
- Joined `savings_savingsaccount`, `savings_transaction`, and `users_customuser`.
- Converted transaction amounts from Kobo to Naira.
- Counted inflow transactions and calculated average transaction value.
- Estimated tenure in months using `TIMESTAMPDIFF`.
- Applied the CLV formula:
  \[
  CLV = \text{Average Transaction Value} \times \text{Transaction Frequency} \times \text{Tenure}
  \]
- Used `GREATEST` to avoid division by zero where transaction count was low.

**Challenges:**  
- Ensured Kobo-to-Naira conversion was applied consistently.
- Handled edge cases for users with only one or two transactions.

---

## Notes

- All monetary values were converted from Kobo to Naira using `/ 100`.
- Queries were tested in MySQL and optimized for clarity and efficiency.
- Each file includes comments where logic may be non-obvious.
