with source as (
    select 
json_value(l.data, '$.id') as change_id,
json_value(l.data, '$.parent_id') as parent_id,
json_value(l.data, '$.event_id') as event_id,
timestamp(json_value(l.data, '$.date_created')) as created_at,
json_value(l.data, '$.created_by') as created_by,
json_value(l.data, '$.field_name') as field_name,
json_value(l.data, '$.data_type') as data_type,
json_value(l.data, '$.before_value_string') as before_value_string,
json_value(l.data, '$.after_value_string') as after_value_string,
json_value(l.data, '$.before_value_text') as before_value_text,
json_value(l.data, '$.after_value_text') as after_value_text,
_batched_at as updated_at,
from {{ source('dotb', 'leads_audit') }} l
)

{{dbt_utils.deduplicate(
    relation = 'source',
    partition_by = 'change_id',
    order_by = 'updated_at desc'
)}}