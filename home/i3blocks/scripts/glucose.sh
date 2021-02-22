#!/usr/bin/env bash
set -euo pipefail

GLUCOSE=$(hass-cli --output=json state get sensor.blood_sugar | jq .[].state | sed 's/\"//g' | awk '{str1 = "scale=1;"; str3 = "/18.1818181818"; str1 str2 str3}')
echo $GLUCOSE
