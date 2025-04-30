package casestudy;

public class CostEstimation extends ConstructionMaterial {

    public CostEstimation(String contractorId, String contractorName, double materialQuantity, double materialBalance) {
        super(contractorId, contractorName, materialQuantity, materialBalance);
    }

    @Override
    public void receiveMaterial() {
        // Not used here
    }

    @Override
    public void useMaterial() {
        // Not used here
    }

    @Override
    public void estimateCost() {
        double costPerTon;
        if (materialQuantity >= 5 && materialQuantity <= 15) {
            costPerTon = 200000;
        } else if (materialQuantity > 15) {
            costPerTon = 180000;
        } else {
            System.out.println("❌ Cost estimation not applicable for less than 5 tons.");
            return;
        }

        double totalCost = materialQuantity * costPerTon;
        System.out.println("📄 Cost Estimation Report");
        System.out.println("---------------------------");
        System.out.println("Contractor ID: " + contractorId);
        System.out.println("Contractor Name: " + contractorName);
        System.out.println("Material Quantity Used: " + materialQuantity + " tons");
        System.out.printf("Total Estimated Cost: RWF %, .2f%n", totalCost);
    }
}
