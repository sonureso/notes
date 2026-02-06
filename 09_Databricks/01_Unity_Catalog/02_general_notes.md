### 1. What is Unity Catalog?
Unity Catalog is Databricks' unified governance solution for managing data and AI assets across workspaces, clouds, and regions. It acts as a centralized catalog that provides fine-grained access control, auditing, data lineage, quality monitoring, and discovery for tables, views, volumes, functions, models, and more. Unlike the legacy Hive Metastore, Unity Catalog is built on open standards and supports multi-cloud environments, ensuring data is governed consistently. It's essential for building a secure lakehouse architecture.

Key benefits include:
- Centralized governance: Define policies once and apply them everywhere.
- Discovery: Search and tag data assets.
- Auditing: Track access and changes.
- Integration: Works seamlessly with Delta Lake, MLflow, and Delta Sharing.

For long-term recall: Think of Unity Catalog as the "control center" for your data ecosystem, replacing siloed metastore management with a scalable, secure layer.

### 2. Overview and Key Features
Unity Catalog's core features revolve around governance, security, and usability:
- **Unified Access Policies**: Secure data across workspaces with ANSI SQL-compliant permissions.
- **Auditing and Lineage**: Built-in tracking of data origins and usage.
- **Data Discovery**: Tagging, search, and system tables for querying metadata.
- **Three-Level Namespace**: Organizes assets as catalog.schema.object (e.g., tables, models).
- **Managed and External Storage**: Supports fully governed (managed) or externally managed data.
- **Integrations**: With Delta Lake for ACID transactions, MLflow for models, and Delta Sharing for cross-organization sharing.
- **System Tables**: Query operational data like audits or lineage (e.g., `SYSTEM.INFORMATION_SCHEMA.TABLES`).

Example: To query system tables for all tables in a catalog (SQL):
```sql
SELECT * FROM system.information_schema.tables WHERE catalog_name = 'my_catalog';
```
This helps in discovering assets without manual exploration.

### 3. Metastore
The metastore is the top-level container for metadata in Unity Catalog. It's a logical boundary (one per region) that holds catalogs, schemas, and objects. Unlike Hive, it's multi-tenant and not a service boundary. It manages storage isolation and is required to enable Unity Catalog in workspaces.

Key points:
- Created per region for data residency.
- Attach workspaces to it for access.
- Optional managed storage at metastore level (e.g., S3 bucket for AWS).

For recall: The metastore is like the "root folder" for all your governed data in a region.

### 4. The Unity Catalog Object Model
Unity Catalog uses a hierarchical three-level namespace: catalog > schema (database) > object. This organizes data logically (e.g., by team, environment, or project).

#### 4.1 Catalogs
Catalogs are top-level organizers, often for environments (dev/prod) or departments. They can be standard or shared (via Delta Sharing).

Requirements: `CREATE CATALOG` privilege on the metastore.

SQL Example: Create a standard catalog:
```sql
CREATE CATALOG IF NOT EXISTS customer_cat
COMMENT 'Catalog for customer data';
MANAGED LOCATION 's3://bucket/path/';  -- Optional managed storage
```

SQL Example: Create a shared catalog:
```sql
CREATE CATALOG IF NOT EXISTS shared_cat USING SHARE provider.share_name;
```

To manage: Use `ALTER CATALOG` to change properties or `DROP CATALOG` to delete.

#### 4.2 Schemas (Databases)
Schemas group related objects within a catalog (e.g., by use case). Synonyms: SCHEMA or DATABASE.

Requirements: `USE CATALOG` on parent catalog, `CREATE SCHEMA` on catalog.

SQL Example: Create a schema:
```sql
CREATE SCHEMA IF NOT EXISTS my_catalog.my_schema
COMMENT 'Schema for analytics'
MANAGED LOCATION 's3://bucket/schema-path/'
WITH PROPERTIES ('key' = 'value');
```

To use: `USE SCHEMA my_catalog.my_schema;`

#### 4.3 Tables
Tables store structured data. Two types:
- **Managed Tables**: Fully governed by Unity Catalog; data stored in managed locations; uses Delta format; lifecycle (create/drop) handled by Databricks.
- **External Tables**: Metadata governed by Unity Catalog; data stored externally; supports formats like Delta, CSV, JSON; useful for existing data.

