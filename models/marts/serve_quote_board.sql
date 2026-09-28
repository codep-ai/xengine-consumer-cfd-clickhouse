-- ClickHouse-only serving model: the latest quote per symbol and the average spread over its last hour — what a live board reads.
-- Built on the same unified fact the Snowflake consumer builds for audit, so the two tiers cannot drift on definitions.
{{ config(order_by='(asset_class, symbol)') }}
select
    asset_class,
    symbol,
    argMax(bid, ts_utc)                                        as last_bid,
    argMax(ask, ts_utc)                                        as last_ask,
    argMax(mid, ts_utc)                                        as last_mid,
    argMax(spread_pips, ts_utc)                                as last_spread_pips,
    avgIf(spread_pips, ts_utc >= max_ts - interval 1 hour)     as avg_spread_1h,
    max_ts                                                     as last_ts_utc
from (select *, max(ts_utc) over (partition by asset_class, symbol) as max_ts from {{ ref('fct_tick_unified') }})
group by asset_class, symbol, max_ts
