with tickets as (

    select *
    from {{ ref('stg_customer_support_tickets') }}

),

enhanced as (

    select

        ticket_id,

        -- Customer information
        customer_name,
        customer_email,
        customer_age,
        customer_gender,

        -- Product information
        product_name,
        purchase_date,

        -- Ticket information
        ticket_type,
        ticket_subject,
        ticket_description,
        ticket_status,
        resolution,
        ticket_priority,
        ticket_channel,

        -- Time information
        first_response_time,
        time_to_resolution,

        -- Satisfaction
        customer_satisfaction_rating,


        -- Business logic flags

        case
            when ticket_status = 'Closed' then true
            else false
        end as is_closed,


        case
            when ticket_status = 'Open' then true
            else false
        end as is_open,


        case
            when ticket_status = 'Pending Customer Response' then true
            else false
        end as is_pending_customer_response,


        case
            when resolution is not null then true
            else false
        end as is_resolved,


        -- Satisfaction categories

        case
            when customer_satisfaction_rating in (1,2)
                then 'Poor'

            when customer_satisfaction_rating = 3
                then 'Average'

            when customer_satisfaction_rating = 4
                then 'Good'

            when customer_satisfaction_rating = 5
                then 'Excellent'

            else 'No Rating'

        end as satisfaction_category,


        -- Customer age groups

        case
            when customer_age < 25
                then 'Young'

            when customer_age between 25 and 40
                then 'Adult'

            when customer_age > 40
                then 'Senior'

            else 'Unknown'

        end as customer_age_group


    from tickets

)

select *
from enhanced