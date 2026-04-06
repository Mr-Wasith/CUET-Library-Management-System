# CUET Library Management System

A terminal-based Library Management System built with Shell Script for the CUET Operating System Lab. This project provides an admin and student interface for managing books, borrow/return operations, reviews, analytics, clearance, and notifications.

## 📌 Project Overview

This system simulates a university library workflow on the terminal. It supports:

- Admin login/signup and student login/signup
- Book inventory management
- Borrowing and returning books
- Student fine tracking
- Review and rating management
- Analytics, leaderboard, and popular book tracking
- Clearance request processing
- Library notices

## ⭐ Key Features

- Admin dashboard for library operations
- Student dashboard for borrowing, returning, and tracking history
- Book search and inventory controls
- Review submission and average rating calculations
- Frequently borrowed books and low-stock alerts
- Clearance request approval/rejection flow
- Notice posting and viewing
- Planned/optional utilities: Leave request handling and CGPA calculator

## 🧩 Current Modules

- `main.sh` — application entrypoint and menu navigation
- `auth.sh` — admin and student authentication
- `book.sh` — add, remove, update, search, and view books
- `borrow.sh` — borrow and return book logic
- `fine.sh` — fine calculation for overdue returns
- `review.sh` — write and manage book reviews
- `avg_rating.sh` — compute average book ratings
- `recommend.sh` — recommend books to students
- `analytics.sh` — student analytics and activity summaries
- `leaderboard.sh` — top students and popular books ranking
- `popularity_graph.sh` — popularity graphs for books
- `frqntt_book.sh` — frequently borrowed books report
- `availability_alert.sh` — low stock alert for books
- `clearance.sh` — clearance application and admin approval
- `notice.sh` — library notice posting and display

## 📝 Planned Additions

The project also includes planned support for:

- Leave request application and approval flow (`leave.sh`)
- CGPA calculator utility (`cgpa.sh`)

If these files are not currently available in the repository, they can be added as companion scripts to extend functionality.

## 💻 Requirements

- GNU/Linux or Windows with a Bash-compatible shell
- `bash`, `awk`, `grep`, and `bc`
- Project files must remain in the same directory

## 🚀 How to Run

1. Open a terminal in the project folder.
2. Make `main.sh` executable (if required):
   ```bash
   chmod +x main.sh
   ```
3. Run the system:
   ```bash
   ./main.sh
   ```
4. Follow the on-screen menu to use admin or student features.

## 📁 Data Storage

The `database/` folder stores text-based records:

- `admin.txt` — admin credentials
- `students.txt` — student profiles
- `books.txt` — book inventory
- `borrow.txt` — borrowed book records
- `history.txt` — borrow/return history
- `reviews.txt` — student reviews
- `clearance.txt` — student clearance requests
- `notices.txt` — library notices

## 🙌 Contribution

You can extend the system by adding new shell modules and menu entries. For example, add `leave.sh` and `cgpa.sh` scripts and wire them into `main.sh` to support leave request processing and CGPA calculation.

## 📄 License

This project is for academic use and lab practice. Feel free to adapt it for learning and local experimentation.
