#!/bin/bash
echo "Testing function sourcing..."
cd /mnt/f/Downloads/CUET-Library-Management-System
echo "Current dir: $(pwd)"
echo "Sourcing clearance.sh..."
source clearance.sh
echo "Trying to call approve_clearance..."
declare -F approve_clearance
echo "Calling view_clearance_requests..."
type view_clearance_requests
