#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$VENDOR_DIR" == "" ]]; then
  VENDOR_DIR=$(mktemp -d)
  function cleanup {
    rm -rf "$VENDOR_DIR"
  }
  trap cleanup EXIT
fi

export PLENARY_DIR="$VENDOR_DIR/plenary.nvim.git"

if ! [[ -d "$PLENARY_DIR" ]]; then
  git clone https://github.com/nvim-lua/plenary.nvim.git $PLENARY_DIR 2> /dev/null
fi

nvim \
  --headless \
  --noplugin \
  -u "${ROOT_DIR}/config/init.vim" \
  -c "PlenaryBustedDirectory ${SPECS_DIR:-specs} { minimal_init = '${ROOT_DIR}/config/init.vim' }"

