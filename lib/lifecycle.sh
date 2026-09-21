#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later

DPS_STATE_ROOT=${DPS_STATE_ROOT:-/var/lib/dietpi-software-extra}
DPS_LOG_ROOT=${DPS_LOG_ROOT:-/var/log/dietpi-software-extra}

dps_state_dir() { printf '%s/%s\n' "$DPS_STATE_ROOT" "$1"; }
dps_state_file() { printf '%s/%s/state\n' "$DPS_STATE_ROOT" "$1"; }

dps_prepare_runtime() {
	local item=$1
	mkdir -p "$(dps_state_dir "$item")" "$DPS_LOG_ROOT"
}

dps_write_state() {
	local item=$1 state=$2 tmp
	dps_prepare_runtime "$item"
	tmp="$(dps_state_file "$item").tmp.$$"
	printf '%s\n' "$state" > "$tmp"
	mv -f "$tmp" "$(dps_state_file "$item")"
}

dps_read_state() {
	local file
	file=$(dps_state_file "$1")
	[[ -r $file ]] && cat "$file" || printf 'unknown\n'
}

dps_run_logged() {
	local item=$1 action=$2 script=$3 logfile rc
	dps_prepare_runtime "$item"
	logfile="$DPS_LOG_ROOT/$item.log"
	dps_log "$item: starting $action"
	set +e
	"$script" 2>&1 | tee -a "$logfile"
	rc=${PIPESTATUS[0]}
	set -e
	if (( rc == 0 )); then
		dps_log "$item: $action completed"
		return 0
	fi
	dps_log "$item: $action failed with exit code $rc"
	return "$rc"
}
