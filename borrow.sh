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
    due=$(date -d "+30 days" +%F)

    echo "$CURRENT_STUDENT|$bid|$today|$due|Borrowed" >> "$BORROW_FILE"
    echo "$CURRENT_STUDENT borrowed $bid on $today" >> "$HISTORY_FILE"

    awk -F'|' -v id="$bid" \
    'BEGIN{OFS="|"} $1==id{$5--}1' \
    "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "Book Borrowed!"
}

return_book() {
    read -p "Book ID: " bid

    today=$(date +%F)

    awk -F'|' -v sid="$CURRENT_STUDENT" -v bid="$bid" -v today="$today" \
    'BEGIN{OFS="|"} $1==sid && $2==bid && $5=="Borrowed" {$5="Returned"}1' \
    "$BORROW_FILE" > temp && mv temp "$BORROW_FILE"

    awk -F'|' -v id="$bid" \
    'BEGIN{OFS="|"} $1==id{$5++}1' \
    "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "$CURRENT_STUDENT returned $bid on $today" >> "$HISTORY_FILE"

    echo "Book Returned!"
}

view_borrowed_books() {
    grep "^$CURRENT_STUDENT|" "$BORROW_FILE"
}