package casestudy;

import java.util.Scanner;

public class RealConstructorMain {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("🏗️ Welcome to REAL CONSTRUCTOR – Site Management System");

        System.out.print("Enter Contractor ID: ");
        String contractorId = scanner.nextLine();

        System.out.print("Enter Contractor Name: ");
        String contractorName = scanner.nextLine();

        System.out.print("Enter initial material quantity (in tons): ");
        double quantity = scanner.nextDouble();

        System.out.print("Enter current material balance (in tons): ");
        double balance = scanner.nextDouble();

        System.out.println("\nChoose Operation:");
        System.out.println("1. Material Delivery");
        System.out.println("2. Material Usage");
        System.out.println("3. Cost Estimation");
        System.out.print("Enter choice (1-3): ");
        int choice = scanner.nextInt();

        ConstructionMaterial material;

        switch (choice) {
            case 1:
                material = new MaterialDelivery(contractorId, contractorName, quantity, balance);
                material.receiveMaterial();
                break;
            case 2:
                material = new MaterialUsage(contractorId, contractorName, quantity, balance);
                material.useMaterial();
                break;
            case 3:
                material = new CostEstimation(contractorId, contractorName, quantity, balance);
                material.estimateCost();
                break;
            default:
                System.out.println("❌ Invalid option selected.");
        }

        scanner.close();
    }
}
