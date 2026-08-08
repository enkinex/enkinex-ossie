# Contributing to Enkinex Ossie

Thank you for your interest in contributing to **Enkinex Ossie**, the [KCL](https://www.kcl-lang.io/) library for the
[Apache Ossie Core Metadata Specification](https://github.com/apache/ossie). This guide covers everything you need to
build, validate, and submit changes.

## Prerequisites

- [KCL Language CLI](https://www.kcl-lang.io/docs/user_docs/getting-started/install) `>= 0.12.4`
- [`just` Command Runner](https://github.com/casey/just).

Check both are on your `PATH`:

```bash
kcl --version
just --version
```

## Getting Started

```bash
git clone git@github.com:enkinex/enkinex-ossie.git
cd enkinex-ossie
just init      # kcl mod update
just check     # fmt + lint + test, the same gate CI/reviewers expect
```

Run `just` with no arguments at any point to list every available task.

## Development Workflow

All day-to-day tasks are `just` recipes defined in the [`Justfile`](Justfile):

| Command      | What it does                                                                                                                                   |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `just init`  | Syncs module dependencies (`kcl mod update`).                                                                                                  |
| `just fmt`   | Formats every `.k` file in the project (`kcl fmt ./...`).                                                                                      |
| `just lint`  | Runs `kcl lint .` against the project.                                                                                                         |
| `just test`  | Currently a **compile check** (`kcl run ossie.k`) — there are no `test/` fixtures yet. See [Where the schema is headed](#where-the-schema-is-headed). |
| `just docs`  | Regenerates the auto-generated schema reference from schema docstrings.                                                                        |
| `just check` | Aggregate gate: formats, verifies the tree is still clean (`git diff --exit-code`), then runs `lint` and `test`. Run this before opening a PR. |

Before pushing, always run:

```bash
just fmt
just check
```

`just check` re-runs `kcl fmt` and fails if it changes anything you haven't committed — so always run `just fmt` and
commit the result first, rather than letting `check` catch it for you.

## Branch and commit conventions

Commit messages in this repo follow a **Conventional Commits** subset. Use one of these prefixes based on what the
commit actually changes:

- `feat:` — a new schema, field, or capability
- `fix:` — a correctness fix (typing, constraints, validation behavior)
- `docs:` — documentation-only changes (README, schema docs, docstrings)
- `test:` — adding or updating test fixtures
- `refactor:` — restructuring without behavior change
- `chore:` — tooling, dependency, or repo-scaffolding changes

Keep the subject line short and imperative (e.g. `fix: reject invalid version
values`), matching the existing `git log`.

Branch names follow `<type>/<short-slug>`, using the same prefixes as above, e.g. `feat/semantic-model-entities` or
`chore/contributor-tooling`.

## Pull request process

1. Fork the repo (or branch directly if you're a collaborator) and open your PR against `main`.
2. Fill in the [PR template](.github/PULL_REQUEST_TEMPLATE.md) — in particular the **Testing** section: paste the output
   of `just check`.
3. Make sure CI (or your local `just check`) is green before requesting review.
4. A maintainer listed in [`.github/CODEOWNERS`](.github/CODEOWNERS) will review; address feedback with follow-up
   commits rather than force-pushes once a review is in progress, unless asked otherwise.
5. PRs are squash-merged, so the PR title should itself read as a good commit message.

## Where the schema is headed

This library is the earliest of the enkinex KCL libraries in its lifecycle: `ossie.k` currently models `SemanticModel`
and its `version` field only, against [`ossie-schema.json`](ossie-schema.json) — itself a `.dev0` pre-release of the
Apache Ossie spec. There is no module split yet; everything lives in the single root `ossie.k`.

As the schema surface grows past a handful of fields, expect (and feel free to propose):

- Splitting related `$defs` sections of `ossie-schema.json` into their own KCL modules, mirroring how `enkinex-odcs`
  organizes `catalog/`, `common/`, `contract/`, `iam/`, `quality/`, `server/`.
- A `test/` directory of fixture YAML files, at which point `just test` should switch from a compile check to
  `kcl vet`-ing those fixtures against the schema (see the `just test` recipe in the [`Justfile`](Justfile) for the
  exact command to update).
- A `docs/schemas/` directory documenting the design rationale for each module, once there is more than one.

If you're adding a new field or schema today, it belongs in `ossie.k` unless you're also introducing the first module
split — raise that as its own discussion before doing it as part of an unrelated change.

## Docstrings and generated docs

Every schema and field should carry a docstring — it's the source of the generated schema reference and the primary way
contributors discover the API. When you add or change a docstring:

1. Run `just docs` to regenerate the schema reference.
2. Include the regenerated file in your PR.

## Code of conduct and security

- This project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
- To report a security vulnerability, see [`SECURITY.md`](SECURITY.md) — please do not open a public issue for security
  reports.

## Other references

- [`AUTHORS.md`](AUTHORS.md) — contributor list.
- [`CHANGELOG.md`](CHANGELOG.md) — notable changes per release.
- [`history.md`](history.md) — which version of the Apache Ossie spec this library tracks.
