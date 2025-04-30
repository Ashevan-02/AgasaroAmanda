package casestudy;

public abstract class ConstructionMaterial {
    // Shared Fields
    protected String contractorId;
    protected String contractorName;
    protected double materialQuantity; // in tons
    protected double materialBalance;  // in tons

    // Constructor
    public ConstructionMaterial(String contractorId, String contractorName, double materialQuantity, double materialBalance) {
        this.contractorId = contractorId;
        this.contractorName = contractorName;
        this.materialQuantity = materialQuantity;
        this.materialBalance = materialBalance;
    }

    // Getters and Setters
    public String getContractorId() {
        return contractorId;
    }

    public void setContractorId(String contractorId) {
        this.contractorId = contractorId;
    }

    public String getContractorName() {
        return contractorName;
    }

    public void setContractorName(String contractorName) {
        this.contractorName = contractorName;
    }

    public double getMaterialQuantity() {
        return materialQuantity;
    }

    public void setMaterialQuantity(double materialQuantity) {
        this.materialQuantity = materialQuantity;
    }

    public double getMaterialBalance() {
        return materialBalance;
    }

    public void setMaterialBalance(double materialBalance) {
        this.materialBalance = materialBalance;
    }

    // Abstract Methods
    public abstract void receiveMaterial();
    public abstract void useMaterial();
    public abstract void estimateCost();
}
