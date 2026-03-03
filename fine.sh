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

    found=0

    while IFS='|' read sid bid bdate ddate status
    do
        if [ "$sid" = "$CURRENT_STUDENT" ] && [ "$status" = "Borrowed" ]; then
            fine=$(calculate_fine "$ddate")

            if [ "$fine" -gt 0 ]; then
                echo "Book: $bid | Fine: $fine"
                found=1
            fi
        fi
    done < "$BORROW_FILE"

    if [ $found -eq 0 ]; then
        echo "No dues found."
    fi
}

admin_overdue_list() {

    found=0

    while IFS='|' read sid bid bdate ddate status
    do
        if [ "$status" = "Borrowed" ]; then
            fine=$(calculate_fine "$ddate")

            if [ "$fine" -gt 0 ]; then
                echo "Student: $sid | Book: $bid | Fine: $fine"
                found=1
            fi
        fi
    done < "$BORROW_FILE"

    if [ $found -eq 0 ]; then
        echo "No overdue books found."
    fi
}