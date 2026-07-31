SELECT
    ticket_id,
    COUNT(*) AS duplicate_count

FROM {{ ref('fact_ticket_metrics') }}

GROUP BY ticket_id

HAVING COUNT(*) > 1