{{ config(
    materialized = 'view',
) }}

with facebook_performance as (
SELECT
    date_start,
    ad_id,
    ad_name,
    campaign_name,
    adset_name,
    account_name,
    sum(spend) as spend,
    sum(impressions) as impressions,
    sum(clicks) as clicks,
    sum(no__purchase) as purchases,
    sum(purchase__value) as purchase_value,
    sum(no__onsite_conversion__messaging_conversation_started_7d) as ad_messages
FROM
    {{ ref("stg_fb__ad_insights") }}
    {{dbt_utils.group_by(6)}}
),

conversations as (
    select 
    date(ad_inserted_at) as ad_inserted_at,
    ad_id,
    count(distinct conversation_id) as num_conversations,
    count(distinct phone_number) as num_phone_number_collected,
    from {{ ref("stg_pancake__conversations") }}
    {{dbt_utils.group_by(2)}}
)


select f.*, c.* except(ad_id, ad_inserted_at)
from facebook_performance f
left join conversations c on f.ad_id = c.ad_id and f.date_start = c.ad_inserted_at


