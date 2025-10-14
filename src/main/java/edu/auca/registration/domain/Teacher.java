package edu.auca.registration.domain;

import edu.auca.registration.domain.enums.EQualification;
import java.util.ArrayList;
import java.util.List;

public class Teacher {
    private String code;
    private String names;
    private String qualification; // keep string per ERD box

    private EQualification highestQualification; // optional enum convenience

    // Relationships
    private List<Course> tutorOf = new ArrayList<>();
    private List<Course> assistantOf = new ArrayList<>();

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNames() {
        return names;
    }

    public void setNames(String names) {
        this.names = names;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public EQualification getHighestQualification() {
        return highestQualification;
    }

    public void setHighestQualification(EQualification highestQualification) {
        this.highestQualification = highestQualification;
    }

    public List<Course> getTutorOf() {
        return tutorOf;
    }

    public void setTutorOf(List<Course> tutorOf) {
        this.tutorOf = tutorOf;
    }

    public List<Course> getAssistantOf() {
        return assistantOf;
    }

    public void setAssistantOf(List<Course> assistantOf) {
        this.assistantOf = assistantOf;
    }
}
