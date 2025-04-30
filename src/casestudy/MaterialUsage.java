package casestudy;

public class MaterialUsage extends ConstructionMaterial {

    public MaterialUsage(String contractorId, String contractorName, double materialQuantity, double materialBalance) {
        super(contractorId, contractorName, materialQuantity, materialBalance);
    }

    @Override
    public void receiveMaterial() {
        // Not used here
    }

    @Override
    public void useMaterial() {
        if (materialBalance - materialQuantity >= 2) {
            materialBalance -= materialQuantity;
            System.out.println("✅ Material used successfully.");
            System.out.println("Remaining material balance: " + materialBalance + " tons");
        } else {
            System.out.println("❌ Cannot use material. Minimum 2 tons must remain in stock.");
        }
    }

    @Override
    public void estimateCost() {
        // Not used here
    }
}
