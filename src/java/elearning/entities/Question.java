package elearning.entities;

import java.time.LocalDateTime;
import java.util.List;

public class Question {
    private int id;
    private int subjectId;
    private int lessonId;
    private int dimensionId;
    private String level;
    private String content;
    private String media;
    private String status;
    private String questionType; // Thêm trường mới
    private LocalDateTime createdAt;
    private List<QuestionAnswer> answers;
    
    // Constructors
    public Question() {
        this.questionType = "multiple_choice"; // default value
    }
    
    public Question(int id, int subjectId, int lessonId, int dimensionId, 
                   String level, String content, String media, String status, 
                   String questionType, LocalDateTime createdAt) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.dimensionId = dimensionId;
        this.level = level;
        this.content = content;
        this.media = media;
        this.status = status;
        this.questionType = questionType != null ? questionType : "multiple_choice";
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getSubjectId() {
        return subjectId;
    }
    
    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }
    
    public int getLessonId() {
        return lessonId;
    }
    
    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }
    
    public int getDimensionId() {
        return dimensionId;
    }
    
    public void setDimensionId(int dimensionId) {
        this.dimensionId = dimensionId;
    }
    
    public String getLevel() {
        return level;
    }
    
    public void setLevel(String level) {
        this.level = level;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getMedia() {
        return media;
    }
    
    public void setMedia(String media) {
        this.media = media;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getQuestionType() {
        return questionType;
    }
    
    public void setQuestionType(String questionType) {
        this.questionType = questionType != null ? questionType : "multiple_choice";
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<QuestionAnswer> getAnswers() {
        return answers;
    }
    
    public void setAnswers(List<QuestionAnswer> answers) {
        this.answers = answers;
    }
    
    // Utility methods
    public boolean isMultipleChoice() {
        return "multiple_choice".equals(this.questionType);
    }
    
    public boolean isTextInput() {
        return "text_input".equals(this.questionType);
    }
    
    public List<QuestionAnswer> getCorrectAnswers() {
        if (answers == null) return null;
        return answers.stream()
                     .filter(QuestionAnswer::isCorrect)
                     .collect(java.util.stream.Collectors.toList());
    }
    
    public List<QuestionAnswer> getIncorrectAnswers() {
        if (answers == null) return null;
        return answers.stream()
                     .filter(answer -> !answer.isCorrect())
                     .collect(java.util.stream.Collectors.toList());
    }
    
    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", subjectId=" + subjectId +
                ", lessonId=" + lessonId +
                ", dimensionId=" + dimensionId +
                ", level='" + level + '\'' +
                ", content='" + content + '\'' +
                ", media='" + media + '\'' +
                ", status='" + status + '\'' +
                ", questionType='" + questionType + '\'' +
                ", createdAt=" + createdAt +
                ", answersCount=" + (answers != null ? answers.size() : 0) +
                '}';
    }
}