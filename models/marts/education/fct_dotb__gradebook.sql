{{
  config(
    materialized = 'view',
    )
}}

select 
* except(detail_result, grade_config),
json_value(detail_result,'$.value') as value,
json_value(grade_config,'$.alias') as col,
json_value(grade_config,'$.label') as label,
json_value(grade_config,'$.type') as value_type,
json_value(grade_config,'$.max_mark') as max_mark,
json_value(grade_config,'$.formula') as formula,
from {{ ref("stg_dotb__gradebook") }}
left join unnest(analytics.json_transform(parse_json( detail_result))) as detail_result
left join unnest(analytics.json_extract_value(grade_config)) grade_config
where json_value(grade_config,'$.alias') = json_value(detail_result,'$.key')