# Asana Tasks Project

### Project Approach

This dbt project is designed to transform raw ingestion tables from an Asana connector into clean, report-ready models. The core approach is a modular, layered data pipeline built to be robust and dynamic, efficiently handling schema differences and complex transformations within a maintainable and scalable framework.

### Project Architecture

#### Layered Structure

The project follows a three-layered structure:

- **Sources**: Raw tables are explicitly defined in `sources.yml` for clear data lineage.
- **Staging**: Models in the staging layer have a dual purpose of cleaning raw data and maintaining schema consistency. Using macros, these models gracefully handle differences in the raw schema between clients to ensure the models are robust and reusable.
- **Intermediate**: This layer contains the core business logic that joins the staged models and performs aggregations to produce the final `asana_tasks` model.

#### Dynamic Modeling

The models are designed to be dynamic, allowing a single project to handle schema differences between different client data without failing. This was achieved by:

- **Resilient Staging**: Jinja macros with conditional logic check for the existence of optional source tables (e.g., `assignee`). If a table is missing, a placeholder model has been created to return `NULL` columns to guarantee a consistent schema for downstream models.
- - **Dynamic Pivoting**: A dynamic macro is used to pivot tag data, which automatically adapts to different tag categories for each client.

* **Hierarchical Data**: `LEFT JOIN`s are used in the models to gracefully handle a flat hierarchy and missing parent tasks, ensuring no rows are dropped and the model remains robust.

#### Dynamic Modeling Patterns

To handle schema differences between different datasets, I wanted to highlight two different patterns that can be used for building dynamic models:

- **Conditional Staging**: This pattern, used for an optional table like `assignee`, that captures all conditional logic within the staging layer. Each staging model checks for its raw source's existence and returns a consistent schema either from the raw table or a NULL-filled placeholder. This keeps downstream models clean and simple, as they can reliably ref() a staging model without needing to know if the underlying source exists.
- **Macro-Driven Aggregation**: For more complex, dynamic transformations, like tag pivoting, a macro is used to generate SQL on the fly. I believe this pattern is better utilized when the final column structure is unknown. The macro queries the database to find all distinct tag categories for the current client and then dynamically builds the MAX(CASE WHEN ...) expressions required to pivot the tag categories into separate columns.

#### Weekly Report Logic

The `asana_tasks_weekly` model was built using the same date spine approach seen in our original SQL interview. A calendar of weeks is generated and then joined to the `asana_tasks` model. The join condition is designed to show one row for every week a task was open, from its creation until its completion.

### Assumptions

- **Data Integrity**: I assumed that primary keys are unique and not null in the raw source tables.
- **Referential Integrity**: I assumed that foreign keys consistently link to valid primary keys.
- **Schema Consistency**: I assumed that the core tables exist for both clients, even if some of their columns or related tables are optional.
- **Tag Categories**: I assumed that a task has at most one tag per category (e.g., one "Cost Center" tag, one "Department" tag).
- **Data Types**: I assumed that date and timestamp columns are in a consistent format.
- **Week Start Day**: I assumed that a week begins on Monday, as the `DATE_TRUNC()` function defaults to this standard.
- **Source Data**: I assumed that a `NULL` value in the `completed_at` column reliably indicates a task that is still open.
