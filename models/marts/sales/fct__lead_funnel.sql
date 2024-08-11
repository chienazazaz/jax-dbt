{{
  config(
    materialized = 'view',
    )
}}

with data_ as (
    select 
regexp_replace(l.phone_mobile,r'^0','84') as phone_mobile,
s.email,
l.gender,
l.last_name,
l.first_name,
coalesce(s.dob,l.dob) as dob,
t.created_at,
date(t.created_at) as conversion_date,
{# t.before_value_string as before_status, #}
t.after_value_string as status,
from {{ ref("stg_dotb__leads_audit") }} t
left join {{ ref('stg_dotb__leads') }} l on t.parent_id = l.lead_id
left join {{ ref('stg_dotb__students') }} s on l.phone_mobile = s.phone_mobile
where 1=1
and t.field_name = 'status'
)
{{dbt_utils.deduplicate(
    relation = 'data_', 
    partition_by = 'phone_mobile,status',
    order_by = 'created_at desc'
)}}