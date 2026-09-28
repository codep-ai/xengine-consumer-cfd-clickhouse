-- Same model as the Snowflake consumer's stg_ticks_commodity, in ClickHouse SQL: raw ts_utc is a string in the Iceberg table, parsed here.
select
    symbol,
    parseDateTime64BestEffort(ts_utc, 6)          as ts_utc,
    bid,
    ask,
    mid,
    spread_pips,
    session,
    source,
    'commodity'                                           as asset_class,
    now64(6)                                       as ingested_at
from {{ source('cfd_lake', 'tick_commodity') }}
