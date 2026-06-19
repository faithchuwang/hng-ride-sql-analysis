--Question 4 — For each driver, calculate their average monthly rides since signup. 
-- Who are the top 5 drivers with the highest consistency?

SELECT
    d.name AS driver_name,
    COUNT(r.ride_id) AS total_rides,
    EXTRACT(YEAR FROM AGE('2024-12-31', d.signup_date)) * 12 +
    EXTRACT(MONTH FROM AGE('2024-12-31', d.signup_date)) AS active_months,
    COUNT(r.ride_id) / (
        EXTRACT(YEAR FROM AGE('2024-12-31', d.signup_date)) * 12 +
        EXTRACT(MONTH FROM AGE('2024-12-31', d.signup_date))
    ) AS avg_monthly_rides
FROM rides_clean r
JOIN drivers_clean d ON r.driver_id = d.driver_id
JOIN payments_clean p ON r.ride_id = p.ride_id
WHERE p.amount > 0
GROUP BY d.driver_id, d.name, d.signup_date
ORDER BY avg_monthly_rides DESC
LIMIT 5;
