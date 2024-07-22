select
-- database information
id as student_id,
date_entered as created_at,
date_modified as updated_at,
deleted,

--student information

last_name ||' '||first_name as full_name,
phone_mobile,
gender,
birthdate as dob,
grade,
primary_address_street as street_address,
primary_address_city as city,
primary_address_state as state,
primary_address_country as country,
portal_name as portal_username,
portal_active as portal_status,
phone_guardian,

-- center information
assigned_user_id,
team_id as center_id,

-- accquisition information
campaign_id,
contact_id,
potential,
lead_source,
source_description,
old_student_id,
utm_source,
utm_medium,
utm_content,
utm_term,
utm_agent_id,
channel,
is_converted_from_lead,

-- other information
status,
voucher_id,
member_card,
date_performed as last_handover_date,
performed_user_id as last_handover_user_id,
last_call_date,
last_call_result,

-- payment information
remain_amount,
paid_amount,
unpaid_amount,
date_issue,
count_payment,
ost_hours,
enrolled_hours,
enrolled_amount,
remain_carry,
total_ost_hours,
payment_process,

from {{ source('dotb', 'contacts') }} c
where deleted = 0
and date_entered >='2023-01-01'