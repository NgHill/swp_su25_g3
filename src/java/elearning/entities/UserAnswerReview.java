package elearning.entities;


public class UserAnswerReview {
    private int questionIndex;
    private String userAnswer;
    private Integer userAnswerId; // Thêm field để lưu ID đáp án multiple choice
    private boolean isCorrect;
    private String questionType;
    
    // Constructors
    public UserAnswerReview() {}
    
    // Getters and Setters
    public int getQuestionIndex() {
        return questionIndex;
    }
    
    public void setQuestionIndex(int questionIndex) {
        this.questionIndex = questionIndex;
    }
    
    public String getUserAnswer() {
        return userAnswer;
    }
    
    public void setUserAnswer(String userAnswer) {
        this.userAnswer = userAnswer;
    }
    
    public Integer getUserAnswerId() {
        return userAnswerId;
    }
    
    public void setUserAnswerId(Integer userAnswerId) {
        this.userAnswerId = userAnswerId;
    }
    
    public boolean isCorrect() {
        return isCorrect;
    }
    
    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
    
    public String getQuestionType() {
        return questionType;
    }
    
    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }
    
    // Helper method để kiểm tra có đáp án không
    public boolean hasAnswer() {
        return userAnswer != null && !userAnswer.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "UserAnswerReview{" +
                "questionIndex=" + questionIndex +
                ", userAnswer='" + userAnswer + '\'' +
                ", userAnswerId=" + userAnswerId +
                ", isCorrect=" + isCorrect +
                ", questionType='" + questionType + '\'' +
                '}';
    }
}