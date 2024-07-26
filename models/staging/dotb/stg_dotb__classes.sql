SELECT
    id AS class_id,
    team_id AS center_id,
    teacher_id,
    class_code,
    class_type,
    c.name AS class_name,
    c.status AS class_status,
    c.hours,
    c.start_date,
    end_date,
    kind_of_course,
    c.level,
    max_size AS max_students,
    number_of_students,
FROM
    {{ source('dotb','classes') }} c
where c.deleted=0