### 1. Tags in Unity Catalog
Tags are key-value attributes (e.g., 'department' = 'sales') used to organize, categorize, and discover securable objects in Unity Catalog. They aid in data discovery, cost attribution, compliance, and governance by allowing metadata attachment without altering the data itself. Tags can be free-form or governed for enforcement. Supported securable objects include catalogs, schemas, tables, table columns, volumes, views, registered models, and model versions. Additionally, tags can apply to dashboards, Genie spaces, and Databricks apps, but not compute resources like clusters or jobs (use separate tagging for those).

**Governed Tags**: These are account-level tags with enforced policies for consistency and control. They prevent unauthorized or inconsistent usage, with rules on who can assign them, allowed values (up to 50 per tag), and where they apply. System-governed tags (predefined by Databricks, marked with a wrench icon) support standardized classification, ownership, and lifecycle tracking; they can't be edited or deleted. User-governed tags (marked with a lock icon) are custom but enforced. Max: 1,000 governed tags per account. Inheritance: Tags on catalogs/schemas propagate to child objects (except table columns). Avoid sensitive info in tags as they're stored in plain text.

For recall: Tags are like labels on files; governed tags add "rules" to ensure everyone uses them correctly.

SQL Example: Apply a tag to a table:
```sql
ALTER TABLE my_catalog.my_schema.my_table
SET TAGS ('department' = 'sales', 'sensitivity' = 'high');
```

SQL Example: Apply a governed tag (assumes tag policy exists):
```sql
ALTER TABLE my_catalog.my_schema.my_table
SET TAGS ('governed_region' = 'EMEA');  -- Enforces policy rules
```

SQL Example: View tags on an object:
```sql
SHOW TAGS ON TABLE my_catalog.my_schema.my_table;
```

SQL Example: Remove a tag:
```sql
ALTER TABLE my_catalog.my_schema.my_table
UNSET TAGS ('department');
```

SQL Example: Query tags via system tables:
```sql
SELECT * FROM system.information_schema.table_tags
WHERE table_name = 'my_table' AND schema_name = 'my_schema';
```

To manage governed tags (UI/Account Console): Admins create via Account Console > Data > Tags > Create tag, define policy (allowed values, assigners). Apply via UI in Catalog Explorer or SQL.

### 2. Policies in Unity Catalog
Policies in Unity Catalog refer to centralized rules for attribute-based access control (ABAC), specifically row filter policies and column mask policies. These enforce dynamic data access based on governed tags, user attributes, and data properties. Policies are hierarchical (catalog > schema > table) with inheritance: Higher-level policies auto-apply to children, reducing redundancy. Types: Row filter (hide rows) and column mask (redact/transform columns). Quotas: 10 per catalog/schema, 5 per table. Policies use UDFs for logic and apply to specified principals (users/groups), with exclusions possible.

For recall: Policies are "rulesets" attached to objects; they use tags to decide what data to show/hide dynamically.

Prerequisites: DBR 16.4+, UDF with EXECUTE privilege, MANAGE on object.

UI Example: Create policy (Catalog Explorer):
1. Go to Catalog > Select object > Policies tab > New policy.
2. Name/describe, select principals (TO/EXCEPT), scope (catalog/schemas/tables).
3. Choose purpose: Mask columns or Hide rows.
4. Define conditions (e.g., match tags) and UDF parameters.
5. Create.

SQL Example: Create row filter policy:
```sql
CREATE OR REPLACE POLICY region_filter_policy
ON TABLE my_catalog.my_schema.customer_data
ROW FILTER my_catalog.my_schema.filter_by_region  -- UDF for filtering
TO `account users`  -- Applies to these principals
FOR TABLES
MATCH COLUMNS hasTagValue('region', 'EMEA') AS region_cols  -- Condition on tags
USING COLUMNS (region_cols);  -- Columns to filter
```

SQL Example: Create column mask policy:
```sql
CREATE OR REPLACE POLICY pii_mask_policy
ON TABLE my_catalog.my_schema.employee_data
COLUMN MASK my_catalog.my_schema.mask_pii  -- UDF for masking
TO `analysts` EXCEPT `admins`  -- Applies to analysts, excludes admins
FOR TABLES
MATCH COLUMNS hasTagValue('sensitivity', 'high') AS pii_cols
USING COLUMNS (pii_cols);
```

To edit: Use CREATE OR REPLACE POLICY with changes.

SQL Example: Drop policy:
```sql
DROP POLICY region_filter_policy;
```

Troubleshooting: Errors if multiple filters/masks resolve (e.g., INVALID_PARAMETER_VALUE.UC_ABAC_MULTIPLE_ROW_FILTERS); refine MATCH COLUMNS or tags.

