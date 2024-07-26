SELECT
    gd.team_id as center_id,
    gd.j_class_id as class_id,
    gd.date_input,
    gd.teacher_id,
    gd.student_id,
    gd.final_result,
    gb.name as test_name,
    gb.date_exam,
    gb.type2,
    gb.type,
    regexp_extract(gb.description, r'(\d+%)', 1) AS weighting,
    gb.status as test_status,
FROM
    {{ source('dotb','gradebook_details') }} gd
LEFT JOIN 
    {{ source('dotb','gradebook') }} AS gb
    ON gd.gradebook_id = gb.id
where gd.deleted=0
and gb.deleted=0