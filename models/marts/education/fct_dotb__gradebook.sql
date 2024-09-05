{{
  config(
    materialized = 'table',
    )
}}

{# with gradebook as ( #}
select 
* except(detail_result, grade_config),
safe_cast(json_value(detail_result,'$.value') as float64) as value,
json_value(grade_config,'$.alias') as col_alias,
regexp_replace(json_value(grade_config,'$.label'),r'\r\n',' ') as value_label,
json_value(grade_config,'$.type') as value_type,
safe_cast(json_value(grade_config,'$.max_mark') as float64) as max_mark,
json_value(grade_config,'$.formula') as formula,
json_value(grade_config,'$.comment') as comment,
from {{ ref("stg_dotb__gradebook") }}
left join unnest(analytics.json_transform(parse_json( detail_result))) as detail_result
left join unnest(analytics.json_extract_value(grade_config)) grade_config
where json_value(grade_config,'$.alias') = json_value(detail_result,'$.key')
{# and safe_cast(json_value(detail_result,'$.value') as float64) is not null #}
{# ) #}


