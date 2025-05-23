CREATE DATABASE final_project1;
USE final_project1;
drop table customer_info;
CREATE TABLE customer_info
(
Id_client INT AUTO_INCREMENT PRIMARY KEY,
Total_amount INT,
Gender enum ('M', 'F'),
Age INT,
Count_city INT,
Response_communication INT,
Communication_3month INT, 
Tenure INT
);

SELECT * FROM transactions_info;
SELECT * FROM customer_info;
drop table transactions_info;
CREATE TABLE transactions_info
(
date_new DATE,
Id_check INT,
Id_client INT,
Count_products INT, 
Sum_payment INT
);

#1
SELECT
    t.Id_client,
    c.Gender,
    c.Age,
    c.Count_city,
    c.Tenure,
    COUNT(*) AS total_operations,
    ROUND(AVG(CASE WHEN t.Count_products > 0 THEN t.Sum_payment / t.Count_products ELSE NULL END), 2) AS avg_check,
    ROUND(SUM(t.Sum_payment) / 12, 2) AS avg_monthly_sum
FROM transactions_info t
JOIN customer_info c ON t.Id_client = c.Id_client
WHERE t.date_new >= '2015-06-01' AND t.date_new < '2016-06-01'
GROUP BY t.Id_client
HAVING COUNT(DISTINCT DATE_FORMAT(t.date_new, '%Y-%m')) = 12
ORDER BY t.Id_client;

#2
SELECT
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,
    ROUND(AVG(CASE WHEN t.Count_products > 0 THEN t.Sum_payment / t.Count_products ELSE NULL END), 2) AS avg_check,
    COUNT(*) AS operations_count,
    COUNT(DISTINCT t.Id_client) AS unique_clients,
    ROUND(SUM(c.Gender = 'M') / COUNT(DISTINCT t.Id_client) * 100, 2) AS percent_male_clients,
    ROUND(SUM(c.Gender = 'F') / COUNT(DISTINCT t.Id_client) * 100, 2) AS percent_female_clients,
    ROUND(SUM(c.Gender IS NULL) / COUNT(DISTINCT t.Id_client) * 100, 2) AS percent_na_clients,
    ROUND(SUM(CASE WHEN c.Gender = 'M' THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment) * 100, 2) AS spend_share_male,
    ROUND(SUM(CASE WHEN c.Gender = 'F' THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment) * 100, 2) AS spend_share_female,
    ROUND(SUM(CASE WHEN c.Gender IS NULL THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment) * 100, 2) AS spend_share_na
FROM transactions_info t
LEFT JOIN customer_info c ON t.Id_client = c.Id_client
WHERE t.date_new >= '2015-06-01' AND t.date_new < '2016-06-01'
GROUP BY DATE_FORMAT(t.date_new, '%Y-%m')
ORDER BY month asc;

#3
SELECT
    CASE 
        WHEN c.Age IS NULL THEN 'UNKNOWN'
        WHEN c.Age < 10 THEN '0–9'
        WHEN c.Age < 20 THEN '10–19'
        WHEN c.Age < 30 THEN '20–29'
        WHEN c.Age < 40 THEN '30–39'
        WHEN c.Age < 50 THEN '40–49'
        WHEN c.Age < 60 THEN '50–59'
        WHEN c.Age < 70 THEN '60–69'
        ELSE '70+'
    END AS age_group,
    SUM(t.Sum_payment) AS total_payment,
    COUNT(*) AS operation_count
FROM transactions_info t
LEFT JOIN customer_info c ON t.Id_client = c.Id_client
WHERE t.date_new >= '2015-06-01' AND t.date_new < '2016-06-01'
GROUP BY age_group
ORDER BY age_group;