#!/bin/bash
cd "$(dirname "$0")/database"
for file in *.txt; do
    if [ -f "$file" ]; then
        tr -d '\r' < "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
        echo "Fixed: $file"
    fi
done
echo "All database files converted to LF"
