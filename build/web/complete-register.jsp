<%-- 
    Document   : complete-register
    Created on : Jun 17, 2025, 11:26:41 AM
    Author     : admin
--%>

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
                background: white;
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
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                padding: 30px;
                flex-direction: column;
            }

            .left img {
                width: 100px;
                margin-bottom: 20px;
            }

            .left p {
                font-size: 20px;
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
            }

            .form-group input:focus {
                border-color: #2575fc;
                outline: none;
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
                margin-top: -10px;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="left">
                <img src="https://cdn-icons-png.flaticon.com/512/747/747376.png" alt="security-icon" />
                <p>Secure your account!</p>
            </div>

            <div class="right">
                <h2>Complete Registration</h2>
                <form action="complete-register" method="post">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" required />
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" required />
                    </div>

                    <!-- Optional error section -->
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <button type="submit" class="btn-submit">Register</button>
                </form>
            </div>
        </div>
    </body>
</html>
