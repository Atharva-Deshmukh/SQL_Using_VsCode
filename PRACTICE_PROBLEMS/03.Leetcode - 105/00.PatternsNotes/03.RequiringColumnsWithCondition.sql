/* Whenever we need other columns of say, col-1 = MAX, 
   Its not possible via SELECT, we use ROW_NUMBER() in that case
   and then we filter all the rows with that rowNum

*/


WITH calculationTable AS (
    SELECT user_id,
           plan_name,
           monthly_amount,
           event_type,
           SUM(event_type = 'downgrade') OVER(
             PARTITION BY user_id
           ) AS noOfDowngrades,
           MAX(monthly_amount) OVER (
             PARTITION BY user_id
           ) AS max_historical_amount,
           FIRST_VALUE(event_date) OVER(
             PARTITION BY user_id
             ORDER BY event_id
           ) AS startDate,
           FIRST_VALUE(event_date) OVER(
             PARTITION BY user_id
             ORDER BY event_id DESC
           ) AS endDate,
           ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY event_id DESC
           ) AS rnk
    FROM subscription_events
)

-- SELECT * FROM calculationTable;

SELECT user_id, 
       plan_name AS current_plan,
       monthly_amount AS current_monthly_amount,
       max_historical_amount,
       DATEDIFF(endDate, startDate) AS days_as_subscriber
FROM calculationTable
WHERE rnk = 1 
  AND event_type <> 'cancel'
  AND noOfDowngrades >= 1
  AND monthly_amount < (0.5 * max_historical_amount)
  AND DATEDIFF(endDate, startDate) >= 60
ORDER BY DATEDIFF(endDate, startDate) DESC, user_id ASC;
