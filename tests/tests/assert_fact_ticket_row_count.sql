SELECT

COUNT(*) AS total_records

FROM {{ ref('fact_ticket_metrics') }}

HAVING COUNT(*) = 0