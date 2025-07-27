-- Tạo database
CREATE DATABASE EducationPlatform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE EducationPlatform;

-- Bảng Users
CREATE TABLE Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Mobile VARCHAR(20),
    Password VARCHAR(255),
    Gender BOOLEAN DEFAULT 0,
    Avatar VARCHAR(255),
    Role VARCHAR(50) DEFAULT 'customer',
    Status VARCHAR(50) DEFAULT 'active',
    ActiveCode VARCHAR(10),
    Username VARCHAR(50) UNIQUE,
    Bio TEXT,
    DateOfBirth DATE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Bảng SubjectPackages (đã cập nhật với các trường mới)
CREATE TABLE SubjectPackages (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Description TEXT,
    BriefInfo TEXT,
    Tagline TEXT,
    Thumbnail VARCHAR(255),
    LowestPrice DOUBLE,
    OriginalPrice DOUBLE,
    SalePrice DOUBLE,
    OwnerId INT,
    Category VARCHAR(100),
    Status VARCHAR(50) DEFAULT 'published',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerId) REFERENCES Users(Id)
);

-- Bảng Registrations 
CREATE TABLE Registrations (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    SubjectId INT,
    PackageMonths INT NOT NULL DEFAULT 1,
    Status VARCHAR(50) DEFAULT 'submitted',
    TotalCost DOUBLE,
    ValidFrom DATE,
    ValidTo DATE,
    RegisteredFullName VARCHAR(100),
    RegisteredEmail VARCHAR(100),
    RegisteredMobile VARCHAR(20),
    RegisteredGender BOOLEAN,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

-- Bảng Posts
CREATE TABLE Posts (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Image VARCHAR(1000),
    Content TEXT,
    Thumbnail VARCHAR(255),
	Description TEXT,
    Category VARCHAR(1000),
    AuthorId INT,
    ViewCount INT DEFAULT 0,
    Status VARCHAR(50) DEFAULT 'published',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AuthorId) REFERENCES Users(Id)
);

-- Bảng Sliders (đã cập nhật)
CREATE TABLE Sliders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Image VARCHAR(500),
    Title VARCHAR(255),
    Description TEXT,
    Type VARCHAR(100),
    OrderNumber INT
);

-- Bảng Subject_List
CREATE TABLE Subject_List (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Number_Of_Lesson INT,
    Owner VARCHAR(100),
    Status VARCHAR(50),
    Featured BOOLEAN DEFAULT FALSE,
    Thumbnail_Url VARCHAR(500),
    Description TEXT,
    Created_At DATETIME DEFAULT CURRENT_TIMESTAMP,
    Updated_At DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng Questions
CREATE TABLE Questions (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SubjectId INT,
    LessonId INT,
    DimensionId INT,
    Level VARCHAR(50),
    Content TEXT,
    Media TEXT,
    QuestionType ENUM('text_input', 'multiple_choice') NOT NULL DEFAULT 'multiple_choice',
    Status VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

-- Bảng QuestionAnswers
CREATE TABLE QuestionAnswers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    QuestionId INT,
    Content TEXT,
    IsCorrect BOOLEAN DEFAULT FALSE,
    Explanation TEXT,
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id)
);

-- Bảng Quizzes
CREATE TABLE Quizzes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    SubjectId INT,
    Duration INT,
    Status VARCHAR(50) DEFAULT 'active',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

-- Bảng QuizQuestions
CREATE TABLE QuizQuestions (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    QuizId INT,
    QuestionId INT,
    FOREIGN KEY (QuizId) REFERENCES Quizzes(Id),
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id)
);

-- Bảng QuizResults
CREATE TABLE QuizResults (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    QuizId INT,
    Score DECIMAL(5,2),
    SubmittedAt DATETIME,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (QuizId) REFERENCES Quizzes(Id)
);

-- Tạo bảng UserAnswer
CREATE TABLE UserAnswer (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    QuizId INT NOT NULL,
    QuestionId INT NOT NULL,
    AnswerId INT NULL, -- Cho multiple choice questions
    TextAnswer TEXT NULL, -- Cho text input questions
    IsCorrect BOOLEAN DEFAULT FALSE,
    ImagePath VARCHAR(500) NULL,
    AnsweredAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (QuizId) REFERENCES Quizzes(Id),
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id),
    FOREIGN KEY (AnswerId) REFERENCES QuestionAnswers(Id),
    INDEX idx_user_quiz (UserId, QuizId),
    INDEX idx_quiz_question (QuizId, QuestionId)
);

