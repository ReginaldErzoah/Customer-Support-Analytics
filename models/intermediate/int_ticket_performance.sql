with tickets as (

    select *
    from {{ ref('stg_customer_support_tickets') }}

),

enhanced as (

    select

        *,

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
        end as is_resolved

    from tickets

)

select *
from enhanced