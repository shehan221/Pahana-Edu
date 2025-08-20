
        // Demo admin credentials (removed since we don't have demo section anymore)
        function fillAdminCredentials() {
            document.getElementById('username').value = 'admin';
            document.getElementById('password').value = 'admin123';
        }

        // Form validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!username) {
                e.preventDefault();
                alert('Please enter your username!');
                return false;
            }
            
            if (!password) {
                e.preventDefault();
                alert('Please enter your password!');
                return false;
            }
        });

        // Auto-hide success messages
        document.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    successAlert.style.opacity = '0';
                    setTimeout(function() {
                        successAlert.remove();
                    }, 300);
                }, 5000);
            }
        });

        // Focus first input
        document.getElementById('username').focus();

        console.log('Login page loaded');
    