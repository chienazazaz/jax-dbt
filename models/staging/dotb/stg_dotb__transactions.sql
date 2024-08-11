with source_payment_details as (
SELECT
json_value(p.data,'$.assigned_user_id') AS assigned_user_id,
json_value(p.data,'$.before_discount') AS before_discount,
json_value(p.data,'$.contract_id') AS contract_id,
json_value(p.data,'$.created_by') AS created_by,
timestamp(json_value(p.data,'$.date_entered')) AS created_at,
timestamp(json_value(p.data,'$.date_modified')) AS updated_at,
json_value(p.data,'$.description') AS description,
cast(json_value(p.data,'$.discount_amount') as float64) AS discount_amount,
json_value(p.data,'$.id') AS transaction_line_id,
json_value(p.data,'$.inv_code') AS inv_code,
json_value(p.data,'$.invoice_id') AS invoice_id,
json_value(p.data,'$.invoice_number') AS invoice_number,
json_value(p.data,'$.is_discount') AS is_discount,
json_value(p.data,'$.is_first') AS is_first,
json_value(p.data,'$.is_old') AS is_old,
cast(json_value(p.data,'$.loyalty_amount') as float64) AS loyalty_amount,
json_value(p.data,'$.modified_user_id') AS updated_by,
json_value(p.data,'$.name') AS transaction_line_code,
json_value(p.data,'$.parent_id') AS parent_id,
json_value(p.data,'$.parent_type') AS parent_type,
cast(json_value(p.data,'$.payment_amount') as float64) AS payment_amount,
date(json_value(p.data,'$.payment_date')) AS transaction_date,
json_value(p.data,'$.payment_datetime') AS transaction_datetime,
json_value(p.data,'$.payment_id') AS transaction_id,
cast(json_value(p.data,'$.payment_method_fee') as float64) AS payment_method_fee,
json_value(p.data,'$.payment_method') AS payment_method,
json_value(p.data,'$.payment_no') AS payment_no,
json_value(p.data,'$.pos_code') AS pos_code,
json_value(p.data,'$.printed_date') AS printed_date,
json_value(p.data,'$.printed_user_id') AS printed_user_id,
cast(json_value(p.data,'$.sponsor_amount') as float64) AS sponsor_amount,
json_value(p.data,'$.status') AS status,
json_value(p.data,'$.team_id') AS center_id,
FROM
    {{ source('dotb','payment_details') }} p
WHERE
    json_value(p.data,'$.deleted') = '0'
),
payment_details as (
    {{dbt_utils.deduplicate(
        relation = 'source_payment_details', 
        partition_by = 'transaction_line_id', 
        order_by = 'updated_at desc'
        )
        }}
),
source_payment as (
select 
json_value(p.data,'$.catch_limit') as catch_limit,
json_value(p.data,'$.class_string') as class_string,
json_value(p.data,'$.coursefee_list') as coursefee_list,
json_value(p.data,'$.created_by') as created_by,
timestamp(json_value(p.data,'$.date_entered')) as created_at,
timestamp(json_value(p.data,'$.date_modified')) as updated_at,
json_value(p.data,'$.description') as description,
json_value(p.data,'$.duration_exp') as duration_exp,
json_value(p.data,'$.id') as transaction_id,
json_value(p.data,'$.ju_class_id') as ju_class_id,
json_value(p.data,'$.kind_of_course_string') as kind_of_course_string,
json_value(p.data,'$.kind_of_course') as kind_of_course,
json_value(p.data,'$.level_string') as level_string,
json_value(p.data,'$.modified_user_id') as updated_by,
json_value(p.data,'$.move_to_center_id') as move_to_center_id,
json_value(p.data,'$.moving_tran_in_date') as moving_tran_in_date,
json_value(p.data,'$.moving_tran_out_date') as moving_tran_out_date,
json_value(p.data,'$.name') as transaction_code,
json_value(p.data,'$.number_of_payment') as number_of_payment,
json_value(p.data,'$.parent_id') as parent_id,
json_value(p.data,'$.parent_type') as parent_type,
date(json_value(p.data,'$.payment_date')) as transaction_date,
json_value(p.data,'$.payment_method') as payment_method,
json_value(p.data,'$.payment_type') as transaction_type,
json_value(p.data,'$.sale_type_date') as sale_type_date,
json_value(p.data,'$.sale_type') as sale_type,
json_value(p.data,'$.settle_date') as settle_date,
json_value(p.data,'$.team_id') as center_id,
json_value(p.data,'$.use_type') as use_type,
from {{ source('dotb','payments') }} p
where json_value(p.data,'$.deleted') = '0'
),
payment as (
{{dbt_utils.deduplicate(
    relation = 'source_payment',
    partition_by = 'transaction_id',
    order_by = 'updated_at desc'
)}}
)

select 
pd.* except(transaction_id, transaction_date, center_id, created_by, updated_by,created_at, updated_at, description,parent_id, parent_type),
p.* except(transaction_id, transaction_date, center_id, created_by, updated_by,created_at, updated_at, description, payment_method, sale_type),
p.center_id,
p.parent_id as student_id,
pd.created_by,
pd.updated_by,
p.created_at,
pd.updated_at,
p.description as transaction_description,
pd.transaction_id, 
pd.transaction_date,
from payment_details pd
left join payment p on pd.transaction_id = p.transaction_id