-- Bảng Stimulations
CREATE TABLE Stimulations (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SubjectId INT NOT NULL,
    StimulationExam VARCHAR(255),
    Level VARCHAR(50),
    NumberOfQuestions INT,
    Duration INT, -- phút
    PassRate DECIMAL(5,2),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

-- Insert các user khác trước để Marketing Staff sẽ có ID = 3
INSERT INTO users (FullName, Email, Mobile, Password, Gender, Avatar, Role, Status, ActiveCode, CreatedAt, Username, Bio, DateOfBirth) VALUES
('John Link Doe', 'john123.doe@example.com', '0912345678', 'hashed_password_1users', 0, NULL, 'customer', 'active', NULL, '2025-07-23 13:47:44', 'johndoe', 'Passionate software developer with 5 years of experience in web development. Love coding and learning new technologies.', '1990-05-15'),
('Jane Smith', 'cc.role@example.com', '0987654321', 'cc1234567@', 1, NULL, 'courseContent', 'active', NULL, '2025-07-23 13:47:44', 'janesmith', 'Digital marketing specialist and content creator. Enthusiastic about social media trends and brand building.', '1988-11-22'),
('Marketing Staff', 'mtk.user@example.com', '0901122334', 'Mtk123456@', 0, NULL, 'mtk', 'active', NULL, '2025-07-23 13:47:44', 'mtkstaff', 'System administrator with extensive experience in database management and server maintenance.', '1985-03-08'),
('Admin User', 'admin.user@example.com', '0901122334', 'hashed_password_3', 0, NULL, 'admin', 'active', NULL, '2025-07-23 13:47:44', 'adminuser', 'System administrator with extensive experience in database management and server maintenance.', '1985-03-08'),
('Huy Manh', 'manhmg24112001@gmail.com', '0385992411', 'A123Manh@', 1, NULL, 'customer', 'active', 'ztGNhGhCVR', '2025-07-23 00:30:27', 'huymanh', NULL, NULL),
('Dat Phan', 'dat@gmail.com', '0123456789', 'hash_password_4', 1, NULL, 'mkt', 'active', NULL, '2025-07-23 13:47:44', 'hoantudrill', 'Poor people', '1999-03-12');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (1, 'Lập trình hướng đối tượng với Java', 'https://i.ytimg.com/vi/nh4jiEq1HHM/maxresdefault.jpg', 'This is a post about lập trình hướng đối tượng với java.',
'Lập trình hướng đối tượng với Java – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.', 'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực IT. Bạn sẽ được hướng dẫn chi tiết về Lập trình hướng đối tượng với Java, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập. Từng phần đều được trình bày rõ ràng, súc tích, dễ tiếp cận và có giá trị ứng dụng cao. Nếu bạn đang tìm kiếm tài liệu chuẩn chỉnh để học chuyên sâu về Lập trình hướng đối tượng với Java, đừng bỏ qua bài viết này.', 'IT', 3, 111, 'active', '2025-07-25 09:01:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (2, 'Giới thiệu về Git và GitHub', 'https://310nae.com/wp-content/uploads/2018/11/github-718x472.png', 'This is a post about giới thiệu về git và github.',
'Giới thiệu về Git và GitHub – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.', 'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực IT. Bạn sẽ được hướng dẫn chi tiết về Giới thiệu về Git và GitHub, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập. Từng phần đều được trình bày rõ ràng, súc tích, dễ tiếp cận và có giá trị ứng dụng cao. Nếu bạn đang tìm kiếm tài liệu chuẩn chỉnh để học chuyên sâu về Giới thiệu về Git và GitHub, đừng bỏ qua bài viết này.', 'IT', 3, 69, 'active', '2025-07-25 09:02:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (3, 'Bảo mật hệ thống mạng cho người mới', 'https://vdodata.vn/wp-content/uploads/2021/04/giai-phap-bao-mat-du-lieu-cho-doanh-nghiep-trong-thoi-ky-cong-nghe-so-1.jpg', 'This is a post about bảo mật hệ thống mạng cho người mới.',
'Bảo mật hệ thống mạng cho người mới – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.', 'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực IT. Bạn sẽ được hướng dẫn chi tiết về Bảo mật hệ thống mạng cho người mới, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập. Từng phần đều được trình bày rõ ràng, súc tích, dễ tiếp cận và có giá trị ứng dụng cao. Nếu bạn đang tìm kiếm tài liệu chuẩn chỉnh để học chuyên sâu về Bảo mật hệ thống mạng cho người mới, đừng bỏ qua bài viết này.', 'IT', 3, 264, 'active', '2025-07-25 09:03:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (4, 'Xây dựng API với Node.js', 'https://th.bing.com/th/id/R.811ab9b30502101044ae7af7ff1d4152?rik=S34RaduyrsQkvw&pid=ImgRaw&r=0', 'This is a post about xây dựng api với node.js.',
'Xây dựng API với Node.js – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.', 'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực IT. Bạn sẽ được hướng dẫn chi tiết về Xây dựng API với Node.js, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập. Từng phần đều được trình bày rõ ràng, súc tích, dễ tiếp cận và có giá trị ứng dụng cao. Nếu bạn đang tìm kiếm tài liệu chuẩn chỉnh để học chuyên sâu về Xây dựng API với Node.js, đừng bỏ qua bài viết này.', 'IT', 3, 74, 'active', '2025-07-25 09:04:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (5, 'Tư duy thuật toán cho lập trình viên', 'https://d3hi6wehcrq5by.cloudfront.net/itnavi-blog/2021/03/T%C6%B0-duy-l%E1%BA%ADp-tr%C3%ACnh-1.jpg', 'This is a post about tư duy thuật toán cho lập trình viên.',
'Tư duy thuật toán cho lập trình viên – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.', 'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực IT. Bạn sẽ được hướng dẫn chi tiết về Tư duy thuật toán cho lập trình viên, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập. Từng phần đều được trình bày rõ ràng, súc tích, dễ tiếp cận và có giá trị ứng dụng cao. Nếu bạn đang tìm kiếm tài liệu chuẩn chỉnh để học chuyên sâu về Tư duy thuật toán cho lập trình viên, đừng bỏ qua bài viết này.', 'IT', 3, 226, 'active', '2025-07-25 09:05:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (6, 'Chiến lược định giá sản phẩm', 'https://storage.googleapis.com/stateless.navee.asia/2023/02/0eea9905-chien-luoc-gia-1.jpg',
'This is a post about chiến lược định giá sản phẩm.',
'Chiến lược định giá sản phẩm – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Business. Bạn sẽ được hướng dẫn chi tiết về Chiến lược định giá sản phẩm, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập...', 
'Business', 3, 103, 'active', '2025-07-25 09:06:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (7, 'Kỹ năng quản lý nhóm hiệu quả', 'https://hrchannels.com/uptalent/attachments/images/20231115/095752803_ky-nang-quan-ly-nhom.jpg',
'This is a post about kỹ năng quản lý nhóm hiệu quả.',
'Kỹ năng quản lý nhóm hiệu quả – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Business. Bạn sẽ được hướng dẫn chi tiết về Kỹ năng quản lý nhóm hiệu quả...'
, 'Business', 3, 193, 'active', '2025-07-25 09:07:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (8, 'Phân tích SWOT trong thực tiễn', 'https://72agency.vn/wp-content/uploads/2022/11/phan-tich-swot-2.jpg',
'This is a post about phân tích swot trong thực tiễn.',
'Phân tích SWOT trong thực tiễn – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Business...'
, 'Business', 3, 61, 'active', '2025-07-25 09:08:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (9, 'Tối ưu chi phí doanh nghiệp nhỏ', 'https://openend.vn/wp-content/uploads/2021/11/giam-chi-phi-lao-dong-1536x893.png',
'This is a post about tối ưu chi phí doanh nghiệp nhỏ.',
'Tối ưu chi phí doanh nghiệp nhỏ – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Business...'
, 'Business', 3, 233, 'active', '2025-07-25 09:09:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (10, 'Lập kế hoạch kinh doanh chuyên nghiệp', 'https://th.bing.com/th/id/R.91b7c03992c9bfdc94156e43245aa02a?rik=bHjUSMeqjn9sjg&pid=ImgRaw&r=0',
'This is a post about lập kế hoạch kinh doanh chuyên nghiệp.',
'Lập kế hoạch kinh doanh chuyên nghiệp – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Business...'
, 'Business', 3, 300, 'active', '2025-07-25 09:10:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (11, 'Thiết kế UI hiện đại cho ứng dụng di động', 'https://data.designervn.net/2018/03/3729_ad96b7ef2508ab86777fabf5039e312c.jpg',
'This is a post about thiết kế ui hiện đại cho ứng dụng di động.',
'Thiết kế UI hiện đại cho ứng dụng di động – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Design...'
, 'Design', 3, 275, 'active', '2025-07-25 09:11:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (12, 'Tâm lý màu sắc trong thiết kế đồ họa', 'https://caodang.fpt.edu.vn/wp-content/uploads/image4-60-1536x713.png',
'This is a post about tâm lý màu sắc trong thiết kế đồ họa.',
'Tâm lý màu sắc trong thiết kế đồ họa – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Design...'
, 'Design', 3, 196, 'active', '2025-07-25 09:12:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (13, 'Figma cơ bản đến nâng cao', 'https://i.ytimg.com/vi/M0JRk9LPOq4/maxresdefault.jpg',
'This is a post about figma cơ bản đến nâng cao.',
'Figma cơ bản đến nâng cao – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Design...'
, 'Design', 3, 158, 'active', '2025-07-25 09:13:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (14, 'Thiết kế banner quảng cáo hiệu quả', 'https://quangcaothanhnien.com.vn/wp-content/uploads/2022/05/standee-gia-cuon-duc-kien-ad-scaled-1.jpg',
'This is a post about thiết kế banner quảng cáo hiệu quả.',
'Thiết kế banner quảng cáo hiệu quả – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Design...'
, 'Design', 3, 227, 'active', '2025-07-25 09:14:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (15, 'Nguyên tắc thị giác trong thiết kế UX', 'https://data.designervn.net/2023/03/14621_28122586_7368256.jpg',
'This is a post about nguyên tắc thị giác trong thiết kế ux.',
'Nguyên tắc thị giác trong thiết kế UX – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Design...'
, 'Design', 3, 92, 'active', '2025-07-25 09:15:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (16, 'IELTS Writing Task 2 – Chiến lược nâng band', 'https://tse1.mm.bing.net/th/id/OIP.B9ckv3Kv4kc1f4pwi4nh6gHaD4?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
'This is a post about ielts writing task 2 – chiến lược nâng band.',
'IELTS Writing Task 2 – Chiến lược nâng band – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Language. Bạn sẽ được hướng dẫn chi tiết về IELTS Writing Task 2 – Chiến lược nâng band, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành. Dù bạn là người mới bắt đầu hay đã có nền tảng, bài viết sẽ giúp bạn mở rộng kiến thức và nâng cao kỹ năng. Đặc biệt, chúng tôi cung cấp các tình huống thực tiễn giúp bạn áp dụng lý thuyết vào công việc hoặc học tập...', 
'Language', 3, 92, 'active', '2025-07-25 09:16:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (17, 'TOEIC Listening: Cách xử lý Part 3-4', 'https://media.zim.vn/64376be6a3ece377f1b8a242/xu-ly-bay-toeic-part-4-2.jpg?w=750&q=75',
'This is a post about toeic listening: cách xử lý part 3-4.',
'TOEIC Listening: Cách xử lý Part 3-4 – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Language. Bạn sẽ được hướng dẫn chi tiết về TOEIC Listening: Cách xử lý Part 3-4, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành...', 
'Language', 3, 169, 'active', '2025-07-25 09:17:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (18, 'Phát âm tiếng Anh theo ngữ điệu Mỹ', 'https://media.zim.vn/66a2145375cbbb869247fb06/huong-dan-cach-luyen-phat-am-tieng-anh-chuan-giong-my-2.jpg',
'This is a post about phát âm tiếng anh theo ngữ điệu mỹ.',
'Phát âm tiếng Anh theo ngữ điệu Mỹ – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Language. Bạn sẽ được hướng dẫn chi tiết về Phát âm tiếng Anh theo ngữ điệu Mỹ, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành...', 
'Language', 3, 215, 'active', '2025-07-25 09:18:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (19, 'Luyện nói tiếng Anh qua podcast', 'https://i.ytimg.com/vi/Z9Sl4MU4ilM/maxresdefault.jpg',
'This is a post about luyện nói tiếng anh qua podcast.',
'Luyện nói tiếng Anh qua podcast – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Language. Bạn sẽ được hướng dẫn chi tiết về Luyện nói tiếng Anh qua podcast, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành...', 
'Language', 3, 141, 'active', '2025-07-25 09:19:00');

INSERT INTO posts (Id, Title, Image, Content, Thumbnail, Description, Category, AuthorId, ViewCount, Status, CreatedAt)
VALUES (20, 'Kỹ năng viết email chuyên nghiệp bằng tiếng Anh', 'https://tse2.mm.bing.net/th/id/OIP.VScu45CTrs7qf0LXQu43hAHaEo?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
'This is a post about kỹ năng viết email chuyên nghiệp bằng tiếng anh.',
'Kỹ năng viết email chuyên nghiệp bằng tiếng Anh – Khơi nguồn cảm hứng và ứng dụng vào thực tế công việc hằng ngày.',
'Bài viết này phân tích sâu sắc chủ đề quan trọng trong lĩnh vực Language. Bạn sẽ được hướng dẫn chi tiết về Kỹ năng viết email chuyên nghiệp bằng tiếng Anh, từ khái niệm cơ bản đến những chiến lược nâng cao. Nội dung bao gồm ví dụ thực tế, lỗi thường gặp và cách khắc phục, cùng với kinh nghiệm từ người trong ngành...', 
'Language', 3, 200, 'active', '2025-07-25 09:20:00');


INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('1','https://tse3.mm.bing.net/th/id/OIP.AAXS553wGPiRSGvOfy83YQHaE8?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', 'Testing time','https://tse3.mm.bing.net/th/id/OIP.AAXS553wGPiRSGvOfy83YQHaE8?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', 'Show', '1');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('2','https://vn.elsaspeak.com/wp-content/uploads/2023/11/viet-email-tieng-anh-min.png', 'Tiếng Anh chuyên nghiệp, đúng chuẩn cho mọi tình huống','https://vn.elsaspeak.com/wp-content/uploads/2023/11/viet-email-tieng-anh-min.png', 'Show', '2');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('3','https://vn.elsaspeak.com/wp-content/uploads/2022/10/Banner-2a-2-1024x461.png', ' ELSA Speak','https://vn.elsaspeak.com/wp-content/uploads/2022/10/Banner-2a-2-1024x461.png', 'Show', '3');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('4','https://anhtester.com/uploads/post/software-engineer.jpg', ' Tester chuyên nghiệp','https://anhtester.com/uploads/post/software-engineer.jpg', 'Hide', '4');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('5','https://static.topcv.vn/cms/tester-la-gi-topcv-06791ed5b8811c.png', ' Tester is ?','https://static.topcv.vn/cms/tester-la-gi-topcv-06791ed5b8811c.png', 'Show', '5');


INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('6','https://www.educatorstechnology.com/wp-content/uploads/2023/05/Quizlet-1024x683.png', ' Quizlet ADD','https://www.educatorstechnology.com/wp-content/uploads/2023/05/Quizlet-1024x683.png', 'Show', '6');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('7','https://edumentors.co.uk/blog/wp-content/uploads/2023/03/Quizlet-Website-Homepage-2048x883.jpg', ' Quizlet ADD 2','https://edumentors.co.uk/blog/wp-content/uploads/2023/03/Quizlet-Website-Homepage-2048x883.jpg', 'Show', '7');

INSERT INTO `educationplatform`.`sliders` (`Id`, `Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES('8','https://indiancybersecuritysolutions.com/checklist-for-penetration-testing-web-applications/assets/img/5651580e26897d2a8f348dc3978fb378.png', ' Checking test','https://indiancybersecuritysolutions.com/checklist-for-penetration-testing-web-applications/assets/img/5651580e26897d2a8f348dc3978fb378.png', 'Hide', '8');




-- Insert SubjectPackages for Teamwork (8 subjects)
INSERT INTO SubjectPackages (Title, Description, BriefInfo, Tagline, Thumbnail, LowestPrice, OriginalPrice, SalePrice, OwnerId, Category, Status) VALUES
('Effective Collaboration Skills', 'Learn how to work seamlessly in a team to achieve common goals.', 'Enhance teamwork abilities.', 'Collaborate effectively, achieve great success.', 'teamwork_collab.jpg', 199000, 250000, 225000, 3, 'Teamwork', 'published'),
('Building Strong Teams', 'This course helps you build and maintain strong teams.', 'Build robust teams.', 'Strong teams, big success.', 'teamwork_strongteam.jpg', 249000, 300000, 270000, 3, 'Teamwork', 'published'),
('Resolving Team Conflicts', 'Strategies for resolving disagreements in the workplace.', 'Resolve conflicts effectively.', 'Harmonize conflicts, strengthen unity.', 'teamwork_conflict.jpg', 179000, 220000, 199000, 3, 'Teamwork', 'published'),
('Goal-Oriented Team Leadership', 'Develop leadership skills to guide teams towards results.', 'Lead successful teams.', 'Lead teams, conquer goals.', 'teamwork_leadership.jpg', 299000, 350000, 320000, 3, 'Teamwork', 'published'),
('Optimizing Team Performance', 'Improve the productivity of the entire team.', 'Optimize team productivity.', 'Elevate team performance.', 'teamwork_performance.jpg', 219000, 280000, 249000, 3, 'Teamwork', 'published'),
('Project Coordination Skills', 'Learn how to coordinate team members in a project.', 'Flexible project coordination.', 'Smooth coordination, successful projects.', 'teamwork_project.jpg', 239000, 290000, 260000, 3, 'Teamwork', 'published'),
('Team Communication', 'Improve internal communication for smooth team operations.', 'Clear communication within the team.', 'Clear communication, strong team cohesion.', 'teamwork_communication.jpg', 189000, 230000, 209000, 3, 'Teamwork', 'published'),
('Building a Team Culture', 'Create a positive and cohesive work environment.', 'Foster team culture.', 'Team culture - Key to success.', 'teamwork_culture.jpg', 269000, 320000, 290000, 3, 'Teamwork', 'published');

-- Insert SubjectPackages for Communication (7 subjects)
INSERT INTO SubjectPackages (Title, Description, BriefInfo, Tagline, Thumbnail, LowestPrice, OriginalPrice, SalePrice, OwnerId, Category, Status) VALUES
('Art of Persuasive Communication', 'This course helps you present ideas clearly and persuasively.', 'Persuade through words.', 'Speak to persuade, listen to believe.', 'comm_persuasion.jpg', 210000, 260000, 230000, 3, 'Communication', 'published'),
('Impressive Presentation Skills', 'Secrets to a professional, engaging presentation.', 'Confident presentation.', 'Peak presentations, lasting impressions.', 'comm_presentation.jpg', 280000, 340000, 300000, 3, 'Communication', 'published'),
('Non-Verbal Communication', 'Understand and use body language effectively.', 'The power of non-verbal cues.', 'Read language, connect hearts.', 'comm_nonverbal.jpg', 160000, 200000, 180000, 3, 'Communication', 'published'),
('Active Listening', 'The art of listening to understand better and build relationships.', 'Listen to understand.', 'Active listening, deep communication.', 'comm_listening.jpg', 150000, 190000, 170000, 3, 'Communication', 'published'),
('Communication in Negotiation', 'Communication strategies to achieve the best results in negotiations.', 'Effective negotiation.', 'Skilful communication, successful negotiation.', 'comm_negotiation.jpg', 250000, 300000, 270000, 3, 'Communication', 'published'),
('Professional Email Writing', 'Skills for clear, concise, and effective email writing.', 'Professional email writing.', 'Standard emails, clear messages.', 'comm_email.jpg', 130000, 170000, 150000, 3, 'Communication', 'published'),
('Constructive Feedback Skills', 'How to give and receive feedback positively and effectively.', 'Constructive feedback.', 'Smart feedback, extraordinary development.', 'comm_feedback.jpg', 190000, 240000, 210000, 3, 'Communication', 'published');

-- Insert SubjectPackages for Self Improve (4 subjects)
INSERT INTO SubjectPackages (Title, Description, BriefInfo, Tagline, Thumbnail, LowestPrice, OriginalPrice, SalePrice, OwnerId, Category, Status) VALUES
('Effective Time Management', 'Secrets to organizing work and priorities to maximize productivity.', 'Time management.', 'Master time, master life.', 'self_time.jpg', 180000, 230000, 200000, 3, 'Self Improve', 'published'),
('Developing Positive Thinking', 'Change your perspective for an optimistic outlook and overcome challenges.', 'Positive thinking.', 'Positive mindset, bright life.', 'self_positive.jpg', 170000, 210000, 190000, 3, 'Self Improve', 'published'),
('Emotional Control', 'Learn to recognize, understand, and manage your emotions.', 'Emotional control.', 'Control emotions, master yourself.', 'self_emotion.jpg', 200000, 250000, 220000, 3, 'Self Improve', 'published'),
('Goal Setting & Personal Planning', 'Set SMART goals and build a roadmap to achieve them.', 'Goal setting.', 'Clear goals, lasting success.', 'self_goal.jpg', 220000, 270000, 240000, 3, 'Self Improve', 'published');

-- Insert SubjectPackages for Thinking (8 subjects)
INSERT INTO SubjectPackages (Title, Description, BriefInfo, Tagline, Thumbnail, LowestPrice, OriginalPrice, SalePrice, OwnerId, Category, Status) VALUES
('Deep Critical Thinking', 'Develop the ability to analyze and evaluate information objectively.', 'Problem analysis.', 'Critical thinking, multi-dimensional perspective.', 'think_critical.jpg', 260000, 310000, 280000, 3, 'Thinking', 'published'),
('Creative Problem Solving', 'Apply creative thinking methods to find solutions.', 'Find creative solutions.', 'Breakthrough creativity, smart solutions.', 'think_problem.jpg', 240000, 290000, 260000, 3, 'Thinking', 'published'),
('Effective Decision Making', 'Decision-making process based on data and analysis.', 'Make sound decisions.', 'Wise decisions, sustainable success.', 'think_decision.jpg', 230000, 280000, 250000, 3, 'Thinking', 'published'),
('Logic & Reasoning', 'Improve the ability to reason rigorously and think logically.', 'Logical reasoning.', 'Sharp logic, strong arguments.', 'think_logic.jpg', 210000, 260000, 230000, 3, 'Thinking', 'published'),
('System Thinking', 'Understand how components interact in a complex system.', 'Holistic thinking.', 'Long-term vision, system thinking.', 'think_system.jpg', 270000, 320000, 290000, 3, 'Thinking', 'published'),
('Innovation Thinking', 'Develop the ability to conceive new, groundbreaking ideas.', 'Ignite innovation.', 'Continuous innovation, lead the trend.', 'think_innovation.jpg', 250000, 300000, 270000, 3, 'Thinking', 'published'),
('Data Analysis Skills', 'How to collect, analyze, and interpret data to draw conclusions.', 'Data analysis.', 'Data in hand, wise decisions.', 'think_data.jpg', 280000, 330000, 300000, 3, 'Thinking', 'published'),
('Strategic Thinking', 'Build long-term plans and strategic vision.', 'Strategic planning.', 'Strategic vision, path to success.', 'think_strategy.jpg', 290000, 340000, 310000, 3, 'Thinking', 'published');

-- Insert Stimulations and Quizzes for each SubjectPackage
-- For Teamwork Subjects
INSERT INTO Stimulations (SubjectId, StimulationExam, Level, NumberOfQuestions, Duration, PassRate) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 'Collaboration Skills Test', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 'Collaboration Competency Assessment', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 'Team Building Exam', 'Intermediate', 35, 50, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 'Team Leadership Challenge', 'Advanced', 45, 70, 75.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 'Conflict Resolution Exercise', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 'Conflict Handling Scenario', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 'Leadership Skills Assessment', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 'Team Guidance Practice', 'Advanced', 50, 75, 80.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 'Team Performance Evaluation', 'Intermediate', 30, 50, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 'Team Productivity Analysis', 'Advanced', 40, 65, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 'Project Coordination Test', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 'Project Management Challenge', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 'Internal Communication Assessment', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 'Team Communication Scenario', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 'Team Culture Examination', 'Intermediate', 30, 50, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 'Culture Development Challenge', 'Advanced', 40, 65, 70.00);

INSERT INTO Quizzes (Title, SubjectId, Duration) VALUES
('Basic Collaboration Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 20),
('Advanced Collaboration Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 30),
('Team Building Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 25),
('Team Leadership Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 35),
('Conflict Resolution Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 20),
('Conflict Management Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 30),
('Effective Leadership Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 25),
('Goal-Oriented Leadership Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 35),
('Performance Optimization Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 20),
('Team Productivity Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 30),
('Basic Coordination Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 20),
('Advanced Coordination Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 30),
('Internal Communication Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 20),
('Effective Team Communication Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 30),
('Team Culture Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 20),
('Culture Development Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 30);

-- For Communication Subjects
INSERT INTO Stimulations (SubjectId, StimulationExam, Level, NumberOfQuestions, Duration, PassRate) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 'Persuasion Skills Test', 'Intermediate', 35, 50, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 'Persuasive Ability Assessment', 'Advanced', 45, 65, 75.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 'Presentation Skills Exam', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 'Stage Presentation Challenge', 'Advanced', 50, 75, 80.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 'Body Language Exercise', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 'Non-Verbal Decoding Scenario', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 'Active Listening Skills Test', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 'Empathetic Listening Practice', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 'Negotiation Assessment', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 'Negotiation & Bargaining Scenario', 'Advanced', 45, 70, 75.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 'Email Writing Exam', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 'Effective Email Writing Practice', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 'Feedback Exercise', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 'Positive Feedback Practice', 'Intermediate', 40, 60, 70.00);

INSERT INTO Quizzes (Title, SubjectId, Duration) VALUES
('Basic Persuasion Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 20),
('Advanced Persuasion Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 30),
('Effective Presentation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 25),
('Professional Presentation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 35),
('Non-Verbal Communication Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 20),
('Body Language Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 30),
('Active Listening Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 20),
('Empathetic Listening Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 30),
('Basic Negotiation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 20),
('Advanced Negotiation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 30),
('Standard Email Writing Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 20),
('Effective Email Writing Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 30),
('Constructive Feedback Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 20),
('Positive Feedback Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 30);

-- For Self Improve Subjects
INSERT INTO Stimulations (SubjectId, StimulationExam, Level, NumberOfQuestions, Duration, PassRate) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 'Time Management Test', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 'Personal Productivity Assessment', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Developing Positive Thinking'), 'Optimistic Thinking Exam', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Developing Positive Thinking'), 'Perspective Shift Challenge', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Emotional Control'), 'Emotional Control Exercise', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Emotional Control'), 'Emotional Management Scenario', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal Setting & Personal Planning'), 'Goal Setting Test', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal Setting & Personal Planning'), 'Planning Practice', 'Intermediate', 35, 55, 65.00);

INSERT INTO Quizzes (Title, SubjectId, Duration) VALUES
('Time Management Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 20),
('Personal Productivity Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 30),
('Positive Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Developing Positive Thinking'), 20),
('Optimism Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Developing Positive Thinking'), 30),
('Emotional Control Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Emotional Control'), 20),
('Emotional Management Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Emotional Control'), 30),
('Goal Setting Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Goal Setting & Personal Planning'), 20),
('Personal Planning Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Goal Setting & Personal Planning'), 30);

-- For Thinking Subjects
INSERT INTO Stimulations (SubjectId, StimulationExam, Level, NumberOfQuestions, Duration, PassRate) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Deep Critical Thinking'), 'Critical Thinking Exam', 'Intermediate', 35, 50, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Deep Critical Thinking'), 'Analytical Ability Assessment', 'Advanced', 45, 65, 75.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Creative Problem Solving'), 'Problem Solving Exam', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Creative Problem Solving'), 'Breakthrough Thinking Challenge', 'Advanced', 50, 75, 80.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Decision Making'), 'Decision Making Exercise', 'Beginner', 30, 45, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Decision Making'), 'Tough Decision Scenario', 'Intermediate', 40, 60, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Logic & Reasoning'), 'Logic Thinking Test', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Logic & Reasoning'), 'Rigorous Reasoning Practice', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'System Thinking'), 'System Thinking Assessment', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'System Thinking'), 'System Analysis Practice', 'Advanced', 45, 70, 75.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Innovation Thinking'), 'Innovative Thinking Exam', 'Beginner', 25, 40, 55.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Innovation Thinking'), 'Breakthrough Idea Challenge', 'Intermediate', 35, 55, 65.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Data Analysis Skills'), 'Data Analysis Exam', 'Intermediate', 30, 50, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Data Analysis Skills'), 'Data Interpretation Practice', 'Advanced', 40, 65, 70.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Strategic Thinking'), 'Strategic Thinking Exam', 'Intermediate', 30, 50, 60.00),
((SELECT Id FROM SubjectPackages WHERE Title = 'Strategic Thinking'), 'Strategic Planning Practice', 'Advanced', 40, 65, 70.00);

INSERT INTO Quizzes (Title, SubjectId, Duration) VALUES
('Basic Critical Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Deep Critical Thinking'), 20),
('Advanced Critical Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Deep Critical Thinking'), 30),
('Problem Solving Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Creative Problem Solving'), 25),
('Creative Breakthrough Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Creative Problem Solving'), 35),
('Decision Making Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Decision Making'), 20),
('Strategic Decision Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Effective Decision Making'), 30),
('Basic Logic Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Logic & Reasoning'), 20),
('Rigorous Reasoning Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Logic & Reasoning'), 30),
('System Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'System Thinking'), 20),
('System Analysis Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'System Thinking'), 30),
('Innovation Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Innovation Thinking'), 20),
('Idea Generation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Innovation Thinking'), 30),
('Data Analysis Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Data Analysis Skills'), 20),
('Data Interpretation Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Data Analysis Skills'), 30),
('Strategic Thinking Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Strategic Thinking'), 20),
('Strategic Planning Quiz', (SELECT Id FROM SubjectPackages WHERE Title = 'Strategic Thinking'), 30);

-- Insert Questions cho Teamwork Category

-- Effective Collaboration Skills - Basic Collaboration Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 1, 'Beginner', 'Effective teamwork requires good _______ between team members.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 1, 'Beginner', 'The key to successful collaboration is building _______ among team members.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 1, 'Beginner', 'What is the most important factor in team collaboration?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 1, 'Beginner', 'Which behavior hinders effective teamwork?', 'multiple_choice', 'active');

-- Effective Collaboration Skills - Advanced Collaboration Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 2, 'Intermediate', 'Cross-functional teams require strong _______ skills to succeed.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 2, 'Intermediate', 'Virtual collaboration tools help teams maintain _______ despite distance.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 2, 'Intermediate', 'What is the biggest challenge in remote team collaboration?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Collaboration Skills'), 1, 2, 'Intermediate', 'Which strategy best improves team synergy?', 'multiple_choice', 'active');

-- Building Strong Teams - Team Building Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 1, 'Beginner', 'Strong teams are built on mutual _______ and respect.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 1, 'Beginner', 'Team diversity brings different _______ to problem-solving.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 1, 'Beginner', 'What is the foundation of a strong team?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 1, 'Beginner', 'Which element is crucial for team cohesion?', 'multiple_choice', 'active');

-- Building Strong Teams - Team Leadership Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 2, 'Intermediate', 'Effective team leaders must demonstrate strong _______ skills.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 2, 'Intermediate', 'Team resilience is built through overcoming _______ together.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 2, 'Intermediate', 'What leadership style works best for team building?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building Strong Teams'), 1, 2, 'Intermediate', 'How should leaders handle team conflicts?', 'multiple_choice', 'active');

-- Resolving Team Conflicts - Conflict Resolution Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 1, 'Beginner', 'Most team conflicts arise from poor _______ between members.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 1, 'Beginner', 'Active _______ is essential for resolving misunderstandings.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 1, 'Beginner', 'What is the first step in conflict resolution?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 1, 'Beginner', 'Which approach is most effective for team conflicts?', 'multiple_choice', 'active');

-- Resolving Team Conflicts - Conflict Management Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 2, 'Intermediate', 'Complex conflicts require skilled _______ to find solutions.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 2, 'Intermediate', 'Preventing future conflicts requires establishing clear _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 2, 'Intermediate', 'What technique helps de-escalate heated conflicts?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Resolving Team Conflicts'), 1, 2, 'Intermediate', 'When should external mediation be considered?', 'multiple_choice', 'active');

-- Goal-Oriented Team Leadership - Effective Leadership Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 1, 'Beginner', 'Effective leaders inspire their teams through clear _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 1, 'Beginner', 'Goal-oriented leadership requires strong _______ abilities.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 1, 'Beginner', 'What quality defines a goal-oriented leader?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 1, 'Beginner', 'How should leaders communicate team objectives?', 'multiple_choice', 'active');

-- Goal-Oriented Team Leadership - Goal-Oriented Leadership Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 2, 'Intermediate', 'Strategic leaders align team efforts with organizational _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 2, 'Intermediate', 'Successful goal achievement requires consistent _______ and evaluation.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 2, 'Intermediate', 'What framework helps teams achieve complex goals?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Goal-Oriented Team Leadership'), 1, 2, 'Intermediate', 'How should leaders handle goal adjustments?', 'multiple_choice', 'active');

-- Optimizing Team Performance - Performance Optimization Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 1, 'Beginner', 'Team performance improves with regular _______ and feedback.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 1, 'Beginner', 'High-performing teams maintain strong _______ and accountability.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 1, 'Beginner', 'What metric best measures team performance?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 1, 'Beginner', 'Which factor most impacts team productivity?', 'multiple_choice', 'active');

-- Optimizing Team Performance - Team Productivity Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 2, 'Intermediate', 'Advanced teams use _______ analysis to identify improvement areas.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 2, 'Intermediate', 'Sustainable performance requires balancing _______ with team wellbeing.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 2, 'Intermediate', 'What tool helps track team performance trends?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Optimizing Team Performance'), 1, 2, 'Intermediate', 'How should teams handle performance plateaus?', 'multiple_choice', 'active');

-- Project Coordination Skills - Basic Coordination Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 1, 'Beginner', 'Project coordination requires excellent _______ and organizational skills.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 1, 'Beginner', 'Successful projects depend on effective _______ management.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 1, 'Beginner', 'What is the key responsibility of a project coordinator?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 1, 'Beginner', 'Which skill is most important for project coordination?', 'multiple_choice', 'active');

-- Project Coordination Skills - Advanced Coordination Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 2, 'Intermediate', 'Complex projects require sophisticated _______ and tracking systems.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 2, 'Intermediate', 'Multi-stakeholder projects demand strong _______ and diplomatic skills.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 2, 'Intermediate', 'What methodology works best for large projects?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Project Coordination Skills'), 1, 2, 'Intermediate', 'How should coordinators handle project delays?', 'multiple_choice', 'active');

-- Team Communication - Internal Communication Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 1, 'Beginner', 'Clear team communication prevents _______ and increases efficiency.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 1, 'Beginner', 'Regular team meetings promote _______ and shared understanding.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 1, 'Beginner', 'What is the most effective communication channel for teams?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 1, 'Beginner', 'Which communication barrier affects teams most?', 'multiple_choice', 'active');

-- Team Communication - Effective Team Communication Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 2, 'Intermediate', 'Advanced communication strategies improve team _______ and decision-making.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 2, 'Intermediate', 'Digital communication tools must be balanced with _______ interaction.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 2, 'Intermediate', 'What communication style works best in diverse teams?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Team Communication'), 1, 2, 'Intermediate', 'How should teams handle communication conflicts?', 'multiple_choice', 'active');

-- Building a Team Culture - Team Culture Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 1, 'Beginner', 'Strong team culture is built on shared _______ and principles.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 1, 'Beginner', 'Team culture influences member _______ and overall satisfaction.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 1, 'Beginner', 'What element is fundamental to team culture?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 1, 'Beginner', 'How is team culture best established?', 'multiple_choice', 'active');

-- Building a Team Culture - Culture Development Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 2, 'Intermediate', 'Sustainable culture requires continuous _______ and reinforcement.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 2, 'Intermediate', 'Cultural transformation demands _______ commitment from all levels.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 2, 'Intermediate', 'What strategy effectively changes team culture?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Building a Team Culture'), 1, 2, 'Intermediate', 'How should leaders measure cultural progress?', 'multiple_choice', 'active');

-- Insert Questions cho Communication Category

-- Art of Persuasive Communication - Basic Persuasion Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 1, 'Beginner', 'Persuasive communication relies on building _______ with your audience.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 1, 'Beginner', 'Effective persuasion requires understanding your audience''s _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 1, 'Beginner', 'What is the foundation of persuasive communication?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 1, 'Beginner', 'Which technique enhances persuasive messages?', 'multiple_choice', 'active');

-- Art of Persuasive Communication - Advanced Persuasion Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 2, 'Intermediate', 'Advanced persuasion techniques leverage psychological _______ and emotional appeal.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 2, 'Intermediate', 'Master persuaders adapt their _______ to different personality types.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 2, 'Intermediate', 'What principle drives ethical persuasion?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Art of Persuasive Communication'), 1, 2, 'Intermediate', 'How should persuaders handle resistance?', 'multiple_choice', 'active');

-- Impressive Presentation Skills - Effective Presentation Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 1, 'Beginner', 'Great presentations start with a compelling _______ that captures attention.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 1, 'Beginner', 'Visual aids should support, not _______ your main message.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 1, 'Beginner', 'What makes a presentation memorable?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 1, 'Beginner', 'Which element is crucial for presentation success?', 'multiple_choice', 'active');

-- Impressive Presentation Skills - Professional Presentation Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 2, 'Intermediate', 'Professional presentations require mastering both _______ and delivery techniques.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 2, 'Intermediate', 'Advanced presenters use _______ techniques to maintain audience engagement.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 2, 'Intermediate', 'What distinguishes expert presenters?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Impressive Presentation Skills'), 1, 2, 'Intermediate', 'How should presenters handle difficult questions?', 'multiple_choice', 'active');

-- Non-Verbal Communication - Non-Verbal Communication Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 1, 'Beginner', 'Body language often conveys more than _______ communication.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 1, 'Beginner', 'Maintaining appropriate eye _______ builds trust and connection.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 1, 'Beginner', 'What percentage of communication is non-verbal?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 1, 'Beginner', 'Which non-verbal cue indicates confidence?', 'multiple_choice', 'active');

-- Non-Verbal Communication - Body Language Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 2, 'Intermediate', 'Cultural differences significantly impact _______ interpretation and meaning.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 2, 'Intermediate', 'Skilled communicators align their _______ signals with their verbal message.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 2, 'Intermediate', 'What should you do when verbal and non-verbal messages conflict?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Non-Verbal Communication'), 1, 2, 'Intermediate', 'How can you improve non-verbal awareness?', 'multiple_choice', 'active');

-- Active Listening - Active Listening Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 1, 'Beginner', 'Active listening requires full _______ and genuine interest in the speaker.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 1, 'Beginner', 'Good listeners avoid _______ and wait for the speaker to finish.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 1, 'Beginner', 'What is the key component of active listening?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 1, 'Beginner', 'Which behavior demonstrates active listening?', 'multiple_choice', 'active');

-- Active Listening - Empathetic Listening Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 2, 'Intermediate', 'Empathetic listening involves understanding both _______ and emotional content.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 2, 'Intermediate', 'Advanced listeners use _______ questions to deepen understanding.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 2, 'Intermediate', 'What technique helps improve listening comprehension?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Active Listening'), 1, 2, 'Intermediate', 'How should listeners handle emotional conversations?', 'multiple_choice', 'active');

-- Communication in Negotiation - Basic Negotiation Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 1, 'Beginner', 'Successful negotiation requires understanding all parties'' _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 1, 'Beginner', 'Effective negotiators seek _______ solutions that benefit everyone.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 1, 'Beginner', 'What is the goal of effective negotiation?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 1, 'Beginner', 'Which approach works best in negotiations?', 'multiple_choice', 'active');

-- Communication in Negotiation - Advanced Negotiation Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 2, 'Intermediate', 'Complex negotiations require strategic _______ and careful timing.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 2, 'Intermediate', 'Master negotiators build _______ while maintaining their position.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 2, 'Intermediate', 'What strategy handles negotiation deadlocks?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Communication in Negotiation'), 1, 2, 'Intermediate', 'How should negotiators prepare for difficult discussions?', 'multiple_choice', 'active');

-- Professional Email Writing - Standard Email Writing Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 1, 'Beginner', 'Professional emails should have clear _______ lines that indicate the purpose.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 1, 'Beginner', 'Email messages should be _______ and focused on the main point.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 1, 'Beginner', 'What makes an email subject line effective?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 1, 'Beginner', 'Which email tone is most professional?', 'multiple_choice', 'active');

-- Professional Email Writing - Effective Email Writing Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 2, 'Intermediate', 'Advanced email writing requires understanding _______ and cultural sensitivity.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 2, 'Intermediate', 'Complex emails benefit from clear _______ and bullet points for readability.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 2, 'Intermediate', 'What strategy improves email response rates?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Professional Email Writing'), 1, 2, 'Intermediate', 'How should you handle sensitive topics in emails?', 'multiple_choice', 'active');

-- Constructive Feedback Skills - Constructive Feedback Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 1, 'Beginner', 'Constructive feedback focuses on _______ rather than personal criticism.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 1, 'Beginner', 'Effective feedback is _______ and actionable for improvement.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 1, 'Beginner', 'What is the purpose of constructive feedback?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 1, 'Beginner', 'Which approach makes feedback more acceptable?', 'multiple_choice', 'active');

-- Constructive Feedback Skills - Positive Feedback Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 2, 'Intermediate', 'Advanced feedback techniques balance _______ recognition with improvement suggestions.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 2, 'Intermediate', 'Skilled feedback providers create safe _______ for honest communication.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 2, 'Intermediate', 'What model structures effective feedback delivery?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Constructive Feedback Skills'), 1, 2, 'Intermediate', 'How should you follow up after giving feedback?', 'multiple_choice', 'active');

-- Effective Time Management - Time Management Quiz
INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, QuestionType, Status) VALUES
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 1, 1, 'Beginner', 'Time management involves organizing tasks by their _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 1, 1, 'Beginner', 'The key to productivity is eliminating time _______.', 'text_input', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 1, 1, 'Beginner', 'What is the most important factor in effective time management?', 'multiple_choice', 'active'),
((SELECT Id FROM SubjectPackages WHERE Title = 'Effective Time Management'), 1, 1, 'Beginner', 'Which technique helps prioritize tasks effectively?', 'multiple_choice', 'active');

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Effective teamwork requires good _______ between team members.' LIMIT 1),
  'Communication',
  TRUE,
  'Communication is essential for teamwork'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'The key to successful collaboration is building _______ among team members.' LIMIT 1),
  'Trust', 
  TRUE, 
  'Trust is the foundation of collaboration'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What is the most important factor in team collaboration?' LIMIT 1),
  'Trust', 
  TRUE, 
  'Trust is the most important factor in team collaboration.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the most important factor in team collaboration?' LIMIT 1),
  'Speed', 
  FALSE, 
  'Speed is not the most important factor in collaboration.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the most important factor in team collaboration?' LIMIT 1),
  'Luck', 
  FALSE, 
  'Luck is not a factor in team collaboration.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the most important factor in team collaboration?' LIMIT 1),
  'Silence', 
  FALSE, 
  'Silence does not help in collaboration.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Which behavior hinders effective teamwork?' LIMIT 1),
  'Arrogance', 
  TRUE, 
  'Arrogance can hinder teamwork by damaging relationships and causing conflicts.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which behavior hinders effective teamwork?' LIMIT 1),
  'Listening', 
  FALSE, 
  'Listening is essential for effective teamwork.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which behavior hinders effective teamwork?' LIMIT 1),
  'Cooperation', 
  FALSE, 
  'Cooperation is key to teamwork.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which behavior hinders effective teamwork?' LIMIT 1),
  'Respect', 
  FALSE, 
  'Respect strengthens teamwork and promotes collaboration.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Cross-functional teams require strong _______ skills to succeed.' LIMIT 1),
  'Communication', 
  TRUE, 
  'Communication is essential for cross-functional teams to succeed.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Virtual collaboration tools help teams maintain _______ despite distance.' LIMIT 1),
  'Connection', 
  TRUE, 
  'Connection is key for remote collaboration.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What is the biggest challenge in remote team collaboration?' LIMIT 1),
  'Lack of face-to-face interaction', 
  TRUE, 
  'Lack of face-to-face interaction is a common challenge in remote collaboration.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the biggest challenge in remote team collaboration?' LIMIT 1),
  'Availability of coffee', 
  FALSE, 
  'Coffee availability is not a major challenge in remote teams.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the biggest challenge in remote team collaboration?' LIMIT 1),
  'Time management', 
  FALSE, 
  'Time management is important, but not the biggest challenge.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the biggest challenge in remote team collaboration?' LIMIT 1),
  'Strong Wi-Fi connection', 
  FALSE, 
  'While Wi-Fi is important, it is not the biggest challenge.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Which strategy best improves team synergy?' LIMIT 1),
  'Effective communication', 
  TRUE, 
  'Effective communication is crucial for improving team synergy.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which strategy best improves team synergy?' LIMIT 1),
  'Ignoring conflict', 
  FALSE, 
  'Ignoring conflict harms team synergy and needs to be addressed.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which strategy best improves team synergy?' LIMIT 1),
  'Competition between team members', 
  FALSE, 
  'Competition can hinder collaboration and reduce synergy.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which strategy best improves team synergy?' LIMIT 1),
  'Individual working alone', 
  FALSE, 
  'Team synergy requires collaboration, not individual work.'
);

-- Quiz 1: Basic Collaboration Quiz (Level Beginner)
INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Basic Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Effective teamwork requires good _______ between team members.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Basic Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'The key to successful collaboration is building _______ among team members.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Basic Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What is the most important factor in team collaboration?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Basic Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Which behavior hinders effective teamwork?' LIMIT 1)
);

-- Quiz 2: Advanced Collaboration Quiz (Level Intermediate)
INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Advanced Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Cross-functional teams require strong _______ skills to succeed.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Advanced Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Virtual collaboration tools help teams maintain _______ despite distance.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Advanced Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What is the biggest challenge in remote team collaboration?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Advanced Collaboration Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Which strategy best improves team synergy?' LIMIT 1)
);

-- =====================================================
-- QUESTION ANSWERS cho Building Strong Teams - Team Building Quiz
-- =====================================================
INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Strong teams are built on mutual _______ and respect.' LIMIT 1),
  'Trust', 
  TRUE, 
  'Trust is the foundation for building strong teams.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Team diversity brings different _______ to problem-solving.' LIMIT 1),
  'Perspectives', 
  TRUE, 
  'Diverse perspectives enhance problem-solving capabilities.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What is the foundation of a strong team?' LIMIT 1),
  'Trust and mutual respect', 
  TRUE, 
  'Trust and mutual respect form the foundation of strong teams.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the foundation of a strong team?' LIMIT 1),
  'Individual brilliance', 
  FALSE, 
  'Individual brilliance alone does not build strong teams.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the foundation of a strong team?' LIMIT 1),
  'Competition among members', 
  FALSE, 
  'Competition can weaken team cohesion.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the foundation of a strong team?' LIMIT 1),
  'Strict hierarchy', 
  FALSE, 
  'Overly strict hierarchy can hinder team collaboration.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Which element is crucial for team cohesion?' LIMIT 1),
  'Shared goals and values', 
  TRUE, 
  'Shared goals and values create unity and cohesion in teams.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which element is crucial for team cohesion?' LIMIT 1),
  'Similar backgrounds', 
  FALSE, 
  'Diversity of backgrounds can strengthen teams when managed well.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which element is crucial for team cohesion?' LIMIT 1),
  'Avoiding difficult conversations', 
  FALSE, 
  'Avoiding difficult conversations can weaken team bonds.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which element is crucial for team cohesion?' LIMIT 1),
  'Working in isolation', 
  FALSE, 
  'Isolation prevents team cohesion and collaboration.'
);

-- =====================================================
-- QUESTION ANSWERS cho Building Strong Teams - Team Leadership Quiz
-- =====================================================

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Effective team leaders must demonstrate strong _______ skills.' LIMIT 1),
  'Communication', 
  TRUE, 
  'Communication skills are essential for effective team leadership.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Team resilience is built through overcoming _______ together.' LIMIT 1),
  'Challenges', 
  TRUE, 
  'Overcoming challenges together builds team resilience and bonds.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What leadership style works best for team building?' LIMIT 1),
  'Collaborative leadership', 
  TRUE, 
  'Collaborative leadership encourages participation and builds strong teams.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What leadership style works best for team building?' LIMIT 1),
  'Authoritarian leadership', 
  FALSE, 
  'Authoritarian leadership can stifle team creativity and collaboration.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What leadership style works best for team building?' LIMIT 1),
  'Laissez-faire leadership', 
  FALSE, 
  'Complete hands-off approach may lack necessary guidance for team building.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What leadership style works best for team building?' LIMIT 1),
  'Micromanagement', 
  FALSE, 
  'Micromanagement undermines trust and team autonomy.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle team conflicts?' LIMIT 1),
  'Address conflicts early and fairly', 
  TRUE, 
  'Early and fair intervention prevents conflicts from escalating.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle team conflicts?' LIMIT 1),
  'Ignore conflicts and hope they resolve', 
  FALSE, 
  'Ignoring conflicts often makes them worse and damages team dynamics.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle team conflicts?' LIMIT 1),
  'Take sides immediately', 
  FALSE, 
  'Taking sides without understanding can worsen conflicts.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle team conflicts?' LIMIT 1),
  'Punish all parties involved', 
  FALSE, 
  'Blanket punishment does not address the root cause of conflicts.'
);

-- =====================================================
-- QUIZ QUESTIONS cho Building Strong Teams - Team Building Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Building Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Strong teams are built on mutual _______ and respect.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Building Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Team diversity brings different _______ to problem-solving.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Building Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What is the foundation of a strong team?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Building Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Which element is crucial for team cohesion?' LIMIT 1)
);

-- =====================================================
-- QUIZ QUESTIONS cho Building Strong Teams - Team Leadership Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Effective team leaders must demonstrate strong _______ skills.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Team resilience is built through overcoming _______ together.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What leadership style works best for team building?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Team Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle team conflicts?' LIMIT 1)
);

-- =====================================================
-- QUESTION ANSWERS cho Resolving Team Conflicts - Conflict Resolution Quiz
-- =====================================================

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Most team conflicts arise from poor _______ between members.' LIMIT 1),
  'Communication', 
  TRUE, 
  'Poor communication is the root cause of most team conflicts.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Active _______ is essential for resolving misunderstandings.' LIMIT 1),
  'Listening', 
  TRUE, 
  'Active listening helps understand different perspectives and resolve conflicts.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What is the first step in conflict resolution?' LIMIT 1),
  'Identify the root cause', 
  TRUE, 
  'Understanding the root cause is essential for effective conflict resolution.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the first step in conflict resolution?' LIMIT 1),
  'Assign blame to parties', 
  FALSE, 
  'Assigning blame escalates conflicts rather than resolving them.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the first step in conflict resolution?' LIMIT 1),
  'Avoid the conflicting parties', 
  FALSE, 
  'Avoidance does not resolve conflicts and may make them worse.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What is the first step in conflict resolution?' LIMIT 1),
  'Impose a quick solution', 
  FALSE, 
  'Quick solutions without understanding may not address the real issues.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Which approach is most effective for team conflicts?' LIMIT 1),
  'Collaborative problem-solving', 
  TRUE, 
  'Collaborative approach engages all parties in finding mutually acceptable solutions.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which approach is most effective for team conflicts?' LIMIT 1),
  'Winner-takes-all approach', 
  FALSE, 
  'Winner-takes-all approach creates resentment and doesn\'t resolve underlying issues.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which approach is most effective for team conflicts?' LIMIT 1),
  'Suppressing disagreements', 
  FALSE, 
  'Suppressing disagreements leads to unresolved tensions.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'Which approach is most effective for team conflicts?' LIMIT 1),
  'Separating conflicting parties', 
  FALSE, 
  'Separation alone doesn\'t address the underlying conflict causes.'
);

-- =====================================================
-- QUESTION ANSWERS cho Resolving Team Conflicts - Conflict Management Quiz
-- =====================================================

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Complex conflicts require skilled _______ to find solutions.' LIMIT 1),
  'Mediation', 
  TRUE, 
  'Skilled mediation is essential for resolving complex conflicts.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Preventing future conflicts requires establishing clear _______.' LIMIT 1),
  'Boundaries', 
  TRUE, 
  'Clear boundaries help prevent misunderstandings and conflicts.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What technique helps de-escalate heated conflicts?' LIMIT 1),
  'Active listening and empathy', 
  TRUE, 
  'Active listening and empathy help calm tensions and promote understanding.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What technique helps de-escalate heated conflicts?' LIMIT 1),
  'Raising voice to be heard', 
  FALSE, 
  'Raising voice escalates rather than de-escalates conflicts.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What technique helps de-escalate heated conflicts?' LIMIT 1),
  'Interrupting frequently', 
  FALSE, 
  'Interrupting prevents effective communication and worsens conflicts.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What technique helps de-escalate heated conflicts?' LIMIT 1),
  'Making demands immediately', 
  FALSE, 
  'Making immediate demands can increase tension and resistance.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'When should external mediation be considered?' LIMIT 1),
  'When internal efforts have failed', 
  TRUE, 
  'External mediation should be considered when internal resolution attempts have been unsuccessful.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'When should external mediation be considered?' LIMIT 1),
  'At the first sign of disagreement', 
  FALSE, 
  'External mediation is not needed for minor disagreements that can be resolved internally.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'When should external mediation be considered?' LIMIT 1),
  'Only after relationships are damaged', 
  FALSE, 
  'Waiting until relationships are severely damaged makes resolution more difficult.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'When should external mediation be considered?' LIMIT 1),
  'Never, teams should handle everything', 
  FALSE, 
  'Some conflicts require external expertise to resolve effectively.'
);

-- =====================================================
-- QUIZ QUESTIONS cho Resolving Team Conflicts - Conflict Resolution Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Resolution Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Most team conflicts arise from poor _______ between members.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Resolution Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Active _______ is essential for resolving misunderstandings.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Resolution Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What is the first step in conflict resolution?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Resolution Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Which approach is most effective for team conflicts?' LIMIT 1)
);

-- =====================================================
-- QUIZ QUESTIONS cho Resolving Team Conflicts - Conflict Management Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Management Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Complex conflicts require skilled _______ to find solutions.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Management Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Preventing future conflicts requires establishing clear _______.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Management Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What technique helps de-escalate heated conflicts?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Conflict Management Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'When should external mediation be considered?' LIMIT 1)
);

-- =====================================================
-- QUESTION ANSWERS cho Goal-Oriented Team Leadership - Effective Leadership Quiz
-- =====================================================

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Effective leaders inspire their teams through clear _______.' LIMIT 1),
  'Vision', 
  TRUE, 
  'Clear vision provides direction and inspiration for teams.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Goal-oriented leadership requires strong _______ abilities.' LIMIT 1),
  'Planning', 
  TRUE, 
  'Strong planning abilities are essential for achieving goals effectively.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What quality defines a goal-oriented leader?' LIMIT 1),
  'Focus and determination', 
  TRUE, 
  'Focus and determination are key qualities that define goal-oriented leaders.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What quality defines a goal-oriented leader?' LIMIT 1),
  'Flexibility without direction', 
  FALSE, 
  'Being flexible without clear direction can lead to confusion and poor results.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What quality defines a goal-oriented leader?' LIMIT 1),
  'Avoiding difficult decisions', 
  FALSE, 
  'Goal-oriented leaders must be willing to make difficult decisions.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What quality defines a goal-oriented leader?' LIMIT 1),
  'Working in isolation', 
  FALSE, 
  'Effective leaders work with their teams, not in isolation.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders communicate team objectives?' LIMIT 1),
  'Clearly and frequently', 
  TRUE, 
  'Clear and frequent communication ensures everyone understands the objectives.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders communicate team objectives?' LIMIT 1),
  'Once and never repeat', 
  FALSE, 
  'Objectives need to be reinforced regularly for effective implementation.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders communicate team objectives?' LIMIT 1),
  'Only to senior team members', 
  FALSE, 
  'All team members need to understand the objectives to contribute effectively.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders communicate team objectives?' LIMIT 1),
  'Using complex technical language', 
  FALSE, 
  'Objectives should be communicated in clear, understandable language.'
);

-- =====================================================
-- QUESTION ANSWERS cho Goal-Oriented Team Leadership - Goal-Oriented Leadership Quiz
-- =====================================================

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Strategic leaders align team efforts with organizational _______.' LIMIT 1),
  'Objectives', 
  TRUE, 
  'Aligning team efforts with organizational objectives ensures strategic coherence.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'Successful goal achievement requires consistent _______ and evaluation.' LIMIT 1),
  'Monitoring', 
  TRUE, 
  'Consistent monitoring and evaluation are crucial for successful goal achievement.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'What framework helps teams achieve complex goals?' LIMIT 1),
  'SMART goals framework', 
  TRUE, 
  'SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound) provide clear structure for complex goals.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What framework helps teams achieve complex goals?' LIMIT 1),
  'Vague aspirational statements', 
  FALSE, 
  'Vague statements don\'t provide the clarity needed for complex goal achievement.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What framework helps teams achieve complex goals?' LIMIT 1),
  'Wishful thinking approach', 
  FALSE, 
  'Wishful thinking lacks the structure and rigor needed for complex goals.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'What framework helps teams achieve complex goals?' LIMIT 1),
  'No framework needed', 
  FALSE, 
  'Complex goals require structured frameworks to manage effectively.'
);

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation) 
VALUES 
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle goal adjustments?' LIMIT 1),
  'Communicate changes transparently', 
  TRUE, 
  'Transparent communication about goal adjustments maintains trust and understanding.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle goal adjustments?' LIMIT 1),
  'Make changes without explanation', 
  FALSE, 
  'Unexplained changes can confuse team members and reduce commitment.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle goal adjustments?' LIMIT 1),
  'Avoid adjustments at all costs', 
  FALSE, 
  'Some adjustments may be necessary due to changing circumstances.'
),
(
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle goal adjustments?' LIMIT 1),
  'Change goals frequently without reason', 
  FALSE, 
  'Frequent unnecessary changes can undermine team confidence and focus.'
);

-- =====================================================
-- QUIZ QUESTIONS cho Goal-Oriented Team Leadership - Effective Leadership Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Effective Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Effective leaders inspire their teams through clear _______.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Effective Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Goal-oriented leadership requires strong _______ abilities.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Effective Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What quality defines a goal-oriented leader?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Effective Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'How should leaders communicate team objectives?' LIMIT 1)
);

-- =====================================================
-- QUIZ QUESTIONS cho Goal-Oriented Team Leadership - Goal-Oriented Leadership Quiz
-- =====================================================

INSERT INTO QuizQuestions (QuizId, QuestionId) VALUES
(
  (SELECT Id FROM Quizzes WHERE Title = 'Goal-Oriented Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Strategic leaders align team efforts with organizational _______.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Goal-Oriented Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'Successful goal achievement requires consistent _______ and evaluation.' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Goal-Oriented Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'What framework helps teams achieve complex goals?' LIMIT 1)
),
(
  (SELECT Id FROM Quizzes WHERE Title = 'Goal-Oriented Leadership Quiz' LIMIT 1),
  (SELECT Id FROM Questions WHERE Content = 'How should leaders handle goal adjustments?' LIMIT 1)
);

INSERT INTO QuizResults (UserId, QuizId, Score, SubmittedAt)
VALUES
(1, 1, 8, '2025-07-25 10:30:00');

