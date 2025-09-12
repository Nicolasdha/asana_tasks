{% set relation = adapter.get_relation(
    database=source('asana_connector', 'assignee').database, 
    schema=source('asana_connector', 'assignee').schema, 
    identifier=source('asana_connector', 'assignee').name
) %}


{% if relation is not none %}

SELECT
  id AS assignee_id,
  first_name,
  last_name
FROM
  {{source('asana_connector', 'assignee')}}

{% else %}

SELECT
  assignee_id,
  first_name,
  last_name
FROM
  {{ ref('stg_asana_assignees_placeholder') }}
{%endif%}