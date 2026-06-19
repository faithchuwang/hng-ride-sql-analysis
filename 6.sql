--Question 6 — Identify riders who have taken more than 10 rides but never paid with cash.

SELECT
    ri.name AS rider_name,
    COUNT(r.ride_id) AS total_rides
FROM rides_clean r
JOIN riders_clean ri ON r.rider_id = ri.rider_id
JOIN payments_clean p ON r.ride_id = p.ride_id
WHERE p.amount > 0
GROUP BY ri.rider_id, ri.name
HAVING COUNT(r.ride_id) > 10
AND COUNT(CASE WHEN p.method = 'cash' THEN 1 END) = 0
ORDER BY total_rides DESC;