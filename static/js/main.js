// CLO Management System - Enhanced JavaScript with Modern Interactions

document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    // Initialize all features
    initAlerts();
    initDeleteConfirmations();
    initFormValidation();
    initDynamicFeatures();
    initAnimations();
    initThemeToggle();
}

// ============================================
// AUTO-HIDE ALERTS
// ============================================
function initAlerts() {
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    });
}

// ============================================
// DELETE CONFIRMATIONS
// ============================================
function initDeleteConfirmations() {
    const deleteButtons = document.querySelectorAll('[data-delete]');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const itemName = this.getAttribute('data-item-name') || 'this item';
            if (!confirm(`⚠️ Are you sure you want to delete ${itemName}?\n\nThis action cannot be undone.`)) {
                e.preventDefault();
            }
        });
    });
}

// ============================================
// FORM VALIDATION
// ============================================
function initFormValidation() {
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
                
                // Show first invalid field
                const firstInvalid = form.querySelector(':invalid');
                if (firstInvalid) {
                    firstInvalid.focus();
                    showToast('Please fill all required fields correctly', 'warning');
                }
            }
            form.classList.add('was-validated');
        });
    });
}

// ============================================
// DYNAMIC FEATURES
// ============================================
function initDynamicFeatures() {
    // Assessment weightage validation
    initWeightageValidation();
    
    // Dynamic CLO fetching
    initCourseCLOFetching();
    
    // Search functionality
    initTableSearch();
}

// Weightage validation for assessments
function initWeightageValidation() {
    const weightageInputs = document.querySelectorAll('input[name="weightages"]');
    if (weightageInputs.length === 0) return;

    const validateWeightages = () => {
        let total = 0;
        weightageInputs.forEach(input => {
            total += parseFloat(input.value) || 0;
        });

        const warning = document.getElementById('weightage-warning');
        const submitBtn = document.querySelector('form button[type="submit"]');
        
        if (Math.abs(total - 100) > 0.01 && total > 0) {
            if (warning) {
                warning.classList.remove('d-none');
                warning.innerHTML = `
                    <i class="bi bi-exclamation-triangle-fill"></i> 
                    Current total: ${total.toFixed(2)}%. Must equal 100%
                `;
            }
            if (submitBtn) submitBtn.disabled = true;
        } else {
            if (warning) warning.classList.add('d-none');
            if (submitBtn) submitBtn.disabled = false;
        }
    };

    weightageInputs.forEach(input => {
        input.addEventListener('input', validateWeightages);
    });
}

// Dynamic course CLO fetching
function initCourseCLOFetching() {
    const courseSelect = document.getElementById('course-select');
    if (!courseSelect) return;

    courseSelect.addEventListener('change', function() {
        const courseId = this.value;
        if (!courseId) return;

        showLoader();
        
        fetch(`/api/courses/${courseId}/clos`)
            .then(response => response.json())
            .then(data => {
                const cloContainer = document.getElementById('clo-list');
                if (!cloContainer) return;

                cloContainer.innerHTML = '';
                
                if (data.length === 0) {
                    cloContainer.innerHTML = `
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No CLOs defined for this course yet.
                        </div>
                    `;
                    return;
                }

                data.forEach(clo => {
                    const cloDiv = document.createElement('div');
                    cloDiv.className = 'card mb-3 fade-in';
                    cloDiv.innerHTML = `
                        <div class="card-body">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" 
                                       name="clo_ids" value="${clo.clo_id}" 
                                       id="clo${clo.clo_id}">
                                <label class="form-check-label" for="clo${clo.clo_id}">
                                    <strong>${clo.clo_code}:</strong> ${clo.clo_description}
                                </label>
                            </div>
                            <div class="mt-2">
                                <input type="number" name="weightages" 
                                       class="form-control" 
                                       placeholder="Weightage %" 
                                       min="0" max="100" step="0.01"
                                       data-clo-id="${clo.clo_id}">
                            </div>
                        </div>
                    `;
                    cloContainer.appendChild(cloDiv);
                });

                initWeightageValidation();
                hideLoader();
            })
            .catch(error => {
                showToast('Error loading CLOs: ' + error.message, 'danger');
                hideLoader();
            });
    });
}

// Table search functionality
function initTableSearch() {
    const searchInputs = document.querySelectorAll('[data-table-search]');
    searchInputs.forEach(input => {
        const tableId = input.getAttribute('data-table-search');
        const table = document.getElementById(tableId);
        if (!table) return;

        input.addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = table.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    });
}

