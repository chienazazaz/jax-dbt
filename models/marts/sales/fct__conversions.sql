select 
coalesce(s.phone_mobile,l.phone_mobile) as phone_mobile,
coalesce(l.created_at,s.created_at)::DATE as lead_created_at,
s.created_at::DATE as converted_at,
coalesce(s.phone_guardian, l.phone_guardian) as phone_guardian,
coalesce(s.lead_source, l.lead_source) as lead_source,
coalesce(s.dob, l.dob) as dob,
datediff('day', coalesce(s.dob, l.dob), current_date) as age,
c.center_name as center_name,
coalesce(s.utm_medium, l.utm_medium) as utm_medium,
coalesce(s.utm_source, l.utm_source) as utm_source,
s.campaign_id as campaign_id,
(s.phone_mobile is not null) as is_converted,
from {{ ref('stg_dotb__leads') }} l
full outer join {{ ref('stg_dotb__students') }} s on l.phone_mobile = s.phone_mobile
left join {{ ref('stg_dotb__centers') }} c on coalesce(s.center_id, l.center_id) = c.center_id
where 1=1