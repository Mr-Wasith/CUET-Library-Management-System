# CUET Library Management System


# Load Modules
source auth.sh
source book.sh
source borrow.sh
source fine.sh
source history.sh
source review.sh
source avg_rating.sh
source recommend.sh
source analytics.sh
source leaderboard.sh
source popularity_graph.sh
source frqntt_book.sh
source availability_alert.sh
source clearance.sh



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
        echo "8. View Reviews"
        echo "9. Average Ratings"
        echo "10. View Top Rated Book"
        echo "11. Delete Review"
        echo "12. Student Analytics"
        echo "13. Leaderboard"
        echo "14. View Popularity Graphs"
        echo "15. View Frequently Borrowed Books"
        echo "16. Low Stock Alert"
        echo "17. View Clearance Requests"
        echo "18. Approve Clearance"
        echo "19. Reject Clearance"
        echo "20. Logout"
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
            8) view_reviews ;;
            9) avg_rating ;;
            10) top_rated_book ;;
            11) delete_review ;;
            12) student_analytics ;;
            13) leaderboard ;;
            14) popularity_graph ;;
            15) frqntt_books ;;
            16) availability_alert ;;
            17) view_clearance_requests ;;
            18) approve_clearance ;;
            19) reject_clearance ;;
            20) echo "Logging out..."; break ;;
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
        echo "8. Write Review"
        echo "9. My Reviews"
        echo "10. Get Book Recommendations"
        echo "11. Leaderboard"
        echo "13. Apply for Clearance"
        echo "14. Check Clearance Status"
        echo "15. Logout"
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
            8) write_review ;;
            9) my_reviews ;;
            10) recommend_books ;;
            11) leaderboard ;;
            13) apply_clearance ;;
            14) check_clearance_status ;;
            15) echo "Logging out..."; break ;;
            *) echo "Invalid choice!" ;;
        esac
    done
}



# Program Start
main_menu

# Main Menu
main_menu() {
    while true
    do
        echo ""
        echo "================================="
        echo "   CUET Library Management System"
        echo "================================="
        echo "1. Admin Login"
        echo "2. Admin Signup"
        echo "3. Student Login"
        echo "4. Student Signup"
        echo "5. Exit"
        echo "================================="
        read -p "Enter choice: " choice

        case $choice in
            1)
                admin_login
                if [ $? -eq 0 ]; then
                    admin_menu
                else
                    echo "Login failed!"
                fi;;
            2)
                admin_signup;;
            3)
                student_login
                if [ $? -eq 0 ]; then
                    student_menu
                else
                    echo "Login failed!"
                fi;;
            4)
                student_signup;;
            5)
                echo "Exiting system..."
                exit 0;;
            *)
                echo "Invalid choice!";;
        esac
    done
}

# Program Start
main_menu