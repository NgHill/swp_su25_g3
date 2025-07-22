package elearning.entities;

import java.sql.Timestamp;

public class PracticeDetail {
    private int userId;
    private int resultId;
    private String quizTitle;
    private String subjectDescription;
    private int duration;
    private Timestamp submittedAt;
    private double score;
    public PracticeDetail() {
    }

    public PracticeDetail(int userId, int quizResultId, String quizTitle, String subjectDescription, int duration, Timestamp submittedAt, double score) {
        this.userId = userId;
        this.resultId = quizResultId;
        this.quizTitle = quizTitle;
        this.subjectDescription = subjectDescription;
        this.duration = duration;
        this.submittedAt = submittedAt;
        this.score = score;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getResultId() {
        return resultId;
    }

    public void setResultId(int quizResultId) {
        this.resultId = quizResultId;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public String getSubjectDescription() {
        return subjectDescription;
    }

    public void setSubjectDescription(String subjectDescription) {
        this.subjectDescription = subjectDescription;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    
}
