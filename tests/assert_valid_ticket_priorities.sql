SELECT DISTINCT
    ticket_priority

FROM {{ ref('fact_ticket_metrics') }}

WHERE ticket_priority NOT IN
(
    'Low',
    'Medium',
    'High',
    'Critical'
)