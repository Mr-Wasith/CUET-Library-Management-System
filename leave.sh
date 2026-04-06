#!/bin/bash

# Leave Management System for Admins

LEAVE_FILE="database/leave.txt"
APPROVER_FILE="database/leave_approver.txt"

# Create leave file if it doesn't exist
if [ ! -f "$LEAVE_FILE" ]; then
    touch "$LEAVE_FILE"
fi

# Create approver file if it doesn't exist
if [ ! -f "$APPROVER_FILE" ]; then
    echo "" > "$APPROVER_FILE"  # Empty by default, no approver set yet
fi

# Function to get the authorized approver
get_approver() {
    if [ -f "$APPROVER_FILE" ]; then
        cat "$APPROVER_FILE"
    else
        echo ""
    fi
}

# Function to set a new approver (admin only)
set_leave_approver() {
    echo ""
    echo "========== SET LEAVE APPROVER =========="

    read -p "Enter the admin username who will approve/reject leaves: " approver_username

    if [ -z "$approver_username" ]; then
        echo "Error: Admin username cannot be empty"
        echo "========================================"
        echo ""
        return 1
    fi

    echo "$approver_username" > "$APPROVER_FILE"

    echo "Leave approver set to: $approver_username"
    echo "========================================"
    echo ""
    return 0
}

# Function to apply for leave
apply_for_leave() {
    echo ""
    echo "========== APPLY FOR LEAVE =========="

    read -p "Enter your username: " admin_username
    read -p "Enter leave reason: " reason
    read -p "Enter start date (DD-MM-YYYY): " start_date
    read -p "Enter end date (DD-MM-YYYY): " end_date

    # Get current timestamp
    current_date=$(date '+%Y-%m-%d %H:%M:%S')

    # Default status is pending
    status="Pending"

    # Append to leave file with empty approved_by and approval_date
    echo "$admin_username|$reason|$start_date|$end_date|$status|$current_date||" >> "$LEAVE_FILE"

    echo ""
    echo "Leave application submitted successfully!"
    echo "Status: Pending (Awaiting approval)"
    echo "====================================="
    echo ""
}

# Function to view all leave applications
view_all_leaves() {
    echo ""
    echo "========== ALL LEAVE APPLICATIONS =========="

    if [ ! -s "$LEAVE_FILE" ]; then
        echo "No leave applications found"
        echo "=========================================="
        echo ""
        return
    fi

    found=0
    while IFS='|' read admin_username reason start_date end_date status applied_date approved_by approval_date
    do
        echo "Admin Username: $admin_username"
        echo "Reason: $reason"
        echo "Period: $start_date to $end_date"
        echo "Status: $status"
        echo "Applied Date: $applied_date"
        if [ ! -z "$approved_by" ]; then
            echo "Approved By: $approved_by"
            echo "Approval Date: $approval_date"
        fi
        echo "---"
        found=1
    done < "$LEAVE_FILE"

    if [ $found -eq 0 ]; then
        echo "No leave applications found"
    fi

    echo "=========================================="
    echo ""
}

# Function to view pending leave applications
view_pending_leaves() {
    echo ""
    echo "========== PENDING LEAVE APPLICATIONS =========="

    if [ ! -s "$LEAVE_FILE" ]; then
        echo "No leave applications found"
        echo "=============================================="
        echo ""
        return
    fi

    found=0
    while IFS='|' read admin_username reason start_date end_date status applied_date approved_by approval_date
    do
        if [ "$status" = "Pending" ]; then
            echo "Admin Username: $admin_username"
            echo "Reason: $reason"
            echo "Period: $start_date to $end_date"
            echo "Applied Date: $applied_date"
            echo "---"
            found=1
        fi
    done < "$LEAVE_FILE"

    if [ $found -eq 0 ]; then
        echo "No pending leave applications"
    fi

    echo "=============================================="
    echo ""
}

