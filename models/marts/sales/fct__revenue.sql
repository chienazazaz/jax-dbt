SELECT
td.transaction_date,
td.transaction_id,
t.transaction_type,
C.center_name,
t.sale_type,
t.class_code,
t.level_code,
t.kind_of_course,
td.payment_method,
td.payment_amount,
td.discount_amount,
td.sponsor_amount,
td.loyalty_amount,
td.payment_method_fee,
td.student_id,
FROM
    {{ ref('stg_dotb__transaction_details') }}
    td
    INNER JOIN {{ ref('stg_dotb__transactions') }}
    t
    ON td.transaction_id = t.transaction_id
    INNER JOIN {{ ref('stg_dotb__centers') }} C
    ON t.center_id = C.center_id
    where td.status = 'Paid'

