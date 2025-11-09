"""
CLO Management System - Complete Flask Application
Database: MySQL (dbms_project)
Python: 3.10+
"""

from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify, send_file
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from functools import wraps
import pymysql
import os
from datetime import datetime, timedelta
import pandas as pd
from io import BytesIO
import json

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'your-secret-key-change-in-production')
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=2)

# Database Configuration
DB_CONFIG = {
    'host': os.environ.get('DB_HOST', 'localhost'),
    'user': os.environ.get('DB_USER', 'root'),
    'password': os.environ.get('DB_PASSWORD', ''),
    'database': os.environ.get('DB_NAME', 'dbms_project'),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor,
    'autocommit': True
}

# Flask-Login Setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

class User(UserMixin):
    def __init__(self, user_id, username, email, role, full_name):
        self.id = user_id
        self.username = username
        self.email = email
        self.role = role
        self.full_name = full_name

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
            user_data = cursor.fetchone()
            if user_data:
                return User(user_data['user_id'], user_data['username'], 
                          user_data['email'], user_data['role'], user_data['full_name'])
    finally:
        conn.close()
    return None

def get_db_connection():
    """Create database connection"""
    return pymysql.connect(**DB_CONFIG)

def role_required(role):
    """Decorator for role-based access control"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated or current_user.role != role:
                flash('Access denied. Insufficient permissions.', 'danger')
                return redirect(url_for('dashboard'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

# ==================== AUTHENTICATION ROUTES ====================

@app.route('/')
def index():
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        conn = get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", 
                             (username, password))
                user_data = cursor.fetchone()
                
                if user_data:
                    user = User(user_data['user_id'], user_data['username'], 
                              user_data['email'], user_data['role'], user_data['full_name'])
                    login_user(user)
                    session.permanent = True
                    flash(f'Welcome back, {user.full_name}!', 'success')
                    return redirect(url_for('dashboard'))
                else:
                    flash('Invalid username or password', 'danger')
        finally:
            conn.close()
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out successfully', 'info')
    return redirect(url_for('login'))

@app.route('/dashboard')
@login_required
def dashboard():
    """Route user to appropriate dashboard based on role"""
    if current_user.role == 'admin':
        return redirect(url_for('admin_dashboard'))
    elif current_user.role == 'faculty':
        return redirect(url_for('faculty_dashboard'))
    elif current_user.role == 'student':
        return redirect(url_for('student_dashboard'))
    return render_template('dashboard.html')

# ==================== ADMIN ROUTES ====================

@app.route('/admin/dashboard')
@login_required
@role_required('admin')
def admin_dashboard():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) as count FROM programs")
            programs_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM courses")
            courses_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM users WHERE role='faculty'")
            faculty_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM users WHERE role='student'")
            student_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM clos")
            clos_count = cursor.fetchone()['count']
            
            stats = {
                'programs': programs_count,
                'courses': courses_count,
                'faculty': faculty_count,
                'students': student_count,
                'clos': clos_count
            }
    finally:
        conn.close()
    
    return render_template('admin/dashboard.html', stats=stats)

@app.route('/admin/programs')
@login_required
@role_required('admin')
def admin_programs():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM programs ORDER BY created_at DESC")
            programs = cursor.fetchall()
    finally:
        conn.close()
    return render_template('admin/programs.html', programs=programs)

@app.route('/admin/programs/add', methods=['POST'])
@login_required
@role_required('admin')
def add_program():
    code = request.form.get('program_code')
    name = request.form.get('program_name')
    dept = request.form.get('department')
    desc = request.form.get('description')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO programs (program_code, program_name, department, description) 
                            VALUES (%s, %s, %s, %s)""", (code, name, dept, desc))
        flash('Program added successfully', 'success')
    except Exception as e:
        flash(f'Error adding program: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('admin_programs'))

@app.route('/admin/programs/<int:program_id>/plos')
@login_required
@role_required('admin')
def program_plos(program_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM programs WHERE program_id = %s", (program_id,))
            program = cursor.fetchone()
            
            cursor.execute("SELECT * FROM plos WHERE program_id = %s ORDER BY plo_code", (program_id,))
            plos = cursor.fetchall()
    finally:
        conn.close()
    return render_template('admin/plos.html', program=program, plos=plos)

@app.route('/admin/plos/add', methods=['POST'])
@login_required
@role_required('admin')
def add_plo():
    program_id = request.form.get('program_id')
    code = request.form.get('plo_code')
    desc = request.form.get('plo_description')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("INSERT INTO plos (program_id, plo_code, plo_description) VALUES (%s, %s, %s)",
                         (program_id, code, desc))
        flash('PLO added successfully', 'success')
    except Exception as e:
        flash(f'Error adding PLO: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('program_plos', program_id=program_id))

@app.route('/admin/courses')
@login_required
@role_required('admin')
def admin_courses():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""SELECT c.*, p.program_name 
                            FROM courses c 
                            JOIN programs p ON c.program_id = p.program_id 
                            ORDER BY c.semester, c.course_code""")
            courses = cursor.fetchall()
            
            cursor.execute("SELECT * FROM programs")
            programs = cursor.fetchall()
    finally:
        conn.close()
    return render_template('admin/courses.html', courses=courses, programs=programs)

@app.route('/admin/courses/add', methods=['POST'])
@login_required
@role_required('admin')
def add_course():
    program_id = request.form.get('program_id')
    code = request.form.get('course_code')
    name = request.form.get('course_name')
    credits = request.form.get('credit_hours')
    semester = request.form.get('semester')
    desc = request.form.get('description')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester, description) 
                            VALUES (%s, %s, %s, %s, %s, %s)""", (program_id, code, name, credits, semester, desc))
        flash('Course added successfully', 'success')
    except Exception as e:
        flash(f'Error adding course: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('admin_courses'))

@app.route('/admin/users')
@login_required
@role_required('admin')
def admin_users():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM users ORDER BY role, full_name")
            users = cursor.fetchall()
    finally:
        conn.close()
    return render_template('admin/users.html', users=users)

@app.route('/admin/users/add', methods=['POST'])
@login_required
@role_required('admin')
def add_user():
    username = request.form.get('username')
    password = request.form.get('password')
    email = request.form.get('email')
    role = request.form.get('role')
    full_name = request.form.get('full_name')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO users (username, password, email, role, full_name) 
                            VALUES (%s, %s, %s, %s, %s)""", (username, password, email, role, full_name))
        flash('User added successfully', 'success')
    except Exception as e:
        flash(f'Error adding user: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('admin_users'))

# ==================== FACULTY ROUTES ====================

@app.route('/faculty/dashboard')
@login_required
@role_required('faculty')
def faculty_dashboard():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Get assigned courses (simplified - all courses for demo)
            cursor.execute("SELECT * FROM courses ORDER BY semester, course_code")
            courses = cursor.fetchall()
            
            cursor.execute("SELECT COUNT(*) as count FROM clos")
            clos_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM assessment_tools")
            assessments_count = cursor.fetchone()['count']
    finally:
        conn.close()
    return render_template('faculty/dashboard.html', courses=courses, 
                         clos_count=clos_count, assessments_count=assessments_count)

@app.route('/faculty/courses/<int:course_id>/clos')
@login_required
@role_required('faculty')
def faculty_course_clos(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM courses WHERE course_id = %s", (course_id,))
            course = cursor.fetchone()
            
            cursor.execute("SELECT * FROM clos WHERE course_id = %s ORDER BY clo_code", (course_id,))
            clos = cursor.fetchall()
            
            cursor.execute("SELECT * FROM plos WHERE program_id = %s", (course['program_id'],))
            plos = cursor.fetchall()
    finally:
        conn.close()
    return render_template('faculty/course_clos.html', course=course, clos=clos, plos=plos)

@app.route('/faculty/clos/add', methods=['POST'])
@login_required
@role_required('faculty')
def add_clo():
    course_id = request.form.get('course_id')
    code = request.form.get('clo_code')
    desc = request.form.get('clo_description')
    bloom = request.form.get('bloom_level')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) 
                            VALUES (%s, %s, %s, %s)""", (course_id, code, desc, bloom))
        flash('CLO added successfully', 'success')
    except Exception as e:
        flash(f'Error adding CLO: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('faculty_course_clos', course_id=course_id))

@app.route('/faculty/clo-plo-mapping/add', methods=['POST'])
@login_required
@role_required('faculty')
def add_clo_plo_mapping():
    clo_id = request.form.get('clo_id')
    plo_id = request.form.get('plo_id')
    strength = request.form.get('correlation_strength')
    course_id = request.form.get('course_id')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) 
                            VALUES (%s, %s, %s)""", (clo_id, plo_id, strength))
        flash('CLO-PLO mapping added successfully', 'success')
    except Exception as e:
        flash(f'Error adding mapping: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('faculty_course_clos', course_id=course_id))

@app.route('/faculty/courses/<int:course_id>/assessments')
@login_required
@role_required('faculty')
def faculty_assessments(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM courses WHERE course_id = %s", (course_id,))
            course = cursor.fetchone()
            
            cursor.execute("SELECT * FROM assessment_tools WHERE course_id = %s ORDER BY assessment_date DESC", 
                         (course_id,))
            assessments = cursor.fetchall()
            
            cursor.execute("SELECT * FROM clos WHERE course_id = %s", (course_id,))
            clos = cursor.fetchall()
    finally:
        conn.close()
    return render_template('faculty/assessments.html', course=course, 
                         assessments=assessments, clos=clos)

@app.route('/faculty/assessments/add', methods=['POST'])
@login_required
@role_required('faculty')
def add_assessment():
    course_id = request.form.get('course_id')
    name = request.form.get('assessment_name')
    atype = request.form.get('assessment_type')
    max_marks = request.form.get('max_marks')
    weightage = request.form.get('weightage')
    date = request.form.get('assessment_date')
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""INSERT INTO assessment_tools 
                            (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) 
                            VALUES (%s, %s, %s, %s, %s, %s)""", 
                         (course_id, name, atype, max_marks, weightage, date))
        flash('Assessment added successfully', 'success')
    except Exception as e:
        flash(f'Error adding assessment: {str(e)}', 'danger')
    finally:
        conn.close()
    return redirect(url_for('faculty_assessments', course_id=course_id))

@app.route('/faculty/assessments/<int:assessment_id>/map-clos', methods=['GET', 'POST'])
@login_required
@role_required('faculty')
def map_assessment_clos(assessment_id):
    conn = get_db_connection()
    
    if request.method == 'POST':
        clo_ids = request.form.getlist('clo_ids')
        weightages = request.form.getlist('weightages')
        
        try:
            with conn.cursor() as cursor:
                for clo_id, weight in zip(clo_ids, weightages):
                    if weight:
                        cursor.execute("""INSERT INTO assessment_clo_mapping 
                                        (assessment_id, clo_id, weightage_percentage) 
                                        VALUES (%s, %s, %s)""", (assessment_id, clo_id, weight))
            flash('CLO mappings saved successfully', 'success')
        except Exception as e:
            flash(f'Error mapping CLOs: {str(e)}', 'danger')
        finally:
            conn.close()
        
        cursor.execute("SELECT course_id FROM assessment_tools WHERE assessment_id = %s", (assessment_id,))
        course = cursor.fetchone()
        return redirect(url_for('faculty_assessments', course_id=course['course_id']))
    
    try:
        with conn.cursor() as cursor:
            cursor.execute("""SELECT a.*, c.course_name 
                            FROM assessment_tools a 
                            JOIN courses c ON a.course_id = c.course_id 
                            WHERE a.assessment_id = %s""", (assessment_id,))
            assessment = cursor.fetchone()
            
            cursor.execute("SELECT * FROM clos WHERE course_id = %s", (assessment['course_id'],))
            clos = cursor.fetchall()
            
            cursor.execute("""SELECT * FROM assessment_clo_mapping 
                            WHERE assessment_id = %s""", (assessment_id,))
            existing = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('faculty/map_assessment_clos.html', 
                         assessment=assessment, clos=clos, existing=existing)

@app.route('/faculty/assessments/<int:assessment_id>/scores', methods=['GET', 'POST'])
@login_required
@role_required('faculty')
def enter_scores(assessment_id):
    conn = get_db_connection()
    
    if request.method == 'POST':
        try:
            with conn.cursor() as cursor:
                for key, value in request.form.items():
                    if key.startswith('score_'):
                        enrollment_id = key.split('_')[1]
                        marks = value if value else 0
                        
                        cursor.execute("""INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) 
                                        VALUES (%s, %s, %s) 
                                        ON DUPLICATE KEY UPDATE marks_obtained = %s""", 
                                     (enrollment_id, assessment_id, marks, marks))
            flash('Scores saved successfully', 'success')
            
            # Calculate CLO attainment after scores are entered
            calculate_clo_attainment(assessment_id)
            
        except Exception as e:
            flash(f'Error saving scores: {str(e)}', 'danger')
        finally:
            conn.close()
        
        return redirect(url_for('enter_scores', assessment_id=assessment_id))
    
    try:
        with conn.cursor() as cursor:
            cursor.execute("""SELECT a.*, c.course_name, c.course_id 
                            FROM assessment_tools a 
                            JOIN courses c ON a.course_id = c.course_id 
                            WHERE a.assessment_id = %s""", (assessment_id,))
            assessment = cursor.fetchone()
            
            cursor.execute("""SELECT e.enrollment_id, u.full_name, u.username, ss.marks_obtained
                            FROM enrollments e 
                            JOIN users u ON e.student_id = u.user_id 
                            LEFT JOIN student_scores ss ON e.enrollment_id = ss.enrollment_id 
                                AND ss.assessment_id = %s
                            WHERE e.course_id = %s AND e.status = 'active'
                            ORDER BY u.full_name""", (assessment_id, assessment['course_id']))
            students = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('faculty/enter_scores.html', assessment=assessment, students=students)

def calculate_clo_attainment(assessment_id):
    """Calculate CLO attainment for students after assessment scores are entered"""
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Get course_id from assessment
            cursor.execute("SELECT course_id FROM assessment_tools WHERE assessment_id = %s", (assessment_id,))
            course = cursor.fetchone()
            
            # Get all enrollments for this course
            cursor.execute("SELECT enrollment_id FROM enrollments WHERE course_id = %s AND status='active'", 
                         (course['course_id'],))
            enrollments = cursor.fetchall()
            
            for enrollment in enrollments:
                enrollment_id = enrollment['enrollment_id']
                
                # Get all CLOs for this course
                cursor.execute("SELECT clo_id FROM clos WHERE course_id = %s", (course['course_id'],))
                clos = cursor.fetchall()
                
                for clo in clos:
                    clo_id = clo['clo_id']
                    
                    # Calculate weighted average for this CLO
                    cursor.execute("""
                        SELECT SUM(ss.marks_obtained / at.max_marks * acm.weightage_percentage) as weighted_score,
                               SUM(acm.weightage_percentage) as total_weight
                        FROM student_scores ss
                        JOIN assessment_tools at ON ss.assessment_id = at.assessment_id
                        JOIN assessment_clo_mapping acm ON at.assessment_id = acm.assessment_id
                        WHERE ss.enrollment_id = %s AND acm.clo_id = %s AND at.course_id = %s
                    """, (enrollment_id, clo_id, course['course_id']))
                    
                    result = cursor.fetchone()
                    
                    if result and result['total_weight'] and result['total_weight'] > 0:
                        attainment_score = (result['weighted_score'] / result['total_weight']) * 100
                        
                        # Determine attainment level
                        if attainment_score < 50:
                            level = 'not_attained'
                        elif attainment_score < 60:
                            level = 'partially_attained'
                        elif attainment_score < 75:
                            level = 'attained'
                        else:
                            level = 'highly_attained'
                        
                        # Insert or update attainment
                        cursor.execute("""
                            INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level)
                            VALUES (%s, %s, %s, %s)
                            ON DUPLICATE KEY UPDATE attainment_score = %s, attainment_level = %s
                        """, (enrollment_id, clo_id, attainment_score, level, attainment_score, level))
    finally:
        conn.close()

@app.route('/faculty/courses/<int:course_id>/reports')
@login_required
@role_required('faculty')
def faculty_reports(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM courses WHERE course_id = %s", (course_id,))
            course = cursor.fetchone()
            
            # Get CLO attainment statistics
            cursor.execute("""
                SELECT c.clo_code, c.clo_description,
                       AVG(ca.attainment_score) as avg_score,
                       SUM(CASE WHEN ca.attainment_level = 'highly_attained' THEN 1 ELSE 0 END) as highly_attained,
                       SUM(CASE WHEN ca.attainment_level = 'attained' THEN 1 ELSE 0 END) as attained,
                       SUM(CASE WHEN ca.attainment_level = 'partially_attained' THEN 1 ELSE 0 END) as partially_attained,
                       SUM(CASE WHEN ca.attainment_level = 'not_attained' THEN 1 ELSE 0 END) as not_attained,
                       COUNT(*) as total_students
                FROM clos c
                LEFT JOIN clo_attainment ca ON c.clo_id = ca.clo_id
                LEFT JOIN enrollments e ON ca.enrollment_id = e.enrollment_id
                WHERE c.course_id = %s AND (e.status = 'active' OR e.status IS NULL)
                GROUP BY c.clo_id
                ORDER BY c.clo_code
            """, (course_id,))
            clo_stats = cursor.fetchall()
            
            # Get CLO-PLO mapping with correlation
            cursor.execute("""
                SELECT c.clo_code, p.plo_code, cpm.correlation_strength
                FROM clos c
                JOIN clo_plo_mapping cpm ON c.clo_id = cpm.clo_id
                JOIN plos p ON cpm.plo_id = p.plo_id
                WHERE c.course_id = %s
                ORDER BY c.clo_code, p.plo_code
            """, (course_id,))
            mappings = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('faculty/reports.html', course=course, 
                         clo_stats=clo_stats, mappings=mappings)

@app.route('/faculty/courses/<int:course_id>/export-report')
@login_required
@role_required('faculty')
def export_course_report():
    course_id = request.args.get('course_id', type=int)
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM courses WHERE course_id = %s", (course_id,))
            course = cursor.fetchone()
            
            cursor.execute("""
                SELECT c.clo_code, c.clo_description,
                       AVG(ca.attainment_score) as avg_score,
                       COUNT(*) as total_students
                FROM clos c
                LEFT JOIN clo_attainment ca ON c.clo_id = ca.clo_id
                WHERE c.course_id = %s
                GROUP BY c.clo_id
            """, (course_id,))
            data = cursor.fetchall()
    finally:
        conn.close()
    
    df = pd.DataFrame(data)
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='CLO Attainment', index=False)
    output.seek(0)
    
    return send_file(output, download_name=f'{course["course_code"]}_report.xlsx', 
                    as_attachment=True, mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

# ==================== STUDENT ROUTES ====================

@app.route('/student/dashboard')
@login_required
@role_required('student')
def student_dashboard():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""SELECT c.*, e.status 
                            FROM enrollments e 
                            JOIN courses c ON e.course_id = c.course_id 
                            WHERE e.student_id = %s 
                            ORDER BY c.semester, c.course_code""", (current_user.id,))
            courses = cursor.fetchall()
            
            cursor.execute("""SELECT COUNT(DISTINCT c.course_id) as count 
                            FROM enrollments e 
                            JOIN courses c ON e.course_id = c.course_id 
                            WHERE e.student_id = %s AND e.status = 'active'""", (current_user.id,))
            active_courses = cursor.fetchone()['count']
    finally:
        conn.close()
    return render_template('student/dashboard.html', courses=courses, active_courses=active_courses)

@app.route('/student/courses/<int:course_id>')
@login_required
@role_required('student')
def student_course_detail(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM courses WHERE course_id = %s", (course_id,))
            course = cursor.fetchone()
            
            cursor.execute("SELECT * FROM clos WHERE course_id = %s ORDER BY clo_code", (course_id,))
            clos = cursor.fetchall()
            
            cursor.execute("SELECT enrollment_id FROM enrollments WHERE student_id = %s AND course_id = %s", 
                         (current_user.id, course_id))
            enrollment = cursor.fetchone()
            
            if enrollment:
                cursor.execute("""SELECT at.assessment_name, at.assessment_type, at.max_marks, 
                                ss.marks_obtained, at.assessment_date
                                FROM assessment_tools at
                                LEFT JOIN student_scores ss ON at.assessment_id = ss.assessment_id 
                                    AND ss.enrollment_id = %s
                                WHERE at.course_id = %s
                                ORDER BY at.assessment_date DESC""", (enrollment['enrollment_id'], course_id))
                assessments = cursor.fetchall()
                
                cursor.execute("""SELECT c.clo_code, c.clo_description, ca.attainment_score, ca.attainment_level
                                FROM clos c
                                LEFT JOIN clo_attainment ca ON c.clo_id = ca.clo_id 
                                    AND ca.enrollment_id = %s
                                WHERE c.course_id = %s
                                ORDER BY c.clo_code""", (enrollment['enrollment_id'], course_id))
                attainments = cursor.fetchall()
            else:
                assessments = []
                attainments = []
    finally:
        conn.close()
    
    return render_template('student/course_detail.html', course=course, clos=clos, 
                         assessments=assessments, attainments=attainments)

@app.route('/student/progress')
@login_required
@role_required('student')
def student_progress():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Get overall CLO attainment across all courses
            cursor.execute("""
                SELECT c.course_code, c.course_name, cl.clo_code, 
                       ca.attainment_score, ca.attainment_level
                FROM clo_attainment ca
                JOIN enrollments e ON ca.enrollment_id = e.enrollment_id
                JOIN clos cl ON ca.clo_id = cl.clo_id
                JOIN courses c ON cl.course_id = c.course_id
                WHERE e.student_id = %s
                ORDER BY c.semester, c.course_code, cl.clo_code
            """, (current_user.id,))
            progress = cursor.fetchall()
            
            # Get PLO attainment through CLO-PLO mapping
            cursor.execute("""
                SELECT p.plo_code, p.plo_description,
                       AVG(ca.attainment_score) as avg_score,
                       COUNT(DISTINCT ca.clo_id) as clo_count
                FROM plos p
                JOIN clo_plo_mapping cpm ON p.plo_id = cpm.plo_id
                JOIN clo_attainment ca ON cpm.clo_id = ca.clo_id
                JOIN enrollments e ON ca.enrollment_id = e.enrollment_id
                WHERE e.student_id = %s
                GROUP BY p.plo_id
                ORDER BY p.plo_code
            """, (current_user.id,))
            plo_progress = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('student/progress.html', progress=progress, plo_progress=plo_progress)

# ==================== API ROUTES FOR AJAX ====================

@app.route('/api/courses/<int:course_id>/clos')
@login_required
def course_clos(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM clos WHERE course_id = %s ORDER BY clo_code", (course_id,))
            clos = cursor.fetchall()
    finally:
        conn.close()
    return jsonify(clos)

@app.route('/api/programs/<int:program_id>/plos')
@login_required
def api_program_plos(program_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM plos WHERE program_id = %s ORDER BY plo_code", (program_id,))
            plos = cursor.fetchall()
    finally:
        conn.close()
    return jsonify(plos)

@app.route('/api/clo-plo-matrix/<int:course_id>')
@login_required
def api_clo_plo_matrix(course_id):
    """Get CLO-PLO correlation matrix for visualization"""
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT c.clo_code, p.plo_code, cpm.correlation_strength
                FROM clos c
                JOIN clo_plo_mapping cpm ON c.clo_id = cpm.clo_id
                JOIN plos p ON cpm.plo_id = p.plo_id
                WHERE c.course_id = %s
                ORDER BY c.clo_code, p.plo_code
            """, (course_id,))
            mappings = cursor.fetchall()
    finally:
        conn.close()
    return jsonify(mappings)

@app.route('/api/delete/program/<int:program_id>', methods=['DELETE'])
@login_required
@role_required('admin')
def delete_program(program_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM programs WHERE program_id = %s", (program_id,))
        return jsonify({'success': True, 'message': 'Program deleted successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    finally:
        conn.close()

@app.route('/api/delete/course/<int:course_id>', methods=['DELETE'])
@login_required
@role_required('admin')
def delete_course(course_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM courses WHERE course_id = %s", (course_id,))
        return jsonify({'success': True, 'message': 'Course deleted successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    finally:
        conn.close()

@app.route('/api/delete/user/<int:user_id>', methods=['DELETE'])
@login_required
@role_required('admin')
def delete_user(user_id):
    if user_id == current_user.id:
        return jsonify({'success': False, 'message': 'Cannot delete your own account'}), 400
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
        return jsonify({'success': True, 'message': 'User deleted successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    finally:
        conn.close()

@app.route('/api/delete/clo/<int:clo_id>', methods=['DELETE'])
@login_required
@role_required('faculty')
def delete_clo(clo_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM clos WHERE clo_id = %s", (clo_id,))
        return jsonify({'success': True, 'message': 'CLO deleted successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    finally:
        conn.close()

@app.route('/api/delete/assessment/<int:assessment_id>', methods=['DELETE'])
@login_required
@role_required('faculty')
def delete_assessment(assessment_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM assessment_tools WHERE assessment_id = %s", (assessment_id,))
        return jsonify({'success': True, 'message': 'Assessment deleted successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    finally:
        conn.close()

# ==================== ANALYTICS & REPORTING ====================

@app.route('/analytics/program/<int:program_id>')
@login_required
def program_analytics(program_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM programs WHERE program_id = %s", (program_id,))
            program = cursor.fetchone()
            
            # PLO attainment across program
            cursor.execute("""
                SELECT p.plo_code, p.plo_description,
                       AVG(ca.attainment_score) as avg_score,
                       COUNT(DISTINCT ca.enrollment_id) as student_count
                FROM plos p
                LEFT JOIN clo_plo_mapping cpm ON p.plo_id = cpm.plo_id
                LEFT JOIN clo_attainment ca ON cpm.clo_id = ca.clo_id
                WHERE p.program_id = %s
                GROUP BY p.plo_id
                ORDER BY p.plo_code
            """, (program_id,))
            plo_stats = cursor.fetchall()
            
            # Course-wise statistics
            cursor.execute("""
                SELECT c.course_code, c.course_name, c.semester,
                       COUNT(DISTINCT e.student_id) as enrolled_students,
                       AVG(ca.attainment_score) as avg_clo_score
                FROM courses c
                LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.status = 'active'
                LEFT JOIN clo_attainment ca ON e.enrollment_id = ca.enrollment_id
                WHERE c.program_id = %s
                GROUP BY c.course_id
                ORDER BY c.semester, c.course_code
            """, (program_id,))
            course_stats = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('analytics/program.html', program=program, 
                         plo_stats=plo_stats, course_stats=course_stats)

@app.route('/analytics/trends')
@login_required
def analytics_trends():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Semester-wise performance trends
            cursor.execute("""
                SELECT c.semester, AVG(ca.attainment_score) as avg_score,
                       COUNT(DISTINCT ca.enrollment_id) as student_count
                FROM courses c
                JOIN enrollments e ON c.course_id = e.course_id
                JOIN clo_attainment ca ON e.enrollment_id = ca.enrollment_id
                GROUP BY c.semester
                ORDER BY c.semester
            """)
            semester_trends = cursor.fetchall()
            
            # Attainment level distribution
            cursor.execute("""
                SELECT attainment_level, COUNT(*) as count
                FROM clo_attainment
                GROUP BY attainment_level
            """)
            level_distribution = cursor.fetchall()
    finally:
        conn.close()
    
    return render_template('analytics/trends.html', 
                         semester_trends=semester_trends, 
                         level_distribution=level_distribution)

# ==================== ERROR HANDLERS ====================

@app.errorhandler(404)
def not_found(e):
    return render_template('errors/404.html'), 404

@app.errorhandler(403)
def forbidden(e):
    return render_template('errors/403.html'), 403

@app.errorhandler(500)
def internal_error(e):
    return render_template('errors/500.html'), 500

# ==================== CONTEXT PROCESSORS ====================

@app.context_processor
def utility_processor():
    """Make utility functions available in templates"""
    def get_attainment_badge_class(level):
        badges = {
            'highly_attained': 'success',
            'attained': 'primary',
            'partially_attained': 'warning',
            'not_attained': 'danger'
        }
        return badges.get(level, 'secondary')
    
    def format_percentage(value):
        if value is None:
            return 'N/A'
        return f"{float(value):.2f}%"
    
    def get_correlation_color(strength):
        colors = {'1': 'info', '2': 'warning', '3': 'danger'}
        return colors.get(str(strength), 'secondary')
    
    return dict(
        get_attainment_badge_class=get_attainment_badge_class,
        format_percentage=format_percentage,
        get_correlation_color=get_correlation_color
    )

# ==================== MAIN ====================

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)

app = app