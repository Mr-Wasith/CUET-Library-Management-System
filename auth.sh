ADMIN_FILE="database/admin.txt"
STUDENT_FILE="database/students.txt"

admin_login() {
    read -p "Admin Username: " user
    read -sp "Password: " pass
    echo

    if grep -q "^$user|$pass$" "$ADMIN_FILE"; then
        echo "Admin Login Successful"
        return 0
    else
        echo "Invalid Credentials"
        return 1
    fi
}

student_login() {
    read -p "Student ID: " sid
    read -sp "Password: " pass
    echo

    if grep -q "^$sid|.*|$pass$" "$STUDENT_FILE"; then
        CURRENT_STUDENT="$sid"
        echo "Login Successful"
        return 0
    else
        echo "Invalid Credentials"
        return 1
    fi
}