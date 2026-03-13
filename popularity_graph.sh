BOOK_FILE="database/books.txt"
BORROW_FILE="database/borrow.txt"

popularity_graph() {

echo ""
echo "====== BOOK POPULARITY GRAPH ======"
echo ""

awk -F'|' '{count[$2]++}
END{
for(book in count)
print book "|" count[book]
}' "$BORROW_FILE" | sort -t'|' -k2 -nr | while IFS="|" read bid total
do

name=$(awk -F'|' -v id="$bid" '$1==id {print $2}' "$BOOK_FILE")

printf "%-30s " "$name"

for ((i=0;i<total;i++))
do
printf "█"
done

echo " ($total)"

done

}