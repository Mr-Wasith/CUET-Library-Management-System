BORROW_FILE="database/borrow.txt"

calculate_fine() {
    due_date=$1

    today=$(date +%s)
    due=$(date -d "$due_date" +%s)

    diff=$(( (today - due) / 86400 ))

    if [ $diff -gt 0 ]; then
        echo $(( diff * 5 ))
    else
        echo 0
    fi
}

student_fine() {
    grep "^$CURRENT_STUDENT|" "$BORROW_FILE" | while IFS='|' read sid bid bdate ddate status
    do
        if [ "$status" = "Borrowed" ]; then
            fine=$(calculate_fine "$ddate")
            echo "Book: $bid | Fine: $fine"
        fi
    done
}

admin_overdue_list() {
    while IFS='|' read sid bid bdate ddate status
    do
        if [ "$status" = "Borrowed" ]; then
            fine=$(calculate_fine "$ddate")
            if [ "$fine" -gt 0 ]; then
                echo "Student: $sid Book: $bid Fine: $fine"
            fi
        fi
    done < "$BORROW_FILE"
}