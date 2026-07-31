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

        -- Additive measure for BI aggregation
        1 as ticket_count,

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
        case
            when t.first_response_time > t.time_to_resolution
            then t.time_to_resolution
            else t.first_response_time
        end as cleaned_first_response_time,


        case
            when t.first_response_time > t.time_to_resolution
            then t.first_response_time
            else t.time_to_resolution
        end as cleaned_resolution_time,


        -- Data quality monitoring
        case
            when t.first_response_time > t.time_to_resolution
            then 'Corrected'
            else 'Valid'
        end as response_time_quality_flag,


        -- Support resolution duration in hours
        round(
            date_diff(
                'minute',

                case
                    when t.first_response_time > t.time_to_resolution
                    then t.time_to_resolution
                    else t.first_response_time
                end,

                case
                    when t.first_response_time > t.time_to_resolution
                    then t.first_response_time
                    else t.time_to_resolution
                end

            ) / 60.0,

            2
        ) as resolution_hours,


        -- Customer experience
        t.customer_satisfaction_rating,


        -- Dimension match quality checks
        case
            when c.customer_id is null
            then 'Unknown Customer'
            else 'Matched'
        end as customer_match_status,


        case
            when p.product_id is null
            then 'Unknown Product'
            else 'Matched'
        end as product_match_status


    from tickets t


    left join customers c
        on t.customer_email = c.customer_email


    left join products p
        on t.product_name = p.product_name

)

select *
from final