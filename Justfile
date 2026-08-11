#!/usr/bin/env just --justfile

default:
    @just --list

init:
    kcl mod update

fmt:
    kcl fmt ./...

lint:
    set -e; for d in . catalog common metric model; do (cd "$d" && kcl lint .); done

test:
    set -e; for f in test/*.yaml; do kcl vet "$f" ossie.k --format yaml -s OssieDocument; done

docs:
    kcl doc generate --escape-html --target docs/library
    mv docs/library/docs/enkinex-ossie.md docs/library/ossie.md
    rmdir docs/library/docs/

check:
    kcl fmt ./...
    git diff --exit-code -- '*.k' || (echo "Code is not formatted — run 'just fmt' and commit the result." && exit 1)
    just lint
    just test
