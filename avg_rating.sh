REVIEW_FILE="database/reviews.txt"
BOOK_FILE="database/books.txt"


avg_rating() {

    echo ""
    echo "====== AVERAGE BOOK RATINGS ======"

    if [ ! -s "$REVIEW_FILE" ]; then
        echo "No ratings available."
        return
    fi

    awk -F'|' '
    {
        sum[$2] += $3
        count[$2]++
    }
    END {
        for (book in sum) {
            avg = sum[book] / count[book]
            printf "Book ID: %s | Average Rating: %.2f / 5 | Total Reviews: %d\n",
            book, avg, count[book]
        }
    }' "$REVIEW_FILE"
}


top_rated_book() {

    echo ""
    echo "====== TOP RATED BOOK ======"

    if [ ! -s "$REVIEW_FILE" ]; then
        echo "No ratings available."
        return
    fi

    awk -F'|' '
    {
        sum[$2] += $3
        count[$2]++
    }
    END {
        max = 0
        best = ""
        for (book in sum) {
            avg = sum[book] / count[book]
            if (avg > max) {
                max = avg
                best = book
            }
        }
        printf "%s|%.2f\n", best, max
    }' "$REVIEW_FILE" | while IFS="|" read bid rating
    do
        book_name=$(awk -F'|' -v id="$bid" '$1==id {print $2}' "$BOOK_FILE")

        echo "Book ID: $bid"
        echo "Book Name: $book_name"
        echo "Average Rating: $rating / 5"
        echo "---------------------------"
    done
}