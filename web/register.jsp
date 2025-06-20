<%-- 
    Document   : register
    Created on : May 28, 2025, 10:19:11 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Registration</title>
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

            .register-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                width: 100%;
                max-width: 1000px;
                min-height: 600px;
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
                background: linear-gradient(45deg, #667eea, #764ba2);
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
            }

            .form-section {
                flex: 1.2;
                padding: 50px 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                position: relative;
                background: #f8f9fa;
                overflow-y: auto;
            }

            .register-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .register-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 10px;
                letter-spacing: -1px;
            }

            .register-tab {
                display: inline-block;
                background: #28a745;
                color: white;
                padding: 8px 24px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                margin-bottom: 25px;
            }

            .form-row {
                display: flex;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                flex: 1;
                margin-bottom: 20px;
            }

            .form-group.full-width {
                flex: none;
                width: 100%;
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
                padding: 14px 18px;
                border: 2px solid #e1e8ed;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .form-input.error {
                border-color: #dc3545;
                box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
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

            .register-button {
                width: 100%;
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                padding: 16px;
                border-radius: 12px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
                margin-top: 10px;
            }

            .register-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            }

            .register-button:active {
                transform: translateY(0);
            }

            .register-button:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
            }

            .login-link {
                text-align: center;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #e1e8ed;
                font-size: 0.95rem;
                color: #6c757d;
            }

            .login-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
            }

            .login-link a:hover {
                text-decoration: underline;
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

            .field-error {
                color: #dc3545;
                font-size: 0.8rem;
                margin-top: 5px;
                display: none;
            }

            .terms-checkbox {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                margin: 20px 0;
                font-size: 0.9rem;
                line-height: 1.4;
            }

            .terms-checkbox input[type="checkbox"] {
                margin-top: 2px;
                transform: scale(1.2);
            }

            .terms-checkbox a {
                color: #667eea;
                text-decoration: none;
            }

            .terms-checkbox a:hover {
                text-decoration: underline;
            }

            @media (max-width: 768px) {
                .register-container {
                    flex-direction: column;
                    max-width: 450px;
                }

                .image-section {
                    min-height: 200px;
                }

                .form-section {
                    padding: 30px 25px;
                }

                .register-title {
                    font-size: 2rem;
                }

                .form-row {
                    flex-direction: column;
                    gap: 0;
                }
            }

            /* Loading animation */
            .loading {
                opacity: 0.7;
                pointer-events: none;
            }

            .loading .register-button {
                position: relative;
            }

            .loading .register-button::after {
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

            /* Input validation styles */
            .input-valid {
                border-color: #28a745 !important;
                box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1) !important;
            }

            .input-invalid {
                border-color: #dc3545 !important;
                box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1) !important;
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <div class="image-section">
                <div class="image-placeholder">
                    🚀<br>
                    <div style="font-size: 1.5rem; margin-top: 20px;">Join us today!</div>
                </div>
            </div>

            <div class="form-section">
                <div class="register-header">
                    <h1 class="register-title">REGISTER</h1>
                    <span class="register-tab">SIGN UP</span>
                </div>

                <!-- Error message display -->
                <c:if test="${error != null}">
                    <div class="error-message">
                        ${error}
                    </div>
                </c:if>
                <form method="post" id="registerForm">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Full Name *</label>
                        <input 
                            type="text" 
                            id="fullName"
                            value='${fullName!=null?fullName:""}'
                            name="fullName" 
                            class="form-input" 
                            placeholder="Enter your full name"
                            required
                            >
                        <div class="field-error" id="fullNameError">Please enter your full name</div>
                    </div>
                    <div class="form-group">
                        <label for="mobile" class="form-label">Gender *</label>
                        <select id="gender" name="gender" class="form-input" required>
                            <option value="1">Male</option>
                            <option value="0">Female</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="email" class="form-label">Email *</label>
                        <input 
                            type="email" 
                            id="email" 
                            value='${email!=null?email:""}'
                            name="email" 
                            class="form-input" 
                            placeholder="example@email.com"
                            required
                            >
                        <div class="field-error" id="emailError">Invalid email address</div>
                    </div>
                    <div class="form-group">
                        <label for="mobile" class="form-label">Phone Number *</label>
                        <input 
                            type="tel" 
                            id="mobile" 
                            value='${mobile!=null?mobile:""}'
                            name="mobile" 
                            class="form-input" 
                            placeholder="Enter your phone number"
                            required
                            >
                        <div class="field-error" id="mobileError">Invalid phone number</div>
                    </div>


                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" required>
                        <label for="terms">
                            I agree to the <a href="#" target="_blank">Terms of Service</a> 
                            and <a href="#" target="_blank">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit" class="register-button" id="registerBtn">
                        Create Account
                    </button>
                </form>

                <div class="login-link">
                    Already have an account? <a href="login">Sign in now</a>
                </div>
            </div>
        </div>

        <script>
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

            // Form validation
            function validateField(field) {
                const value = field.value.trim();
                const fieldName = field.name;
                const errorElement = document.getElementById(fieldName + 'Error');
                let isValid = true;

                switch (fieldName) {
                    case 'fullName':
                        isValid = value.length >= 2;
                        break;
                    case 'email':
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        isValid = emailRegex.test(value);
                        break;
                    case 'mobile':
                        const phoneRegex = /^[0-9]{10,11}$/;
                        isValid = phoneRegex.test(value.replace(/\s+/g, ''));
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
        </script>
    </body>
</html>