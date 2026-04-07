#!/bin/bash
source auth.sh
source clearance.sh
# Quick test
echo "Testing if functions are available:"
type approve_clearance 2>&1 | head -1
type view_clearance_requests 2>&1 | head -1  
type reject_clearance 2>&1 | head -1
