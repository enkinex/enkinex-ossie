#!/usr/bin/env just --justfile

init:
    kcl mod update

docs:
    kcl doc generate --escape-html
