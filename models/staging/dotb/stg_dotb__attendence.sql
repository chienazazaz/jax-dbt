select *
from {{ source('dotb', 'attendence') }}