// ============================================
// AJAX DELETE FUNCTIONS
// ============================================
window.deleteItem = function(type, id, redirectUrl) {
    if (!confirm(`⚠️ Are you sure you want to delete this ${type}?\n\nThis action cannot be undone.`)) {
        return;
    }

    showLoader();

    fetch(`/api/delete/${type}/${id}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        hideLoader();
        if (data.success) {
            showToast(data.message, 'success');
            setTimeout(() => {
                if (redirectUrl) {
                    window.location.href = redirectUrl;
                } else {
                    location.reload();
                }
            }, 1000);
        } else {
            showToast('Error: ' + data.message, 'danger');
        }
    })
    .catch(error => {
        hideLoader();
        showToast('An error occurred: ' + error.message, 'danger');
    });
};

// ============================================
// EXPORT FUNCTIONS
// ============================================
window.exportToExcel = function(courseId) {
    showLoader();
    window.location.href = `/faculty/courses/${courseId}/export-report`;
    setTimeout(hideLoader, 2000);
};

// ============================================
// ANIMATIONS
// ============================================
function initAnimations() {
    // Animate elements on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.card, .stat-card').forEach(el => {
        observer.observe(el);
    });
}

// ============================================
// THEME TOGGLE (Optional Enhancement)
// ============================================
function initThemeToggle() {
    const themeToggle = document.getElementById('theme-toggle');
    if (!themeToggle) return;

    themeToggle.addEventListener('click', function() {
        document.body.classList.toggle('light-theme');
        const icon = this.querySelector('i');
        icon.className = document.body.classList.contains('light-theme') 
            ? 'bi bi-moon-fill' 
            : 'bi bi-sun-fill';
    });
}

// ============================================
// UTILITY FUNCTIONS
// ============================================

// Show loading overlay
function showLoader() {
    let overlay = document.getElementById('loader-overlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'loader-overlay';
        overlay.className = 'spinner-overlay';
        overlay.innerHTML = `
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
        `;
        document.body.appendChild(overlay);
    }
    overlay.style.display = 'flex';
}

// Hide loading overlay
function hideLoader() {
    const overlay = document.getElementById('loader-overlay');
    if (overlay) {
        overlay.style.display = 'none';
    }
}

// Show toast notification
function showToast(message, type = 'info') {
    const toastContainer = getToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} alert-dismissible fade show`;
    toast.setAttribute('role', 'alert');
    toast.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    toastContainer.appendChild(toast);
    
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300);
    }, 5000);
}

// Get or create toast container
function getToastContainer() {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
        `;
        document.body.appendChild(container);
    }
    return container;
}

// Format percentage
function formatPercentage(value) {
    return parseFloat(value).toFixed(2) + '%';
}

// Get attainment color
function getAttainmentColor(score) {
    if (score >= 75) return 'success';
    if (score >= 60) return 'primary';
    if (score >= 50) return 'warning';
    return 'danger';
}

// Get attainment level text
function getAttainmentLevel(score) {
    if (score >= 75) return 'Highly Attained';
    if (score >= 60) return 'Attained';
    if (score >= 50) return 'Partially Attained';
    return 'Not Attained';
}

// ============================================
// CHART FUNCTIONS (if Chart.js is included)
// ============================================
function renderAttainmentChart(canvasId, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas || typeof Chart === 'undefined') return;

    const ctx = canvas.getContext('2d');
    
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'CLO Attainment %',
                data: data.values,
                backgroundColor: [
                    'rgba(59, 130, 246, 0.8)',
                    'rgba(139, 92, 246, 0.8)',
                    'rgba(16, 185, 129, 0.8)',
                    'rgba(245, 158, 11, 0.8)',
                    'rgba(239, 68, 68, 0.8)'
                ],
                borderColor: [
                    'rgb(59, 130, 246)',
                    'rgb(139, 92, 246)',
                    'rgb(16, 185, 129)',
                    'rgb(245, 158, 11)',
                    'rgb(239, 68, 68)'
                ],
                borderWidth: 2,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: '#1a1f3a',
                    titleColor: '#fff',
                    bodyColor: '#94a3b8',
                    borderColor: '#2d3348',
                    borderWidth: 1,
                    padding: 12,
                    displayColors: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    grid: {
                        color: '#2d3348'
                    },
                    ticks: {
                        color: '#94a3b8',
                        callback: function(value) {
                            return value + '%';
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#94a3b8'
                    }
                }
            }
        }
    });
}

// ============================================
// SIDEBAR TOGGLE FOR MOBILE
// ============================================
const sidebarToggle = document.getElementById('sidebarToggle');
if (sidebarToggle) {
    sidebarToggle.addEventListener('click', function() {
        const sidebar = document.getElementById('sidebar');
        sidebar.classList.toggle('show-mobile');
    });
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(e) {
    const sidebar = document.getElementById('sidebar');
    const toggle = document.getElementById('sidebarToggle');
    
    if (sidebar && toggle && !sidebar.contains(e.target) && !toggle.contains(e.target)) {
        sidebar.classList.remove('show-mobile');
    }
});
