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
    LowestPrice DECIMAL(10,2),
    OriginalPrice DECIMAL(10,2),
    SalePrice DECIMAL(10,2),
    OwnerId INT,
    Category VARCHAR(100),
    Status VARCHAR(50) DEFAULT 'published',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OwnerId) REFERENCES Users(Id)
);

CREATE TABLE Registrations (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT,
    SubjectId INT,
    Status VARCHAR(50) DEFAULT 'submitted',
    TotalCost DECIMAL(10,2),
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