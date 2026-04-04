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

admin_signup() {
    read -p "New Admin Username: " user

   
    if grep -q "^$user|" "$ADMIN_FILE"; then
        echo "Username already exists!"
        return 1
    fi

    read -sp "Set Password: " pass
    echo
    read -sp "Confirm Password: " pass2
    echo

    if [ "$pass" != "$pass2" ]; then
        echo "Passwords do not match!"
        return 1
    fi

    echo "$user|$pass" >> "$ADMIN_FILE"
    echo "Admin account created successfully!"
}

student_signup() {
    read -p "Enter Student ID: " sid

   
    if grep -q "^$sid|" "$STUDENT_FILE"; then
        echo "Student ID already registered!"
        return 1
    fi

    read -p "Enter Full Name: " name
    read -sp "Set Password: " pass
    echo
    read -sp "Confirm Password: " pass2
    echo

    if [ "$pass" != "$pass2" ]; then
        echo "Passwords do not match!"
        return 1
    fi

    echo "$sid|$name|$pass" >> "$STUDENT_FILE"
    echo "Student account created successfully!"
}