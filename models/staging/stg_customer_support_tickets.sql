{{ config(
    materialized='table'
) }}

with source_data as (

    select *
    from {{ source('customer_support', 'customer_support_tickets') }}

),

cleaned as (

    select

        -- Ticket information
        "Ticket ID" as ticket_id,

        -- Customer information
        "Customer Name" as customer_name,
        "Customer Email" as customer_email,
        "Customer Age" as customer_age,
        "Customer Gender" as customer_gender,

        -- Product information
        "Product Purchased" as product_name,
        cast("Date of Purchase" as date) as purchase_date,

        -- Ticket classification
        "Ticket Type" as ticket_type,
        "Ticket Subject" as ticket_subject,
        "Ticket Description" as ticket_description,
        "Ticket Status" as ticket_status,
        "Resolution" as resolution,
        "Ticket Priority" as ticket_priority,
        "Ticket Channel" as ticket_channel,

        -- Performance metrics
        cast("First Response Time" as timestamp) as first_response_time,
        cast("Time to Resolution" as timestamp) as time_to_resolution,
        "Customer Satisfaction Rating" as customer_satisfaction_rating

    from source_data

)

select *
from cleaned