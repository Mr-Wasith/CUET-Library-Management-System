HISTORY_FILE="database/history.txt"

view_student_history() {

    result=$(grep "$CURRENT_STUDENT" "$HISTORY_FILE")

    if [ -z "$result" ]; then
        echo "No history found."
    else
        echo "---- Transaction History ----"
        echo "$result"
    fi
}