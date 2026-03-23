#!/bin/sh

# shell-time.sh

# Library for measuring time
# Originally developed for adblock-lean, later improved and ported into geoip-shell and now published as a separate library

# License: GPLv3
# Copyright: antonk (antonk.d3v@gmail.com)
# github.com/friendly-bits


# Code is POSIX-compliant but only works on Linux because of reliance on /proc/uptime

# Usage:
# 1. get_init_uptime
# 2. print_elapsed_time <marker_string> 

# To get raw value in centiseconds (rather than printing it out in human-readable format):
# 1. get_init_uptime
# 2. get_elapsed_time <var_name>

is_uint() {
	for _v in "${@}"; do
		case "${_v}" in
			''|*[!0-9]*) return 1
		esac
	done
	:
}

get_init_uptime() {
	get_uptime INIT_UPTIME
}

# 1 - var name for centiseconds output
get_uptime() {
	eval "${1}=" || return 1
	read -r __uptime _ < /proc/uptime &&

	case "${__uptime}" in
		''|*.*.*) false ;;
		*.*) ;;
		*) false ;;
	esac &&
	i_cs="${__uptime##*.}" &&
	case "${i_cs}" in
		'') gu_cs=00 ;;
		?) gu_cs="${i_cs}0" ;;
		??) gu_cs="${i_cs}" ;;
		??*) gu_cs="${i_cs%"${i_cs#??}"}"
	esac &&
	gu_s="${__uptime%.*}" &&
	is_uint "${gu_s}" "${gu_cs}" ||
	{
		echo "Error: failed to get uptime from /proc/uptime."
		eval "${1}"=0
		return 1
	}
	gu_cs="${gu_s:-0}${gu_cs:-00}"
	gu_cs="${gu_cs#"${gu_cs%%[!0]*}"}"
	eval "${1}"='${gu_cs:-0}'
}

# To use, first get initial uptime: 'get_uptime INITIAL_UPTIME'
# Then call this function to get elapsed time string at desired intervals, e.g.:
# get_elapsed_time elapsed_time "${INITIAL_UPTIME}"
# 1 - var name for centiseconds output
# 2 - initial uptime in centiseconds
get_elapsed_time() {
	eval "${1}=" &&
	get_uptime ge_uptime_cs &&
	eval "${1}"='$(( ge_uptime_cs - ${2:-ge_uptime_cs} ))'
}

print_elapsed_time() {
	get_elapsed_time _e_elapsed "${INIT_UPTIME}" || return 1
    # shellcheck disable=SC2154
	_e_m=$(( _e_elapsed / 6000 ))
	[ "$_e_m" -gt 0 ] || _e_m=
	_e_cs=$(( _e_elapsed % 6000 ))
	_e_s=$(( _e_cs / 100 ))
	case "${_e_cs}" in
		'') _e_cs=00 ;;
		?) _e_cs="0${_e_cs}" ;;
		??) ;;
		??*) _e_cs="${_e_cs#"${_e_cs%??}"}"
	esac
	printf '%s\n' "*** $1: ${_e_m:+"${_e_m}m:"}${_e_s:-0}.${_e_cs:-0}s"
}
