# Changelog

This document tracks the history and evolution of the **Enkinex KCL Library** for the **Apache Ossie Core Metadata
Specification**.

## v0.2.0.dev0 - Initial 0.2.0.dev0 Draft

* Schemas
    * `ossie.k` (root): `OssieDocument`
    * `model/`: `SemanticModel`
    * `catalog/`: `Dataset`, `Field`, `Dimension`, `Relationship`
    * `metric/`: `Metric`
    * `common/`: `Dialect`, `DataType`, `Vendor`, `Expression`, `DialectExpression`, `AIContext`, `CustomExtension`,
      `isTimeEffective`
    * Re-vendored `ossie-schema.json` from upstream `core-spec/osi-schema.json` (the previous copy predated
      `DataType`, `datatype` on `Field`/`Metric`, and the `BIGQUERY` dialect)
* Documentation
    * README module overview and external references
    * Schema Mapping and Architectural Decisions per module (`docs/schemas/`)
    * Reference documentation generated from KCL (`docs/library/ossie.md`)
    * Tutorial
        * ...
* Sample Project
    * ...
* Validation
    * `test/*.yaml` fixtures: the spec's full example plus minimal/complete coverage per module
    * `just test` switched from a compile check to `kcl vet` against `OssieDocument`
* Repo scaffolding
    * Add `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`
    * Add GitHub issue templates and PR template
    * Add the Claude Code policy-guard hook (`.claude/settings.json`)
