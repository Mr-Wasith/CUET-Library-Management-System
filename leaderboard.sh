BORROW_FILE="database/borrow.txt"

leaderboard() {

echo ""
echo "========== TOP READERS LEADERBOARD =========="
echo ""
printf "%-5s | %-10s | %-15s\n" "Rank" "StudentID" "Books Borrowed"
echo "----------------------------------------------"

awk -F'|' '{count[$1]++}
END{
for(student in count)
print student "|" count[student]
}' "$BORROW_FILE" | sort -t'|' -k2 -nr | \
awk -F'|' '
{
printf "%-5d | %-10s | %-15s\n", NR, $1, $2
}'

echo ""
echo "=============================================="

}