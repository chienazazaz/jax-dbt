with students as (
    select
        json_value(c.data,'$.assigned_user_id') as assigned_user_id,
        date(json_value(c.data,'$.birthdate')) as dob,
        json_value(c.data,'$.campaign_id') as campaign_id,
        json_value(c.data,'$.channel') as channel,
        json_value(c.data,'$.contact_id') as contact_id,
        json_value(c.data,'$.count_payment') as count_payment,
        timestamp(json_value(c.data,'$.date_entered')) as created_at,
        date(json_value(c.data,'$.date_issue')) as date_issue,
        timestamp(json_value(c.data,'$.date_modified')) as updated_at,
        date(json_value(c.data,'$.date_performed')) as last_handover_date,
        json_value(c.data,'$.enrolled_amount') as enrolled_amount,
        json_value(c.data,'$.enrolled_hours') as enrolled_hours,
        nullif(json_value(c.data,'$.gender'),'') as gender,
        json_value(c.data,'$.grade') as grade,
        json_value(c.data,'$.id') as student_id,
        json_value(c.data,'$.is_converted_from_lead') as is_converted_from_lead,
        date(json_value(c.data,'$.last_call_date')) as last_call_date,
        json_value(c.data,'$.last_call_result') as last_call_result,
        json_value(c.data,'$.last_name') as last_name,
        json_value(c.data,'$.first_name') as first_name,
        json_value(c.data,'$.full_student_name') as full_student_name,
        json_value(c.data,'$.lead_source') as lead_source,
        nullif(json_value(c.data,'$.lms_user_name'),'') as email,
        json_value(c.data,'$.member_card') as member_card,
        json_value(c.data,'$.old_student_id') as old_student_id,
        json_value(c.data,'$.ost_hours') as ost_hours,
        json_value(c.data,'$.paid_amount') as paid_amount,
        json_value(c.data,'$.payment_process') as payment_process,
        json_value(c.data,'$.performed_user_id') as last_handover_user_id,
        json_value(c.data,'$.phone_guardian') as phone_guardian,
        regexp_replace(regexp_replace(json_value(c.data,'$.phone_mobile'), r'[\+\-\s]', ''),r'^84','0') as phone_mobile,
        json_value(c.data,'$.portal_active') as portal_status,
        json_value(c.data,'$.portal_name') as portal_username,
        json_value(c.data,'$.potential') as potential,
        json_value(c.data,'$.primary_address_city') as city,
        json_value(c.data,'$.primary_address_country') as country,
        json_value(c.data,'$.primary_address_state') as state,
        json_value(c.data,'$.primary_address_street') as street_address,
        json_value(c.data,'$.remain_amount') as remain_amount,
        json_value(c.data,'$.remain_carry') as remain_carry,
        json_value(c.data,'$.source_description') as source_description,
        json_value(c.data,'$.status') as status,
        json_value(c.data,'$.team_id') as center_id,
        json_value(c.data,'$.total_ost_hours') as total_ost_hours,
        json_value(c.data,'$.unpaid_amount') as unpaid_amount,
        json_value(c.data,'$.utm_agent_id') as utm_agent_id,
        json_value(c.data,'$.utm_content') as utm_content,
        json_value(c.data,'$.utm_medium') as utm_medium,
        json_value(c.data,'$.utm_source') as utm_source,
        json_value(c.data,'$.utm_term') as utm_term,
        json_value(c.data,'$.voucher_id') as voucher_id,
    from {{ source('dotb', 'contacts') }} c
        where json_value(c.data,'$.deleted') = '0'
        ),

    deduplicate as (
            {{
                dbt_utils.deduplicate(
                    relation = 'students', 
                    partition_by= 'student_id', 
                    order_by='updated_at desc'
                )
            }}
        )
        
    select 
        *
    from deduplicate
        where {{validate_phone_number('phone_mobile')}}