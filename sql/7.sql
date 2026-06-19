--Question 7 — Find the top 3 drivers in each city by total revenue earned between June 2021 and Dec 2024.
WITH driver_revenue AS (
    SELECT
        d.name AS driver_name,
        r.pickup_city,
        SUM(p.amount) AS total_revenue,
        RANK() OVER (PARTITION BY r.pickup_city ORDER BY SUM(p.amount) DESC) AS rank
    FROM rides_clean r
    JOIN drivers_clean d ON r.driver_id = d.driver_id
    JOIN payments_clean p ON r.ride_id = p.ride_id
    WHERE p.amount > 0
    GROUP BY d.name, r.pickup_city
)
SELECT *
FROM driver_revenue
WHERE rank <= 3
ORDER BY pickup_city, rank;
