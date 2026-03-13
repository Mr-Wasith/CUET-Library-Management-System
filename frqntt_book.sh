BOOK_FILE="database/books.txt"
BORROW_FILE="database/borrow.txt"

frqntt_books() {

echo ""
echo "====== FREQUENTLY BORROWED BOOKS ======"
echo ""

awk -F'|' '{count[$2]++}
END{
for(book in count)
print book "|" count[book]
}' "$BORROW_FILE" | sort -t'|' -k2 -nr | while IFS="|" read bid total
do

name=$(awk -F'|' -v id="$bid" '$1==id {print $2}' "$BOOK_FILE")

printf "%-30s (%d times)\n" "$name" "$total"

done

}