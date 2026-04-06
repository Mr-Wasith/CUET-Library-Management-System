# CUET Library Management System

A terminal-based Library Management System built with shell scripts for the CUET Operating System Lab. The system offers both admin and student workflows for managing library operations, student services, and academic tools.

## 📌 Project Overview

This application simulates a university library management system in the terminal. It supports:

- Admin and student login/signup
- Book inventory management (add, remove, update, search, view)
- Borrowing and returning books
- Borrow history tracking
- Fine calculation on overdue returns
- Student reviews and average ratings
- Book recommendation support
- Analytics, leaderboards, and popularity reports
- Clearance request workflows
- Noticeboard posting, viewing, searching, and deletion
- CGPA calculation utility

## ⭐ Full Feature Set

### Admin Features

- Add, remove, and update book quantities
- View all books and search inventory
- View borrowed books and overdue records
- View and delete book reviews
- Compute average book ratings and top-rated books
- View student analytics and library leaderboard
- Display popularity graphs and frequently borrowed books
- Receive low stock alerts for books
- Handle student clearance requests (view, approve, reject)
- Post, view, delete, and search notices on the noticeboard

### Student Features

- View all books and search for books
- Borrow and return books
- View currently borrowed books and history
- Check fines for overdue returns
- Write reviews and view personal reviews
- Get book recommendations
- View leaderboard rankings
- View noticeboard announcements
- Apply for clearance and check clearance status
- Calculate CGPA for coursework

## 🧩 Project Modules

- `main.sh` — application entrypoint and menu navigation
- `auth.sh` — admin and student authentication flow
- `book.sh` — book inventory operations
- `borrow.sh` — borrow/return processing
- `fine.sh` — overdue fine calculation
- `history.sh` — borrow/return history viewing
- `review.sh` — review creation and listing
- `avg_rating.sh` — average rating and top-rated book reports
- `recommend.sh` — book recommendation engine
- `analytics.sh` — student analytics summaries
- `leaderboard.sh` — leaderboard generation
- `popularity_graph.sh` — popularity graph reporting
- `frqntt_book.sh` — frequently borrowed book report
- `availability_alert.sh` — low stock alert generation
- `clearance.sh` — clearance request handling
- `cgpa.sh` — CGPA calculator utility
- `noticeboard.sh` — noticeboard management

## 💾 Data Storage

The `database/` folder stores application data as plain text records:

- `admin.txt` — admin usernames and passwords
- `students.txt` — registered student records
- `books.txt` — library book inventory
- `borrow.txt` — active borrow records
- `history.txt` — completed borrow/return history
- `reviews.txt` — student book reviews
- `clearance.txt` — clearance applications
- `noticeboard.txt` — posted notices

## 🚀 Requirements

- Bash-compatible shell (`bash` on Windows, WSL, Git Bash, or Linux)
- Standard shell utilities: `awk`, `grep`, `bc`, `date`
- Keep all project files in the same directory structure

## ▶️ How to Run

1. Open a terminal in the project folder.
2. If required, make `main.sh` executable:
   ```bash
   chmod +x main.sh
   ```
3. Start the application:
   ```bash
   ./main.sh
   ```
4. Use the on-screen menu to choose Admin or Student actions.

## 🙌 Contribution

Extend this project by adding new menu options and supporting modules. Recommended enhancements:

- Improve validation and error handling
- Add book categories and advanced search filters
- Add student profile editing
- Add reports for fines collected and books returned

## 📄 License

This project is intended for academic use and lab practice. Feel free to adapt it for learning and experimentation.
