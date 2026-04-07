#!/bin/bash
CURRENT_STUDENT=2204024
BORROW_FILE="database/borrow.txt"
has_borrowed_books=0

echo "Testing borrowed books detection for student: $CURRENT_STUDENT"

while IFS="|" read -r sid bid bdate ddate status
do
    if [ "$sid" = "$CURRENT_STUDENT" ] && [ "$status" = "Borrowed" ]; then
        has_borrowed_books=1
        echo "FOUND: Student $sid has borrowed book $bid (status: $status)"
        break
    fi
done < "$BORROW_FILE"

echo "Final result: has_borrowed_books=$has_borrowed_books"
if [ "$has_borrowed_books" -eq 1 ]; then
    echo "STATUS: Should show 'Return the book first'"
else
    echo "STATUS: Would check for already applied"
fi