### 3. ABAC (Attribute-Based Access Control) in Unity Catalog
ABAC is a flexible, scalable governance model in Unity Catalog that complements static privileges with dynamic access based on attributes (e.g., tags, user roles, environment). It uses governed tags on data assets to trigger policies for row filtering or column masking. Key: Centralized – define once, apply everywhere; inheritance ensures consistency. Benefits: Simplifies least-privilege access, secures sensitive data (e.g., PII), audits via logs, scales without per-asset rules. Components: Governed tags (attributes), Policies (rules at catalog/schema/table), UDFs (custom logic for filter/mask).

How it works: User queries tagged asset → Unity Catalog evaluates tags → Applies matching policies → Enforces UDF-based filter/mask dynamically. Inheritance: Catalog policy applies to all schemas/tables below.

For recall: ABAC is "smart security" – access depends on "who, what, where" attributes, not just roles.

Prerequisites: Public Preview (as of 2026), DBR 16.4+/serverless.

Example: Row filter UDF:
```sql
CREATE FUNCTION filter_by_region(region STRING)
RETURNS BOOLEAN
RETURN region = 'EMEA' OR is_account_group_member('global_admins');  -- Logic: Show EMEA or to admins
```

Then attach via policy (see Section 2).

Example: Column mask UDF:
```sql
CREATE FUNCTION mask_phone(phone STRING)
RETURNS STRING
RETURN CASE
  WHEN hasTagValue('sensitivity', 'low') OR is_account_group_member('compliance') THEN phone
  ELSE 'XXX-XXX-XXXX'
END;
```

Limitations: No views, no time travel/cloning (unless excluded), max 3 column conditions per policy, errors on multiple masks/filters.

To manage: Use UI for policies (Catalog > Policies tab), SQL for UDFs/policies.

### 4. Data Masking in Unity Catalog
Data masking hides or transforms sensitive column values (e.g., redact PII like emails/SSNs) based on user identity, preventing unauthorized exposure while allowing queries. Implemented via column masks (UDFs that return masked values). Can use ABAC for centralized/tag-based application or manual per-table. vs. Row filters (hide rows entirely). Best for columns like credit cards, emails. Use simple CASE logic for performance; avoid mapping tables/subqueries. Each column: 1 mask max. Supports nested STRUCTs.

For recall: Masking is "blurring" sensitive data; use UDFs to decide what to show (e.g., full to admins, redacted to others).

Prerequisites: Unity Catalog-enabled, DBR 12.2 LTS+, UDF with EXECUTE.

SQL Example: Basic column mask UDF and application:
```sql
CREATE FUNCTION ssn_mask(ssn STRING)
RETURNS STRING
RETURN CASE WHEN is_account_group_member('hr') THEN ssn ELSE '***-**-****' END;

CREATE TABLE employees (id INT, ssn STRING MASK ssn_mask);
-- Or on existing: ALTER TABLE employees ALTER COLUMN ssn SET MASK ssn_mask;
```

SQL Example: Mask with additional columns (USING COLUMNS):
```sql
CREATE FUNCTION mask_address(address STRING, country STRING)
RETURNS STRING
RETURN CASE WHEN is_account_group_member(country || '_viewers') THEN address ELSE 'REDACTED' END;

ALTER TABLE customers ALTER COLUMN address SET MASK mask_address USING COLUMNS (country);
```

SQL Example: Python-wrapped mask (for complex logic):
```sql
CREATE FUNCTION email_mask_py(email STRING) RETURNS STRING LANGUAGE PYTHON AS $$
import re
return re.sub(r'^[^@]+', lambda m: '*' * len(m.group()), email)
$$;

CREATE FUNCTION email_mask_sql(email STRING) RETURNS STRING RETURN email_mask_py(email);  -- Wrapper

CREATE TABLE contacts (email STRING MASK email_mask_sql);
```

SQL Example: Nested STRUCT mask:
```sql
CREATE FUNCTION mask_nested(data STRUCT<value: STRING, secret: STRING>)
RETURNS STRUCT<value: STRING, secret: STRING>
RETURN CASE WHEN is_account_group_member('privileged') THEN data
  ELSE NAMED_STRUCT('value', data.value, 'secret', 'REDACTED')
END;

CREATE TABLE data (nested STRUCT<value: STRING, secret: STRING> MASK mask_nested);
```

SQL Example: Remove mask:
```sql
ALTER TABLE employees ALTER COLUMN ssn DROP MASK;
```

Best Practices: Use ABAC for scale; simple UDFs (CASE over subqueries); test performance; deterministic logic.

Limitations: No views/Iceberg; no time travel/cloning; MERGE restrictions on older DBR; no vector search indexes.