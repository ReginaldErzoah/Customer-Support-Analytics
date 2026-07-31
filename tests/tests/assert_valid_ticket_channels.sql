SELECT DISTINCT
    ticket_channel

FROM {{ ref('fact_ticket_metrics') }}

WHERE ticket_channel NOT IN
(
    'Email',
    'Phone',
    'Chat',
    'Social media'
)