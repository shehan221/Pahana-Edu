// Password toggle functionality
function togglePassword() {
    const passwordField = document.getElementById('password');
    const toggleIcon = document.getElementById('passwordToggleIcon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        toggleIcon.className = 'fas fa-eye-slash';
    } else {
        passwordField.type = 'password';
        toggleIcon.className = 'fas fa-eye';
    }
}

// Password strength checker
function checkPasswordStrength(password) {
    const strengthIndicator = document.getElementById('passwordStrength');
    const strengthText = document.getElementById('strengthText');
    
    if (!password.length) {
        strengthIndicator.style.display = 'none';
        return;
    }
    
    strengthIndicator.style.display = 'block';
    
    let score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[0-9]/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;
    
    // Reset classes
    strengthIndicator.className = 'password-strength';
    
    if (score < 3) {
        strengthIndicator.classList.add('strength-weak');
        strengthText.textContent = 'Weak - Add more characters and variety';
    } else if (score < 5) {
        strengthIndicator.classList.add('strength-fair');
        strengthText.textContent = 'Fair - Consider adding special characters';
    } else {
        strengthIndicator.classList.add('strength-strong');
        strengthText.textContent = 'Strong password!';
    }
}

// Simple toast notifications
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.textContent = message;
    
    const colors = {
        success: '#059669',
        error: '#dc2626',
        info: '#3b82f6'
    };
    
    toast.style.cssText = `
        position: fixed; top: 20px; right: 20px;
        background: ${colors[type]}; color: white;
        padding: 12px 20px; border-radius: 8px;
        font-size: 14px; z-index: 10000;
        transition: all 0.3s ease;
    `;
    
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

// Form validation and interactions
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('registrationForm');
    const inputs = document.querySelectorAll('.form-input');
    
    // Password strength monitoring
    document.getElementById('password').addEventListener('input', function() {
        checkPasswordStrength(this.value);
    });
    
    // Username availability checker
    document.getElementById('username').addEventListener('blur', function() {
        const username = this.value.trim();
        if (username.length >= 3) {
            // Simulate username availability check (replace with real API call)
            setTimeout(() => {
                // You can replace this with actual AJAX call to your server
                // Example: fetch('/check-username', { method: 'POST', body: JSON.stringify({username}) })
                const isAvailable = Math.random() > 0.3; // Simulate 70% availability
                
                if (isAvailable) {
                    this.style.borderColor = '#059669';
                    showToast('Username is available!', 'success');
                } else {
                    this.style.borderColor = '#dc2626';
                    showToast('Username is already taken', 'error');
                }
            }, 500);
        }
    });
    
    // Input validation styling
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            this.style.borderColor = this.checkValidity() ? '#059669' : '#e5e7eb';
        });
        
        // Enter key navigation
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const nextInput = this.parentElement.nextElementSibling?.querySelector('.form-input');
                if (nextInput) {
                    nextInput.focus();
                } else {
                    document.getElementById('submitBtn').focus();
                }
            }
        });
    });
    
    // Form submission with validation
    form.addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const username = document.getElementById('username').value;
        const fullName = document.getElementById('fullName').value;
        
        if (password.length < 6) {
            e.preventDefault();
            showToast('Password must be at least 6 characters', 'error');
            return;
        }
        
        if (username.length < 3) {
            e.preventDefault();
            showToast('Username must be at least 3 characters', 'error');
            return;
        }
        
        if (fullName.trim().length < 2) {
            e.preventDefault();
            showToast('Please enter your full name', 'error');
            return;
        }
        
        // Show loading state
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Creating Account...';
    });
    
    // Auto-format inputs
    document.getElementById('fullName').addEventListener('input', function() {
        this.value = this.value.replace(/\b\w/g, char => char.toUpperCase());
    });
    
    document.getElementById('username').addEventListener('input', function() {
        this.value = this.value.toLowerCase().replace(/[^a-z0-9_-]/g, '');
    });
    
    // Focus first input
    document.getElementById('username').focus();
    
    // Auto-hide alerts after 5 seconds
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(alert => {
            alert.style.transition = 'all 0.3s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 300);
        });
    }, 5000);
    
    // Clear form with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && confirm('Clear form?')) {
            form.reset();
            document.getElementById('passwordStrength').style.display = 'none';
            showToast('Form cleared', 'info');
        }
    });
});