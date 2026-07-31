with customers as (

    select distinct

        customer_email,
        customer_name,
        customer_age,
        customer_gender

    from {{ ref('int_ticket_performance') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'customer_email',
        'customer_name',
        'customer_age',
        'customer_gender'
    ]) }} as customer_id,

    customer_email,
    customer_name,
    customer_age,
    customer_gender

from customers