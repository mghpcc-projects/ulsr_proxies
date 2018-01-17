#!/bin/bash
#
# Run iblinkinfo just for this host and echo output
# This output can be used to figure the remote end GUID
# so that the remote port can be disabled/enabled.
#
/usr/sbin/iblinkinfo -l -D 1
