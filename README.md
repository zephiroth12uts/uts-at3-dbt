# Sydney Airbnb ELT Data Pipeline

This repository contains the dbt component of an end-to-end ELT data pipeline developed for Sydney Airbnb analysis using Google Cloud Platform, Apache Airflow, PostgreSQL and dbt Cloud.

The project integrates twelve months of Airbnb listing data from May 2020 to April 2021 with 2016 Census and NSW Local Government Area reference data. The warehouse follows a Medallion architecture with Bronze, Silver, Gold and Datamart layers.

## Architecture

- **Bronze:** Raw Airbnb, Census and LGA reference data loaded into PostgreSQL by Apache Airflow.
- **Silver:** Cleaned and standardised models, including decomposed Airbnb entities.
- **Snapshots:** SCD Type 2 history for host, listing and property entities using dbt timestamp snapshots.
- **Gold:** Star-schema layer containing dimensions, Census reference tables and the central Airbnb fact table.
- **Datamart:** Analytical views supporting neighbourhood, property-type and host-location analysis.

## Repository Structure

```text
models/
├── silver/
├── gold/
└── datamart/

snapshots/
├── host_snapshot.sql
├── listing_snapshot.sql
└── property_snapshot.sql

dbt_project.yml
```

## Main dbt Commands

Run all models:

```bash
dbt run
```

Run snapshots:

```bash
dbt snapshot
```

Rebuild all models:

```bash
dbt run --full-refresh
```

Run tests:

```bash
dbt test
```

## Data Processing

Airbnb monthly datasets were loaded sequentially from May 2020 to April 2021. After each monthly Airflow ingestion, dbt models were executed, snapshots were updated, and downstream models were refreshed to preserve the correct SCD Type 2 history.

## Analytical Outputs

The project produces three Datamart views:

- `dm_listing_neighbourhood`
- `dm_property_type`
- `dm_host_neighbourhood`

These views support analysis of listing activity, pricing, estimated revenue, host behaviour, property characteristics and geographic performance.

## Technologies

- Google Cloud Platform
- Google Cloud Storage
- Google Cloud Composer
- Apache Airflow
- Google Cloud SQL
- PostgreSQL
- dbt Cloud
- DBeaver

## Author

Fabián David Andrés Moreno Cruz