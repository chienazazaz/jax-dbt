with source as (
    SELECT
    json_value(t.data,'$.id') AS center_id,
    json_value(t.data,'$.name') AS center_name,
    json_value(t.data,'$.legal_name') AS legal_name,
    json_value(t.data,'$.code_prefix') AS code_prefix,
    json_value(t.data, '$.deleted') AS is_deleted,
    TIMESTAMP(json_value(t.data, '$.date_entered')) created_at,
    TIMESTAMP(json_value(t.data, '$.date_modified')) updated_at,
FROM
    {{ source('dotb','teams') }} t
WHERE
    json_value(t.data,'$.private') = '0'
)
{{
    dbt_utils.deduplicate(
        relation = 'source', 
        partition_by= 'center_id', 
        order_by='updated_at desc'
        )
        }}