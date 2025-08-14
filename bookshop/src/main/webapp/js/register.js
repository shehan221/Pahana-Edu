
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
           const strengthFill = document.getElementById('strengthFill');
           const strengthText = document.getElementById('strengthText');
           
           if (password.length === 0) {
               strengthIndicator.style.display = 'none';
               return;
           }
           
           strengthIndicator.style.display = 'block';
           
           let score = 0;
           let feedback = '';
           
           // Length check
           if (password.length >= 8) score++;
           if (password.length >= 12) score++;
           
           // Character variety checks
           if (/[a-z]/.test(password)) score++;
           if (/[A-Z]/.test(password)) score++;
           if (/[0-9]/.test(password)) score++;
           if (/[^A-Za-z0-9]/.test(password)) score++;
           
           // Remove all strength classes
           strengthIndicator.className = 'password-strength';
           
           if (score < 3) {
               strengthIndicator.classList.add('strength-weak');
               feedback = 'Weak - Add more characters and variety';
           } else if (score < 4) {
               strengthIndicator.classList.add('strength-fair');
               feedback = 'Fair - Consider adding special characters';
           } else if (score < 6) {
               strengthIndicator.classList.add('strength-good');
               feedback = 'Good - Strong password!';
           } else {
               strengthIndicator.classList.add('strength-strong');
               feedback = 'Excellent - Very secure password!';
           }
           
           strengthText.textContent = feedback;
       }

       // Form submission with loading animation
       document.getElementById('registrationForm').addEventListener('submit', function() {
           const submitBtn = document.getElementById('submitBtn');
           submitBtn.classList.add('loading');
           submitBtn.disabled = true;
       });

       // Input field enhancements
       document.querySelectorAll('.form-input').forEach(input => {
           input.addEventListener('focus', function() {
               this.parentElement.style.transform = 'scale(1.02)';
           });
           
           input.addEventListener('blur', function() {
               this.parentElement.style.transform = 'scale(1)';
           });
           
           // Real-time validation feedback
           input.addEventListener('input', function() {
               if (this.checkValidity()) {
                   this.style.borderColor = '#059669';
               } else {
                   this.style.borderColor = '#e5e7eb';
               }
           });
       });

       // Password strength monitoring
       document.getElementById('password').addEventListener('input', function() {
           checkPasswordStrength(this.value);
       });

       // Username availability checker (visual feedback)
       document.getElementById('username').addEventListener('blur', function() {
           const username = this.value.trim();
           if (username.length >= 3) {
               // Simulate username check (you can implement real check via AJAX)
               setTimeout(() => {
                   this.style.borderColor = '#059669';
                   showToast('Username looks good!', 'success');
               }, 500);
           }
       });

       // Email validation
       document.getElementById('email').addEventListener('blur', function() {
           const email = this.value.trim();
           if (email && this.checkValidity()) {
               this.style.borderColor = '#059669';
           }
       });

       // Toast notification system
       function showToast(message, type = 'info') {
           const toast = document.createElement('div');
           toast.textContent = message;
           
           const colors = {
               success: '#059669',
               error: '#dc2626',
               info: '#3b82f6'
           };
           
           toast.style.cssText = `
               position: fixed;
               top: 20px;
               right: 20px;
               background: ${colors[type]};
               color: white;
               padding: 12px 20px;
               border-radius: 8px;
               font-size: 14px;
               z-index: 10000;
               animation: slideInToast 0.3s ease;
           `;
           
           document.body.appendChild(toast);
           
           setTimeout(() => {
               toast.style.animation = 'slideOutToast 0.3s ease forwards';
               setTimeout(() => toast.remove(), 300);
           }, 3000);
       }

       // Add toast animations
       const toastStyle = document.createElement('style');
       toastStyle.textContent = `
           @keyframes slideInToast {
               from { transform: translateX(100%); opacity: 0; }
               to { transform: translateX(0); opacity: 1; }
           }
           @keyframes slideOutToast {
               from { transform: translateX(0); opacity: 1; }
               to { transform: translateX(100%); opacity: 0; }
           }
       `;
       document.head.appendChild(toastStyle);

       // Auto-hide alerts
       setTimeout(function() {
           const alerts = document.querySelectorAll('.alert');
           alerts.forEach(alert => {
               alert.style.opacity = '0';
               alert.style.transform = 'translateY(-10px)';
               setTimeout(() => alert.remove(), 300);
           });
       }, 5000);

       // Form validation before submit
       document.getElementById('registrationForm').addEventListener('submit', function(e) {
           const password = document.getElementById('password').value;
           const username = document.getElementById('username').value;
           const fullName = document.getElementById('fullName').value;
           
           if (password.length < 6) {
               e.preventDefault();
               showToast('Password must be at least 6 characters long', 'error');
               return;
           }
           
           if (username.length < 3) {
               e.preventDefault();
               showToast('Username must be at least 3 characters long', 'error');
               return;
           }
           
           if (fullName.trim().length < 2) {
               e.preventDefault();
               showToast('Please enter your full name', 'error');
               return;
           }
       });

       // Add ripple effect to button
       document.querySelector('.submit-btn').addEventListener('click', function(e) {
           const ripple = document.createElement('span');
           const rect = this.getBoundingClientRect();
           const size = Math.max(rect.width, rect.height);
           const x = e.clientX - rect.left - size / 2;
           const y = e.clientY - rect.top - size / 2;
           
           ripple.style.width = ripple.style.height = size + 'px';
           ripple.style.left = x + 'px';
           ripple.style.top = y + 'px';
           ripple.classList.add('ripple');
           
           this.appendChild(ripple);
           
           setTimeout(() => {
               ripple.remove();
           }, 600);
       });

       // Add ripple CSS
       const rippleStyle = document.createElement('style');
       rippleStyle.textContentrippleStyle.textContent = `
          .ripple {
              position: absolute;
              border-radius: 50%;
              background: rgba(255, 255, 255, 0.3);
              transform: scale(0);
              animation: rippleEffect 0.6s linear;
              pointer-events: none;
          }
          
          @keyframes rippleEffect {
              to {
                  transform: scale(2);
                  opacity: 0;
              }
          }
      `;
      document.head.appendChild(rippleStyle);

      // Keyboard shortcuts
      document.addEventListener('keydown', function(e) {
          // Escape to clear form
          if (e.key === 'Escape') {
              if (confirm('Clear all form data?')) {
                  document.getElementById('registrationForm').reset();
                  document.getElementById('passwordStrength').style.display = 'none';
                  showToast('Form cleared', 'info');
              }
          }
      });

      // Auto-format inputs
      document.getElementById('fullName').addEventListener('input', function() {
          // Capitalize first letter of each word
          this.value = this.value.replace(/\b\w/g, char => char.toUpperCase());
      });

      // Username input formatting
      document.getElementById('username').addEventListener('input', function() {
          // Remove spaces and special characters except underscore and dash
          this.value = this.value.toLowerCase().replace(/[^a-z0-9_-]/g, '');
      });

      // Enhanced form interactions
      document.querySelectorAll('.form-input').forEach((input, index) => {
          // Tab navigation enhancement
          input.addEventListener('keydown', function(e) {
              if (e.key === 'Enter') {
                  e.preventDefault();
                  const inputs = document.querySelectorAll('.form-input');
                  const nextInput = inputs[index + 1];
                  if (nextInput) {
                      nextInput.focus();
                  } else {
                      document.getElementById('submitBtn').focus();
                  }
              }
          });
      });

      // Progressive form completion indicator
      function updateFormProgress() {
          const inputs = document.querySelectorAll('.form-input[required]');
          let completed = 0;
          
          inputs.forEach(input => {
              if (input.value.trim() !== '' && input.checkValidity()) {
                  completed++;
              }
          });
          
          const progress = (completed / inputs.length) * 100;
          
          // You can add a progress bar if needed
          if (progress === 100) {
              document.getElementById('submitBtn').style.background = 
                  'linear-gradient(135deg, #047857, #059669)';
          } else {
              document.getElementById('submitBtn').style.background = 
                  'linear-gradient(135deg, #059669, #10b981)';
          }
      }

      // Monitor form completion
      document.querySelectorAll('.form-input').forEach(input => {
          input.addEventListener('input', updateFormProgress);
          input.addEventListener('blur', updateFormProgress);
      });

      // Initialize form on page load
      document.addEventListener('DOMContentLoaded', function() {
          // Focus first input
          document.getElementById('username').focus();
          
          // Initialize progress
          updateFormProgress();
      });

      // Smooth scroll to alerts
      function scrollToAlert() {
          const alert = document.querySelector('.alert');
          if (alert) {
              alert.scrollIntoView({ behavior: 'smooth', block: 'center' });
          }
      }

      // Call on page load if there are alerts
      if (document.querySelector('.alert')) {
          setTimeout(scrollToAlert, 100);
      }