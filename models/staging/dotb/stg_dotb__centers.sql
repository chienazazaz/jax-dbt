SELECT
    id as center_id, 
    t.name as center_name,
    code_prefix,
    deleted::BOOL as is_deleted,
FROM
    {{ source('dotb','teams') }} t
WHERE
    t.private = 0
