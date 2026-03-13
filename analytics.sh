BORROW_FILE="database/borrow.txt"
REVIEW_FILE="database/reviews.txt"
# Track how active students are.

student_analytics() {

echo "====== STUDENT ANALYTICS ======"

awk -F'|' '{borrow[$1]++} END{for(s in borrow) print s "|" borrow[s]}' "$BORROW_FILE" > temp1

awk -F'|' '{review[$1]++} END{for(s in review) print s "|" review[s]}' "$REVIEW_FILE" > temp2

echo "StudentID | Borrows | Reviews"

join -t'|' temp1 temp2 | awk -F'|' '{printf "%-10s | %-7s | %-7s\n", $1, $2, $3}'

rm temp1 temp2

}