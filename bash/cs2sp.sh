#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] -u url {block | unblock}

CS2 matchmaking server picker.

Note: this script must be run with root privileges.

Available options:

-h, --help             Print this help and exit
-v, --verbose          Print script debug information
-u, --api-url          Endpoint to get servers IPv4 addresses
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # Default exit status 1.
  msg "$msg"
  exit "$code"
}

parse_params() {
  api_url="https://api.steampowered.com/ISteamApps/GetSDRConfig/v1?appid=730"

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -u | --api-url)
      api_url="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # Check required argument.
  [[ ${#args[@]} -ne 1 ]] && die "Missing script argument"
  
  action=${args[0]}

  return 0
}

handle_cluster() {
  echo $clusters | jq -c '.' | while read cluster; do # Loop on clusters.
    name=$(echo $cluster | jq -r '.[0]')
    relays=$(echo $cluster | jq -r '.[1]')
    
    if [ "$name" = "$1" ]; then
      echo $relays | jq -c 'try .relays[]' | while read relay; do # Loop on relays.
        ip_address=$(echo $relay | jq -r '.ipv4')
        echo "ipv4='$ip_address', cluster='$name'"
        
        if [ "$2" = "block" ]; then
          ufw deny out to $ip_address  
        else
          ufw delete deny out to $ip_address
        fi
      done
    fi
  done
}

parse_params "$@"

title="cs2sp"
prompt="Choose a region:"
options=("Western North America" "Eastern North America" "South America" "Western Europe" "Eastern Europe" "Africa" "Asia" "Oceania")

nae_clusters="atl iad mmi1 mny1 ord"
naw_clusters="eat dfw lax mdf1 msa1 msj1 msl1 sea"
euw_clusters="ams fra lhr mad mlx1 mst1i par"
eue_clusters="sto sto2 vie waw"
sa_clusters="eze gru lim scl"
as_clusters="bom can canm cant canu dxb hkg maa mhk1 pwg pwj pwui pww pwz seo sgp sha sham shat shau shb tsn tsnm tsnt tsnu tyoi tyo1"
af_clusters="jnb"
oc_clusters="syd"

clusters=$(curl -s $api_url | jq -r '.pops | keys[] as $k | "[\($k | @sh),\(.[$k])]"' | tr "'" '"')

while opt=$(zenity --title="$title" --text="$prompt" --list  --column="Regions" "${options[@]}"); do
    case "$opt" in
    "${options[0]}") selected_clusters=$naw_clusters ;;
    "${options[1]}") selected_clusters=$nae_clusters ;;
    "${options[2]}") selected_clusters=$sa_clusters ;;
    "${options[3]}") selected_clusters=$euw_clusters ;;
    "${options[4]}") selected_clusters=$eue_clusters ;;
    "${options[5]}") selected_clusters=$af_clusters ;;
    "${options[6]}") selected_clusters=$as_clusters ;;
    "${options[8]}") selected_clusters=$oc_clusters ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done > /dev/null 2>&1

for cluster in $selected_clusters
do
  if [ "$action" = "block" ]
  then
    handle_cluster "$cluster" "block"
  else
    handle_cluster "$cluster" "unblock"
  fi
done
