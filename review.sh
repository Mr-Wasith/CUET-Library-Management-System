REVIEW_FILE="database/reviews.txt"
BOOK_FILE="database/books.txt"

write_review() {

    read -p "Book ID: " bid
    read -p "Rating (1-5): " rating
    read -p "Write Review: " review

    # Append review to file
    printf "%s|%s|%s|%s\n" "$CURRENT_STUDENT" "$bid" "$rating" "$review" >> "$REVIEW_FILE"

    echo "Review and Rating Added Successfully!"
}

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