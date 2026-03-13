ADMIN_FILE="database/admin.txt"
STUDENT_FILE="database/students.txt"

admin_login() {
    read -p "Admin Username: " user
    read -sp "Password: " pass
    echo

    if awk -F'|' -v u="$user" -v p="$pass" '$1==u && $2==p' "$ADMIN_FILE" | grep -q .; then
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

    if awk -F'|' -v id="$sid" -v pw="$pass" '$1==id && $3==pw' "$STUDENT_FILE" | grep -q .; then
        CURRENT_STUDENT="$sid"
        echo "Login Successful"
        return 0
    else
        echo "Invalid Credentials"
        return 1
    fi
}