# shell-time

Library for measuring time in shell scripts.
Originally developed for [adblock-lean](https://github.com/lynxthecat/adblock-lean), later improved and ported into [geoip-shell](https://github.com/friendly-bits/geoip-shell) and now published as a separate library.

Code is POSIX-compliant but only works on Linux because of reliance on /proc/uptime.

Usage:
1. `get_init_uptime`
2. `print_elapsed_time <marker_string>`

Example:

```
get_init_uptime
<some_code>
print_elapsed_time "First"
<some_more_code>
print_elapsed_time "Second"
```

To get raw value in centiseconds (rather than printing it out in human-readable format):
1. `get_uptime VAR_NAME_FOR_INIT_UPTIME`
2. `get_elapsed_time VAR_NAME_FOR_ELAPSED_TIME "${VAR_NAME_FOR_INIT_UPTIME}"`

Example:

```
get_uptime START_TIME
<some_code>
get_elapsed_time first_delta "${START_TIME}"
echo "Elapsed time in sentiseconds: ${first_delta}"
```
