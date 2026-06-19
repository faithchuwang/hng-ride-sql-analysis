--Question 3 — Compare quarterly revenue between 2021, 2022, 2023, and 2024. Which quarter had the biggest YoY growth?
SELECT
    EXTRACT(YEAR FROM r.request_time) AS year,
    EXTRACT(QUARTER FROM r.request_time) AS quarter,
    SUM(p.amount) AS total_revenue
FROM rides_clean r
JOIN payments_clean p ON r.ride_id = p.ride_id
WHERE p.amount > 0
GROUP BY year, quarter
ORDER BY year, quarter;
