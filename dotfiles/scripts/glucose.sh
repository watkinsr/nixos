#!/usr/bin/env bash
set -euo pipefail

GLUCOSE=$(hass-cli --output=json state get sensor.blood_sugar | jq .[].state | sed 's/\"//g' | awk '{print "scale=1;" $1 "/18.1818181818"}' | bc)
echo "$GLUCOSE mmol/l"
