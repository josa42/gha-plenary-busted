#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPECS_DIR="${SPECS_DIR:-specs}"

if [[ "$INIT_FILE" == "" ]] && [[ -f "$SPECS_DIR/init.lua" ]]; then
  export INIT_FILE="$SPECS_DIR/init.lua"
fi

if [[ "$VENDOR_DIR" == "" ]]; then
  VENDOR_DIR=$(mktemp -d)
  function cleanup {
    rm -rf "$VENDOR_DIR"
  }
  trap cleanup EXIT
fi

export VENDOR_DIR="$VENDOR_DIR"
export PLENARY_DIR="$VENDOR_DIR/plenary.nvim.git"

nvim \
  --headless \
  --noplugin \
  -u "${ROOT_DIR}/config/init.lua" \
  -c "PlenaryBustedDirectory ${SPECS_DIR} { minimal_init = '${ROOT_DIR}/config/init.lua' }"

