BOOK_FILE="database/books.txt"
BORROW_FILE="database/borrow.txt"
HISTORY_FILE="database/history.txt"
MAX_BORROW=3

show_available_books_for_borrow() {
    echo "ID | Title | Author | Available"
    awk -F'|' '{gsub(/\r/, "", $5)} $5>0 {print $1" | "$2" | "$3" | "$5}' "$BOOK_FILE"
}

borrow_book() {

      current_count=$(awk -F'|' -v sid="$CURRENT_STUDENT" '
$1==sid && $5=="Borrowed" {count++}
END{print count+0}' "$BORROW_FILE")

if [ "$current_count" -ge "$MAX_BORROW" ]; then
    echo "Borrow limit reached! (Max: $MAX_BORROW books)"
    return
fi

    echo ""
    echo "Available books to request:"
    show_available_books_for_borrow
    echo ""

    read -p "Book ID: " bid
    bid=$(echo "$bid" | tr -d '\r' | xargs)

    available=$(awk -F'|' -v id="$bid" '$1==id {gsub(/\r/, "", $5); print $5; exit}' "$BOOK_FILE")

    if ! echo "$available" | grep -Eq '^[0-9]+$'; then
        echo "Book not available!"
        return
    fi

    if [ -z "$available" ] || [ "$available" -le 0 ]; then
        echo "Book not available!"
        return
    fi

    existing=$(awk -F'|' -v sid="$CURRENT_STUDENT" -v bid="$bid" '
    $1==sid && $2==bid && ($5=="Borrowed" || $5=="Pending") {print 1; exit}
    ' "$BORROW_FILE")

    if [ "$existing" = "1" ]; then
        echo "You already have a pending/active request for this book."
        return
    fi

    today=$(date +%F)

    echo "$CURRENT_STUDENT|$bid|$today|NA|Pending" >> "$BORROW_FILE"
    echo "$CURRENT_STUDENT requested Book $bid on $today" >> "$HISTORY_FILE"

    echo "Borrow request submitted. Wait for admin approval."
}

return_book() {
    borrowed_now=$(awk -F'|' -v sid="$CURRENT_STUDENT" '
    $1==sid && $5=="Borrowed" {print $2"|"$3"|"$4}
    ' "$BORROW_FILE")

    if [ -z "$borrowed_now" ]; then
        echo "You do not have any borrowed books to return."
        return
    fi

    echo ""
    echo "Your currently borrowed books:"
    echo "BookID | Title | Borrowed On | Due Date"
    echo "----------------------------------------"
    while IFS='|' read -r bid bdate ddate
    do
        title=$(awk -F'|' -v id="$bid" '$1==id {print $2; exit}' "$BOOK_FILE")
        if [ -z "$title" ]; then
            title="Unknown"
        fi
        echo "$bid | $title | $bdate | $ddate"
    done <<EOF
$borrowed_now
EOF

    read -p "Book ID(s) (space/comma separated): " bid_input

    bid_input=$(echo "$bid_input" | tr ',' ' ' | tr -d '\r')
    if [ -z "$(echo "$bid_input" | xargs)" ]; then
        echo "No Book ID provided."
        return
    fi

    today=$(date +%F)
    success_count=0
    failed_count=0

    for bid in $bid_input
    do
        bid=$(echo "$bid" | xargs)

        if ! echo "$bid" | grep -Eq '^[0-9]+$'; then
            echo "Invalid Book ID: $bid"
            failed_count=$((failed_count + 1))
            continue
        fi

        awk -F'|' -v sid="$CURRENT_STUDENT" -v bid="$bid" '
        BEGIN{OFS="|"; done=0}
        $1==sid && $2==bid && $5=="Borrowed" && done==0 {
            $5="Returned"
            done=1
        }
        {print}
        END{if(done==0) exit 1}
        ' "$BORROW_FILE" > temp

        if [ $? -ne 0 ]; then
            rm -f temp
            echo "No active borrowed record found for Book ID: $bid"
            failed_count=$((failed_count + 1))
            continue
        fi

        mv temp "$BORROW_FILE"

        awk -F'|' -v id="$bid" '
        BEGIN{OFS="|"; done=0}
        $1==id && done==0 {$5++; done=1}
        {print}
        ' "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

        echo "$CURRENT_STUDENT returned Book $bid on $today" >> "$HISTORY_FILE"
        echo "Returned Book ID: $bid"
        success_count=$((success_count + 1))
    done

    echo "Return summary -> Success: $success_count, Failed: $failed_count"
}

view_borrowed_books() {

    result=$(grep "^$CURRENT_STUDENT|" "$BORROW_FILE")

    if [ -z "$result" ]; then
        echo "No borrowed books found."
    else
        echo "StudentID | BookID | BorrowDate | DueDate | Status"
        echo "$result"
    fi
}

admin_view_borrowed_books() {
    found=0

    echo "StudentID | BookID | BorrowDate | DueDate | Status"
    echo "===================================================="

    while IFS='|' read sid bid bdate ddate status
    do
        if [ "$status" = "Borrowed" ]; then
            echo "$sid | $bid | $bdate | $ddate | $status"
            found=1
        fi
    done < "$BORROW_FILE"

    if [ $found -eq 0 ]; then
        echo "No borrowed books found."
    fi
}

view_borrow_requests() {
    found=0

    echo "StudentID | BookID | RequestDate | Status"
    echo "========================================="

    while IFS='|' read sid bid bdate ddate status
    do
        if [ "$status" = "Pending" ]; then
            echo "$sid | $bid | $bdate | $status"
            found=1
        fi
    done < "$BORROW_FILE"

    if [ $found -eq 0 ]; then
        echo "No pending borrow requests."
    fi
}

approve_borrow_request() {
    view_borrow_requests

    read -p "Enter Student ID to approve: " sid
    read -p "Enter Book ID to approve: " bid
    bid=$(echo "$bid" | tr -d '\r' | xargs)

    has_request=$(awk -F'|' -v sid="$sid" -v bid="$bid" '
    $1==sid && $2==bid && $5=="Pending" {print 1; exit}
    ' "$BORROW_FILE")

    if [ "$has_request" != "1" ]; then
        echo "No matching pending request found."
        return
    fi

    available=$(awk -F'|' -v id="$bid" '$1==id {gsub(/\r/, "", $5); print $5; exit}' "$BOOK_FILE")
    if ! echo "$available" | grep -Eq '^[0-9]+$'; then
        echo "Book is no longer available."
        return
    fi

    if [ -z "$available" ] || [ "$available" -le 0 ]; then
        echo "Book is no longer available."
        return
    fi

    today=$(date +%F)
    due=$(date -d "+7 days" +%F)

    awk -F'|' -v sid="$sid" -v bid="$bid" -v today="$today" -v due="$due" '
    BEGIN{OFS="|"; done=0}
    $1==sid && $2==bid && $5=="Pending" && done==0 {
        $3=today; $4=due; $5="Borrowed"; done=1
    }
    {print}
    ' "$BORROW_FILE" > temp && mv temp "$BORROW_FILE"

    awk -F'|' -v id="$bid" '
    BEGIN{OFS="|"}
    $1==id {$5--}
    {print}
    ' "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "$sid borrow request approved for Book $bid on $today" >> "$HISTORY_FILE"
    echo "Borrow request approved."
}

reject_borrow_request() {
    view_borrow_requests

    read -p "Enter Student ID to reject: " sid
    read -p "Enter Book ID to reject: " bid

    has_request=$(awk -F'|' -v sid="$sid" -v bid="$bid" '
    $1==sid && $2==bid && $5=="Pending" {print 1; exit}
    ' "$BORROW_FILE")

    if [ "$has_request" != "1" ]; then
        echo "No matching pending request found."
        return
    fi

    awk -F'|' -v sid="$sid" -v bid="$bid" '
    BEGIN{OFS="|"; done=0}
    $1==sid && $2==bid && $5=="Pending" && done==0 {$5="Rejected"; done=1}
    {print}
    ' "$BORROW_FILE" > temp && mv temp "$BORROW_FILE"

    today=$(date +%F)
    echo "$sid borrow request rejected for Book $bid on $today" >> "$HISTORY_FILE"
    echo "Borrow request rejected."
}