#!/bin/bash 
#
# Read list of GUID values to enable/disable from standard in
# Format is
# 0xXXXXXXXXXXXXXXXX NN enable
# or
# 0xXXXXXXXXXXXXXXXX NN disable
#
# where XXXXXXXXXXXXXXXX is a hexadecimal GUID
# and NN is a decimale port number.
#
# These are used to execute a command of the form
#
# ibportstate -G 0xXXXXXXXXXXXXXX NN [enable|disable]
#
# The GUID port number combination is optionally checked against an
# independent list of allowed GUID decimal port number pairs
# that can be used to limit which ports and devices can be
# manipulated.
#

#
# Set some safety features for sudo script
# Fail on error
set -e
set -E
# Unset variables are an error
set -u
# No globbing
set -f
# Fail on error anywhere in pipe
set -o pipefail
set -o nounset
# Trace (for debugging)
# set -x

# Parameters
ibpstate_cmd_path="/usr/sbin/ibportstate"
conf_file="ulsr_ibproxy.conf"

awk_cmd="/bin/awk"
dirname_cmd="/usr/bin/dirname"
grep_cmd="/bin/grep"
sed_cmd="/bin/sed"
stat_cmd="/usr/bin/stat"
wc_cmd="/usr/bin/wc"

# Functions
function parseline() {
 local line;
 line=( ${1} ); nw=${#line[@]};
 if [ ${nw} == 3 ]; then
  ifld=0
  fld="${line[${ifld}]}"
  printf -v gvar '0x%14.14x' "${fld}" 2>/dev/null || { echo -E "# \"${fld}\"" "is not a valid GUID format."; exit 1; }
  # printf 'GUID = \"%s\"\n' "${gvar}"
  ifld=1
  fld="${line[${ifld}]}"
  printf -v pvar '%d' "${fld}" 2>/dev/null || { echo -E "# \"${fld}\"" "is not a valid port number format."; exit 2; }
  # printf 'PORT NUMBER = \"%s\"\n' "${pvar}"
  ifld=2
  fld="${line[${ifld}]}"
  printf -v pcmd '%s' "${fld}" 2>/dev/null || { echo -E "# \"${fld}\"" "is not a valid port action format."; exit 3; }
  # printf 'ACTION = \"%s\"\n' "${pcmd}"
 else
  if [ ${line[0]} == "#" ]; then
   continue
  else
   echo "# Invalid input line"
   exit 4
  fi
 fi
 parsedline=("${gvar}" "${pvar}" "${pcmd}")
}

function check_allowed() {
 nany=`${grep_cmd} -v '^ *#' "${proxy_conf_file}" | ${grep_cmd} ' *ANY *' | ${wc_cmd} -l`
 if [ ${nany} -eq 1 ]; then
  return 0
 fi
 nmatch=`${grep_cmd} -v '^ *#' "${proxy_conf_file}" | ${grep_cmd} ' *'"${1}"' *'"${2}" | ${wc_cmd} -l`
 if [ ${nmatch} -eq 1 ]; then
  return 0
 fi
 return 1
}

function get_settings() {
 cmd_name="$1"
 dname=$(cd `$dirname_cmd "$cmd_name"` && pwd)
 owper=`$stat_cmd -c '%A' ${dname} | $awk_cmd '{print $1}' | $sed_cmd s'/........\(.\)./\1/'`
 if [ "$owper" != "-" ]; then
  echo -E "# Script directory \"${dname}\" write permisissions too open."
  return 1
 fi
 owper=`$stat_cmd -c '%A' ${cmd_name} | $awk_cmd '{print $1}' | $sed_cmd s'/........\(.\)./\1/'`
 if [ "$owper" != "-" ]; then
  echo -E "# Script file \"${cmd_name}\" write permisissions too open."
  return 1
 fi
 proxy_conf_file="${dname}""/""${conf_file}"
 if [ ! -f ${proxy_conf_file} ]; then
  echo -E "# Config file \"${proxy_conf_file}\" not found."
  return 1
 fi
 owper=`$stat_cmd -c '%A' ${proxy_conf_file} | $awk_cmd '{print $1}' | $sed_cmd s'/........\(.\)./\1/'`
 if [ "$owper" != "-" ]; then
  echo -E "# Script file \"${proxy_conf_file}\" write permisissions too open."
  return 1
 fi
 if [ ! -f ${ibpstate_cmd_path} ]; then
  echo -E "# IB port control command \"${ibpstate_cmd_path}\" not found."
  return 1
 fi
 return 0
}

get_settings "$0" || { echo -E "# Configuration file checking failed."; exit 6; }
echo "# Using config file \"${proxy_conf_file}\""
while IFS= read -r line || [ -n "$line" ]
do
 parsedline=""
 parseline "${line}"
 check_allowed ${parsedline[0]} ${parsedline[1]} || { echo -E "# GUID port combination allow check failed."; exit 5; }
 echo '# !!! SHOULD BE OK TO EXECUTE !!! '"${ibpstate_cmd_path} -G ${parsedline[0]} ${parsedline[1]} ${parsedline[2]}"
done
