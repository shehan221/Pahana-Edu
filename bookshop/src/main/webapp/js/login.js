/**
 * 
 */// Password toggle functionality
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

      // Copy to clipboard functionality
      function copyToClipboard(text, type) {
          navigator.clipboard.writeText(text).then(() => {
              // Visual feedback
              const event = new Event('copied');
              document.dispatchEvent(event);
              
              // Fill the form field
              if (type === 'username') {
                  document.getElementById('username').value = text;
              } else if (type === 'password') {
                  document.getElementById('password').value = text;
              }
              
              // Show temporary success
              showToast(`${type} copied and filled!`);
          }).catch(() => {
              // Fallback for older browsers
              const input = document.createElement('input');
              input.value = text;
              document.body.appendChild(input);
              input.select();
              document.execCommand('copy');
              document.body.removeChild(input);
              
              if (type === 'username') {
                  document.getElementById('username').value = text;
              } else if (type === 'password') {
                  document.getElementById('password').value = text;
              }
              
              showToast(`${type} copied and filled!`);
          });
      }

      // Toast notification
      function showToast(message) {
          const toast = document.createElement('div');
          toast.textContent = message;
          toast.style.cssText = `
              position: fixed;
              top: 20px;
              right: 20px;
              background: #059669;
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
          }, 2000);
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

      // Form submission with loading animation
      document.getElementById('loginForm').addEventListener('submit', function() {
          const loginBtn = document.getElementById('loginBtn');
          loginBtn.classList.add('loading');
          loginBtn.disabled = true;
      });

      // Input field enhancements
      document.querySelectorAll('.form-input').forEach(input => {
          input.addEventListener('focus', function() {
              this.parentElement.style.transform = 'scale(1.02)';
          });
          
          input.addEventListener('blur', function() {
              this.parentElement.style.transform = 'scale(1)';
          });
      });

      // Auto-hide alerts
      setTimeout(function() {
          const alerts = document.querySelectorAll('.alert');
          alerts.forEach(alert => {
              alert.style.opacity = '0';
              alert.style.transform = 'translateY(-10px)';
              setTimeout(() => alert.remove(), 300);
          });
      }, 5000);

      // Auto-focus appropriate field
      document.addEventListener('DOMContentLoaded', function() {
          const usernameField = document.getElementById('username');
          const passwordField = document.getElementById('password');
          
          if (usernameField.value === '') {
              usernameField.focus();
          } else {
              passwordField.focus();
          }
      });

      // Keyboard shortcuts
      document.addEventListener('keydown', function(e) {
          // Ctrl + Alt + L to auto-fill login
          if (e.ctrlKey && e.altKey && e.key === 'l') {
              e.preventDefault();
              document.getElementById('username').value = 'admin';
              document.getElementById('password').value = 'admin123';
              showToast('Login credentials auto-filled!');
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
      rippleStyle.textContent = `
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