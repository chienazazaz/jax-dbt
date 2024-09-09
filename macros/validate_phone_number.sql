{%- macro  validate_phone_number(phone) %}
    regexp_contains({{phone}}, r'^((84|0)[3|5|7|8|9])+([0-9]{8})\b')
{% endmacro -%}