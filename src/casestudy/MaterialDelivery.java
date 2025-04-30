package casestudy;

public class MaterialDelivery extends ConstructionMaterial {

    public MaterialDelivery(String contractorId, String contractorName, double materialQuantity, double materialBalance) {
        super(contractorId, contractorName, materialQuantity, materialBalance);
    }

    @Override
    public void receiveMaterial() {
        if (materialQuantity >= 1 && materialQuantity <= 10) {
            materialBalance += materialQuantity;
            System.out.println("✅ Material delivered successfully.");
            System.out.println("Updated material balance: " + materialBalance + " tons");
        } else {
            System.out.println("❌ Delivery failed: Material quantity must be between 1 and 10 tons.");
        }
    }

    @Override
    public void useMaterial() {
        // Not used here
    }

    @Override
    public void estimateCost() {
        // Not used here
    }
}
