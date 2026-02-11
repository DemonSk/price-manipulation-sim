# Price Manipulation Simulator (Foundry)

A focused demo of **price‑oracle manipulation** attacks in DeFi. Uses a toy AMM + lending market to show *exploit → impact → fix*.

## ✅ Scenarios
- One‑block price manipulation to bypass collateral checks
- Oracle lag exploitation (spot vs TWAP)
- Mitigation using TWAP + circuit breaker

## Structure
- **src/** — toy AMM + lending market (intentionally vulnerable)
- **test/** — exploit scenarios + fix variants
- **docs/** — write‑ups and diagrams

## Run tests
```bash
forge test -vv
```

## Goals
Show how manipulation works in practice and how to mitigate it:
- TWAP / median oracles
- Circuit breakers on large deltas
- Minimum liquidity thresholds

## License
MIT
