-- Same model as the Snowflake consumer's mart_spread_by_asset_hourly: average bid-ask spread per asset class, symbol and hour.
{{ config(order_by='(asset_class, symbol, event_hour)') }}
select
    asset_class,
    symbol,
    toStartOfHour(ts_utc)          as event_hour,
    count()                        as ticks,
    round(avg(spread_pips), 3)     as avg_spread_pips,
    round(min(spread_pips), 3)     as min_spread_pips,
    round(max(spread_pips), 3)     as max_spread_pips,
    round(avg(mid), 5)             as avg_mid
from {{ ref('fct_tick_unified') }}
group by asset_class, symbol, toStartOfHour(ts_utc)
