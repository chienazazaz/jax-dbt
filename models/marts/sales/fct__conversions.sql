{{
  config(
    materialized = 'view',
    )
}}
select 
c.center_name,
regexp_replace(s.phone_mobile,r'^0','84') as phone_mobile,
s.email,
s.last_name,
s.first_name,
s.gender,
s.dob,
t.transaction_code,
"physical_store" as lead_source,
sum(t.payment_amount) as total,
max(t.transaction_date) as transaction_date,
from {{ ref("stg_dotb__transactions") }} t
left join {{ ref("stg_dotb__centers") }} c on t.center_id = c.center_id
left join {{ ref("stg_dotb__students") }} s on t.parent_id = s.student_id
where 1=1
and t.status = 'Paid'
{{dbt_utils.group_by(9)}}