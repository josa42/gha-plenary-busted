#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPECS_DIR="${SPECS_DIR:-specs}"

if [[ "$INIT_FILE" == "" ]] && [[ -f "$SPECS_DIR/init.lua" ]]; then
  export INIT_FILE="$SPECS_DIR/init.lua"
fi

tmp_dir="$(mktemp -d)"
data_dir="${tmp_dir}/data"
state_dir="${tmp_dir}/state"
config_dir="${tmp_dir}/config"

if [[ "$VENDOR_DIR" == "" ]]; then
  VENDOR_DIR="$tmp_dir/vendor"
fi
mkdir -p "$VENDOR_DIR" "$state_dir" "$data_dir" "$config_dir"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

export XDG_STATE_HOME="$state_dir"
export XDG_DATA_HOME="$data_dir"
export XDG_CONFIG_HOME="$config_dir"

export VENDOR_DIR="$VENDOR_DIR"

nvim \
  --headless \
  --noplugin \
  -u "${ROOT_DIR}/config/init.lua" \
  -c "PlenaryBustedDirectory ${SPECS_DIR} { minimal_init = '${ROOT_DIR}/config/init.lua' }"
