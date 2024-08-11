{{
  config(
    enabled=false
    )
}}
select 
from {{ source('dotb', 'tasks') }}