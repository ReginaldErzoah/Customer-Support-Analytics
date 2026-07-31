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

        -- Product details
        t.product_name,

        -- Dates
        t.purchase_date,

        -- Original timestamps
        t.first_response_time,
        t.time_to_resolution,


        -- Cleaned timestamps
        CASE
            WHEN t.first_response_time > t.time_to_resolution
            THEN t.time_to_resolution
            ELSE t.first_response_time
        END AS cleaned_first_response_time,


        CASE
            WHEN t.first_response_time > t.time_to_resolution
            THEN t.first_response_time
            ELSE t.time_to_resolution
        END AS cleaned_resolution_time,


        -- Data quality monitoring
        CASE
            WHEN t.first_response_time > t.time_to_resolution
            THEN 'Corrected'
            ELSE 'Valid'
        END AS response_time_quality_flag,


        -- Support resolution duration in hours
        ROUND(
            DATE_DIFF(
                'minute',

                CASE
                    WHEN t.first_response_time > t.time_to_resolution
                    THEN t.time_to_resolution
                    ELSE t.first_response_time
                END,

                CASE
                    WHEN t.first_response_time > t.time_to_resolution
                    THEN t.first_response_time
                    ELSE t.time_to_resolution
                END

            ) / 60.0,

            2
        ) AS resolution_hours,


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