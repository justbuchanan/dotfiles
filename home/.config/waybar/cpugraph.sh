#!/usr/bin/env bash

# Displays a "bar graph" showing current utilization of each cpu core

set -e

while true; do
    gopsuinfo -c g -d "100ms" -t
done
