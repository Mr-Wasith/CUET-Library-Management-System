# CUET Library Management System


# Load Modules
source auth.sh
source book.sh
source borrow.sh
source fine.sh
source history.sh


# Admin Menu 
admin_menu() {
    while true
    do
        echo ""
        echo "========== ADMIN MENU =========="
        echo "1. Add Book"
        echo "2. Remove Book"
        echo "3. Update Book Quantity"
        echo "4. View All Books"
        echo "5. Search Book"
        echo "6. View Borrowed Books"
        echo "7. View Overdue Books"
        echo "8. Logout"
        echo "==============================="
        read -p "Enter choice: " choice

        case $choice in
            1) add_book ;;
            2) remove_book ;;
            3) update_book ;;
            4) view_books ;;
            5) search_book ;;
            6) view_borrowed_books ;;
            7) admin_overdue_list ;;
            8) echo "Logging out..."; break ;;
            *) echo "Invalid choice!" ;;
        esac
    done
}


# Student Menu 
student_menu() {
    while true
    do
        echo ""
        echo "========= STUDENT MENU ========="
        echo "1. View All Books"
        echo "2. Search Book"
        echo "3. Borrow Book"
        echo "4. Return Book"
        echo "5. My Borrowed Books"
        echo "6. Check Fine"
        echo "7. View History"
        echo "8. Logout"
        echo "==============================="
        read -p "Enter choice: " choice

        case $choice in
            1) view_books ;;
            2) search_book ;;
            3) borrow_book ;;
            4) return_book ;;
            5) view_borrowed_books ;;
            6) student_fine ;;
            7) view_student_history ;;
            8) echo "Logging out..."; break ;;
            *) echo "Invalid choice!" ;;
        esac
    done
}


# Main Menu
main_menu() {
    while true
    do
        echo ""
        echo "================================="
        echo "   CUET Library Management System"
        echo "================================="
        echo "1. Admin Login"
        echo "2. Student Login"
        echo "3. Exit"
        echo "================================="
        read -p "Enter choice: " choice

        case $choice in
            1)
                admin_login
                if [ $? -eq 0 ]; then
                    admin_menu
                else
                    echo "Login failed!"
                fi
                ;;
            2)
                student_login
                if [ $? -eq 0 ]; then
                    student_menu
                else
                    echo "Login failed!"
                fi
                ;;
            3)
                echo "Exiting system..."
                exit 0
                ;;
            *)
                echo "Invalid choice!"
                ;;
        esac
    done
}


# Program Start
main_menu