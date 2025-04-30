package casestudy3;

import java.util.Arrays;
import java.util.List;

public class ViolationEntry extends TrafficRecord {

    public ViolationEntry(String driverId, String driverName, String vehiclePlate, String violationType) {
        super(driverId, driverName, vehiclePlate, violationType);
    }

    @Override
    public void recordViolation() {
        List<String> allowedTypes = Arrays.asList("SPEEDING", "RED_LIGHT", "NO_HELMET", "DUI");

        if (!allowedTypes.contains(violationType.toUpperCase())) {
            System.out.println("❌ Error: Violation type '" + violationType + "' is not recognized.");
            return;
        }

        this.paymentStatus = "UNPAID";

        System.out.println("✅ Violation recorded:");
        System.out.println("Driver: " + driverName + " (" + driverId + ")");
        System.out.println("Vehicle Plate: " + vehiclePlate);
        System.out.println("Violation Type: " + violationType.toUpperCase());
        System.out.println("Payment Status: " + paymentStatus);
    }


    @Override
    public void assessFine() {

    }

    @Override
    public void processPayment() {

    }
}
