
{% set columns = adapter.get_columns_in_relation(source('asana_connector', 'task')) %}
{% set assignee_id_exists= 'assignee_id' in columns | map(attribute='name') | list %}
{% set parent_task_id_exists= 'parent_task_id' in columns | map(attribute='name') | list %}

SELECT
  id AS task_id,
  name AS task_name,
  created_at,
  completed_at,
  due_date,
  notes,

  {% if parent_task_id_exists %}
    parent_task_id,
  {% else %}
    CAST(NULL AS integer) AS parent_task_id,
  {% endif %}

  {% if assignee_id_exists %}
    assignee_id
  {% else %}
    CAST(NULL AS integer) AS assignee_id
  {% endif %}

FROM
  {{source('asana_connector', 'task')}}