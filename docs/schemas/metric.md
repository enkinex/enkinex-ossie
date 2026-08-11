# `metric` module

Quantitative measures defined at the semantic-model level, potentially
spanning multiple datasets.

---

## Schema Mapping

| Module Path                          | KCL schema | Ossie JSON Schema entity |
|-----------------------------------------|------------|---------------------------|
| [`metric/metric.k`](../../metric/metric.k) | `Metric`   | `$defs/Metric`             |

---

## Architecture Decisions

### `Metric` is its own module, not folded into `catalog/`

- `Field` (in `catalog/`) and `Metric` share almost every attribute
  (`name`, `expression`, `description`, `datatype`, `ai_context`,
  `custom_extensions`) and could have been unified as one schema with an
  optional `dimension`. They are kept separate because they occupy different
  levels of the standard: `Field` is scoped to one `Dataset`, `Metric` is
  scoped to the whole `SemanticModel` and its expressions may reference
  columns across multiple datasets (spec.md's "Cross-Dataset Metric"
  example: `SUM(orders.amount) / COUNT(DISTINCT customers.id)`). Merging them
  would obscure that scope difference and make `Dimension` awkwardly optional
  on something that is never dimensional.
- The near-duplication of fields between `Field` and `Metric` is accepted as
  the cost of keeping that distinction explicit (see
  [`docs/schemas/common.md`](common.md), "Open Questions").

---

## Open Questions

### No aggregation-shape validation

- Nothing in the JSON schema or this library distinguishes an aggregate
  expression (`SUM(...)`) from a scalar one on `Metric.expression` — both
  `Field.expression` and `Metric.expression` share the same `Expression`
  shape, and the spec's guidance that field expressions must be scalar
  ("Use scalar SQL expressions (no aggregations)") is prose convention, not a
  structural constraint. Recovering it would require parsing the dialect
  expression string, which is out of scope for a schema-level `check`.
