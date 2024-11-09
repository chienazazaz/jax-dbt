{{
  config(
    materialized = 'view',
    )
}}
with 

mess_leads as (
    select distinct
    phone_number,
    ad_id,
    date(updated_at) as last_interaction_date,
    from {{ ref("stg_pancake__conversations") }}
    where phone_number is not null
    and ad_id is not null
    {# {{dbt_utils.group_by(3)}} #}
    qualify row_number() over (partition by phone_number order by ad_inserted_at desc) =1
),


leads_contact as (
    select
    s.phone_mobile,
    la.after_value_string as new_status,
    date(la.created_at) as status_change_date,
    from {{ ref("stg_dotb__leads_audit") }} la
    left join {{ ref("stg_dotb__leads") }} s on la.parent_id = s.lead_id
    where field_name = 'status'
    {{dbt_utils.group_by(3)}}
),


revenue as (
    select
    t.transaction_date,
    s.phone_mobile,
    t.transaction_code,
    sum(t.payment_amount) as payment_amount,
    from {{ ref("stg_dotb__transactions") }} t
    left join {{ ref("stg_dotb__students") }} s on t.parent_id = s.student_id
    where t.transaction_type in ('Cashholder','Deposit')
    and t.status ='Paid'
    {{dbt_utils.group_by(3)}}
)

select 
l.*,
r.transaction_date,
r.transaction_code,
min(case when lc.new_status in ('Ready to PT') then lc.status_change_date end) as ready_to_pt_date,
min(case when lc.new_status in ('Converted') then lc.status_change_date end) as converted_date,
sum(r.payment_amount) as revenue,
from mess_leads l
left join leads_contact lc on l.phone_number = lc.phone_mobile and date_diff(lc.status_change_date,l.last_interaction_date,day) <= 30 and lc.status_change_date >= l.last_interaction_date
left join revenue r on lc.phone_mobile = r.phone_mobile and date_diff(r.transaction_date,lc.status_change_date,day) <= 30 and r.transaction_date >= lc.status_change_date and lc.new_status in ('Converted')
{{dbt_utils.group_by(5)}}


