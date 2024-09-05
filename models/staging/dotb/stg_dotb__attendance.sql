{{
  config(
    materialized = 'view',
    )
}}

with source as (
select 
  nullif(json_value(data,'$.absent_for_hour'),'') as absent_for_hour,
  json_value(data,'$.acl_team_set_id') as acl_team_set_id,
  json_value(data,'$.assigned_user_id') as assigned_user_id,
  json_value(data,'$.attendance_type') as attendance_type,
  safe_cast(json_value(data,'$.attended') as int64) as attended,
  nullif(json_value(data,'$.care_comment'),'') as care_comment,
  json_value(data,'$.check_in_by_id') as check_in_by_id,
  json_value(data,'$.check_in_id') as check_in_id,
  timestamp(json_value(data,'$.check_in_time')) as check_in_time,
  json_value(data,'$.check_out_by_id') as check_out_by_id,
  json_value(data,'$.check_out_id') as check_out_id,
  timestamp(json_value(data,'$.check_out_time')) as check_out_time,
  json_value(data,'$.class_id') as class_id,
  json_value(data,'$.created_by') as created_by,
  nullif(json_value(data,'$.customer_comment'),'') as customer_comment,
  timestamp(json_value(data,'$.date_entered')) as date_entered,
  timestamp(json_value(data,'$.date_input')) as date_input,
  timestamp(json_value(data,'$.date_modified')) as date_modified,
  timestamp(json_value(data,'$.datetime_notify_sent')) as datetime_notify_sent,
  nullif(json_value(data,'$.description'),'') as description,
  json_value(data,'$.flipped') as flipped,
  nullif(json_value(data,'$.homework'),'') as homework,
  nullif(json_value(data,'$.homework_comment'),'') as homework_comment,
  safe_cast(json_value(data,'$.homework_num') as int64) as homework_num,
  safe_cast(json_value(data,'$.homework_score') as float64) as homework_score,
  json_value(data,'$.id') as attendance_id,
  json_value(data,'$.meeting_id') as meeting_id,
  json_value(data,'$.modified_user_id') as modified_user_id,
  nullif(json_value(data,'$.name'),'') as name,
  safe_cast(json_value(data,'$.number_of_part') as int64) as number_of_part,
  safe_cast(json_value(data,'$.number_of_question') as int64) as number_of_question,
  safe_cast(json_value(data,'$.number_of_right') as int64) as number_of_right,
  safe_cast(json_value(data,'$.number_of_wrong') as int64) as number_of_wrong,
  safe_cast(json_value(data,'$.star_rating') as int64) as star_rating,
  json_value(data,'$.student_id') as student_id,
  json_value(data,'$.student_type') as student_type,
  safe_cast(json_value(data,'$.teacher_comment_num') as int64) as teacher_comment_num,
  safe_cast(json_value(data,'$.teacher_comment_num_per') as float64) as teacher_comment_num_per,
  json_value(data,'$.team_id') as center_id,
  json_value(data,'$.team_set_id') as team_set_id,
  safe_cast(json_value(data,'$.total_score') as float64) as total_score,
  safe_cast(json_value(data,'$.total_time') as float64) as total_time,
from {{ source('dotb', 'attendance') }}
  where json_value(data,'$.deleted') = '0'
)

{{
  dbt_utils.deduplicate(
    relation = 'source', 
    partition_by= 'attendance_id', 
    order_by='date_modified desc'
  )
}}