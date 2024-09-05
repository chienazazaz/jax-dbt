{# {{
  config(
    
    )
}} #}

select 
    id as koc_id,
    c.name as koc_name,
    team_id as center_id,
    kind_of_course,
    k.status as koc_status,
from {{ source('dotb', 'kind_of_course') }} k