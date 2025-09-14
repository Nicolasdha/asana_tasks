SELECT
  task_id
FROM
  {{ ref('asana_tasks_weekly') }}
WHERE
  completed_at_date IS NOT NULL
  AND completed_at_date < week