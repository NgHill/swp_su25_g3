package elearning.entities;

import java.sql.Timestamp;

public class UserAnswer {
    private int id;
    private int userId;
    private int quizId;
    private int questionId;
    private Integer answerId; // Có thể null cho text questions
    private String textAnswer; // Có thể null cho multiple choice questions
    private boolean isCorrect;
    private String imagePath;
    private Timestamp answeredAt;
    
    // Constructors
    public UserAnswer() {}
    
    public UserAnswer(int userId, int quizId, int questionId, Integer answerId, 
                     String textAnswer, boolean isCorrect, String imagePath) {
        this.userId = userId;
        this.quizId = quizId;
        this.questionId = questionId;
        this.answerId = answerId;
        this.textAnswer = textAnswer;
        this.isCorrect = isCorrect;
        this.imagePath = imagePath;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public int getQuestionId() {
        return questionId;
    }
    
    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }
    
    public Integer getAnswerId() {
        return answerId;
    }
    
    public void setAnswerId(Integer answerId) {
        this.answerId = answerId;
    }
    
    public String getTextAnswer() {
        return textAnswer;
    }
    
    public void setTextAnswer(String textAnswer) {
        this.textAnswer = textAnswer;
    }
    
    public boolean isCorrect() {
        return isCorrect;
    }
    
    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public Timestamp getAnsweredAt() {
        return answeredAt;
    }
    
    public void setAnsweredAt(Timestamp answeredAt) {
        this.answeredAt = answeredAt;
    }
}