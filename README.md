# HNG Ride — SQL Business Analysis

## Project Background

HNG Ride is a mid-sized ride-hailing company operating across 10 major cities in North America including Toronto, Chicago, New York, Vancouver, and Calgary. The company has been active since mid-2021 and operates on a marketplace business model — connecting riders who need transportation with independent drivers through a digital platform.

As a data analyst at HNG Ride, I was tasked with reviewing operational performance for the period June 2021 through December 2024. Key business metrics of interest include total revenue, ride completion rates, cancellation rates, driver consistency, and rider retention.

Insights and recommendations are provided on the following key areas:

- **Revenue Trends:** Quarterly revenue performance across 2021–2024
- **Driver Performance:** Consistency, city-level revenue contribution, and bonus eligibility
- **Rider Behaviour:** Retention, ride frequency, and payment preferences
- **Operational Issues:** Cancellation rates across cities and data quality findings

The SQL queries used to clean and prepare the data for this analysis can be found [here](#).

Targeted SQL queries addressing the 8 business questions can be found [here](#).

---

## Data Structure & Initial Checks

The HNG Ride database consists of four tables with a total of 112,000 records. A description of each table is as follows:

- **rides_raw** — 50,000 records. Contains trip-level data including pickup/dropoff cities, distance, fare, status, and timestamps
- **riders_raw** — 10,000 records. Contains customer information including name, city, email, and signup date
- **drivers_raw** — 2,000 records. Contains driver information including name, city, rating, and signup date
- **payments_raw** — 50,000 records. Contains one payment record per ride including amount, payment method, and payment date

**Relationships:**
- `rides.rider_id` → `riders.rider_id`
- `rides.driver_id` → `drivers.driver_id`
- `payments.ride_id` → `rides.ride_id`

---

## Executive Summary

### Overview of Findings

HNG Ride processed over 36,000 completed rides between June 2021 and December 2024, generating approximately $100,000 in revenue per quarter. However, three issues stand out: revenue has been on a slow but consistent decline since 2022, cancellation rates are alarmingly high across all cities (averaging ~18%), and only 2 out of 2,000 drivers meet the current bonus eligibility criteria — suggesting the incentive program needs revisiting.

---

## Insights Deep Dive

### Revenue Trends

**Quarterly revenue has been declining since 2022.** Revenue peaked in 2022 and has trended downward since, with 2024 Q1 recording the lowest full-quarter revenue at $96,603 — a drop of roughly 7% from the 2022 average of ~$104,700 per quarter.

**2021 data is partial.** The analysis window starts from June 2021, meaning Q2 2021 only captured half a quarter ($34,474). The first full comparable quarter is Q3 2021 at $107,314.

**Revenue is relatively stable quarter-to-quarter within each year.** There are no dramatic seasonal spikes — revenue stays within a ~$7,000 range within any given year, suggesting demand is consistent throughout the year.

**2024 Q3 showed a partial recovery.** After a low Q1 and Q2, 2024 Q3 rebounded to $104,545 — the strongest quarter of 2024 — before dipping again in Q4.

---

### Driver Performance

**Only 2 drivers qualify for the bonus.** Out of 2,000 drivers, only Driver_1005 (4.80 rating, 0% cancellation, 33 rides) and Driver_1181 (4.60 rating, 3.13% cancellation, 31 rides) meet all three bonus criteria — indicating the thresholds may be unrealistically strict.

**Driver_219 is the most consistent driver** with an average of 2.58 completed rides per month over 12 active months. The top 5 most consistent drivers all average between 2.0 and 2.58 rides per month.

**Driver_1980 generated the highest single-city revenue** at $476.91 in Calgary. Across all cities, top-earning drivers generate between $303 and $477 in total revenue over the analysis period.

**Some drivers operate across multiple cities.** Driver_286 ranks in the top 3 for both Boston (rank 2, $326.58) and San Francisco (rank 1, $354.75) — showing cross-city activity that management should track for driver utilisation insights.

---

### Rider Behaviour

**Retention from 2021 is strong.** 1,826 riders who signed up in 2021 were still taking rides in 2024 — a meaningful cohort that management should study to understand long-term loyalty drivers.

**Cash remains a dominant payment method.** Only 1 rider with more than 10 rides has never used cash (Rider_7823). This means almost every frequent rider has paid with cash at least once, indicating deep cash dependency across the rider base.

**Payment methods are evenly distributed.** Across all completed rides, voucher (12,320), PayPal (12,686), card (12,592), and cash (12,402) are nearly equally used — no single method dominates, reflecting diverse rider preferences.

**Only one truly cash-free frequent rider exists.** This is a strong signal that removing or limiting cash payments would face significant rider resistance.

---

### Operational Issues — Cancellations

**Chicago has the highest cancellation rate at 19.25%** — nearly 1 in 5 rides is cancelled there. Toronto is second at 19.09%.

**Cancellation rates are high across all cities.** Rates range from 17.74% (Boston) to 19.25% (Chicago) — a very narrow band. This suggests the problem is systemic and company-wide, not specific to any one city or market.

**Over 8,000 rides were cancelled** during the analysis window out of ~44,800 total rides — roughly 18% overall. This represents significant lost revenue and a poor rider/driver experience.

**The narrow range across cities eliminates geography as the root cause.** Management should investigate platform-level factors such as driver availability at peak times, fare pricing accuracy, or app-related friction as potential causes.

---

## Recommendations

Based on the insights above, we recommend the operations and product teams consider the following:

**Revenue is declining — investigate demand-side causes.** Quarterly revenue has dropped from ~$104k in 2022 to ~$96k–$102k in 2024. Management should analyse whether this reflects fewer rides, lower fares, or rider churn, and act accordingly with targeted promotions or pricing adjustments.

**Cancellation rates demand immediate attention.** An 18–19% cancellation rate across all cities is too high to ignore. We recommend a dedicated investigation into when cancellations happen (pre-pickup vs. en route), who initiates them (rider vs. driver), and what time of day they peak.

**Revisit the bonus criteria.** With only 2 out of 2,000 drivers qualifying, the current thresholds are effectively excluding the entire driver pool from incentives. Consider tiered bonus levels (e.g. Bronze/Silver/Gold) to reward a broader range of strong performers and improve driver retention.

**Protect cash as a payment option.** Given that nearly all frequent riders have used cash, any move to reduce or eliminate cash payments should be approached with caution and communicated clearly to riders to avoid churn.

**Invest in retaining the 2021 rider cohort.** 1,826 riders from 2021 are still active — these are your most loyal customers. Identify what keeps them engaged and build targeted loyalty programmes around those behaviours.

---

## Assumptions and Caveats

**Completed rides are defined by payment amount > 0.** The IT team confirmed that a positive payment amount in the payments table is the reliable indicator of a completed ride. Rides with zero or null payment amounts were excluded from all business question queries.

**Negative fares and payment amounts were treated as data entry errors.** 652 negative fares and 520 negative payment amounts were corrected using `ABS()` — assumed to be sign errors rather than refunds, as no refund column exists in the dataset.

**City name abbreviations were standardised.** `N.Y`, `L.A`, and `S.F` were mapped to `New York`, `Los Angeles`, and `San Francisco` respectively across all tables. These were clearly the same cities based on context.

**The analysis window starts June 2021.** 2021 Q2 revenue figures are partial (June only) and are excluded from year-over-year comparisons to avoid misleading growth calculations.

**Driver active months calculated to December 2024.** For consistency, all driver tenure calculations used December 31, 2024 as the end date regardless of when their last ride occurred.
