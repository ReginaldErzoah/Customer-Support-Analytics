{{ config(
    materialized='table'
) }}

with ranked_customers as (

    select

        customer_email,
        customer_name,
        customer_age,
        customer_gender,

        row_number() over (
            partition by customer_email
            order by customer_name
        ) as customer_rank

    from {{ ref('int_ticket_performance') }}

),

customers as (

    select

        customer_email,
        customer_name,
        customer_age,
        customer_gender

    from ranked_customers

    where customer_rank = 1

)

select

    {{ dbt_utils.generate_surrogate_key([
        'customer_email'
    ]) }} as customer_id,

    customer_email,
    customer_name,
    customer_age,
    customer_gender

from customers