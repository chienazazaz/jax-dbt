with source as (
    SELECT
    json_value(data,'$.assigned_user_id') as assigned_user_id,
    nullif(json_value(data,'$.call_destination'),"") as call_destination,
    safe_cast(json_value(data,'$.call_duration') as float64) as call_duration,
    nullif(json_value(data,'$.call_recording'),"") as call_recording,
    nullif(json_value(data,'$.call_result'),"") as call_result,
    nullif(json_value(data,'$.call_status'),"") as call_status,
    nullif(json_value(data,'$.created_by'),"") as agent_id,
    nullif(json_value(data,'$.customer_journey_blocked_by'),"") as customer_journey_blocked_by,
    nullif(json_value(data,'$.customer_journey_points'),"") as customer_journey_points,
    nullif(json_value(data,'$.customer_journey_progress'),"") as customer_journey_progress,
    nullif(json_value(data,'$.customer_journey_score'),"") as customer_journey_score,
    timestamp(json_value(data,'$.date_end')) as date_end,
    timestamp(json_value(data,'$.date_entered')) as date_entered,
    timestamp(json_value(data,'$.date_modified')) as date_modified,
    timestamp(json_value(data,'$.date_start')) as date_start,
    nullif(json_value(data,'$.description'),"") as description,
    nullif(json_value(data,'$.direction'),"") as direction,
    safe_cast(json_value(data,'$.duration') as float64) as duration,
    json_value(data,'$.id') as call_id,
    nullif(json_value(data,'$.lead_status'),"") as lead_status,
    json_value(data,'$.modified_user_id') as modified_user_id,
    nullif(json_value(data,'$.name'),"") as call_title,
    json_value(data,'$.parent_call') as parent_call,
    json_value(data,'$.parent_id') as parent_id,
    nullif(json_value(data,'$.parent_type'),"") as parent_type,
    nullif(json_value(data,'$.phone_mobile'),"") as phone_mobile,
    timestamp(json_value(data,'$.recall_at')) as recall_at,
    safe_cast(json_value(data,'$.recall') as int64) as recall,
    json_value(data,'$.recurrence_id') as recurrence_id,
    json_value(data,'$.recurring_source') as recurring_source,
    json_value(data,'$.reminder_time') as reminder_time,
    json_value(data,'$.repeat_count') as repeat_count,
    json_value(data,'$.repeat_days') as repeat_days,
    json_value(data,'$.repeat_dow') as repeat_dow,
    json_value(data,'$.repeat_interval') as repeat_interval,
    json_value(data,'$.repeat_ordinal') as repeat_ordinal,
    json_value(data,'$.repeat_parent_id') as repeat_parent_id,
    json_value(data,'$.repeat_selector') as repeat_selector,
    json_value(data,'$.repeat_type') as repeat_type,
    json_value(data,'$.repeat_unit') as repeat_unit,
    json_value(data,'$.repeat_until') as repeat_until,
    nullif(json_value(data,'$.status'),"") as status,
    json_value(data,'$.team_id') as center_id,
    _batched_at,
FROM
    {{ source('dotb','calls') }}
    where json_value(data,'$.deleted') = '0'
)

{{
    dbt_utils.deduplicate(
        relation = 'source', 
        partition_by= 'call_id', 
        order_by='_batched_at desc'
        )
        }}
