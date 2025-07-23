<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Complete Registration</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                box-sizing: border-box;
                font-family: 'Inter', sans-serif;
            }

            body {
                margin: 0;
                background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                background: #fff;
                width: 800px;
                max-width: 95%;
                display: flex;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            }

            .left {
                flex: 1;
                background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
                color: #fff;
                padding: 30px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }

            .left img {
                width: 100px;
                margin-bottom: 20px;
            }

            .left p {
                font-size: 20px;
                text-align: center;
            }

            .right {
                flex: 1;
                padding: 40px;
            }

            .right h2 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 30px;
                color: #1e1e1e;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                margin-bottom: 8px;
                font-weight: 600;
            }

            .form-group input {
                width: 100%;
                padding: 12px 14px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }

            .form-group input:focus {
                border-color: #2575fc;
                outline: none;
            }

            .form-group p {
                font-size: 13px;
                margin: 6px 0 0;
                min-height: 18px;
            }

            .btn-submit {
                width: 100%;
                padding: 14px;
                background-color: #28a745;
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .btn-submit:hover {
                background-color: #218838;
            }

            .error-message {
                color: red;
                font-size: 13px;
                margin-bottom: 10px;
            }

            .password-wrapper {
                position: relative;
            }

            .password-wrapper input {
                padding-right: 40px;
            }

            .toggle-password {
                position: absolute;
                top: 50%;
                right: 12px;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 18px;
                color: #666;
                user-select: none;
            }
        </style>
    </head>
    <body>
        <%
            String email = request.getParameter("email");
            String activeCode = request.getParameter("activeCode");
        %>
        <div class="container">
            <div class="left">
                <img src="https://cdn-icons-png.flaticon.com/512/747/747376.png" alt="security-icon" />
                <p>Secure your account!</p>
            </div>

            <div class="right">
                <h2>Complete Registration</h2>
                <form action="active-account" method="post">
                    <input type="hidden" name="email" value="<%= email %>">
                    <input type="hidden" name="activeCode" value="<%= activeCode %>">

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="password-wrapper">
                            <input type="password" name="password" id="password" />
                            <span class="toggle-password" onclick="togglePassword('password', this)">👁</span>
                        </div>
                        <p id="pwmsg"></p>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <div class="password-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" required />
                            <span class="toggle-password" onclick="togglePassword('confirmPassword', this)">👁</span>
                        </div>
                        <p id="pwmsg2"></p>
                    </div>

                    <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <button type="submit" class="btn-submit">Register</button>
                </form>
            </div>
        </div>

        <script>
            const passwordField = document.getElementById('password');
            const confirmPasswordField = document.getElementById('confirmPassword');
            const pwMsg = document.getElementById('pwmsg');
            const pwMsg2 = document.getElementById('pwmsg2');
            const form = document.querySelector('form');

            const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;
            const msg = "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.";

            function validatePasswordStrength() {
                const pw = passwordField.value;
                if (!regex.test(pw)) {
                    pwMsg.textContent = msg;
                    pwMsg.style.color = 'red';
                    return false;
                } else {
                    pwMsg.textContent = "Mật khẩu hợp lệ.";
                    pwMsg.style.color = 'green';
                    return true;
                }
            }

            function validatePasswordMatch() {
                const pw = passwordField.value;
                const confirmPw = confirmPasswordField.value;
                if (pw !== confirmPw) {
                    pwMsg2.textContent = "Mật khẩu xác nhận không khớp.";
                    pwMsg2.style.color = 'red';
                    return false;
                } else {
                    pwMsg2.textContent = "Xác nhận hợp lệ.";
                    pwMsg2.style.color = 'green';
                    return true;
                }
            }

            passwordField.addEventListener('input', () => {
                validatePasswordStrength();
                validatePasswordMatch();
            });

            confirmPasswordField.addEventListener('input', validatePasswordMatch);

            form.addEventListener('submit', function (e) {
                const isStrong = validatePasswordStrength();
                const isMatch = validatePasswordMatch();
                if (!isStrong || !isMatch) {
                    e.preventDefault();
                }
            });

            function togglePassword(fieldId, iconElement) {
                const input = document.getElementById(fieldId);
                if (input.type === "password") {
                    input.type = "text";
                    iconElement.textContent = "🙈";
                } else {
                    input.type = "password";
                    iconElement.textContent = "👁";
                }
            }
        </script>
    </body>
</html>
