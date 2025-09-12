{% set relation = adapter.get_relation(
    database=source('asana_connector', 'project_task').database, 
    schema=source('asana_connector', 'project_task').schema, 
    identifier=source('asana_connector', 'project_task').name
) %}

{% if relation is not none %}

    -- The source table exists, so select from it
    SELECT
      project_id,
      task_id
    FROM
      {{ source('asana_connector', 'project_task') }}

{% else %}

    -- The source table does not exist, so select from the placeholder
    SELECT
      project_id,
      task_id
    FROM
      {{ ref('stg_asana_project_tasks_placeholder') }}

{% endif %}