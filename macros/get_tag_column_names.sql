{% macro get_tag_column_names() %}
  
  {% set get_categories_sql %}
    SELECT DISTINCT category FROM {{ ref('stg_asana_tag') }}
  {% endset %}

  {% set categories = run_query(get_categories_sql) %}

  {% set tag_columns = [] %}
  {% for row in categories %}
    {% set category_name = row['category'] %}
    {% do tag_columns.append(category_name.replace(' ', '_')) %}
  {% endfor %}

  {% if tag_columns | length > 0 %}
    {{ return(tag_columns | join(', ')) }}
  {% else %}
    {{ return("NULL") }}
  {% endif %}
{% endmacro %}