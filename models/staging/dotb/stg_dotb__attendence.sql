{{
  config(
    enabled=false
    )
}}

select *
from {{ source('dotb', 'attendence') }}