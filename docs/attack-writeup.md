# Attack Write‑up: Price Manipulation

## Summary
A borrower manipulates a thin‑liquidity AMM to inflate collateral price, borrows against it, then the price snaps back.

## Impact
- Under‑collateralized borrow
- Bad debt for the protocol

## Fixes
- Use TWAP/median oracles
- Apply circuit breakers on large price deltas
- Require sufficient liquidity thresholds
