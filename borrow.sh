BOOK_FILE="database/books.txt"
BORROW_FILE="database/borrow.txt"
HISTORY_FILE="database/history.txt"

borrow_book() {
    read -p "Book ID: " bid

    available=$(awk -F'|' -v id="$bid" '$1==id {print $5}' "$BOOK_FILE")

    if [ -z "$available" ] || [ "$available" -le 0 ]; then
        echo "Book not available!"
        return
    fi

    today=$(date +%F)
    due=$(date -d "+7 days" +%F)

    echo "$CURRENT_STUDENT|$bid|$today|$due|Borrowed" >> "$BORROW_FILE"
    echo "$CURRENT_STUDENT borrowed Book $bid on $today" >> "$HISTORY_FILE"

    awk -F'|' -v id="$bid" \
    'BEGIN{OFS="|"} $1==id{$5--}1' \
    "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "Book Borrowed Successfully!"
}

return_book() {
    read -p "Book ID: " bid

    today=$(date +%F)

    updated=$(awk -F'|' -v sid="$CURRENT_STUDENT" -v bid="$bid" -v today="$today" '
    BEGIN{OFS="|"; found=0}
    $1==sid && $2==bid && $5=="Borrowed" {
        $5="Returned"
        found=1
    }
    {print}
    END{ if(found==0) exit 1 }
    ' "$BORROW_FILE" > temp)

    if [ $? -ne 0 ]; then
        echo "No such borrowed book found."
        rm -f temp
        return
    fi

    mv temp "$BORROW_FILE"

    awk -F'|' -v id="$bid" \
    'BEGIN{OFS="|"} $1==id{$5++}1' \
    "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "$CURRENT_STUDENT returned Book $bid on $today" >> "$HISTORY_FILE"

    echo "Book Returned Successfully!"
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