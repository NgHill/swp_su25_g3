/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import java.time.LocalDateTime;

public class QuizResult {
    private int id;
    private int userId;
    private int quizId;
    private double score;
    private LocalDateTime submittedAt;
    
    // Constructors
    public QuizResult() {}
    
    public QuizResult(int id, int userId, int quizId, double score, 
                     LocalDateTime submittedAt) {
        this.id = id;
        this.userId = userId;
        this.quizId = quizId;
        this.score = score;
        this.submittedAt = submittedAt;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }
    
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(LocalDateTime submittedAt) { this.submittedAt = submittedAt; }
}
