
with source as (
    SELECT
    json_value(C.data,'$.id') AS course_id,
    json_value(C.data,'$.team_id') as center_id,
    json_value(C.data,'$.kind_of_course') as kind_of_course,
    json_value(C.data,'$.type_of_course_fee') as type_of_course_fee,
    json_value(C.data,'$.unit_price') as unit_price,
    json_value(C.data,'$.type') as course_type,
    json_value(C.data,'$.name') as course_name,
    regexp_replace(json_value(C.data,'$.duration_exp'),r'\^','') as duration_exp,
    json_value(C.data,'$.description') as description,
    json_value(C.data,'$.ext_unit') as ext_unit,
    json_value(C.data,'$.ext_name') as ext_name,
    TIMESTAMP(json_value(C.data,'$.date_modified')) as updated_at,
FROM
    {{ source('dotb','courses') }} C
WHERE
    json_value(C.data,'$.deleted') = '0'
)
{{dbt_utils.deduplicate(
    relation = 'source',
    partition_by = 'course_id',
    order_by = 'updated_at desc'
)}}
