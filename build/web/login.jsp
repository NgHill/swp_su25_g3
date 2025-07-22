<%-- 
    Document   : login
    Created on : May 28, 2025, 10:06:20 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
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

            .login-container {
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
                flex: 1;
                padding: 60px 50px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                position: relative;
                background: #f8f9fa;
            }

            .login-header {
                text-align: center;
                margin-bottom: 40px;
            }

            .login-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 10px;
                letter-spacing: -1px;
            }

            .login-tab {
                display: inline-block;
                background: #667eea;
                color: white;
                padding: 8px 24px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                margin-bottom: 30px;
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
            }

            .form-input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
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

            .forgot-password {
                text-align: right;
                margin-bottom: 30px;
            }

            .forgot-password a {
                color: #667eea;
                text-decoration: none;
                font-size: 0.9rem;
                font-weight: 500;
            }

            .forgot-password a:hover {
                text-decoration: underline;
            }

            .login-button {
                width: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 16px;
                border-radius: 12px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .login-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .login-button:active {
                transform: translateY(0);
            }

            .signup-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 25px;
                border-top: 1px solid #e1e8ed;
                font-size: 0.95rem;
                color: #6c757d;
            }

            .signup-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
            }

            .signup-link a:hover {
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

            @media (max-width: 768px) {
                .login-container {
                    flex-direction: column;
                    max-width: 400px;
                }

                .image-section {
                    min-height: 200px;
                }

                .form-section {
                    padding: 40px 30px;
                }

                .login-title {
                    font-size: 2rem;
                }
            }

            /* Loading animation */
            .loading {
                opacity: 0.7;
                pointer-events: none;
            }

            .loading .login-button {
                position: relative;
            }

            .loading .login-button::after {
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
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="image-section">
                <div class="image-placeholder">
                    📱<br>
                    <div style="font-size: 1.5rem; margin-top: 20px;">Welcome back!</div>
                </div>
            </div>

            <div class="form-section">
                <div class="login-header">
                    <h1 class="login-title">LOGIN</h1>
                    <span class="login-tab">LOG IN</span>
                </div>

                <!-- Error message display -->
                <c:if test="${success_message != null}">
                    <div class="error-message">
                        ${success_message}
                    </div>
                </c:if>
                <c:if test="${error != null}">
                    <div class="error-message">
                        ${error}
                    </div>
                </c:if>
                <form method="post" id="loginForm" action="login">
                    <div class="form-group">
                        <label for="username" class="form-label">Username</label>
                        <input 
                            type="text" 
                            id="username" 
                            name="username" 
                            class="form-input" 
                            placeholder="Enter email or phone number"
                            required
                            >
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <div class="password-container">
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                class="form-input" 
                                placeholder="Enter your password"
                                required
                                >
                            <button type="button" class="password-toggle" onclick="togglePassword()">
                                👁️
                            </button>
                        </div>
                    </div>

                    <div class="forgot-password">
                        <a href="forgot-password">Forgot password?</a>
                    </div>

                    <button type="submit" class="login-button" id="loginBtn">
                        Login
                    </button>
                </form>

                <div class="signup-link">
                    Don't have an account? <a href="register">Sign up now</a>
                </div>
            </div>
        </div>

        <script>
            function togglePassword() {
                const passwordInput = document.getElementById('password');
                const toggleBtn = document.querySelector('.password-toggle');

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleBtn.textContent = '🙈';
                } else {
                    passwordInput.type = 'password';
                    toggleBtn.textContent = '👁️';
                }
            }

            // Form submission with loading state
            document.getElementById('loginForm').addEventListener('submit', function () {
                const form = this;
                const loginBtn = document.getElementById('loginBtn');

                form.classList.add('loading');
                loginBtn.textContent = 'Logging in...';

                // Remove loading state after 10 seconds (fallback)
                setTimeout(() => {
                    form.classList.remove('loading');
                    loginBtn.textContent = 'Login';
                }, 10000);
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