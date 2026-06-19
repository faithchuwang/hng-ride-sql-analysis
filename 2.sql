--Question 2 — How many riders who signed up in 2021 still took rides in 2024?
SELECT COUNT(DISTINCT r.rider_id)
FROM rides_clean r
JOIN riders_clean ri ON r.rider_id = ri.rider_id
JOIN payments_clean p ON r.ride_id = p.ride_id
WHERE EXTRACT(YEAR FROM ri.signup_date) = 2021
AND EXTRACT(YEAR FROM r.request_time) = 2024
AND p.amount > 0;
