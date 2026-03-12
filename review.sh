REVIEW_FILE="database/reviews.txt"
BOOK_FILE="database/books.txt"

write_review() {

    read -p "Book ID: " bid
    read -p "Rating (1-5): " rating
    read -p "Write Review: " review

    if grep -q "^$CURRENT_STUDENT|$bid|" "$REVIEW_FILE"; then
        echo "You already reviewed this book!"
        return
    fi

    echo "$CURRENT_STUDENT|$bid|$rating|$review" >> "$REVIEW_FILE"

    echo "Review added successfully!"

}
#admin
view_reviews() {

    if [ ! -s "$REVIEW_FILE" ]; then
        echo "No reviews available."
        return
    fi

    echo ""
    echo "====== BOOK REVIEWS ======"
    echo "StudentID | Book Name | Rating | Review"
    echo "----------------------------------------"

    while IFS="|" read student book rating review
    do
        book_name=$(awk -F'|' -v id="$book" '$1==id {print $2}' "$BOOK_FILE")

        echo "$student | $book_name | $rating / 5 | $review"

    done < "$REVIEW_FILE"
}
# student can only see their own reviews 
my_reviews() {

    echo "====== MY REVIEWS ======"

    result=$(grep "^$CURRENT_STUDENT|" "$REVIEW_FILE")

    if [ -z "$result" ]; then
        echo "No reviews found."
    else
        echo "StudentID | BookID | Rating | Review"
        echo "$result"
    fi

}
# delete review(admin)
delete_review() {

    read -p "Student ID: " sid
    read -p "Book ID: " bid

    awk -F'|' -v s="$sid" -v b="$bid" '
    !( $1==s && $2==b )
    ' "$REVIEW_FILE" > temp && mv temp "$REVIEW_FILE"

    echo "Review deleted successfully!"

}