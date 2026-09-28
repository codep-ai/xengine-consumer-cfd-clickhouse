-- Same model as the Snowflake consumer's fct_tick_unified: one fact table over the four asset classes. MergeTree, ordered for
-- "what was the market doing at time T" reads. Subquery rather than CTEs (ClickHouse 23.8 + dbt CREATE TABLE ... AS).
{{ config(order_by='(asset_class, symbol, ts_utc)') }}
select asset_class, symbol, ts_utc, bid, ask, mid, spread_pips, session, source, ingested_at
from (
    select asset_class, symbol, ts_utc, bid, ask, mid, spread_pips, session, source, ingested_at from {{ ref('stg_ticks_fx') }}
    union all
    select asset_class, symbol, ts_utc, bid, ask, mid, spread_pips, exchange_region as session, source, ingested_at from {{ ref('stg_ticks_crypto') }}
    union all
    select asset_class, symbol, ts_utc, bid, ask, mid, spread_pips, session, source, ingested_at from {{ ref('stg_ticks_index') }}
    union all
    select asset_class, symbol, ts_utc, bid, ask, mid, spread_pips, session, source, ingested_at from {{ ref('stg_ticks_commodity') }}
) u
