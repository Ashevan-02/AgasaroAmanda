package casestudy3;

public class FinePayment extends TrafficRecord {

    // ✅ Add fineAmount and paymentStatus to constructor parameters
    public FinePayment(String driverId, String driverName, String vehiclePlate, String violationType, double fineAmount, String paymentStatus) {
        super(driverId, driverName, vehiclePlate, violationType);
        this.fineAmount = fineAmount;
        this.paymentStatus = paymentStatus;
    }

    @Override
    public void recordViolation() {
        // Not needed in FinePayment, but required to implement
    }

    @Override
    public void assessFine() {
        // Not needed in FinePayment, but required to implement
    }

    @Override
    public void processPayment() {
        if (paymentStatus.equalsIgnoreCase("PAID")) {
            System.out.println("❌ Payment already completed.");
            return;
        }

        paymentStatus = "PAID";
        System.out.println("🧾 PAYMENT RECEIPT:");
        System.out.println("Driver: " + driverName + " (" + driverId + ")");
        System.out.println("Vehicle Plate: " + vehiclePlate);
        System.out.println("Amount Paid: " + fineAmount + " RWF");
        System.out.println("Payment Status: " + paymentStatus);
    }
}
