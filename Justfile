#!/usr/bin/env just --justfile

init:
    kcl mod update

docs:
    kcl doc generate --escape-html --target docs/library
    mv docs/library/docs/enkinex-ossie.md docs/library/ossie.md
    rmdir docs/library/docs/
