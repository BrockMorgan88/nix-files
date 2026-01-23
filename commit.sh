#!/usr/bin/env bash
git add .
treefmt
git add .
git commit -m "$1"