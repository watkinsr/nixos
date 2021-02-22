#!/usr/bin/env bash
set -euo pipefail

hass-cli --output=json state get weather.home | jq .[].attributes.temperature
