REVIEW_FILE="database/reviews.txt"
BOOK_FILE="database/books.txt"

# Students get recommended books based on high ratings.

recommend_books() {

echo "====== RECOMMENDED BOOKS ======"

awk -F'|' '
{
sum[$2]+=$3
count[$2]++
}
END{
for(book in sum){
avg=sum[book]/count[book]
if(avg>=4)
print book "|" avg
}
}' "$REVIEW_FILE" | while IFS="|" read bid avg
do
book_name=$(awk -F'|' -v id="$bid" '$1==id {print $2}' "$BOOK_FILE")

echo "Book: $book_name"
printf "Average Rating: %.2f / 5\n" "$avg"
echo "---------------------"
done

}