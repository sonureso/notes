# System Design for Data Engineering Interview Notes

## 1. Core Architecture Patterns
- **Lambda Architecture**: Combines Batch (for accuracy/completeness) and Speed layers (for real-time) with a Serving layer.
- **Kappa Architecture**: Simplifies Lambda by treating everything as a stream; uses a single stream processing engine for both real-time and historical data.
- **Medallion Architecture**: 
    - **Bronze**: Raw data ingestion.
    - **Silver**: Filtered, cleaned, and joined data.
    - **Gold**: Business-ready aggregates for analytics.

## 2. Data Storage & Formats
- **Storage Types**:
    - **Data Lake**: Object storage (S3, ADLS, GCS) for raw, unstructured/semi-structured data.
    - **Data Warehouse**: Optimized for SQL queries (Snowflake, BigQuery, Redshift).
    - **Lakehouse**: Combines Lake flexibility with Warehouse ACID transactions (Delta Lake, Iceberg, Hudi).
- **File Formats**:
    - **Row-based (Avro)**: Ideal for write-heavy workloads and streaming.
    - **Columnar (Parquet, ORC)**: Ideal for read-heavy analytical queries (compression, predicate pushdown).

## 3. Data Processing & Computation
- **Batch Processing**:
    - **MapReduce/Spark**: Distributed processing of large datasets.
    - **Key Concepts**: Shuffling, Partitioning, DAGs, Lazy Evaluation.
- **Stream Processing**:
    - **Engines**: Flink, Spark Streaming, Kafka Streams.
    - **Concepts**: Windowing (Tumbling, Sliding, Session), Watermarking (handling late data), Exactly-once semantics.
- **ETL vs ELT**:
    - **ETL**: Transform before loading (Traditional DW).
    - **ELT**: Load then transform (Modern Cloud DW/Lakehouse).

## 4. Messaging & Ingestion
- **Message Queues**: Kafka, RabbitMQ, Pulsar.
- **Kafka Key Concepts**:
    - **Topics/Partitions**: For parallelism and scalability.
    - **Consumer Groups**: Offset management and load balancing.
    - **Replication Factor**: For fault tolerance.
- **CDC (Change Data Capture)**: Capturing row-level changes from DB logs (e.g., Debezium) to keep downstream systems in sync.

## 5. Database Design & Scaling
- **CAP Theorem**: Consistency, Availability, Partition Tolerance (pick two).
- **Scaling**:
    - **Vertical**: More CPU/RAM.
    - **Horizontal**: More machines (Sharding).
- **Indexing**: B-Trees (Read optimized), LSM Trees (Write optimized - NoSQL).
- **Consistency Models**: Strong vs. Eventual consistency.

## 6. Data Modeling
- **Relational (Normalization)**: Reducing redundancy (1NF, 2NF, 3NF).
- **Dimensional Modeling**:
    - **Star Schema**: Fact tables surrounded by Dimension tables (optimal for BI).
    - **Snowflake Schema**: Normalized dimensions.
- **SCD (Slowly Changing Dimensions)**:
    - **Type 1**: Overwrite.
    - **Type 2**: History (New row with version/date).
    - **Type 3**: Current/Previous column.

## 7. Reliability & Performance Optimization
- **Partitioning**: Dividing data by a key (e.g., date) to avoid full table scans.
- **Bucketing**: Distributing data into fixed files to optimize joins.
- **Skewness**: When one partition is significantly larger than others $\rightarrow$ Fix using Salting.
- **Backpressure**: Handling producer speed exceeding consumer capacity in streams.
- **Idempotency**: Ensuring a process can be retried without duplicating data (crucial for Exactly-once).

## 8. Monitoring & Governance
- **Observability**: Metrics, Logs, Tracing.
- **Data Quality**: Schema validation, null checks, volume checks.
- **Lineage**: Tracking data from source to destination for impact analysis.
- **Security**: Encryption at rest/transit, RBAC (Role-Based Access Control).