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


-- Insert 5 posts sample data (English and Soft Skills topics)
INSERT INTO Posts (Title, Image, Content, Thumbnail, Category, AuthorId, ViewCount, Status, CreatedAt) VALUES
(
    'Essential Communication Skills for Career Success',
    'https://example.com/images/communication-skills.jpg',
    'Effective communication is the cornerstone of professional success. In today''s workplace, the ability to convey ideas clearly, listen actively, and engage with diverse teams is more valuable than ever. This article explores key communication strategies including active listening, nonverbal communication awareness, and adapting your message to different audiences. We''ll also discuss how to give constructive feedback, handle difficult conversations, and present ideas confidently. Whether you''re leading a team meeting or networking at industry events, strong communication skills will set you apart and accelerate your career growth.',
    'https://example.com/thumbnails/communication-thumb.jpg',
    'Soft Skills,Communication,Career Development',
    1,
    342,
    'published',
    '2024-01-15 09:30:00'
),
(
    'Mastering Time Management: Productivity Tips for Professionals',
    'https://example.com/images/time-management.jpg',
    'Time management is a critical soft skill that directly impacts your productivity and work-life balance. This comprehensive guide covers proven techniques like the Eisenhower Matrix for prioritizing tasks, time-blocking for focused work sessions, and the two-minute rule for handling quick tasks immediately. We''ll explore how to identify and eliminate time wasters, set realistic deadlines, and create daily routines that maximize efficiency. Learn how successful professionals structure their days, manage interruptions, and maintain focus in our increasingly distracted world.',
    'https://example.com/thumbnails/time-management-thumb.jpg',
    'Soft Skills,Productivity,Time Management',
    2,
    287,
    'published',
    '2024-01-18 11:15:00'
),
(
    'Building Emotional Intelligence in the Modern Workplace',
    'https://example.com/images/emotional-intelligence.jpg',
    'Emotional intelligence (EI) has become one of the most sought-after soft skills in professional environments. This article delves into the four core components of EI: self-awareness, self-regulation, empathy, and social skills. We''ll provide practical exercises to help you recognize your emotional triggers, manage stress effectively, and understand others'' perspectives. Learn how emotionally intelligent leaders inspire their teams, resolve conflicts constructively, and create positive work cultures. With real-world examples and actionable strategies, you''ll discover how to leverage emotional intelligence for career advancement.',
    'https://example.com/thumbnails/emotional-intelligence-thumb.jpg',
    'Soft Skills,Leadership,Emotional Intelligence',
    1,
    198,
    'published',
    '2024-01-22 16:20:00'
),
(
    'Critical Thinking and Problem-Solving in Business',
    'https://example.com/images/critical-thinking.jpg',
    'In an era of rapid change and complex challenges, critical thinking and problem-solving skills are invaluable assets. This post explores systematic approaches to analyzing problems, evaluating solutions, and making informed decisions. We''ll cover techniques like root cause analysis, brainstorming methodologies, and decision-making frameworks. Learn how to ask the right questions, challenge assumptions, and consider multiple perspectives before reaching conclusions. Through case studies and practical exercises, you''ll develop the analytical mindset needed to tackle complex business challenges and drive innovative solutions.',
    'https://example.com/thumbnails/critical-thinking-thumb.jpg',
    'Soft Skills,Problem Solving,Business Strategy',
    3,
    156,
    'published',
    '2024-01-25 13:45:00'
),
(
    'Leadership and Team Collaboration: Building High-Performance Teams',
    'https://example.com/images/team-leadership.jpg',
    'Effective leadership and team collaboration are essential for organizational success. This comprehensive guide explores different leadership styles, from transformational to servant leadership, and when to apply each approach. We''ll discuss how to build trust within teams, facilitate productive meetings, and navigate team dynamics. Learn strategies for motivating diverse team members, delegating effectively, and fostering a culture of innovation and accountability. Whether you''re a new manager or an experienced leader, these insights will help you create high-performing teams that achieve exceptional results together.',
    'https://example.com/thumbnails/team-leadership-thumb.jpg',
    'Soft Skills,Leadership,Team Management',
    2,
    421,
    'published',
    '2024-01-28 10:00:00'
);

INSERT INTO Users (FullName, Email, Mobile, Password, Gender, Role, Status, Username, Bio, DateOfBirth) VALUES
('John Doe', 'john.doe@example.com', '0912345678', 'hashed_password_1', 0, 'customer', 'active', 'johndoe', 'Passionate software developer with 5 years of experience in web development. Love coding and learning new technologies.', '1990-05-15'),
('Jane Smith', 'jane.smith@example.com', '0987654321', 'hashed_password_2', 1, 'customer', 'active', 'janesmith', 'Digital marketing specialist and content creator. Enthusiastic about social media trends and brand building.', '1988-11-22'),
('Admin User', 'admin.user@example.com', '0901122334', 'hashed_password_3', 0, 'admin', 'active', 'adminuser', 'System administrator with extensive experience in database management and server maintenance.', '1985-03-08');

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







