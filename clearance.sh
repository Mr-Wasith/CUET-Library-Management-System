CLEARANCE_FILE="database/clearance.txt"
BORROW_FILE="database/borrow.txt"
BOOK_FILE="database/books.txt"

apply_clearance() {

    echo "----- Clearance Check -----"

    borrowed_count=$(awk -F'|' -v sid="$CURRENT_STUDENT" '$1==sid && $5=="Borrowed" {count++} END {print count+0}' "$BORROW_FILE")

    if [ "$borrowed_count" -ne 0 ]; then
        echo ""
        echo "You cannot apply for clearance now."
        echo "Return the following books first:"
        echo ""

        awk -F'|' -v sid="$CURRENT_STUDENT" -v bookfile="$BOOK_FILE" '
        $1==sid && $5=="Borrowed" {
            title="Unknown"
            while ((getline line < bookfile) > 0) {
                split(line, b, "|")
                if (b[1]==$2) {
                    title=b[2]
                    break
                }
            }
            close(bookfile)
            printf "BookID: %s | Title: %s | Borrowed On: %s | Due: %s\n", $2, title, $3, $4
        }
        ' "$BORROW_FILE"
        return
    fi

    existing_status=$(awk -F'|' -v sid="$CURRENT_STUDENT" '$1==sid {print $2; exit}' "$CLEARANCE_FILE")

    if [ "$existing_status" = "Pending" ]; then
        echo "You already have a pending clearance request."
        return
    fi

    if [ "$existing_status" = "Approved" ]; then
        echo "Your clearance is already approved."
        return
    fi

    if [ "$existing_status" = "Rejected" ]; then
        awk -F'|' -v sid="$CURRENT_STUDENT" '
        BEGIN{OFS="|"}
        $1==sid {$2="Pending"}
        {print}
        ' "$CLEARANCE_FILE" > temp.txt && mv temp.txt "$CLEARANCE_FILE"
    else
        echo "$CURRENT_STUDENT|Pending" >> "$CLEARANCE_FILE"
    fi

    echo "Clearance request submitted. Wait for admin approval."
    echo "$CURRENT_STUDENT applied for library clearance" >> "$HISTORY_FILE"
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