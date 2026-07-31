{{ config(
    materialized='table'
) }}

with products as (

    select distinct
        product_name

    from {{ ref('stg_customer_support_tickets') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(
            ['product_name']
        ) }} as product_id,

        product_name

    from products

)

select *
from final