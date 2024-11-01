{{ config(
    materialized='view',
    tags = ['ggads','fact','view']
) }}

WITH ad_group_stats AS (

    SELECT
        ad_group_id,
        campaign_id,
        account_id,
        DATE,
        SUM(clicks) clicks,
        SUM(conversions) conversions,
        SUM(conversions_value) conversions_value,
        SUM(cost) cost,
        SUM(impressions) impressions,
        SUM(interactions) interactions,
        SUM(view_through_conversions) view_through_conversions,
    FROM
        {{ ref('stg_googleads__ad_group_stats') }}
    GROUP BY
        1,
        2,
        3,4
)
select *,
cast(null as string) network_type,
    cast(null as float64) top_impression_percentage,
    cast(null as float64) search_top_impression_share,
    cast(null as float64) video_quartile_p100_rate,
    cast(null as float64) video_quartile_p75_rate,
    cast(null as float64) video_quartile_p50_rate,
    cast(null as float64) video_quartile_p25_rate,
    cast(null as float64) absolute_top_impression_percentage,
    cast(null as float64) content_impression_share,
    cast(null as float64) content_rank_lost_impression_share,
    cast(null as float64) cross_device_conversions,
    cast(null as float64) engagements,
    cast(null as float64) relative_ctr,
    cast(null as float64) search_absolute_top_impression_share,
    cast(null as float64) search_budget_lost_absolute_top_impression_share,
    cast(null as float64) search_budget_lost_top_impression_share,
    cast(null as float64) search_impression_share,
    cast(null as float64) search_rank_lost_absolute_top_impression_share,
    cast(null as float64) search_rank_lost_impression_share,
    cast(null as float64) search_rank_lost_top_impression_share,
    cast(null as float64) video_views,
from ad_group_stats