package elearning.controller;


import elearning.BasicDAO.ProfileDAO;
import elearning.entities.Profile;
import elearning.entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name="Profile", urlPatterns={"/profile"})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024,   // 10MB
    fileSizeThreshold = 1024 * 1024      // 1MB
)
public class ProfileServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();

    // Lưu ngoài webapp để không mất khi redeploy
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + File.separator + "uploads";
    private static final String UPLOAD_DIR = "avatars";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        User userAuth = (User) request.getSession().getAttribute("userAuth");
        if (userAuth == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int id = userAuth.getId(); // Lấy ID từ session

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
        // FIXED: Lấy ID từ session thay vì hardcode
        User userAuth = (User) request.getSession().getAttribute("userAuth");
        if (userAuth == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
       }
            int id = userAuth.getId(); 
            
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

            // Xóa avatar cũ nếu có
            List<Profile> oldProfiles = profileDAO.getProfileById(id);
            if (!oldProfiles.isEmpty() && oldProfiles.get(0).getAvatar() != null) {
                String oldAvatarPath = UPLOAD_BASE_PATH + File.separator + oldProfiles.get(0).getAvatar().replace("/", File.separator);
                File oldFile = new File(oldAvatarPath);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            // THÊM: Xử lý upload avatar
            String avatarPath = handleAvatarUpload(request);
            
            Profile profile = buildProfileFromForm(request, id, dateOfBirth);
            
            // THÊM: Set avatar
            if (avatarPath != null) {
                profile.setAvatar(avatarPath);
            } else {
                // Giữ avatar cũ
                List<Profile> old = profileDAO.getProfileById(id);
                if (!old.isEmpty()) {
                    profile.setAvatar(old.get(0).getAvatar());
                }
            }
            
            boolean isUpdated = profileDAO.updateProfile(profile);

            if (isUpdated) {
                // Cập nhật avatar trong session
                userAuth.setAvatar(profile.getAvatar());
                request.getSession().setAttribute("userAuth", userAuth);
                request.setAttribute("message", "Cập nhật thành công");
            } else {
                request.setAttribute("message", "Cập nhật thất bại");
            }


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
    // THÊM: Upload avatar
    private String handleAvatarUpload(HttpServletRequest request) throws IOException, ServletException {
        Part part = request.getPart("avatar");
        if (part == null || part.getSize() == 0) return null;

        if (!part.getContentType().startsWith("image/")) {
            throw new ServletException("Chỉ cho phép ảnh!");
        }

        String originalFileName = getFileName(part);
        String extension = originalFileName.substring(originalFileName.lastIndexOf(".")).toLowerCase();

        // Kiểm tra extension
        boolean isValidExtension = false;
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (extension.equals(allowedExt)) {
                isValidExtension = true;
                break;
            }
        }
        if (!isValidExtension) {
            throw new ServletException("Định dạng file không được hỗ trợ!");
        }

        // Tạo đường dẫn theo năm/tháng
        java.util.Calendar cal = java.util.Calendar.getInstance();
        String yearMonth = String.format("%d/%02d", 
            cal.get(java.util.Calendar.YEAR), cal.get(java.util.Calendar.MONTH) + 1);
        String subDir = UPLOAD_DIR + "/" + yearMonth;
        String uploadPath = UPLOAD_BASE_PATH + File.separator + UPLOAD_DIR + File.separator + yearMonth;

        String fileName = System.currentTimeMillis() + "_" + java.util.UUID.randomUUID().toString() + extension;
        new File(uploadPath).mkdirs();

        part.write(uploadPath + File.separator + fileName);
        return subDir + "/" + fileName; // VD: avatars/2024/07/filename.jpg
    }

    // THÊM: Lấy tên file
    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "avatar.jpg";
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
