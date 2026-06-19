--Question 5 — Calculate the cancellation rate per city and identify which city had the highest cancellation rate.

SELECT
    pickup_city,
    COUNT(*) AS total_rides,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_rides,
    ROUND(COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM rides_clean
GROUP BY pickup_city
ORDER BY cancellation_rate DESC;
