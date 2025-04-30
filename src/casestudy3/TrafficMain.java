package casestudy3;

import java.util.Scanner;

public class TrafficMain {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter Driver ID (16 digits): ");
        String driverId = scanner.nextLine();
        if (driverId.length() != 16) {
            System.out.println("❌ Invalid Driver ID. Must be 16 digits.");
            return;
        }

        System.out.print("Enter Driver Name: ");
        String driverName = scanner.nextLine();

        System.out.print("Enter Vehicle Plate (e.g., RAB123D): ");
        String plate = scanner.nextLine();
        if (!plate.matches("R[A-Z]{2}\\d{3}[A-Z]")) {
            System.out.println("❌ Invalid plate format.");
            return;
        }

        System.out.print("Enter Violation Type (SPEEDING/RED_LIGHT/NO_HELMET/DUI): ");
        String violation = scanner.nextLine();

        System.out.println("\n--- RECORDING VIOLATION ---");
        ViolationEntry violationEntry = new ViolationEntry(driverId, driverName, plate, violation);
        violationEntry.recordViolation();

        System.out.println("\n--- ASSESSING FINE ---");
        FineAssessment fineAssessment = new FineAssessment(driverId, driverName, plate, violation);
        fineAssessment.assessFine();

        System.out.println("\n--- PROCESSING PAYMENT ---");
        FinePayment finePayment = new FinePayment(driverId, driverName, plate, violation, fineAssessment.fineAmount, "UNPAID");
        finePayment.processPayment();
    }
}


