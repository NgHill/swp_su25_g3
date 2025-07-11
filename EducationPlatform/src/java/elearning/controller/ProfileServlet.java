package elearning.controller;


import elearning.BasicDAO.ProfileDAO;
import elearning.entities.Profile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name="Profile", urlPatterns={"/profile"})
public class ProfileServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = 2; // ID mặc định (có thể thay bằng session sau này)

        // Lấy thông tin profile từ DB
        List<elearning.entities.Profile> profiles = profileDAO.getProfileById(id);
        if (!profiles.isEmpty()) {
            request.setAttribute("profile", profiles.get(0));
        }

        // Lấy thông báo nếu có từ query string
        String message = request.getParameter("message");      
        if (message != null) {
            request.setAttribute("message", message);
        }

        // Chuyển tới trang JSP hiển thị profile
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         request.setCharacterEncoding("UTF-8");

    try {
        // Lấy dữ liệu từ form
        int id = 2; 
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String mobile = request.getParameter("mobile");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bio = request.getParameter("bio");

        // Chuyển đổi dateOfBirth sang java.sql.Date
        Date dateOfBirth = null;           
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                dateOfBirth = Date.valueOf(dateOfBirthStr); // Định dạng phải là yyyy-MM-dd
            }            

        Map<String, String> errors = new HashMap<>();

        if (!isValidFullName(fullName)) {
            errors.put("fullNameError", "Full Name phải viết hoa chữ cái đầu mỗi từ.");
        }
        if (!isValidUsername(username)) {
            errors.put("usernameError", "Username phải từ 5–12 ký tự, không có khoảng trắng.");
        }
        if (!isValidMobile(mobile)) {
            errors.put("mobileError", "Mobile phải là 10 chữ số, bắt đầu băng số 0.");
        }

        // Nếu có lỗi → gửi lại form
            if (!errors.isEmpty()) {
                Profile profile = buildProfileFromForm(request, id, dateOfBirth);
                request.setAttribute("profile", profile);
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Không có lỗi → cập nhật
            Profile profile = buildProfileFromForm(request, id, dateOfBirth);
            boolean isUpdated = profileDAO.updateProfile(profile);

            request.setAttribute("message", isUpdated ? "Cập nhật thành công" : "Cập nhật thất bại");
            request.setAttribute("messageType", isUpdated ? "success" : "error");

            // Reload lại profile mới
            List<Profile> profiles = profileDAO.getProfileById(id);
            if (!profiles.isEmpty()) {
                request.setAttribute("profile", profiles.get(0));
            }

            request.getRequestDispatcher("/profile.jsp").forward(request, response);


    } catch (Exception e) {
        e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?message=Lỗi hệ thống&type=error");
            return;
    }
}
    private Profile buildProfileFromForm(HttpServletRequest request, int id, Date dateOfBirth) {
        Profile profile = new Profile();
        profile.setId(id);
        profile.setFullName(request.getParameter("fullName"));
        profile.setEmail(request.getParameter("email"));
        profile.setUsername(request.getParameter("username"));
        profile.setMobile(request.getParameter("mobile"));
        profile.setDateOfBirth(dateOfBirth);
        profile.setGender(request.getParameter("gender"));
        profile.setBio(request.getParameter("bio"));
        return profile;
    }
    
    private boolean isValidFullName(String fullName) {
    if (fullName == null || fullName.trim().isEmpty()) return false;

    String[] words = fullName.trim().split("\\s+");
    for (String word : words) {
        if (word.length() == 0) return false;
        char firstChar = word.charAt(0);
        if (!Character.isUpperCase(firstChar)) {
            return false;
        }
    }
    return true;
}

    private boolean isValidUsername(String username) {
    if (username == null) return false;
    return username.length() >= 5 && username.length() <= 20 && !username.contains(" ");
}

    private boolean isValidMobile(String mobile) {
    return mobile != null && mobile.matches("^0\\d{9}$");
}

}
