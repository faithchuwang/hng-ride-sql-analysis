CREATE TABLE rides_raw (
    ride_id       INT,
    rider_id      INT,
    driver_id     INT,
    request_time  TEXT,
    pickup_time   TEXT,
    dropoff_time  TEXT,
    pickup_city   TEXT,
    dropoff_city  TEXT,
    distance_km   FLOAT,
    status        TEXT,
    fare          FLOAT
);

CREATE TABLE riders_raw (
    rider_id     INT,
    name         TEXT,
    signup_date  TEXT,
    city         TEXT,
    email        TEXT
);

CREATE TABLE drivers_raw (
    driver_id    INT,
    name         TEXT,
    city         TEXT,
    signup_date  TEXT,
    rating       FLOAT
);

CREATE TABLE payments_raw (
    payment_id  INT,
    ride_id     INT,
    amount      FLOAT,
    method      TEXT,
    paid_date   TEXT
);

SELECT COUNT(*) FROM rides_raw;
SELECT COUNT(*) FROM riders_raw;
SELECT COUNT(*) FROM drivers_raw;
SELECT COUNT(*) FROM payments_raw;

-- Status values in rides_raw
SELECT status, COUNT(*) 
FROM rides_raw 
GROUP BY status;


--city names in rides_raw
SELECT pickup_city, COUNT(*) 
FROM rides_raw 
GROUP BY pickup_city 
ORDER BY COUNT(*) DESC;

--negative fares
SELECT COUNT(*) 
FROM rides_raw 
WHERE fare < 0;

--payment method inconsistencies
SELECT method, COUNT(*) 
FROM payments_raw 
GROUP BY method;

--negative payment amounts:
SELECT COUNT(*) 
FROM payments_raw 
WHERE amount < 0;

--city names in riders_raw:
SELECT city, COUNT(*) 
FROM riders_raw 
GROUP BY city 
ORDER BY COUNT(*) DESC;

--city names in drivers_raw:
SELECT city, COUNT(*) 
FROM drivers_raw 
GROUP BY city 
ORDER BY COUNT(*) DESC;

CREATE TABLE drivers_clean AS
SELECT
    driver_id,
    name,
    CASE
        WHEN city = 'N.Y' THEN 'New York'
        WHEN city = 'S.F' THEN 'San Francisco'
        WHEN city = 'L.A' THEN 'Los Angeles'
        ELSE city
    END AS city,
    TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI') AS signup_date,
    rating
FROM drivers_raw;

SELECT city, COUNT(*) 
FROM drivers_clean 
GROUP BY city 
ORDER BY COUNT(*) DESC;

CREATE TABLE riders_clean AS
SELECT
    rider_id,
    name,
    CASE
        WHEN city = 'N.Y' THEN 'New York'
        WHEN city = 'S.F' THEN 'San Francisco'
        WHEN city = 'L.A' THEN 'Los Angeles'
        ELSE city
    END AS city,
    TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI') AS signup_date,
    email
FROM riders_raw;

SELECT city, COUNT(*) 
FROM riders_clean 
GROUP BY city 
ORDER BY COUNT(*) DESC;

CREATE TABLE payments_clean AS
SELECT
    payment_id,
    ride_id,
    ABS(amount) AS amount,
    CASE
        WHEN method = 'pay pal' THEN 'paypal'
        ELSE method
    END AS method,
    TO_TIMESTAMP(paid_date, 'MM/DD/YYYY HH24:MI') AS paid_date
FROM payments_raw;

SELECT method, COUNT(*) 
FROM payments_clean 
GROUP BY method;

SELECT COUNT(*) 
FROM payments_clean 
WHERE amount < 0;

CREATE TABLE rides_clean AS
SELECT
    ride_id,
    rider_id,
    driver_id,
    TO_TIMESTAMP(request_time, 'MM/DD/YYYY HH24:MI') AS request_time,
    TO_TIMESTAMP(pickup_time, 'MM/DD/YYYY HH24:MI') AS pickup_time,
    TO_TIMESTAMP(dropoff_time, 'MM/DD/YYYY HH24:MI') AS dropoff_time,
    CASE
        WHEN pickup_city = 'N.Y' THEN 'New York'
        WHEN pickup_city = 'S.F' THEN 'San Francisco'
        WHEN pickup_city = 'L.A' THEN 'Los Angeles'
        ELSE pickup_city
    END AS pickup_city,
    CASE
        WHEN dropoff_city = 'N.Y' THEN 'New York'
        WHEN dropoff_city = 'S.F' THEN 'San Francisco'
        WHEN dropoff_city = 'L.A' THEN 'Los Angeles'
        ELSE dropoff_city
    END AS dropoff_city,
    distance_km,
    CASE
        WHEN status = 'complted' THEN 'completed'
        ELSE status
    END AS status,
    ABS(fare) AS fare
FROM rides_raw
WHERE TO_TIMESTAMP(request_time, 'MM/DD/YYYY HH24:MI') 
    BETWEEN '2021-06-01' AND '2024-12-31';

SELECT status, COUNT(*) 
FROM rides_clean 
GROUP BY status;

--Find the top 10 longest rides (by distance), including driver name, 
-- rider name, pickup/dropoff cities, and payment method.


select *
from riders_clean;

select *
from payments_clean;
