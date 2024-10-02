SELECT
    customer_id AS account_id,
    customer_descriptive_name AS account_name,
    customer_currency_code AS currency_code,
    customer_manager AS is_manager_account
FROM
    {{ source(
        'googleads',
        'customer'
    ) }}
qualify row_number() over (partition by customer_id order by _data_date desc) = 1