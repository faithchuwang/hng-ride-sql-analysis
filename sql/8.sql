--Question 8 — Top 10 drivers qualified for bonuses
SELECT
    d.name AS driver_name,
    COUNT(CASE WHEN p.amount > 0 THEN 1 END) AS completed_rides,
    ROUND(AVG(d.rating)::NUMERIC, 2) AS avg_rating,
    ROUND(COUNT(CASE WHEN r.status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM rides_clean r
JOIN drivers_clean d ON r.driver_id = d.driver_id
JOIN payments_clean p ON r.ride_id = p.ride_id
GROUP BY d.driver_id, d.name
HAVING COUNT(CASE WHEN p.amount > 0 THEN 1 END) >= 30
AND AVG(d.rating) >= 4.5
AND COUNT(CASE WHEN r.status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*) < 5
ORDER BY avg_rating DESC
LIMIT 10;
