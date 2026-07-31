{{ config(
    materialized='table'
) }}

with products as (

    select

        product_name

    from {{ ref('stg_customer_support_tickets') }}

    group by product_name

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key([
            'product_name'
        ]) }} as product_id,

        product_name

    from products

)

select *
from final