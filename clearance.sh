CLEARANCE_FILE="database/clearance.txt"
BORROW_FILE="database/borrow.txt"

apply_clearance() {

    echo ""
    echo "====== APPLY FOR CLEARANCE ======"

    found=0
    while IFS="|" read sid status
    do
        if [ "$sid" = "$CURRENT_STUDENT" ]; then
            found=1
            if [ "$status" = "Approved" ]; then
                echo "Your clearance is already APPROVED!"
            else
                echo "You already applied. Current Status: $status"
            fi
            return
        fi
    done < "$CLEARANCE_FILE"

    unreturned=0
    while IFS="|" read sid bid bdate ddate status
    do
        if [ "$sid" = "$CURRENT_STUDENT" ] && [ "$status" = "Borrowed" ]; then
            unreturned=1
        fi
    done < "$BORROW_FILE"

    if [ "$unreturned" -eq 1 ]; then
        echo "Cannot apply! You have unreturned books."
        echo "Please return all books first."
        return
    fi

    echo "$CURRENT_STUDENT|Pending" >> "$CLEARANCE_FILE"
    echo "Clearance application submitted!"
    echo "Please wait for admin approval."
}

check_clearance_status() {

    echo ""
    echo "====== MY CLEARANCE STATUS ======"

    found=0
    while IFS="|" read sid status
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
    while IFS="|" read sid status
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
    while IFS="|" read s status
    do
        if [ "$s" = "$sid" ]; then
            found=1
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No request found for Student: $sid"
        return
    fi

    while IFS="|" read s status
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
    while IFS="|" read s status
    do
        if [ "$s" = "$sid" ]; then
            found=1
        fi
    done < "$CLEARANCE_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No request found for Student: $sid"
        return
    fi

    while IFS="|" read s status
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