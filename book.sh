BOOK_FILE="database/books.txt"

add_book() {
    read -p "Book ID: " id
    read -p "Title: " title
    read -p "Author: " author
    read -p "Quantity: " qty

    echo "$id|$title|$author|$qty|$qty" >> "$BOOK_FILE"
    echo "Book Added!"
}

remove_book() {
    read -p "Book ID to remove: " id
    grep -v "^$id|" "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"
    echo "Book Removed!"
}

update_book() {
    read -p "Book ID: " id
    read -p "New Quantity: " qty

    awk -F'|' -v id="$id" -v qty="$qty" \
    'BEGIN{OFS="|"} $1==id{$4=qty;$5=qty}1' \
    "$BOOK_FILE" > temp && mv temp "$BOOK_FILE"

    echo "Updated!"
}

view_books() {
    echo "ID | Title | Author | Total | Available"
    cat "$BOOK_FILE"
}

search_book() {
    read -p "Enter keyword: " key
    grep -i "$key" "$BOOK_FILE"
}