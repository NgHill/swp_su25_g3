package elearning.entities;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubjectList {

    int id;
    String name;
    String category;
    int lessons;
    String owner;
    String status;
    boolean featured;
    String thumbnailUrl;
    String description;
    Timestamp createdAt;
    Timestamp updatedAt;

    public SubjectList(String name, String category, int numberOfLesson, boolean featured,
            String owner, String description, String thumbnail) {
        this.name = name;
        this.category = category;
        this.lessons = numberOfLesson;
        this.featured = featured;
        this.owner = owner;
        this.description = description;
        this.thumbnailUrl = thumbnail;
    }

}
