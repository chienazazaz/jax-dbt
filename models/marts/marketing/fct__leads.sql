WITH leads AS (
    SELECT
        phone_mobile,
        lead_id,
        lead_source,
        created_at
    FROM
        {{ ref("stg_dotb__leads") }}
    {# group by 1,2,3,4 #}
),
students AS (
    SELECT
        phone_mobile,
        student_id,
        lead_source,
        created_at
    from {{ ref("stg_dotb__students") }}
    {# group by 1,2,3,4 #}
),

contacts as (
    select phone_mobile from leads
        union distinct
    select phone_mobile from students
    )

select c.*,
l.lead_id,
s.student_id,
coalesce(l.lead_source,s.lead_source) as lead_source,
least(l.created_at,s.created_at) as created_at,
(s.student_id is not null) as is_converted,
s.created_at as converted_at,
from contacts c
left join leads l on c.phone_mobile = l.phone_mobile
left join students s on c.phone_mobile = s.phone_mobile