--Question 1 — Top 10 longest rides by distance
SELECT
    d.name AS driver_name,
    ri.name AS rider_name,
    r.pickup_city,
    r.dropoff_city,
    r.distance_km,
    p.method AS payment_method
FROM rides_clean r
JOIN drivers_clean d ON r.driver_id = d.driver_id
JOIN riders_clean ri ON r.rider_id = ri.rider_id
JOIN payments_clean p ON r.ride_id = p.ride_id
WHERE p.amount > 0
ORDER BY r.distance_km DESC
LIMIT 10;
