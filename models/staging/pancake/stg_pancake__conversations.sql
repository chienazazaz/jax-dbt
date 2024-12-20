{{
  config(
    tags=['view', 'fact','pancake']
    )
}}

SELECT
    conversations.inserted_at,
    {{dbt_utils.generate_surrogate_key(['conversation_id','customer_id'])}} as conversation_id,
    conversations.conversation_id as chat_id,
    conversations.customer_id,
    conversations.user_id,
    conversations.page_id,
    conversations.post_id,
    conversations.tag_id,
    conversations.message_count,
    conversations.snippet,
    conversations.type,
    coalesce(conversations.updated_at, conversations.inserted_at) as updated_at,
    conversations.ad_id,
    conversations.ad_inserted_at,
    conversations.ad_post_id,
    conversations.tag_histories,
    conversations.phone_number,
FROM
    {{ ref("base_pancake__conversations") }}
    conversations
