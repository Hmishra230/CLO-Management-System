# CLO Management System

A full-featured web app for defining, tracking, and analyzing Course Learning Outcomes (CLOs) and Program Learning Outcomes (PLOs). Built with Flask and MySQL. Designed for higher education institutions aiming for outcome-based education, accreditation, and data-driven improvement.

## Features
- **Authentication**: Secure login/logout with role-based access—Admin, Faculty, Student
- **User Dashboards**: Different UI for each role
- **Program Management**: Create and edit programs and PLOs
- **Course Management**: Create, edit, delete courses and CLOs
- **CLO-PLO Mapping**: Align CLOs with PLOs and set correlation strengths
- **Assessments**: Create, assign, manage assessment tools and map them to CLOs
- **Student Scores**: Faculty can enter grades and comments; students see feedback
- **Automated Analytics**: Instant attainment calculations and visual reports
- **Export**: Download reports as Excel/PDF
- **Responsive UI**: Uses Bootstrap 5 for a modern look, with robust tables and charts

---

## Getting Started

### Prerequisites
- Python 3.10+
- MySQL (local or cloud instance)
- pip (Python package manager)

### Installation

1. **Clone the repository**
git clone https://github.com/Hmishra230/CLO-Management-System.git

text
2. **Install dependencies**
pip install -r requirements.txt

text
3. **Environment Variables**
- Copy `.env.example` to `.env` and fill in your MySQL credentials:
  ```
  DB_HOST=localhost
  DB_USER=your_mysql_user
  DB_PASSWORD=your_mysql_password
  DB_NAME=dbms_project
  SECRET_KEY=your-secret-key-here
  ```
4. **Initialize MySQL database**
- Use MySQL Workbench or the command line:
mysql -u your_mysql_user -p dbms_project < schema_and_seed.sql

text
(Use your provided schema and sample data file)

5. **Run the app locally**
python app.py

text
The app will be at [http://localhost:5000](http://localhost:5000).


---

## Default Login Credentials
| Role    | Username  | Password        |
|---------|-----------|-----------------|
| Admin   | admin     | adminpassword   |
| Faculty | faculty1  | facultypassword |
| Student | student1  | studentpassword |

---

## Directory Structure
clo-management-system/
├── app.py
├── requirements.txt
├── .env.example
├── README.md
├── templates/
│ ├── base.html
│ ├── login.html
│ ├── admin/...
│ ├── faculty/...
│ ├── student/...
│ └── errors/...
├── static/
│ ├── css/style.css
│ └── js/main.js

text

---

## Tech Stack
- Flask (Python 3.10)
- MySQL (database backend)
- SQLAlchemy or PyMySQL (ORM/DB driver)
- Flask-Login (authentication)
- Bootstrap 5 (frontend framework)
- Additional: pandas, openpyxl, python-dotenv

---

## Usage
- Log in as **admin** to create programs, courses, users, PLOs, CLOs
- Assign faculty to courses
- Faculty can define course CLOs, create assessments, map CLOs to PLOs
- Faculty enters student scores; system auto-calculates attainment
- Students view scores, feedback, and attainment/progress dashboards
- Use the export functions for reporting

---

## Database Schema
- See `schema_and_seed.sql` or within the repository for detailed CREATE TABLEs & seed data.

---

## Customization
- App is modular: you can extend features, add new roles, or integrate other analytics/reporting tools.
- Styles and templates live in `/static` and `/templates`, allowing easy customization.

---

## License
This project is for educational and academic use. Contact maintainer for permissions or questions.

---

## More on MySQL
- MySQL is an open source, relational database management system (RDBMS) well-suited for both small-scale and large-scale web applications. It is known for its speed, scalability, and security features, and is widely used in education, business, and industry environments[1][3][5][8].
