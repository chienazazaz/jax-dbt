WITH date_spine AS (
    {{ dbt_utils.date_spine(
        start_date = "cast('2021-01-01' as Date)",
        datepart = "day",
        end_date = "date_add( current_date() , interval 6 month)"
    ) }}
),
calendar AS (
    SELECT
        DISTINCT DATE(date_day) AS DATE,
        EXTRACT(DAY FROM date_day) AS day_of_month,
        format_date('%A',date_day) AS day_name,
        DATE_TRUNC(DATE(date_day), MONTH) AS start_of_month,
        LAST_DAY(date_day,MONTH) AS end_of_month,
        DATE_TRUNC(DATE(date_day), isoweek) AS start_of_week,
        LAST_DAY(DATE(date_day), isoweek) AS end_of_week,
        format_date('%B',date_day) AS month_name,
        format_date('%Y.%m',date_day) AS year_month,
        format_date('%YQ%Q',date_day) AS year_quarter,
        EXTRACT(YEAR FROM date_day) AS YEAR,
        EXTRACT(MONTH FROM date_day) AS MONTH,
        format_date('%m.%d',date_day) AS month_day,
        format_date('%u',date_day) AS day_of_week,
    FROM
        date_spine
),
calendar_fmt AS (
    SELECT
        *,
        "Tuần " || DENSE_RANK() over (
            PARTITION BY start_of_month
            ORDER BY
                GREATEST(
                    start_of_month,
                    start_of_week
                ) ASC
        ) || ' (' || format_date("%d/%m", GREATEST(start_of_month, start_of_week)) || ' - ' || format_date("%d/%m", LEAST(end_of_week, end_of_month)) || ')' AS period,
        format_date(
            "%Y.%mT",
            DATE
        ) || DENSE_RANK() over (
            PARTITION BY start_of_month
            ORDER BY
                GREATEST(
                    start_of_month,
                    start_of_week
                ) ASC
        ) AS period_code
    FROM
        calendar
)
SELECT
    DISTINCT d.*
FROM
    calendar_fmt d
