## Table of Contents

- [Data Warehouse, Data Lake, and Data Lakehouse](#data-warehouse-data-lake-and-data-lakehouse--comprehensive-notes-as-of-2026)
   - [1. Data Warehouse](#1-data-warehouse)
   - [2. Data Lake](#2-data-lake)
   - [3. Data Lakehouse](#3-data-lakehouse)
   - [Quick Comparison Table](#quick-comparison-table-2026-perspective)

### Data Warehouse, Data Lake, and Data Lakehouse – Comprehensive Notes (as of 2026)

These three architectures represent the evolution of enterprise data management.  
- **Data Warehouse** → Traditional structured analytics (1990s–2010s dominant).  
- **Data Lake** → Big data flexibility for raw data (2010s rise).  
- **Data Lakehouse** → Modern unified platform (2020s standard, combining best of both).

#### 1. Data Warehouse
A **data warehouse** is a centralized relational database optimized for **analytical querying** (OLAP – Online Analytical Processing) on **structured, cleaned, and processed data**. It follows **schema-on-write** (data is structured before loading) and is designed for high-performance BI reporting, dashboards, and business decision support.

**Key Characteristics**
- Data is highly structured (tables, rows, columns).
- ETL/ELT processes clean and transform data before storage.
- ACID transactions, strong consistency, indexing, columnar storage for fast SQL queries.
- Expensive storage (optimized compute + proprietary formats).
- High concurrency for many users running reports simultaneously.

**Typical Use Cases**
- Executive dashboards, financial reporting, sales forecasting.
- BI tools like Tableau, Power BI connecting via SQL.

**Popular Examples (2026)**
- Snowflake (cloud-native, separated compute/storage).
- Amazon Redshift.
- Google BigQuery.
- Azure Synapse Analytics (dedicated SQL pools).

**Simple Example Workflow**
1. Source systems (CRM, ERP) → ETL job cleans/transforms data.
2. Load into warehouse tables (star/snowflake schema).
3. Business users query:  
   ```sql
   SELECT 
     region, 
     SUM(sales_amount) AS total_sales
   FROM fact_sales
   JOIN dim_date ON fact_sales.date_id = dim_date.date_id
   WHERE year = 2025
   GROUP BY region;
   ```
   → Fast sub-second response for aggregated reporting.

**Pros & Cons**
- Pros: Excellent query performance, strong governance, mature BI ecosystem.
- Cons: High cost for storage, limited to structured data, slow/expensive for ML or raw data exploration, data duplication common.

#### 2. Data Lake
A **data lake** is a centralized repository that stores **vast amounts of raw data** in its native format (structured, semi-structured, unstructured) at low cost using object storage. It follows **schema-on-read** (structure applied only when reading/querying data).

**Key Characteristics**
- Stores anything: JSON logs, CSV files, images, videos, Parquet, Avro.
- Cheap, scalable storage (S3, ADLS, GCS).
- No enforced schema at ingest → high flexibility.
- Often becomes a "data swamp" without governance (poor quality, no ACID, hard to trust).
- Best for data science, ML, streaming, exploratory analysis.

**Typical Use Cases**
- Storing raw IoT sensor data, web logs, social media feeds.
- Training ML models on large unstructured datasets.
- Ingest once, analyze many ways (batch + streaming).

**Popular Examples (2026)**
- AWS S3 + Lake Formation / Athena.
- Azure Data Lake Storage Gen2 + Synapse Spark.
- Google Cloud Storage + BigQuery external tables.
- Hadoop HDFS (legacy).

**Simple Example Workflow**
1. Ingest raw files directly: logs/, images/, json_events/.
2. Use Spark or Presto/Trino to query on-demand:  
   ```python
   # PySpark example
   df = spark.read.json("s3://my-lake/raw/events/*.json")
   df_filtered = df.filter("event_type = 'purchase' AND year(event_time) = 2025")
   df_filtered.groupBy("user_country").count().show()
   ```
   → Explore raw data quickly without pre-processing.

**Pros & Cons**
- Pros: Low-cost storage, handles any data type, supports ML/AI natively.
- Cons: Governance challenges, poor performance for BI, no transactions (risk of corruption), "swamp" risk.

#### 3. Data Lakehouse
A **data lakehouse** is a modern hybrid architecture that combines:
- Low-cost, scalable object storage + open formats of a **data lake**.
- ACID transactions, schema enforcement, governance, and high-performance analytics of a **data warehouse**.

It uses an **open table format** (metadata layer) on top of files (usually Parquet) to bring reliability and performance to the lake.

**Key Characteristics**
- Stores raw + processed data in one place (no duplication).
- Schema-on-read with optional enforcement + evolution.
- ACID transactions, time travel, schema evolution, upserts (MERGE).
- Supports BI (SQL), ML (Python/R/Scala), streaming in unified platform.
- Open formats avoid vendor lock-in (Delta Lake, Iceberg, Hudi).

**Enabling Technologies (2026 dominant)**
- **Delta Lake** (Databricks origin, open-source).
- **Apache Iceberg** (Netflix/Apple origin, very popular for multi-engine).
- **Apache Hudi** (Uber origin, strong upserts/streaming).
- Platforms: Databricks Lakehouse, Snowflake (with Iceberg support), Microsoft Fabric, Dremio, etc.

**Typical Use Cases**
- Unified analytics + ML on same data (no ETL copies).
- Medallion architecture (bronze → silver → gold layers).
- Real-time + batch, BI + data science on petabyte-scale data.

**Popular Examples (2026)**
- Databricks (Delta Lake + Unity Catalog + Photon engine).
- Snowflake with Iceberg tables / Unistore.
- Microsoft Fabric (OneLake + Delta-Parquet).
- Dremio, Starburst (Trino + Iceberg).

**Simple Example – Medallion Architecture (Databricks-style)**
1. Bronze layer (raw ingestion):  
   ```sql
   CREATE TABLE bronze_events USING DELTA
   LOCATION 's3://lake/bronze/events/'
   AS SELECT * FROM json.`s3://raw/*.json`;
   ```

2. Silver layer (cleaned + enforced schema):  
   ```sql
   CREATE TABLE silver_events USING DELTA
   LOCATION 's3://lake/silver/events/'
   AS SELECT 
        user_id, 
        event_type, 
        CAST(event_time AS TIMESTAMP) AS ts,
        country
      FROM bronze_events
      WHERE user_id IS NOT NULL;
   ```

3. Gold layer (aggregated for BI/ML):  
   ```sql
   CREATE TABLE gold_daily_sales USING DELTA
   LOCATION 's3://lake/gold/sales/'
   AS SELECT 
        date(ts) AS sale_date,
        country,
        COUNT(*) AS transactions,
        SUM(amount) AS revenue
      FROM silver_events
      WHERE event_type = 'purchase'
      GROUP BY date(ts), country;
   ```

   → Same table supports SQL BI, Spark ML, streaming updates, time travel (`VERSION AS OF 42`), etc.

**Pros & Cons**
- Pros: One copy of data, supports BI + ML + streaming, ACID + governance, cost-effective, open formats.
- Cons: Still maturing in some areas (e.g., pure BI concurrency vs. Snowflake), requires modern tools/skills.

#### Quick Comparison Table (2026 Perspective)

| Feature                  | Data Warehouse              | Data Lake                     | Data Lakehouse                  |
|--------------------------|-----------------------------|-------------------------------|---------------------------------|
| Data Types               | Structured only             | All (raw, unstructured)       | All (raw + processed)           |
| Schema                   | Schema-on-write             | Schema-on-read                | Schema-on-read + enforcement    |
| Storage Cost             | Higher                      | Very low                      | Very low                        |
| ACID Transactions        | Yes                         | No (unless added)             | Yes (via table format)          |
| Primary Use Case         | BI / Reporting              | ML / Data Science / Exploration | Unified BI + ML + Streaming     |
| Performance for BI       | Excellent                   | Poor                          | Very good (Photon/Trino/Iceberg)|
| Governance & Quality     | Strong                      | Weak (swamp risk)             | Strong (catalog + lineage)      |
| Best Platform Examples   | Snowflake, Redshift, BigQuery | S3 + Athena, ADLS + Spark   | Databricks, Fabric, Snowflake+I |

**Bottom Line (2026)**
- Choose **warehouse** if your workload is 90%+ structured BI/reporting and you want simplicity.
- Choose **lake** (plain) only for pure raw storage + heavy ML experimentation (rare in 2026).
- Choose **lakehouse** for most modern enterprises: it has become the default for organizations that want scale, cost efficiency, governance, and support for analytics + AI/ML on the same governed data.