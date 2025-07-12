/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import java.time.LocalDateTime;
import java.util.List;

public class Quiz {
    private int id;
    private String title;
    private int subjectId;
    private int duration;
    private String status;
    private LocalDateTime createdAt;
    private List<Question> questions;
    
    // Constructors
    public Quiz() {}
    
    public Quiz(int id, String title, int subjectId, int duration, 
               String status, LocalDateTime createdAt) {
        this.id = id;
        this.title = title;
        this.subjectId = subjectId;
        this.duration = duration;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
}