-- Same model as the Snowflake consumer's stg_ticks_crypto: crypto trades 24/7, so `session` is exposed as exchange_region.
select
    symbol,
    parseDateTime64BestEffort(ts_utc, 6)          as ts_utc,
    bid,
    ask,
    mid,
    spread_pips,
    session                                        as exchange_region,
    source,
    'crypto'                                       as asset_class,
    now64(6)                                       as ingested_at
from {{ source('cfd_lake', 'fct_tick_crypto') }}
