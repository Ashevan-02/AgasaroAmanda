package edu.auca.registration.domain;

import edu.auca.registration.domain.enums.EAcademicUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * Academic unit such as Programme, Faculty, Department.
 */
public class AcademicUnit {
    private String code;
    private String name;
    private EAcademicUnit unitType;

    // Self-referencing hierarchy
    private AcademicUnit parent; // Many child units may share the same parent
    private List<AcademicUnit> children = new ArrayList<>();

    // Relationships
    private List<Course> courses = new ArrayList<>();

    public AcademicUnit() {}

    public AcademicUnit(String code, String name, EAcademicUnit unitType) {
        this.code = code;
        this.name = name;
        this.unitType = unitType;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public EAcademicUnit getUnitType() {
        return unitType;
    }

    public void setUnitType(EAcademicUnit unitType) {
        this.unitType = unitType;
    }

    public AcademicUnit getParent() {
        return parent;
    }

    public void setParent(AcademicUnit parent) {
        this.parent = parent;
    }

    public List<AcademicUnit> getChildren() {
        return children;
    }

    public void setChildren(List<AcademicUnit> children) {
        this.children = children;
    }

    public List<Course> getCourses() {
        return courses;
    }

    public void setCourses(List<Course> courses) {
        this.courses = courses;
    }
}
