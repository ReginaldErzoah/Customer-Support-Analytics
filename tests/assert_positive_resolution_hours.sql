SELECT *

FROM {{ ref('fact_ticket_metrics') }}

WHERE resolution_hours < 0