# Function to approve leave
approve_leave() {
    echo ""
    echo "========== APPROVE LEAVE =========="

    # Check if user has permission to approve
    approver=$(get_approver)

    if [ -z "$approver" ]; then
        echo "Error: No approver has been set yet!"
        echo "===================================="
        echo ""
        return 1
    fi

    read -p "Enter your username: " current_admin

    if [ "$current_admin" != "$approver" ]; then
        echo "Error: Only '$approver' has permission to approve leave!"
        echo "===================================="
        echo ""
        return 1
    fi

    # Verify password
    read -sp "Enter your password: " admin_password
    echo ""

    ADMIN_FILE="database/admin.txt"
    if ! awk -F'|' -v u="$current_admin" -v p="$admin_password" '$1==u && $2==p' "$ADMIN_FILE" | grep -q .; then
        echo "Error: Incorrect password!"
        echo "===================================="
        echo ""
        return 1
    fi

    read -p "Enter username to approve: " admin_username

    if [ ! -s "$LEAVE_FILE" ]; then
        echo "No leave applications found"
        echo "===================================="
        echo ""
        return
    fi

    found=0
    updated=0
    temp_file=$(mktemp)
    approval_timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    while IFS='|' read aid reason start_date end_date status applied_date approved_by approval_date
    do
        if [ "$aid" = "$admin_username" ] && [ "$status" = "Pending" ] && [ $updated -eq 0 ]; then
            echo "$aid|$reason|$start_date|$end_date|Approved|$applied_date|$current_admin|$approval_timestamp" >> "$temp_file"
            found=1
            updated=1
            echo "Leave approved successfully!"
        else
            echo "$aid|$reason|$start_date|$end_date|$status|$applied_date|$approved_by|$approval_date" >> "$temp_file"
        fi
    done < "$LEAVE_FILE"

    if [ $found -eq 0 ]; then
        echo "No pending leave found for username: $admin_username"
    fi

    mv "$temp_file" "$LEAVE_FILE"
    echo "===================================="
    echo ""
}

# Function to reject leave
reject_leave() {
    echo ""
    echo "========== REJECT LEAVE =========="

    # Check if user has permission to reject
    approver=$(get_approver)

    if [ -z "$approver" ]; then
        echo "Error: No approver has been set yet!"
        echo "==================================="
        echo ""
        return 1
    fi

    read -p "Enter your username: " current_admin

    if [ "$current_admin" != "$approver" ]; then
        echo "Error: Only '$approver' has permission to reject leave!"
        echo "==================================="
        echo ""
        return 1
    fi

    # Verify password
    read -sp "Enter your password: " admin_password
    echo ""

    ADMIN_FILE="database/admin.txt"
    if ! awk -F'|' -v u="$current_admin" -v p="$admin_password" '$1==u && $2==p' "$ADMIN_FILE" | grep -q .; then
        echo "Error: Incorrect password!"
        echo "==================================="
        echo ""
        return 1
    fi

    read -p "Enter username to reject: " admin_username

    if [ ! -s "$LEAVE_FILE" ]; then
        echo "No leave applications found"
        echo "==================================="
        echo ""
        return
    fi

    found=0
    updated=0
    temp_file=$(mktemp)
    rejection_timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    while IFS='|' read aid reason start_date end_date status applied_date approved_by approval_date
    do
        if [ "$aid" = "$admin_username" ] && [ "$status" = "Pending" ] && [ $updated -eq 0 ]; then
            echo "$aid|$reason|$start_date|$end_date|Rejected|$applied_date|$current_admin|$rejection_timestamp" >> "$temp_file"
            found=1
            updated=1
            echo "Leave rejected successfully!"
        else
            echo "$aid|$reason|$start_date|$end_date|$status|$applied_date|$approved_by|$approval_date" >> "$temp_file"
        fi
    done < "$LEAVE_FILE"

    if [ $found -eq 0 ]; then
        echo "No pending leave found for username: $admin_username"
    fi

    mv "$temp_file" "$LEAVE_FILE"
    echo "==================================="
    echo ""
}

# Function to view my leaves (for admin)
view_my_leaves() {
    admin_username=$1
    echo ""
    echo "========== MY LEAVE APPLICATIONS =========="

    if [ ! -s "$LEAVE_FILE" ]; then
        echo "No leave applications found"
        echo "=========================================="
        echo ""
        return
    fi

    found=0
    while IFS='|' read aid reason start_date end_date status applied_date approved_by approval_date
    do
        if [ "$aid" = "$admin_username" ]; then
            echo "Reason: $reason"
            echo "Period: $start_date to $end_date"
            echo "Status: $status"
            echo "Applied Date: $applied_date"
            if [ ! -z "$approved_by" ]; then
                echo "Approved By: $approved_by"
                echo "Approval Date: $approval_date"
            fi
            echo "---"
            found=1
        fi
    done < "$LEAVE_FILE"

    if [ $found -eq 0 ]; then
        echo "No leave applications from you"
    fi

    echo "=========================================="
    echo ""
}
