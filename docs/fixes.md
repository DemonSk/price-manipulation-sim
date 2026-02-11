# Fixes & Mitigations

## 1) TWAP / Median oracle
Use a time‑weighted or median price instead of spot price to reduce 1‑block manipulation.

## 2) Circuit breaker on price jumps
Reject borrows if price moves more than a configured threshold within a single update window.

## 3) Liquidity thresholds
Refuse to trust markets below a minimum liquidity threshold.

## 4) Multi‑source oracles
Use multiple sources (Chainlink + DEX TWAP) for redundancy.
