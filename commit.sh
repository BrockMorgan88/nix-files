#!/usr/bin/env bash
git add .
treefmt
git commit -m "$1"