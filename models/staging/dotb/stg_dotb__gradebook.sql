with source_gradebook as (
    select 
    json_value(g.data, '$.id') as gradebook_id,
    json_value(g.data, '$.team_id') as center_id,
    json_value(g.data, '$.active_date') as active_date,
    json_value(g.data, '$.assigned_user_id') as assigned_user_id,
    TIMESTAMP(json_value(g.data, '$.date_input')) as date_input,
    TIMESTAMP(json_value(g.data, '$.date_modified')) as updated_at,
    json_value(g.data, '$.name') as gradebook_name,
    json_value(g.data, '$.status') as gradebook_status,
    json_value(g.data, '$.type') as gradebook_type,
    json_value(g.data, '$.type2') as gradebook_type2,
    json_value(g.data, '$.date_exam') as date_exam,
    json_value(g.data, '$.grade_config') as grade_config,
    from {{ source('dotb', 'gradebook') }} g
    where json_value(g.data, '$.deleted') = '0'
),
gradebook as (
    {{
        dbt_utils.deduplicate(
        relation = 'source_gradebook', 
        partition_by = 'gradebook_id', 
        order_by = 'updated_at desc'
        )
        }}
),
source_gradebook_detail as (
select 
    json_value(gd.data, '$.id') as gradebook_detail_id,
    json_value(gd.data, '$.gradebook_id') as gradebook_id,
    TIMESTAMP(json_value(gd.data, '$.date_input')) as date_input,
    TIMESTAMP(json_value(gd.data, '$.date_modified')) as updated_at,
    json_value(gd.data, '$.j_class_id') as class_id,
    json_value(gd.data, '$.student_id') as student_id,
    json_value(gd.data, '$.teacher_id') as teacher_id,
    json_value(gd.data, '$.team_id') as center_id,
    json_value(gd.data, '$.content') as detail_result,
    json_value(gd.data, '$.final_result') as final_result,
    json_value(gd.data, '$.description') as description,
from {{ source('dotb', 'gradebook_details') }} gd
where json_value(gd.data, '$.deleted') = '0'
),
gradebook_detail as (
    {{
        dbt_utils.deduplicate(
            relation = 'source_gradebook_detail', 
            partition_by = 'gradebook_detail_id', 
            order_by = 'updated_at desc'
            )
            }}
),

source_teacher_gradebook as (
    select 
    json_value(tg.data, '$.id') as teacher_gradebook_id,
    json_value(tg.data, '$.c_teachers_j_gradebook_1j_gradebook_idb') as gradebook_id,
    json_value(tg.data, '$.c_teachers_j_gradebook_1c_teachers_ida') as teacher_id,
    TIMESTAMP(json_value(tg.data, '$.date_modified')) as updated_at,
    from {{ source('dotb', 'teacher_gradebook') }} tg
    where json_value(tg.data, '$.deleted') = '0'
),

teacher_gradebook as ({{dbt_utils.deduplicate(
    relation = 'source_teacher_gradebook', 
    partition_by = 'teacher_gradebook_id', 
    order_by = 'updated_at desc'
    )}}
)

select 
gd.gradebook_detail_id,
g.gradebook_id,
g.center_id,
gd.class_id,
gd.student_id,
g.assigned_user_id,
gd.date_input,
gd.updated_at,
g.active_date,
cast(gd.final_result as float64) final_result,
g.gradebook_status,
g.gradebook_type,
g.gradebook_type2,
tg.teacher_id,
g.gradebook_name,
gd.detail_result,
g.grade_config,
from gradebook g 
inner join gradebook_detail gd on gd.gradebook_id = g.gradebook_id
left join teacher_gradebook tg on tg.gradebook_id = g.gradebook_id
{# where g.gradebook_status='Approved' #}