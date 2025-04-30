package casestudy2;

public class Billing extends HotelService{
    public Billing(String guestId, String guestName, String roomType, int stayDays, String roomStatus) {
        super(guestId, guestName, roomType, stayDays, roomStatus);
    }

    @Override
    public boolean bookRoom() {
        System.out.println("⏳ Checkout not applicable in billing.");
        return false;
    }

    @Override
    public void checkoutGuest() {
        System.out.println("⏳ Checkout not applicable in billing.");
    }

    @Override
    public void generateBill() {
        int costPerNight;

        switch (roomType.toUpperCase()) {
            case "STANDARD":
                costPerNight = 50000;
                break;
            case "DELUXE":
                costPerNight = 80000;
                break;
            case "SUITE":
                costPerNight = 120000;
                break;
            default:
                System.out.println("❌ Invalid room type. Cannot generate bill.");
                return;
        }

        int totalCost = costPerNight * stayDays;

        System.out.println("🧾 BILLING DETAILS:");
        System.out.println("Guest: " + guestName + " (ID: " + guestId + ")");
        System.out.println("Room Type: " + roomType);
        System.out.println("Days Stayed: " + stayDays);
        System.out.println("Total Amount: " + totalCost + " RWF");
    }
}

