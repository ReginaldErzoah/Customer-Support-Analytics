with customers as (

    select
        customer_email,
        customer_name,
        customer_age,
        customer_gender

    from {{ ref('int_ticket_performance') }}

),

deduplicated as (

    select distinct *

    from customers

)

select

    {{ dbt_utils.generate_surrogate_key(['customer_email']) }}
        as customer_id,

    customer_email,
    customer_name,
    customer_age,
    customer_gender

from deduplicated