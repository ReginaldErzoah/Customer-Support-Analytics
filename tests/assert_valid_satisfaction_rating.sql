SELECT *

FROM {{ ref('fact_ticket_metrics') }}

WHERE customer_satisfaction_rating < 1
   OR customer_satisfaction_rating > 5