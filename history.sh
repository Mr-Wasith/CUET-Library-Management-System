HISTORY_FILE="database/history.txt"

view_student_history() {
    grep "$CURRENT_STUDENT" "$HISTORY_FILE"
}