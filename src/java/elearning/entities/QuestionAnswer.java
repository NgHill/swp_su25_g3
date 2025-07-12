// QuestionAnswer.java
package elearning.entities;

public class QuestionAnswer {
    private int id;
    private int questionId;
    private String content;
    private boolean isCorrect;
    private String explanation;
    
    // Constructors
    public QuestionAnswer() {}
    
    public QuestionAnswer(int id, int questionId, String content, 
                         boolean isCorrect, String explanation) {
        this.id = id;
        this.questionId = questionId;
        this.content = content;
        this.isCorrect = isCorrect;
        this.explanation = explanation;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }
    
    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }
}