{{ config(
    materialized='table'
) }}

with tickets as (

    select *
    from {{ ref('stg_customer_support_tickets') }}

),

customers as (

    select *
    from {{ ref('dim_customers') }}

),

products as (

    select *
    from {{ ref('dim_products') }}

),

final as (

    select

        -- Ticket key
        t.ticket_id,

        -- Dimension keys
        c.customer_id,
        p.product_id,

        -- Ticket details
        t.ticket_type,
        t.ticket_status,
        t.ticket_priority,
        t.ticket_channel,

        -- Dates
        t.purchase_date,

        -- Performance metrics
        t.first_response_time,
        t.time_to_resolution,

        -- Customer experience
        t.customer_satisfaction_rating

    from tickets t

    left join customers c
        on t.customer_email = c.customer_email

    left join products p
        on t.product_name = p.product_name

)

select *
from final