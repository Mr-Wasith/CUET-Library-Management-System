#!/bin/bash

# Noticeboard System

NOTICEBOARD_FILE="database/noticeboard.txt"

# Create noticeboard file if it doesn't exist
if [ ! -f "$NOTICEBOARD_FILE" ]; then
    touch "$NOTICEBOARD_FILE"
fi

# Function to post a notice
post_notice() {
    echo ""
    echo "========== POST NOTICE =========="

    read -p "Enter poster username (admin/staff): " poster_username
    read -p "Enter notice title: " title
    read -p "Enter notice content: " content

    # Get current timestamp
    posted_date=$(date '+%Y-%m-%d %H:%M:%S')
    notice_id=$(date +%s)  # Use timestamp as unique ID

    # Append to noticeboard file
    echo "$notice_id|$poster_username|$title|$content|$posted_date" >> "$NOTICEBOARD_FILE"

    echo ""
    echo "Notice posted successfully!"
    echo "================================"
    echo ""
}

# Function to view all notices
view_all_notices() {
    echo ""
    echo "========== NOTICEBOARD =========="

    if [ ! -s "$NOTICEBOARD_FILE" ]; then
        echo "No notices posted yet"
        echo "================================"
        echo ""
        return
    fi

    found=0
    # Display notices in reverse chronological order (newest first)
    while IFS='|' read notice_id poster_username title content posted_date
    do
        echo "Title: $title"
        echo "Posted by: $poster_username"
        echo "Date: $posted_date"
        echo "Content: $content"
        echo "---"
        found=1
    done < <(tac "$NOTICEBOARD_FILE")

    if [ $found -eq 0 ]; then
        echo "No notices to display"
    fi

    echo "================================"
    echo ""
}

# Function to view recent notices (last 5)
view_recent_notices() {
    echo ""
    echo "========== RECENT NOTICES =========="

    if [ ! -s "$NOTICEBOARD_FILE" ]; then
        echo "No notices posted yet"
        echo "===================================="
        echo ""
        return
    fi

    count=0
    while IFS='|' read notice_id poster_username title content posted_date
    do
        if [ $count -lt 5 ]; then
            echo "Title: $title"
            echo "Posted by: $poster_username"
            echo "Date: $posted_date"
            echo "Content: $content"
            echo "---"
            ((count++))
        fi
    done < <(tac "$NOTICEBOARD_FILE")

    if [ $count -eq 0 ]; then
        echo "No notices to display"
    fi

    echo "===================================="
    echo ""
}

# Function to delete a notice (admin only)
delete_notice() {
    echo ""
    echo "========== DELETE NOTICE =========="

    if [ ! -s "$NOTICEBOARD_FILE" ]; then
        echo "No notices to delete"
        echo "===================================="
        echo ""
        return
    fi

    echo "Notices:"
    line_num=0
    while IFS='|' read notice_id poster_username title content posted_date
    do
        ((line_num++))
        echo "$line_num. $title (Posted by: $poster_username)"
    done < "$NOTICEBOARD_FILE"

    read -p "Enter notice number to delete: " delete_num

    if ! [[ "$delete_num" =~ ^[0-9]+$ ]]; then
        echo "Invalid input"
        echo "===================================="
        echo ""
        return
    fi

    line_num=0
    temp_file=$(mktemp)

    while IFS='|' read notice_id poster_username title content posted_date
    do
        ((line_num++))
        if [ $line_num -ne $delete_num ]; then
            echo "$notice_id|$poster_username|$title|$content|$posted_date" >> "$temp_file"
        fi
    done < "$NOTICEBOARD_FILE"

    mv "$temp_file" "$NOTICEBOARD_FILE"
    echo "Notice deleted successfully!"
    echo "===================================="
    echo ""
}

# Function to search notices by keyword
search_notices() {
    echo ""
    echo "========== SEARCH NOTICES =========="

    read -p "Enter search keyword: " keyword

    if [ ! -s "$NOTICEBOARD_FILE" ]; then
        echo "No notices found"
        echo "===================================="
        echo ""
        return
    fi

    found=0
    while IFS='|' read notice_id poster_username title content posted_date
    do
        if [[ "$title" == *"$keyword"* ]] || [[ "$content" == *"$keyword"* ]]; then
            echo "Title: $title"
            echo "Posted by: $poster_username"
            echo "Date: $posted_date"
            echo "Content: $content"
            echo "---"
            found=1
        fi
    done < "$NOTICEBOARD_FILE"

    if [ $found -eq 0 ]; then
        echo "No notices found matching: $keyword"
    fi

    echo "===================================="
    echo ""
}