Requirements: `CREATE TABLE` on schema, `USE SCHEMA` and `USE CATALOG`.

SQL Example: Create a managed table:
```sql
CREATE TABLE my_catalog.my_schema.my_managed_table (
  id INT,
  name STRING
)
USING DELTA;  -- Default for managed
```

SQL Example: Create an external table:
```sql
CREATE EXTERNAL TABLE my_catalog.my_schema.my_external_table (
  col1 INT,
  col2 STRING
)
USING CSV
OPTIONS (header 'true', inferSchema 'true')
LOCATION 's3://bucket/path/';
```

To alter: `ALTER TABLE my_table ADD COLUMN new_col STRING;`

#### 4.4 Views
Views are saved queries, virtual tables for abstraction or security. Dynamic views add row/column-level security using functions like `is_account_group_member()` or `CURRENT_RECIPIENT()`.

Requirements: `CREATE VIEW` on schema.

SQL Example: Standard view:
```sql
CREATE VIEW my_catalog.my_schema.sales_redacted AS
SELECT user_id, country FROM my_table WHERE product = 'widget';
```

SQL Example: Dynamic view for column masking:
```sql
CREATE VIEW my_catalog.my_schema.sales_redacted AS
SELECT 
  user_id,
  CASE WHEN is_account_group_member('auditors') THEN email ELSE 'REDACTED' END AS email
FROM sales_raw;
```

#### 4.5 Volumes
Volumes manage non-tabular data (files like JSON, images). Managed: Stored in Unity Catalog; External: Governed but stored externally.

Use cases: ETL staging, logs, ML datasets.

SQL Example: Managed volume:
```sql
CREATE VOLUME my_catalog.my_schema.my_managed_volume;
```

SQL Example: External volume:
```sql
CREATE EXTERNAL VOLUME my_catalog.my_schema.my_external_volume
LOCATION 's3://bucket/path/';
```

Access: Use paths like `/Volumes/my_catalog/my_schema/my_volume/file.txt`.

#### 4.6 Functions (UDFs)
User-defined functions (UDFs) for custom logic in SQL or Python.

Requirements: DBR 13.3+ for Python UDFs.

SQL Example: SQL UDF:
```sql
CREATE FUNCTION my_catalog.my_schema.calculate_bmi(weight DOUBLE, height DOUBLE)
RETURNS DOUBLE
RETURN weight / (height * height);
```

Python UDF Example:
```sql
CREATE FUNCTION my_catalog.my_schema.greet(name STRING)
RETURNS STRING
LANGUAGE PYTHON
AS $$
  return f"Hello, {name}!"
$$;
```

#### 4.7 Models
Models are ML models registered via MLflow, treated as functions for inference.

Requirements: MLflow integration.

Python Example: Register a model:
```python
import mlflow
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import load_iris

iris = load_iris()
X, y = iris.data, iris.target
clf = RandomForestClassifier()
clf.fit(X, y)

with mlflow.start_run():
    mlflow.sklearn.log_model(clf, "model")
    model_uri = mlflow.get_artifact_uri("model")
    mlflow.register_model(model_uri, "my_catalog.my_schema.iris_model")
```

SQL Inference: `SELECT my_catalog.my_schema.iris_model(features) FROM data;`

### 5. Securable Objects for External Data Sources
These manage access to external storage and services.

#### 5.1 Storage Credentials
Encapsulate credentials (e.g., IAM roles).

SQL Example:
```sql
CREATE STORAGE CREDENTIAL my_cred
IAM_ROLE 'arn:aws:iam::123:role/my-role';
```

#### 5.2 External Locations
Link paths to credentials for external data.

SQL Example:
```sql
CREATE EXTERNAL LOCATION my_loc
URL 's3://bucket/path/'
WITH (STORAGE CREDENTIAL my_cred);
```

#### 5.3 Connections and Service Credentials
For external databases (e.g., Lakehouse Federation) or services. Similar syntax to storage credentials.

### 6. Securable Objects for Shared Assets
Enable sharing across boundaries.

#### 6.1 Clean Rooms
Managed collaboration spaces without data movement.

#### 6.2 Shares, Recipients, Providers (Delta Sharing)
Shares are collections of assets for sharing. Use Databricks-to-Databricks or open sharing.

Steps:
1. Provider creates share.
2. Adds assets (tables, views, volumes).
3. Shares with recipient's metastore ID.

