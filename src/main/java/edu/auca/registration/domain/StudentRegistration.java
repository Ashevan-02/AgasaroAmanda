package edu.auca.registration.domain;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Registration of a student to a semester and department (academic unit).
 */
public class StudentRegistration {
    private String id;
    private String studentId; // denormalized per ERD box
    private LocalDate registrationDate;

    // Relationships
    private Student student;     // Many registrations to one student
    private Semester semester;   // Many registrations to one semester
    private AcademicUnit department; // Department level unit

    private List<StudentCourse> studentCourses = new ArrayList<>();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = registrationDate;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Semester getSemester() {
        return semester;
    }

    public void setSemester(Semester semester) {
        this.semester = semester;
    }

    public AcademicUnit getDepartment() {
        return department;
    }

    public void setDepartment(AcademicUnit department) {
        this.department = department;
    }

    public List<StudentCourse> getStudentCourses() {
        return studentCourses;
    }

    public void setStudentCourses(List<StudentCourse> studentCourses) {
        this.studentCourses = studentCourses;
    }
}
