calculate_student_cgpa() {
    echo "========================================="
    echo "       CGPA Calculator"
    echo "========================================="
    echo ""

    read -p "Enter number of courses: " num_courses


    if ! [[ "$num_courses" =~ ^[0-9]+$ ]] || [ "$num_courses" -le 0 ]; then
        echo "Error: Please enter a valid positive number"
        return 1
    fi

    total_grade_points=0
    total_credits=0


    for ((i=1; i<=num_courses; i++))
    do
        echo ""
        echo "--- Course $i ---"

        read -p "Enter course name: " course_name
        read -p "Enter course credit: " credit
        read -p "Enter obtained GPA (0.0-4.0): " gpa


        if ! [[ "$credit" =~ ^[0-9]+\.?[0-9]*$ ]] || ! [[ "$gpa" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo "Error: Please enter valid numbers for credit and GPA"
            return 1
        fi


        grade_points=$(echo "$gpa * $credit" | bc -l)


        total_grade_points=$(echo "$total_grade_points + $grade_points" | bc -l)
        total_credits=$(echo "$total_credits + $credit" | bc -l)
    done


    if (( $(echo "$total_credits > 0" | bc -l) )); then
        cgpa=$(echo "scale=2; $total_grade_points / $total_credits" | bc -l)
    else
        cgpa="0.00"
    fi

    # Display results
    echo ""
    echo "========================================="
    echo "           CGPA RESULT"
    echo "========================================="
    echo "Total Credits: $total_credits"
    echo "Total Grade Points: $total_grade_points"
    echo "CGPA: $cgpa"
    echo "========================================="
}