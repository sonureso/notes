# System Design for Data Engineering Interview Notes
- PHASE-1: Requirements Gathering
- PHASE-2: Pipeline Design
- PHASE-3: Data Modeling
- PHASE-4: Storage & File Formats
- PHASE-5: Data Quality & Oberservability
- PHASE-6: Scalability, Backfill and DataOps

### PHASE-1: Requirements Gathering
Ask Questions:
1. Who are the users ?
2. What are the functionalities this system will provide to the end users ?
3. What is latency requirement ? Once, hourly, daily, weekly, monthly ?
4. What is the volume of data, system has to process ? MB/GB/TB/PB ?

### PHASE-2: Pipeline Design
1. How data will move from source to Raw Layer or destination?
2. Which processing ? Batch or Streaming ?
3. which architecture we will use ? Lambda | Kappa | Medallian ?
4. Which tool for orchestration ? Airflow | ADF
5. 

### PHASE-3: Data Modeling
1. Decide the shape of the data.
2. Star schema or snowflake schema ?
3. How Fact and dimention tables will look like ?
4. If medallian then: How bronze/silver/gold layers will look like ?
5. Which type of SCD, we are going to follow ? Type-1, Type-2 or Type-3 ?

### PHASE-4: Storage & File Formats
1. Where and in which format, you data will live ? Parquet or deltalake or iceberg ?
2. What are storage optimizations, we are going to follow ?
    - Partitioning or Bucketing or Liquid Clustering

### PHASE-5: Data Quality & Oberservability
1. How do you know the PL output data are accurate ?
    - Setting up data quality check rules and matrix to understand it.
2. Testing: How testing will happen ?
3. Alerts: How PL alarts will be given to DEV & Users.
4. Logging: How logging need to be done or just alarts are enough ?

###  PHASE-6: Scalability, Backfill and DataOps
1. What happens if source fails to connect ?
2. How Failure recovery will happen ?
3. Can system handle 10x load ?
4. Can you regenerate last 3 months/3 days of data again ?
5. If PL runs multiple times, does it handle duplicates with no manual handling?
6. What is schema changes on the source side ?

> # Understanding in Detail

### PHASE-1: Requirements Gathering
1. Functional Requirements: What does the system do?
2. Non Functional Requirement: How should the system behave ?

... to be continued.