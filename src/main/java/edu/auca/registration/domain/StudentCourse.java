package edu.auca.registration.domain;

import java.math.BigDecimal;

/**
 * Join entity between StudentRegistration and Course capturing credits and results.
 */
public class StudentCourse {
    private String id;
    private Integer credits;
    private BigDecimal results;

    // Relationships
    private StudentRegistration registration; // Many student-course rows to one registration
    private Course course;                     // Many student-course rows to one course

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getCredits() {
        return credits;
    }

    public void setCredits(Integer credits) {
        this.credits = credits;
    }

    public BigDecimal getResults() {
        return results;
    }

    public void setResults(BigDecimal results) {
        this.results = results;
    }

    public StudentRegistration getRegistration() {
        return registration;
    }

    public void setRegistration(StudentRegistration registration) {
        this.registration = registration;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }
}
