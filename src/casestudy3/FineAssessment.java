package casestudy3;

public class FineAssessment extends TrafficRecord {

    public FineAssessment(String driverId, String driverName, String vehiclePlate, String violationType) {
        super(driverId, driverName, vehiclePlate, violationType);
    }

    @Override
    public void recordViolation() {

    }

    @Override
    public void assessFine() {
        switch (violationType.toUpperCase()) {
            case "SPEEDING":
                fineAmount = 50000;
                break;
            case "RED_LIGHT":
                fineAmount = 80000;
                break;
            case "NO_HELMET":
                fineAmount = 30000;
                break;
            case "DUI":
                fineAmount = 150000;
                break;
            default:
                System.out.println("❌ Error: Unknown violation type for fine assessment.");
                return;
        }

        System.out.println("💸 Fine Assessment:");
        System.out.println("Driver: " + driverName + " (" + driverId + ")");
        System.out.println("Violation: " + violationType.toUpperCase());
        System.out.println("Fine Amount: " + fineAmount + " RWF");
    }



    @Override
    public void processPayment() {

    }
}
