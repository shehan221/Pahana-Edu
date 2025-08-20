
       // Form validation
       document.getElementById('registerForm').addEventListener('submit', function(e) {
           const password = document.getElementById('password').value;
           const confirmPassword = document.getElementById('confirmPassword').value;
           
           if (password !== confirmPassword) {
               e.preventDefault();
               alert('Passwords do not match!');
               return false;
           }
           
           if (password.length < 6) {
               e.preventDefault();
               alert('Password must be at least 6 characters long!');
               return false;
           }
       });

       // Real-time password confirmation check
       document.getElementById('confirmPassword').addEventListener('input', function() {
           const password = document.getElementById('password').value;
           const confirmPassword = this.value;
           
           if (confirmPassword && password !== confirmPassword) {
               this.style.borderColor = '#e53e3e';
               this.style.backgroundColor = '#fed7d7';
           } else {
               this.style.borderColor = '#e1e8ed';
               this.style.backgroundColor = '#f8f9fa';
           }
       });

       // Auto-hide success message and redirect to login
       document.addEventListener('DOMContentLoaded', function() {
           const successAlert = document.querySelector('.alert-success');
           if (successAlert) {
               setTimeout(function() {
                   window.location.href = '${pageContext.request.contextPath}/pages/login.jsp';
               }, 3000);
           }
       });

       console.log('Register page loaded');
