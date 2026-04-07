CLEARANCE_FILE="database/clearance.txt"
BORROW_FILE="database/borrow.txt"

apply_clearance() {
    echo ""
    echo "====== APPLY FOR CLEARANCE ======"

    # 1. Check for Borrowed Books FIRST
    has_borrowed_books=0

    if [ -f "$BORROW_FILE" ]; then
        # Format: sid|bid|bdate|ddate|status
        while IFS="|" read -r sid bid bdate ddate status
        do
            if [ "$sid" = "$CURRENT_STUDENT" ] && [ "$status" = "Borrowed" ]; then
                has_borrowed_books=1
                break
            fi
        done < "$BORROW_FILE"
    fi

    # 2. Block if any borrowed books exist
    if [ "$has_borrowed_books" -eq 1 ]; then
        echo "Return the book first"
        return
    fi

    # 3. Check if the student has already applied or is already approved
    if [ -f "$CLEARANCE_FILE" ]; then
        while IFS="|" read -r sid status
        do
            if [ "$sid" = "$CURRENT_STUDENT" ]; then
                if [ "$status" = "Approved" ]; then
                    echo "Your clearance is already APPROVED!"
                else
                    echo "You already applied. Current Status: $status"
                fi
                return
            fi
        done < "$CLEARANCE_FILE"
    fi

    # 4. If all checks pass, submit the request
    echo "$CURRENT_STUDENT|Pending" >> "$CLEARANCE_FILE"
    echo "Clearance application submitted!"
    echo "Please wait for admin approval."
}

check_clearance_status() {
    echo ""
    echo "====== MY CLEARANCE STATUS ======"

    found=0
    while IFS="|" read -r sid status
    do
        if [ "$sid" = "$CURRENT_STUDENT" ]; then
            found=1
            echo "Student ID : $sid"
            echo "Status     : $status"

            if [ "$status" = "Approved" ]; then
                echo ""
                echo "CLEARANCE ACCEPTED! You are cleared."
            elif [ "$status" = "Rejected" ]; then
                echo "Your clearance was rejected. Contact admin."
            else
                echo "Your clearance is still pending."
            fi
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "You have not applied for clearance yet."
    fi

    echo "================================="
}

view_clearance_requests() {
    echo ""
    echo "====== CLEARANCE REQUESTS ======"
    echo ""
    echo "StudentID | Status"
    echo "--------------------"

    found=0
    while IFS="|" read -r sid status
    do
        if [ -n "$sid" ]; then
            echo "$sid | $status"
            found=1
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No clearance requests found."
    fi

    echo ""
}

approve_clearance() {
    view_clearance_requests

    read -p "Enter Student ID to approve: " sid

    found=0
    while IFS="|" read -r s status
    do
        if [ "$s" = "$sid" ]; then
            found=1
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No request found for Student: $sid"
        return
    fi

    while IFS="|" read -r s status
    do
        if [ "$s" = "$sid" ]; then
            echo "$s|Approved"
        else
            echo "$s|$status"
        fi
    done < "$CLEARANCE_FILE" > temp.txt

    mv temp.txt "$CLEARANCE_FILE"

    echo "Clearance APPROVED for Student: $sid"
}

reject_clearance() {
    view_clearance_requests

    read -p "Enter Student ID to reject: " sid

    found=0
    while IFS="|" read -r s status
    do
        if [ "$s" = "$sid" ]; then
            found=1
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No request found for Student: $sid"
        return
    fi

    while IFS="|" read -r s status
    do
        if [ "$s" = "$sid" ]; then
            echo "$s|Rejected"
        else
            echo "$s|$status"
        fi
    done < "$CLEARANCE_FILE" > temp.txt

    mv temp.txt "$CLEARANCE_FILE"

    echo "Clearance REJECTED for Student: $sid"
}