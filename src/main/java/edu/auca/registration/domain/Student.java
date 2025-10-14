package edu.auca.registration.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * Student aggregate root.
 *
 * Relationships are expressed via fields only (no JPA annotations yet).
 */
public class Student {
    private String regNo;
    private String firstName;
    private String dateOfBirth; // as per ERD

    // Relationships
    private List<StudentRegistration> registrations = new ArrayList<>();

    public Student() {}

    public Student(String regNo, String firstName, String dateOfBirth) {
        this.regNo = regNo;
        this.firstName = firstName;
        this.dateOfBirth = dateOfBirth;
    }

    public String getRegNo() {
        return regNo;
    }

    public void setRegNo(String regNo) {
        this.regNo = regNo;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public List<StudentRegistration> getRegistrations() {
        return registrations;
    }

    public void setRegistrations(List<StudentRegistration> registrations) {
        this.registrations = registrations;
    }
}
