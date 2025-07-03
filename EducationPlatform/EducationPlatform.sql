-- Tạo database
CREATE DATABASE EducationPlatform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE EducationPlatform;

CREATE TABLE Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Mobile VARCHAR(20),
    Password VARCHAR(255),
    Gender BOOLEAN DEFAULT true,
    Avatar VARCHAR(255),
    Role VARCHAR(50) DEFAULT 'customer',
    Status VARCHAR(50) DEFAULT 'active',
    ActiveCode VARCHAR(10),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SubjectPackages (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Description TEXT,
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


CREATE TABLE TimePackages (
		TimePackage Int);

CREATE TABLE Registrations (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    SubjectId INT,
    Status VARCHAR(50) DEFAULT 'submitted',
    TotalCost DOUBLE,
    ValidFrom DATE,
    ValidTo DATE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

CREATE TABLE Posts (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    Image VARCHAR(1000),
    Content TEXT,
    Thumbnail VARCHAR(255),
    Category VARCHAR(1000),
    AuthorId INT,
    Status VARCHAR(50) DEFAULT 'draft',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AuthorId) REFERENCES Users(Id)
);

CREATE TABLE Sliders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Image VARCHAR(255),
    Title VARCHAR(255),
    Description TEXT,
    Type VARCHAR(50),
    OrderNumber INT DEFAULT 0
);

CREATE TABLE Lessons (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SubjectId INT,
    Title VARCHAR(255),
    Description TEXT,
    Status VARCHAR(50) DEFAULT 'active',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

CREATE TABLE SubjectDimensions (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SubjectId INT,
    Name VARCHAR(100),
    Type VARCHAR(50),
    Description TEXT,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

CREATE TABLE Questions (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SubjectId INT,
    LessonId INT,
    DimensionId INT,
    Level VARCHAR(50),
    Content TEXT,
    Media TEXT,
    Status VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id),
    FOREIGN KEY (LessonId) REFERENCES Lessons(Id),
    FOREIGN KEY (DimensionId) REFERENCES SubjectDimensions(Id)
);

CREATE TABLE QuestionAnswers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    QuestionId INT,
    Content TEXT,
    IsCorrect BOOLEAN DEFAULT FALSE,
    Explanation TEXT,
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id)
);

CREATE TABLE Quizzes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255),
    SubjectId INT,
    Duration INT,
    Status VARCHAR(50) DEFAULT 'draft',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SubjectId) REFERENCES SubjectPackages(Id)
);

CREATE TABLE QuizQuestions (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    QuizId INT,
    QuestionId INT,
    FOREIGN KEY (QuizId) REFERENCES Quizzes(Id),
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id)
);

CREATE TABLE QuizResults (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    QuizId INT,
    Score DECIMAL(5,2),
    SubmittedAt DATETIME,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (QuizId) REFERENCES Quizzes(Id)
);

INSERT INTO Users (FullName, Email, Mobile, Password, Gender, Avatar, Role, Status, ActiveCode)
VALUES
('Nguyen Van A', 'a@example.com', '0909123456', 'hashed_password1', true, 'avatar1.png', 'admin', 'active', 'ABC123'),
('Tran Thi B', 'b@example.com', '0909234567', 'hashed_password2', false, 'avatar2.png', 'teacher', 'active', 'XYZ789'),
('Le Van C', 'c@example.com', '0909345678', 'hashed_password3', true, 'avatar3.png', 'customer', 'inactive', 'QWE456');

INSERT INTO SubjectPackages (Title, Description, Thumbnail, LowestPrice, OriginalPrice, SalePrice, OwnerId, Category)
VALUES
('Toán lớp 10', 'Khóa học toán cơ bản lớp 10', 'math10.png', 199000, 299000, 249000, 2, 'Toán'),
('Văn học hiện đại', 'Tổng hợp các tác phẩm văn học thế kỷ 20', 'vanhoc.png', 149000, 249000, 199000, 2, 'Ngữ văn');

INSERT INTO Registrations (UserId, SubjectId, TotalCost, ValidFrom, ValidTo)
VALUES
(3, 1, 249000, '2025-05-01', '2025-08-01'),
(3, 2, 199000, '2025-05-10', '2025-09-10');

INSERT INTO Posts (Title, Image, Content, Thumbnail, Category, AuthorId)
VALUES
('Cách học toán hiệu quả', 'image1.png', 'Nội dung bài viết...', 'thumb1.png', 'Học tập', 2),
('Phân tích truyện ngắn hay', 'image2.png', 'Bài viết về văn học...', 'thumb2.png', 'Văn học', 2);

INSERT INTO Sliders (Image, Title, Description, Type, OrderNumber)
VALUES
('slider1.png', 'Chào mừng đến EducationPlatform', 'Nền tảng học tập hàng đầu', 'banner', 1),
('slider2.png', 'Ưu đãi mùa hè', 'Giảm giá 50% tất cả các khóa học', 'promotion', 2);

INSERT INTO Lessons (SubjectId, Title, Description)
VALUES
(1, 'Phương trình bậc hai', 'Lý thuyết và bài tập'),
(2, 'Phân tích truyện ngắn', 'Cấu trúc và nội dung');

INSERT INTO SubjectDimensions (SubjectId, Name, Type, Description)
VALUES
(1, 'Đại số', 'Lý thuyết', 'Các chủ đề về đại số'),
(2, 'Văn bản', 'Phân tích', 'Chủ đề về văn bản văn học');

INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, Status)
VALUES
(1, 1, 1, 'Dễ', 'Giải phương trình x^2 - 5x + 6 = 0', 'active'),
(2, 2, 2, 'Trung bình', 'Phân tích nhân vật trong truyện ngắn “Lão Hạc”', 'active');

INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, Explanation)
VALUES
(1, 'x = 2 hoặc x = 3', true, 'Áp dụng công thức nghiệm'),
(1, 'x = 1 hoặc x = 6', false, 'Sai nghiệm'),
(2, 'Lão Hạc là người cha hy sinh', true, 'Dựa theo diễn biến tâm lý nhân vật');

INSERT INTO Quizzes (Title, SubjectId, Duration)
VALUES
('Quiz toán cơ bản', 1, 30),
('Quiz văn học', 2, 45);

INSERT INTO QuizQuestions (QuizId, QuestionId)
VALUES
(1, 1),
(2, 2);

INSERT INTO QuizResults (UserId, QuizId, Score, SubmittedAt)
VALUES
(3, 1, 8.5, '2025-05-20 10:00:00'),
(3, 2, 7.0, '2025-05-21 11:00:00');
