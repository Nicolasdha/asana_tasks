{% macro get_tag_pivot_columns() %}
  
  {% set get_categories_sql %}
    SELECT DISTINCT category FROM {{ ref('stg_asana_tag') }}
  {% endset %}
  
  {% set categories = run_query(get_categories_sql) %}

  {% set tags_list = [] %}
  {% for row in categories %}
    {% set category_name = row['category'] %}
    {% set tag_column_name = category_name.replace(' ', '_') %}
    
    {% do tags_list.append(
        "MAX(CASE WHEN t.category = '" ~ category_name ~ "' THEN t.value END) AS " ~ tag_column_name
    ) %}
  {% endfor %}
  
  {% if tags_list | length > 0 %}
    {{ tags_list | join(',\n    ') }}
  {% else %}
    {{ return('') }}
  {% endif %}

{% endmacro %}




--   SELECT
--     tt.task_id AS task_id,
--     MAX(CASE WHEN t.category = 'Cost Center' THEN t.value END) AS cost_center,
--     MAX(CASE WHEN t.category = 'Department' THEN t.value END) AS department,
--     MAX(CASE WHEN t.category = 'Location' THEN t.value END) AS location
--   FROM
--     {{ ref('stg_asana_task_tag') }}  tt
--   JOIN
--     {{ ref('stg_asana_tag') }} t ON tt.tag_id = t.tag_id
--   GROUP BY
--     tt.task_id
-- ),