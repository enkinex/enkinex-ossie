# `ossie` root

The root module. `ossie.k` defines `OssieDocument`, the top-level file shape
for an Apache Ossie semantic model definition (`version` + a list of
`SemanticModel` entries), and composes the four submodules that model
everything under it.

---

## Schema Mapping

| Module Path                                | KCL schema      | Ossie JSON Schema entity |
|---------------------------------------------|-----------------|---------------------------|
| [`ossie.k`](../../ossie.k)                  | `OssieDocument` | root object (`version`, `semantic_model`) |

## `OssieDocument` field ownership

| Field | Type | Owning module |
|---|---|---|
| `version` | `ApiVersionType` (literal `"0.2.0.dev0"`) | `ossie.k` |
| `semantic_model` | `[semantic_model.SemanticModel]` | `model/` |

---

## Architecture Decisions

### The root is `OssieDocument`, not `SemanticModel`

- The JSON schema's root object (`version` + `semantic_model[]`) and its
  `$defs/SemanticModel` item are different shapes: the root is a *file*, each
  array entry is a *model*. Naming both `SemanticModel` — as the pre-0.1
  scaffolding of this library did — collided the two.
- `OssieDocument` names the file shape; `SemanticModel` (in `model/`) keeps
  the standard's own name for the array item, so the root name stays
  distinct from every schema it composes.

### `version` stays a single-value literal union

- The JSON schema pins `version` with `const: "0.2.0.dev0"`. `ApiVersionType`
  is declared as a one-member literal union (`"0.2.0.dev0"`) rather than a
  `check` against a constant string: enums — including single-valued ones —
  are literal unions here, never runtime membership tests.
- The value has to be bumped by hand as the standard's `dev0` prerelease
  advances; there is no cross-repo mechanism keeping `kcl.mod` version,
  `ApiVersionType`, and the vendored `ossie-schema.json` in sync.

---

## Open Questions

### The standard is a moving `.dev0` prerelease

- `spec.md`'s own banner: "DRAFT version — in development, schema may change
  before 0.2.0 is released." Field shapes, not just the version string, may
  still change upstream. This library snapshots `0.2.0.dev0` as of the commit
  that added it; re-diffing `ossie-schema.json` against
  `github.com/apache/ossie` before the next change is good practice while the
  standard is pre-release.
