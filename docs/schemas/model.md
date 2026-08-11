# `model` module

The single schema one level below the root: `SemanticModel`, the entry type
of `OssieDocument.semantic_model`. Everything else in the library — datasets,
relationships, metrics — hangs off this one container.

---

## Schema Mapping

| Module Path                                          | KCL schema     | Ossie JSON Schema entity |
|--------------------------------------------------------|----------------|---------------------------|
| [`model/semantic_model.k`](../../model/semantic_model.k) | `SemanticModel` | `$defs/SemanticModel`     |

---

## Architecture Decisions

### `model/` exists as its own module even though it holds one schema

- `SemanticModel` sits at a different level of composition than `catalog/`
  (per-dataset shapes) and `metric/` (measures): it is the container that
  references both. Keeping it in its own module — rather than folding it into
  `ossie.k` or into `catalog/` — follows the one-module-per-concern rule and
  leaves room to grow if the standard adds more document-level constructs
  (e.g. named views over a `SemanticModel`) without reshuffling `catalog/` or
  `metric/`.

### Uniqueness constraints beyond what JSON Schema states

- The JSON schema does not declare `datasets`/`relationships`/`metrics`
  entries as unique by `name` — JSON Schema's `uniqueItems` only compares
  whole objects, which cannot express "unique by one key." `SemanticModel`
  adds three `check` rules recovering that intent via a
  dict-comprehension-length idiom:
  `len(datasets) == len({d.name: d for d in datasets})`.
- This is a deliberate strengthening beyond the letter of the JSON schema,
  justified because a semantic model with two datasets of the same name is
  not meaningfully usable by any consumer that resolves relationships or
  metric expressions by name.

### `datasets` enforces `minItems: 1` via `check`, not the array type

- JSON's `minItems: 1` on `datasets` has no direct KCL array-length type
  annotation; it is recovered as `len(datasets) > 0` in the `check:` block.

---

## Open Questions

### Cross-reference validation is out of scope

- `Relationship.from`/`.to` and `Field`/`Metric` expressions reference dataset
  and column names by string, but nothing in the JSON schema — or this
  library — checks that those strings resolve to an actual `Dataset`/column
  elsewhere in the same `SemanticModel`. Full referential integrity needs
  whole-document context a single schema's `check:` block does not have.
