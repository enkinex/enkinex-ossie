# `common` module

Definitions reused across `catalog/`, `metric/`, and `model/`: the
multi-dialect `Expression`/`DialectExpression` pair, the `AIContext` union,
`CustomExtension`, the `Dialect`/`DataType`/`Vendor` enums, and the
`is_time` resolution helper.

---

## Schema Mapping

| Module Path                                        | KCL schema / symbol             | Ossie JSON Schema entity |
|-------------------------------------------------------|----------------------------------|---------------------------|
| [`common/enums.k`](../../common/enums.k)               | `Dialect`                        | `$defs/Dialect`            |
| [`common/enums.k`](../../common/enums.k)               | `DataType`                       | `$defs/DataType`           |
| [`common/enums.k`](../../common/enums.k)               | `Vendor`                         | `$defs/Vendor`             |
| [`common/expression.k`](../../common/expression.k)     | `DialectExpression`              | `$defs/DialectExpression`  |
| [`common/expression.k`](../../common/expression.k)     | `Expression`                     | `$defs/Expression`         |
| [`common/ai_context.k`](../../common/ai_context.k)     | `AIContextObject`, `AIContext`   | `$defs/AIContext`          |
| [`common/extension.k`](../../common/extension.k)       | `CustomExtension`                | `$defs/CustomExtension`    |
| [`common/temporal.k`](../../common/temporal.k)         | `isTimeEffective` (lambda)       | *(not a `$defs` entity — recovers spec.md prose, see [`docs/schemas/catalog.md`](catalog.md))* |

---

## Architecture Decisions

### `Vendor` stays an unconstrained `str` alias

- The JSON schema gives `Vendor` `examples`, not `enum` — explicitly: "Any
  string value is accepted." The seven examples (`COMMON`, `SNOWFLAKE`,
  `SALESFORCE`, `DBT`, `DATABRICKS`, `GOODDATA`, `WISDOM`) are
  documented in `CustomExtension.vendor_name`'s docstring rather than encoded
  as a literal union, because a literal union would reject any vendor not on
  that list — the opposite of what the standard's extensibility mechanism is
  for. This is the one enum-shaped field in the standard that is
  deliberately *not* modeled as a KCL literal union, unlike `Dialect` and
  `DataType`, which are closed enumerations.

### `AIContext` is a three-member union, not the literal `oneOf`

- The JSON schema's `AIContext` is `oneOf [string, object]`, and the object
  branch is `additionalProperties: true`. The direct KCL translation,
  `type AIContext = str | AIContextObject`, compiles and works for in-code
  KCL literals, but fails `kcl vet` YAML coercion for the object branch: KCL
  cannot route a YAML dict through a schema member of a union that also
  contains `str` (verified empirically — see the comment above the type
  alias in `common/ai_context.k`). Adding the permissive `{str:any}` member —
  `type AIContext = str | AIContextObject | {str:any}` — fixes coercion.
  `AIContextObject`'s own field types are still checked first (an invalid
  `synonyms: "not an array"` is still rejected — the `{str:any}` fallback is
  not a silent escape hatch for malformed known keys, only a coercion-path
  workaround for the union-of-schema-and-str limitation).

### `Expression.dialects` uniqueness-by-dialect is a `check`, not `uniqueItems`

- JSON's `minItems: 1` on `dialects` says nothing about *which* dialects may
  repeat. The spec's own examples never show a dialect twice ("Multi-Dialect
  Field": one entry per dialect). `Expression` adds
  `len(dialects) == len({d.dialect: d for d in dialects})`, the same
  dict-comprehension-length idiom used throughout this library for name/key
  uniqueness.

---

## Open Questions

### `AIContextObject`'s open-ended keys are typed `any`

- The index signature `[str]: any` accepts any additional key with any value
  shape, matching the JSON schema's `additionalProperties: true` exactly —
  but it means a key like `synonyms` misspelled as `synonym` is silently
  accepted as an extra key rather than flagged as a typo of a known field.
  This is the accepted trade-off of a permissive-superset schema.
