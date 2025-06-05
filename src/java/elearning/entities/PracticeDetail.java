package elearning.entities;

import java.sql.Timestamp;

public class PracticeDetail {
    private int quizResultId;
    private String quizTitle;
    private String subjectDescription;
    private int duration;
    private Timestamp submittedAt;
    private double score;

    // Constructor đầy đủ (nên thêm cả quizResultId)
    public PracticeDetail(int quizResultId, String quizTitle, String subjectDescription, int duration, Timestamp submittedAt, double score) {
        this.quizResultId = quizResultId;
        this.quizTitle = quizTitle;
        this.subjectDescription = subjectDescription;
        this.duration = duration;
        this.submittedAt = submittedAt;
        this.score = score;
    }

    // Constructor không có ID (nếu cần)
    public PracticeDetail(String quizTitle, String subjectDescription, int duration, Timestamp submittedAt, double score) {
        this.quizTitle = quizTitle;
        this.subjectDescription = subjectDescription;
        this.duration = duration;
        this.submittedAt = submittedAt;
        this.score = score;
    }

    public PracticeDetail() {
    }

    // Getters and Setters
    public int getQuizResultId() {
        return quizResultId;
    }

    public void setQuizResultId(int quizResultId) {
        this.quizResultId = quizResultId;
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
