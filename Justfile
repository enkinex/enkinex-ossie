#!/usr/bin/env just --justfile

default:
    @just --list

init:
    kcl mod update

fmt:
    kcl fmt ./...

lint:
    kcl lint .

# No `test/` fixtures exist yet, so the gate is that the module still
# compiles. Replace with `kcl vet` over test/*.yaml once fixtures land.
test:
    kcl run ossie.k > /dev/null

docs:
    kcl doc generate --escape-html --target docs/library
    mv docs/library/docs/enkinex-ossie.md docs/library/ossie.md
    rmdir docs/library/docs/

check:
    kcl fmt ./...
    git diff --exit-code -- '*.k' || (echo "Code is not formatted — run 'just fmt' and commit the result." && exit 1)
    just lint
    just test
