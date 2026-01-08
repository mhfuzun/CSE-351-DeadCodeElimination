#!/usr/bin/env bash

# -----------------------------
# Default path to the 'dead' executable
# This will be used unless overridden from the command line
# -----------------------------
DEAD_BIN="./build/dead"

# -----------------------------
# Usage check
# -----------------------------
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <input_file> [path_to_dead]"
    exit 1
fi

INPUT_FILE="$1"

# -----------------------------
# If a second argument is provided,
# override the default DEAD_BIN
# -----------------------------
if [[ $# -eq 2 ]]; then
    DEAD_BIN="$2"
fi

# -----------------------------
# Sanity checks
# -----------------------------
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: input file '$INPUT_FILE' does not exist."
    exit 1
fi

if [[ ! -x "$DEAD_BIN" ]]; then
    echo "Error: '$DEAD_BIN' is not executable or does not exist."
    exit 1
fi

# -----------------------------
# Pipeline execution
# -----------------------------
tail -r "$INPUT_FILE" | "$DEAD_BIN" | tail -r
