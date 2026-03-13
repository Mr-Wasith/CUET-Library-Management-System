BOOK_FILE="database/books.txt"

availability_alert() {

echo ""
echo "====== LOW STOCK BOOK ALERT ======"
echo ""

found=0

while IFS="|" read -r id name author total available
do

available=$(echo "$available" | tr -d '\r')

if [ "$available" -le 2 ]; then
printf "%-30s | Available: %d\n" "$name" "$available"
found=1
fi

done < "$BOOK_FILE"

if [ $found -eq 0 ]; then
echo "All books are sufficiently available."
fi

}