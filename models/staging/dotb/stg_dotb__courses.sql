select 
    id as course_id,
    c.name as course_name,
    team_id as center_id,
    type as course_type,
    unit_price as course_price,
    c.status as course_status,
    apply_date,
    regexp_replace(kind_of_course,r'\^','') as kind_of_course,
    expired_term,
    ext_name,
    ext_unit,
from {{ source('dotb', 'courses') }} c