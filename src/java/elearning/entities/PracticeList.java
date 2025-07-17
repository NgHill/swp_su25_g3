package elearning.entities;

import java.sql.Timestamp;

public class PracticeList {
    private int quizResultId;
    private int userId;
    private int quizId;
    private double score;
    private Timestamp submittedAt;
    private String quizTitle;

    public PracticeList() {}

    public PracticeList(int quizResultId, int userId, int quizId, double score, Timestamp submittedAt, String quizTitle) {
        this.quizResultId = quizResultId;
        this.userId = userId;
        this.quizId = quizId;
        this.score = score;
        this.submittedAt = submittedAt;
        this.quizTitle = quizTitle;
    }

    // Getter & Setter đầy đủ
    public int getQuizResultId() { 
        return quizResultId; 
    }
    public void setQuizResultId(int quizResultId) { 
        this.quizResultId = quizResultId; 
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

    public double getScore() { 
        return score; 
    }
    
    public void setScore(double score) { 
        this.score = score; 
    }

    public Timestamp getSubmittedAt() { 
        return submittedAt; 
    }
    public void setSubmittedAt(Timestamp submittedAt) { 
        this.submittedAt = submittedAt; 
    }

    public String getQuizTitle() { 
        return quizTitle; 
    }
    
    public void setQuizTitle(String quizTitle) { 
        this.quizTitle = quizTitle; 
    }
}
