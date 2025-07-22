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
-- Insert Users
INSERT INTO Users (FullName, Email, Mobile, Password, Gender, Role, Status) VALUES
('John Doe', 'john.doe@example.com', '0912345678', 'hashed_password_1', 0, 'customer', 'active'),
('Jane Smith', 'jane.smith@example.com', '0987654321', 'hashed_password_2', 1, 'customer', 'active'),
('Admin User', 'admin.user@example.com', '0901122334', 'hashed_password_3', 0, 'admin', 'active');

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