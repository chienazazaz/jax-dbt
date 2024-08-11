
with source_classes as (
    SELECT
    json_value(c.data,'$.id') AS class_id,
    json_value(c.data,'$.team_id') AS center_id,
    nullif(json_value(c.data,'$.teacher_id'),'') AS teacher_id,
    json_value(c.data,'$.class_code') AS class_code,
    json_value(c.data,'$.class_type') AS class_type,
    json_value(c.data,'$.name') AS class_name,
    json_value(c.data,'$.status') AS class_status,
    json_value(c.data,'$.hours') AS hours,
    date(json_value(c.data,'$.start_date')) AS start_date,
    date(json_value(c.data,'$.end_date')) AS end_date,
    nullif(json_value(c.data,'$.kind_of_course'),'') AS kind_of_course,
    nullif(json_value(c.data,'$.level'),'') AS level,
    json_value(c.data,'$.max_size') AS max_students,
    TIMESTAMP(json_value(c.data,'$.date_entered')) AS created_at,
    TIMESTAMP(json_value(c.data,'$.date_modified')) AS updated_at,
FROM
    {{ source('dotb','classes') }} c
where json_value(c.data,'$.deleted') = '0'
),
    classes as (
        {{
        dbt_utils.deduplicate(
            relation = 'source_classes', 
            partition_by = 'class_id', 
            order_by = 'updated_at desc'
            )
            }}
),
source_teacher_class as (
    select 
    json_value(tc.data, '$.id') as teacher_class_id,
    json_value(tc.data, '$.j_class_c_teachers_1j_class_ida') as class_id,
    json_value(tc.data, '$.j_class_c_teachers_1c_teachers_idb') as teacher_id,
    TIMESTAMP(json_value(tc.data, '$.date_modified')) as updated_at,
    from {{ source('dotb', 'class_teachers') }} tc
    where json_value(tc.data, '$.deleted') = '0'
),
teacher_class as (
    {{
    dbt_utils.deduplicate(
        relation = 'source_teacher_class', 
        partition_by = 'teacher_class_id', 
        order_by = 'updated_at desc'
        )
        }}
)

select c.* except(teacher_id),
coalesce(c.teacher_id,tc.teacher_id) as teacher_id
from classes c 
left join teacher_class tc on c.class_id = tc.class_id and c.teacher_id is null
