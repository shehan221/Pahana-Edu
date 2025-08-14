
    // Show debug info if there are database issues
    if (window.location.search.includes('action=updateProfile')) {
        document.getElementById('dbInfo').style.display = 'block';
    }

    // Additional logout functions
    function forceLogout() {
        // Try multiple logout methods
        document.cookie.split(";").forEach(function(c) { 
            document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
        });
        
        // Clear session storage and local storage
        if (typeof(Storage) !== "undefined") {
            sessionStorage.clear();
            localStorage.clear();
        }
        
        // Force redirect to login or home
        window.location.replace('/');
    }
    
    function clearSession() {
        // Clear browser session and redirect
        if (typeof(Storage) !== "undefined") {
            sessionStorage.clear();
        }
        alert('Session cleared. Please navigate to login page manually.');
        closeLogoutModal();
    }
    
    // Check if logout failed and show alternative options
    setTimeout(function() {
        if (window.location.search.includes('action=logout')) {
            // If we're still on this page after logout attempt, show alternatives
            document.getElementById('alternativeLogout').style.display = 'block';
        }
    }, 2000);

    // Edit Profile Modal Functions
    function openEditModal() {
        document.getElementById('editModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
        document.getElementById('editProfileForm').reset();
        // Reset values to current user data
        document.getElementById('editFullName').value = '${user.fullName}';
        document.getElementById('editEmail').value = '${user.email}';
    }

    // Logout Modal Functions
    function openLogoutModal() {
        document.getElementById('logoutModal').style.display = 'block';
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    function confirmLogout() {
        // Show loading message
        document.querySelector('.logout-body p').innerHTML = 'Logging out...';
        
        // Disable buttons
        document.querySelector('.btn-confirm').disabled = true;
        document.querySelector('.btn-cancel').disabled = true;
        
        // Multiple logout strategies
        try {
            // Method 1: Try normal redirect
            window.location.href = '?action=logout';
        } catch (e) {
            // Method 2: Force page reload with logout action
            setTimeout(function() {
                window.location.replace(window.location.pathname + '?action=logout');
            }, 100);
        }
    }

    // Form validation
    document.getElementById('editProfileForm').addEventListener('submit', function(e) {
        var fullName = document.getElementById('editFullName').value.trim();
        var email = document.getElementById('editEmail').value.trim();
        var newPassword = document.getElementById('newPassword').value;
        
        if (!fullName) {
            e.preventDefault();
            alert('Full name is required.');
            document.getElementById('editFullName').focus();
            return;
        }
        
        if (!email) {
            e.preventDefault();
            alert('Email address is required.');
            document.getElementById('editEmail').focus();
            return;
        }
        
        // Email format validation
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address.');
            document.getElementById('editEmail').focus();
            return;
        }
        
        // Password validation (if provided)
        if (newPassword && newPassword.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long.');
            document.getElementById('newPassword').focus();
            return;
        }
    });

    // Auto-format full name (capitalize words)
    document.getElementById('editFullName').addEventListener('input', function() {
        this.value = this.value.replace(/\b\w/g, function(char) {
            return char.toUpperCase();
        });
    });

    // Close modals when clicking outside
    window.onclick = function(event) {
        var editModal = document.getElementById('editModal');
        var logoutModal = document.getElementById('logoutModal');
        
        if (event.target == editModal) {
            closeEditModal();
        }
        if (event.target == logoutModal) {
            closeLogoutModal();
        }
    }

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert');
        for (var i = 0; i < alerts.length; i++) {
            alerts[i].style.opacity = '0';
            alerts[i].style.transform = 'translateY(-10px)';
        }
    }, 5000);