SQL Example: Create share and add table:
```sql
CREATE SHARE my_share;
ALTER SHARE my_share ADD TABLE my_catalog.my_schema.my_table
PARTITION (year = 2023);
```

Recipient: Create catalog from share:
```sql
CREATE CATALOG IF NOT EXISTS received_cat USING SHARE provider.my_share;
```

For incremental (CDF): Enable `delta.enableChangeDataFeed = true` on table, then merge changes.

### 7. Admin Roles
- **Account Admins**: Manage metastores, users, privileges.
- **Metastore Admins**: Optional; manage storage at metastore level.
- **Workspace Admins**: Handle workspace objects; can have metastore access.

Default: Least privilege; users start with access to workspace catalog only.

### 8. Granting and Revoking Access
Use ANSI SQL for privileges (e.g., SELECT, CREATE, USE). Inheritance: Parent privileges apply to children.

Privileges: ALL PRIVILEGES, SELECT, MODIFY, CREATE TABLE, etc.

SQL Example: Grant:
```sql
GRANT SELECT, INSERT ON TABLE my_table TO `data-team`;
GRANT USE CATALOG, CREATE SCHEMA ON CATALOG my_catalog TO `analysts`;
```

SQL Example: Revoke:
```sql
REVOKE SELECT ON TABLE my_table FROM `data-team`;
REVOKE ALL PRIVILEGES ON SCHEMA my_schema FROM `user`;
```

To show grants: `SHOW GRANTS ON TABLE my_table;`

Ownership: `ALTER TABLE my_table OWNER TO `group`;`

### 9. Working with Database Objects
Use SQL for CRUD on objects. UI: Catalog Explorer for visual management.

Example: List schemas: `SHOW SCHEMAS IN my_catalog;`

Query: `SELECT * FROM my_catalog.my_schema.my_table;`

### 10. Managed vs. External Tables and Volumes
- **Managed**: Databricks handles storage, optimization (auto-compact), deletion. Best for governance/performance.
- **External**: Flexible for legacy data; risk of bypass if not secured.

Transition: Create managed from external via CTAS: `CREATE TABLE managed AS SELECT * FROM external;`

### 11. Cloud Storage and Data Isolation
Use external locations for access. Hierarchy: Schema > Catalog > Metastore for managed storage.

Isolation: Bind catalogs to workspaces (e.g., dev/prod separation).

Avoid direct bucket access; use Unity Catalog paths.

### 12. Setup and Configuration
Steps:
1. Create storage (e.g., S3 bucket/Azure container).
2. Create IAM role/managed identity for access.
3. In Databricks Account Console: Catalog > Create Metastore > Enter name, region, storage.
4. Assign workspaces: Select metastore > Assign to workspaces.
5. Post-setup: Create catalogs/schemas, grant access.

Auto-assignment: Enable for new workspaces.

Terraform example (for advanced):
```hcl
resource "databricks_metastore" "my_metastore" {
  name   = "my-metastore"
  region = "us-west-2"
}
```

### 13. Upgrading to Unity Catalog
Migrate from Hive: Create external tables over existing data, then transition to managed. Use migration tools or SQL to copy.

Steps: Enable metastore, attach workspace, sync metadata.

### 14. Requirements and Restrictions
- Regions: All supported.
- Compute: DBR 11.3 LTS+; SQL warehouses default-enabled.
- Formats: Managed = Delta; External = Delta, CSV, etc.
- Naming: Lowercase, no specials; max 255 chars.
- Limits: No workspace groups in GRANTs; quotas on objects.
- Quotas: Monitor via API.

### 15. Best Practices
From docs:
- **Organization**: Use catalogs for isolation (e.g., per env/team); schemas per use case. Avoid path overlaps.
- **Security**: Use groups for grants/ownership; least privilege (e.g., BROWSE for discovery). Service principals for prod jobs. No direct external access.
- **Performance**: Prefer managed tables for optimizations. Use Delta Sharing for cross-region. Enable file events on locations.
- **Sharing**: Use dynamic views in shares for fine-grained control.
- Tip: Grant BROWSE on catalogs to all users for self-service requests.

Example: Team isolation:
```sql
CREATE SCHEMA my_catalog.team_schema;
GRANT USE SCHEMA, CREATE TABLE ON SCHEMA my_catalog.team_schema TO `team-group`;
```