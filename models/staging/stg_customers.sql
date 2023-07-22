{{
    config(
        materialized='table',
        post_hook='
            update {{ this }} set is_duplicated = 1 
            where customer_id in (
                select unique_field 
                from "analytics_dbt_test__audit"."unique_stg_customers_customer_id"
                )'
    )
}}

with

source as (

    select * from {{ source('ecom', 'raw_customers') }}

),

renamed as (

    select

        ----------  ids
        id as customer_id,

        ---------- properties
        name as customer_name,
        0 as is_duplicated 

    from source
)
select * from renamed
