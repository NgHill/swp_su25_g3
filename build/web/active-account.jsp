<%-- 
    Document   : active-account
    Created on : May 28, 2025, 10:51:27 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Activation</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .activation-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                width: 100%;
                max-width: 900px;
                min-height: 500px;
                display: flex;
                animation: slideUp 0.8s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .image-section {
                flex: 1;
                background: linear-gradient(45deg, #ff6b6b, #ffa726);
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow: hidden;
            }

            .image-section::before {
                content: '';
                position: absolute;
                width: 200%;
                height: 200%;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="white" fill-opacity="0.1"/></svg>') repeat;
                animation: float 20s linear infinite;
            }

            @keyframes float {
                0% {
                    transform: translate(-50%, -50%) rotate(0deg);
                }
                100% {
                    transform: translate(-50%, -50%) rotate(360deg);
                }
            }

            .image-placeholder {
                font-size: 4rem;
                color: white;
                font-weight: 300;
                z-index: 1;
                text-align: center;
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
            }

            .form-section {
                flex: 1;
                padding: 60px 50px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                position: relative;
                background: #f8f9fa;
            }

            .activation-header {
                text-align: center;
                margin-bottom: 40px;
            }

            .activation-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 10px;
                letter-spacing: -1px;
            }

            .activation-tab {
                display: inline-block;
                background: #ff6b6b;
                color: white;
                padding: 8px 24px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                margin-bottom: 20px;
            }

            .instruction-text {
                background: #e8f4fd;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 30px;
                border-left: 4px solid #667eea;
            }

            .instruction-text h3 {
                color: #2c3e50;
                font-size: 1.1rem;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .instruction-text p {
                color: #6c757d;
                line-height: 1.6;
                margin-bottom: 8px;
            }

            .email-highlight {
                color: #667eea;
                font-weight: 600;
                background: rgba(102, 126, 234, 0.1);
                padding: 2px 6px;
                border-radius: 4px;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                font-size: 0.95rem;
            }

            .form-input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e1e8ed;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: white;
                text-align: center;
                font-weight: 600;
                letter-spacing: 2px;
            }
            
            .password-container {
                position: relative;
            }

            .password-toggle {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #6c757d;
                cursor: pointer;
                font-size: 1.1rem;
                padding: 5px;
            }

            .password-toggle:hover {
                color: #667eea;
            }

            .password-strength {
                margin-top: 8px;
                font-size: 0.85rem;
            }

            .strength-weak {
                color: #dc3545;
            }
            .strength-medium {
                color: #ffc107;
            }
            .strength-strong {
                color: #28a745;
            }

            .form-input:focus {
                outline: none;
                border-color: #ff6b6b;
                box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
                transform: translateY(-2px);
            }

            .form-input.code-input {
                font-size: 1.2rem;
            }

            .activate-button {
                width: 100%;
                background: linear-gradient(135deg, #ff6b6b 0%, #ffa726 100%);
                color: white;
                border: none;
                padding: 16px;
                border-radius: 12px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
                margin-bottom: 20px;
            }

            .activate-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
            }

            .activate-button:active {
                transform: translateY(0);
            }

            .resend-section {
                text-align: center;
                padding: 20px 0;
                border-top: 1px solid #e1e8ed;
                margin-top: 10px;
            }

            .resend-text {
                color: #6c757d;
                font-size: 0.9rem;
                margin-bottom: 15px;
            }

            .resend-button {
                background: none;
                border: 2px solid #667eea;
                color: #667eea;
                padding: 10px 24px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-right: 10px;
            }

            .resend-button:hover {
                background: #667eea;
                color: white;
                transform: translateY(-2px);
            }

            .back-button {
                background: none;
                border: 2px solid #6c757d;
                color: #6c757d;
                padding: 10px 24px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .back-button:hover {
                background: #6c757d;
                color: white;
                transform: translateY(-2px);
            }

            .error-message {
                background: #fee;
                color: #c53030;
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #c53030;
                font-size: 0.9rem;
            }

            .success-message {
                background: #f0fff4;
                color: #2d7d2d;
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #28a745;
                font-size: 0.9rem;
            }

            .countdown-timer {
                background: #fff3cd;
                color: #856404;
                padding: 10px 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                font-size: 0.9rem;
                font-weight: 500;
            }

            @media (max-width: 768px) {
                .activation-container {
                    flex-direction: column;
                    max-width: 400px;
                }

                .image-section {
                    min-height: 200px;
                }

                .form-section {
                    padding: 40px 30px;
                }

                .activation-title {
                    font-size: 2rem;
                }

                .instruction-text {
                    padding: 15px;
                }
            }

            /* Loading animation */
            .loading {
                opacity: 0.7;
                pointer-events: none;
            }

            .loading .activate-button {
                position: relative;
            }

            .loading .activate-button::after {
                content: '';
                position: absolute;
                width: 20px;
                height: 20px;
                border: 2px solid transparent;
                border-top: 2px solid white;
                border-radius: 50%;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: translateY(-50%) rotate(0deg);
                }
                100% {
                    transform: translateY(-50%) rotate(360deg);
                }
            }

            /* Code input animation */
            .code-input:focus {
                animation: glow 1s ease-in-out infinite alternate;
            }

            @keyframes glow {
                from {
                    box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
                }
                to {
                    box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.3);
                }
            }
        </style>
    </head>
    <body>
        <div class="activation-container">
            <div class="image-section">
                <div class="image-placeholder">
                    ✉️<br>
                    <div style="font-size: 1.5rem; margin-top: 20px;">Check your email!</div>
                </div>
            </div>

            <div class="form-section">
                <div class="activation-header">
                    <h1 class="activation-title">ACTIVATION</h1>
                    <span class="activation-tab">ACTIVATE</span>
                </div>

                <!-- Error message display -->
                <c:if test="${error != null}">
                    <div class="error-message">
                        ${error}
                    </div>
                </c:if>
                <form method="post" id="activationForm">
                    <input type="hidden" name="email" value='${email != null ? email : ""}'>
                    <input type="hidden" name="activeCode" value='${activeCode != null ? activeCode:""}'>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">Password *</label>
                        <div class="password-container">
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                class="form-input" 
                                placeholder="Minimum 6 characters"
                                required
                                minlength="6"
                                >
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                👁️
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength"></div>
                        <div class="field-error" id="passwordError">Password must be at least 6 characters</div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password *</label>
                        <div class="password-container">
                            <input 
                                type="password" 
                                id="confirmPassword" 
                                name="confirmPassword" 
                                class="form-input" 
                                placeholder="Re-enter password"
                                required
                                >
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                👁️
                            </button>
                        </div>
                        <div class="field-error" id="confirmPasswordError">Password confirmation does not match</div>
                    </div>
                    
                    <button type="submit" class="activate-button" id="activateBtn">
                        🚀 Activate Account
                    </button>
                </form>

                <div class="resend-section">
                    <p class="resend-text">Didn't receive the email?</p>
                    <button type="button" class="resend-button" id="resendBtn" onclick="resendCode()">
                        📤 Resend Code
                    </button>
                    <a href="register" class="back-button">
                        ← Back to Registration
                    </a>

                    <div class="countdown-timer" id="countdown" style="display: none;">
                        Can resend in: <span id="timer">60</span>s
                    </div>
                </div>
            </div>
        </div>

        <script>
            let countdownInterval;
            let canResend = true;
            
            // Form validation
            function validateField(field) {
                const value = field.value.trim();
                const fieldName = field.name;
                const errorElement = document.getElementById(fieldName + 'Error');
                let isValid = true;

                switch (fieldName) {
                    case 'password':
                        isValid = value.length >= 6;
                        checkPasswordStrength(value);
                        // Also validate confirm password if it has value
                        const confirmPassword = document.getElementById('confirmPassword');
                        if (confirmPassword.value) {
                            validateField(confirmPassword);
                        }
                        break;
                    case 'confirmPassword':
                        const password = document.getElementById('password').value;
                        isValid = value === password && value.length > 0;
                        break;
                }

                if (isValid) {
                    field.classList.remove('input-invalid');
                    field.classList.add('input-valid');
                    errorElement.style.display = 'none';
                } else if (value.length > 0) {
                    field.classList.remove('input-valid');
                    field.classList.add('input-invalid');
                    errorElement.style.display = 'block';
                } else {
                    field.classList.remove('input-valid', 'input-invalid');
                    errorElement.style.display = 'none';
                }

                return isValid || value.length === 0;
            }
            // Add event listeners
            document.addEventListener('DOMContentLoaded', function () {
                const inputs = document.querySelectorAll('.form-input');
                const form = document.getElementById('registerForm');
                const submitBtn = document.getElementById('registerBtn');

                inputs.forEach(input => {
                    input.addEventListener('blur', () => validateField(input));
                    input.addEventListener('input', () => {
                        if (input.classList.contains('input-invalid')) {
                            validateField(input);
                        }
                    });
                });

                // Form submission
                form.addEventListener('submit', function (e) {
                    let isFormValid = true;

                    inputs.forEach(input => {
                        if (!validateField(input) && input.value.trim().length > 0) {
                            isFormValid = false;
                        } else if (input.hasAttribute('required') && input.value.trim().length === 0) {
                            isFormValid = false;
                            validateField(input);
                        }
                    });

                    const termsCheckbox = document.getElementById('terms');
                    if (!termsCheckbox.checked) {
                        isFormValid = false;
                        alert('Please agree to the terms of service');
                    }

                    if (!isFormValid) {
                        e.preventDefault();
                        return;
                    }

                    // Add loading state
                    form.classList.add('loading');
                    submitBtn.textContent = 'Registering...';

                    // Remove loading state after 10 seconds (fallback)
                    setTimeout(() => {
                        form.classList.remove('loading');
                        submitBtn.textContent = 'Create Account';
                    }, 10000);
                });
            });

            // Add focus animations
            document.querySelectorAll('.form-input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentElement.style.transform = 'scale(1.02)';
                });

                input.addEventListener('blur', function () {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
            
            function togglePassword(inputId) {
                const passwordInput = document.getElementById(inputId);
                const toggleBtn = passwordInput.nextElementSibling;

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleBtn.textContent = '🙈';
                } else {
                    passwordInput.type = 'password';
                    toggleBtn.textContent = '👁️';
                }
            }
            
            // Password strength checker
            function checkPasswordStrength(password) {
                const strengthElement = document.getElementById('passwordStrength');
                let strength = 0;
                let feedback = '';

                if (password.length >= 6)
                    strength++;
                if (password.match(/[a-z]/) && password.match(/[A-Z]/))
                    strength++;
                if (password.match(/\d/))
                    strength++;
                if (password.match(/[^a-zA-Z\d]/))
                    strength++;

                switch (strength) {
                    case 0:
                    case 1:
                        feedback = '<span class="strength-weak">Weak</span>';
                        break;
                    case 2:
                        feedback = '<span class="strength-medium">Medium</span>';
                        break;
                    case 3:
                    case 4:
                        feedback = '<span class="strength-strong">Strong</span>';
                        break;
                }

                strengthElement.innerHTML = password.length > 0 ? `Password strength: ${feedback}` : '';
            }

            // Form submission with loading state
            document.getElementById('activationForm').addEventListener('submit', function () {
                const form = this;
                const activateBtn = document.getElementById('activateBtn');

                form.classList.add('loading');
                activateBtn.innerHTML = '🔄 Activating...';

                // Remove loading state after 10 seconds (fallback)
                setTimeout(() => {
                    form.classList.remove('loading');
                    activateBtn.innerHTML = '🚀 Activate Account';
                }, 10000);
            });

            // Resend code function
            function resendCode() {
                if (!canResend)
                    return;

                const resendBtn = document.getElementById('resendBtn');
                const countdown = document.getElementById('countdown');
                const timer = document.getElementById('timer');

                // Disable resend button
                canResend = false;
                resendBtn.disabled = true;
                resendBtn.style.opacity = '0.5';
                resendBtn.style.cursor = 'not-allowed';

                // Show countdown
                countdown.style.display = 'block';
                let timeLeft = 60;
                timer.textContent = timeLeft;

                countdownInterval = setInterval(() => {
                    timeLeft--;
                    timer.textContent = timeLeft;

                    if (timeLeft <= 0) {
                        clearInterval(countdownInterval);
                        countdown.style.display = 'none';
                        canResend = true;
                        resendBtn.disabled = false;
                        resendBtn.style.opacity = '1';
                        resendBtn.style.cursor = 'pointer';
                    }
                }, 1000);

                // Simulate API call (replace with actual resend logic)
                fetch('/resend-activation-code', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'email=<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>'
                })
                        .then(response => {
                            if (response.ok) {
                                showNotification('✅ Activation code has been resent!', 'success');
                            } else {
                                showNotification('❌ An error occurred, please try again!', 'error');
                            }
                        })
                        .catch(error => {
                            showNotification('📧 Activation code has been resent!', 'success');
                        });
            }

            // Show notification
            function showNotification(message, type) {
                const notification = document.createElement('div');
                notification.className = type === 'success' ? 'success-message' : 'error-message';
                notification.textContent = message;
                notification.style.position = 'fixed';
                notification.style.top = '20px';
                notification.style.right = '20px';
                notification.style.zIndex = '1000';
                notification.style.minWidth = '300px';
                notification.style.animation = 'slideIn 0.5s ease-out';

                document.body.appendChild(notification);

                setTimeout(() => {
                    notification.style.animation = 'slideOut 0.5s ease-out';
                    setTimeout(() => {
                        document.body.removeChild(notification);
                    }, 500);
                }, 3000);
            }

            // Add CSS for notification animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideIn {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                @keyframes slideOut {
                    from { transform: translateX(0); opacity: 1; }
                    to { transform: translateX(100%); opacity: 0; }
                }
            `;
            document.head.appendChild(style);

            // Auto-format activation code input
            document.getElementById('activeCode').addEventListener('input', function (e) {
                let value = e.target.value.replace(/[^A-Z0-9a-z]/g, '');
                e.target.value = value;
            });

            // Auto-focus on code input
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('activeCode').focus();
            });

            // Add focus animations
            document.querySelectorAll('.form-input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentElement.style.transform = 'scale(1.02)';
                });

                input.addEventListener('blur', function () {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });

            // Handle paste event for activation code
            document.getElementById('activeCode').addEventListener('paste', function (e) {
                setTimeout(() => {
                    let value = e.target.value.replace(/[^A-Z0-9a-z]/g, '');
                    e.target.value = value.substring(0, 10);
                }, 10);
            });
        </script>
    </body>
</html>