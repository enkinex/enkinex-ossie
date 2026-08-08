# `catalog` module

Dataset shape: logical datasets, their row-level fields, and the foreign-key
relationships between them.

---

## Schema Mapping

| Module Path                                            | KCL schema     | Ossie JSON Schema entity |
|-----------------------------------------------------------|----------------|---------------------------|
| [`catalog/dataset.k`](../../catalog/dataset.k)             | `Dataset`      | `$defs/Dataset`           |
| [`catalog/field.k`](../../catalog/field.k)                 | `Field`        | `$defs/Field`             |
| [`catalog/field.k`](../../catalog/field.k)                 | `Dimension`    | `$defs/Dimension`         |
| [`catalog/relationship.k`](../../catalog/relationship.k)   | `Relationship` | `$defs/Relationship`      |

---

## Architecture Decisions

### Field names are spelled exactly as the standard spells them: snake_case

- Ossie's JSON schema is snake_case (`primary_key`, `unique_keys`,
  `custom_extensions`, `from_columns`, `to_columns`), so fields here are
  spelled spell-for-spell to match.

### `Relationship.from_columns` / `to_columns` length-matching is a `check`

- The spec's prose ("Important Notes": "Both arrays must have the same number
  of columns") is not expressible in the vendored JSON schema at all — it has
  no `$defs`-level way to relate the lengths of two sibling array properties.
  `Relationship` recovers it as `len(from_columns) == len(to_columns)`,
  a `check` block recovering what JSON Schema structurally cannot say.

### `Dataset.fields` uniqueness by name is a `check`, matching `SemanticModel`

- Same dict-comprehension-length idiom as the root-level uniqueness checks in
  `model/semantic_model.k`; see [`docs/schemas/model.md`](model.md).

### The `is_time` temporal default is a lambda, not a schema default

- `Dimension.is_time` has no default in JSON Schema and none here — an
  omitted value round-trips as omitted. The spec's resolution rule ("defaults
  to `true` if `datatype` is one of `Date`, `Time`, `DateTime`, `DateTimeTz`,
  and `false` otherwise; explicit `is_time` always wins") is a *cross-field*
  computed default, which KCL's `= <default>` syntax cannot express — a
  default binds to one field, not a function of a sibling field.
- The rule is exposed as a plain module lambda in
  [`common/temporal.k`](../../common/temporal.k),
  `isTimeEffective(datatype, isTime)`: logic that doesn't belong in a
  `check:` block (because it computes a value, not a pass/fail) lives as a
  callable a consumer can invoke.
- This preserves the type/role separation the spec draws between `datatype`
  (what kind of value) and `is_time` (whether to treat the field as a time
  dimension) — see spec.md's "DataType and `is_time`: type vs. role" section.

---

## Open Questions

### `logicalType`-style per-type option validation does not exist here

- Ossie's `Field` has no per-`datatype` options object — `datatype` is a bare
  enum with no attached configuration — so there is nothing to recover. Noted
  here so a future `datatype`-specific options object (should the standard
  add one) has a starting point.
