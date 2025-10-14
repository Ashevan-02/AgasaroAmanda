package edu.auca.registration.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * Offered course instance tied to an AcademicUnit.
 */
public class Course {
    private String id; // synthetic id for linking

    // Relationships
    private CourseDefinition definition; // Many courses can refer to one definition
    private AcademicUnit academicUnit;   // Many courses belong to one academic unit

    private List<StudentCourse> studentCourses = new ArrayList<>();

    private Teacher tutor;     // optional in ERD (tutor)
    private Teacher assistant; // assistant

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public CourseDefinition getDefinition() {
        return definition;
    }

    public void setDefinition(CourseDefinition definition) {
        this.definition = definition;
    }

    public AcademicUnit getAcademicUnit() {
        return academicUnit;
    }

    public void setAcademicUnit(AcademicUnit academicUnit) {
        this.academicUnit = academicUnit;
    }

    public List<StudentCourse> getStudentCourses() {
        return studentCourses;
    }

    public void setStudentCourses(List<StudentCourse> studentCourses) {
        this.studentCourses = studentCourses;
    }

    public Teacher getTutor() {
        return tutor;
    }

    public void setTutor(Teacher tutor) {
        this.tutor = tutor;
    }

    public Teacher getAssistant() {
        return assistant;
    }

    public void setAssistant(Teacher assistant) {
        this.assistant = assistant;
    }
}
