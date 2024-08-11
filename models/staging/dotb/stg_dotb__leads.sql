{# {{config(
  enabled = false
)}} #}

with source_leads as (
  SELECT
  json_value(t.data, '$.assigned_user_id') AS assigned_user_id,
  date(json_value(t.data, '$.birthdate')) AS dob,
  json_value(t.data, '$.channel') AS channel,
  json_value(t.data, '$.contact_id') AS contact_id,
  json_value(t.data, '$.converted') AS converted,
  json_value(t.data, '$.created_by') AS created_by,
  TIMESTAMP(json_value(t.data, '$.date_entered')) AS created_at,
  TIMESTAMP(json_value(t.data, '$.date_modified')) AS updated_at,
  json_value(t.data, '$.date_performed') AS last_handover_date,
  json_value(t.data, '$.description') AS description,
  TIMESTAMP(json_value(t.data, '$.dp_consent_last_updated')) AS dp_consent_last_updated,
  json_value(t.data, '$.eng_level') AS eng_level,
  date(json_value(t.data, '$.first_call_date')) AS first_call_date,
  json_value(t.data, '$.first_call_result') AS first_call_result,
  json_value(t.data, '$.full_lead_name') AS full_lead_name,
  json_value(t.data, '$.first_name') AS first_name,
  json_value(t.data, '$.last_name') AS last_name,
  json_value(t.data, '$.gender') as gender,
  json_value(t.data, '$.guardian_name') AS guardian_name,
  json_value(t.data, '$.id') AS lead_id,
  json_value(t.data, '$.last_call_date') AS last_call_date,
  json_value(t.data, '$.last_call_result') AS last_call_result,
  json_value(t.data, '$.last_call_status') AS last_call_status,
  json_value(t.data, '$.last_pt_date') AS last_pt_date,
  json_value(t.data, '$.last_pt_status') AS last_pt_status,
  json_value(t.data, '$.lead_source') AS lead_source,
  json_value(t.data, '$.modified_user_id') AS modified_user_id,
  json_value(t.data, '$.object') AS lead_segment_group,
  json_value(t.data, '$.other_mobile') AS other_mobile,
  json_value(t.data, '$.performed_user_id') AS last_handover_user_id,
  json_value(t.data, '$.phone_guardian') AS phone_guardian,
  json_value(t.data, '$.phone_mobile') AS phone_mobile,
  json_value(t.data, '$.potential') AS potential,
  json_value(t.data, '$.prefer_level') AS prefer_level,
  json_value(t.data, '$.primary_address_city') AS primary_address_city,
  json_value(t.data, '$.primary_address_country') AS primary_address_country,
  json_value(t.data, '$.primary_address_state') AS primary_address_state,
  json_value(t.data, '$.primary_address_street') AS primary_address_street,
  json_value(t.data, '$.school_id') AS school_id,
  json_value(t.data, '$.source_description') AS source_description,
  json_value(t.data, '$.status') AS status,
  json_value(t.data, '$.target') AS target,
  json_value(t.data, '$.team_id') AS center_id,
  json_value(t.data, '$.utm_agent_id') AS utm_agent_id,
  json_value(t.data, '$.utm_content') AS utm_content,
  json_value(t.data, '$.utm_medium') AS utm_medium,
  json_value(t.data, '$.utm_source') AS utm_source,

FROM
    {{ source('dotb','leads') }} t
where 1=1 
and json_value(t.data, '$.deleted') = '0'
)

{{dbt_utils.deduplicate(
    relation = 'source_leads', 
    partition_by= 'lead_id', 
    order_by='updated_at desc'
    ) }}