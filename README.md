# xengine-consumer-cfd-clickhouse

The realtime/serving team's dbt project on **ClickHouse** (dbt-clickhouse) for the CFD tick estate. It depends on the producer only
through `models/staging/_sources.yml`: the four raw tick tables (`glue:cfd.tick_*`) the Kafka Connect Iceberg sink writes to
`s3://datapai-cfd-lake/lake/` (folders still named `lake/fct_tick_*`, a June naming carried by the sink) and catalogues in Glue.
ClickHouse reads them **in place** through `iceberg()` views created on-run-start from the S3 table roots in `dbt_project.yml`.
Models are the same as the Snowflake consumer's — staging per asset class → `fct_tick_unified` → `mart_spread_by_asset_hourly` —
as MergeTree tables in `cfd_mesh`, plus `serve_quote_board` (ClickHouse-only). The estate (`xengine-estate-cfd`) stitches both
consumers into one column lineage.

    ./xdbt.sh build
    ./xdbt.sh docs generate

ClickHouse 23.8 reads Iceberg by the https bucket URL with the instance role; a Glue-catalog database needs 25.12+.
