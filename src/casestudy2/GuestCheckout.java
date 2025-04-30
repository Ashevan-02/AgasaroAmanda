package casestudy2;

public class GuestCheckout extends HotelService{
    public GuestCheckout(String guestId, String guestName, String roomType, int stayDays, String roomStatus) {
        super(guestId, guestName, roomType, stayDays, roomStatus);
    }

    @Override
    public boolean bookRoom() {
        System.out.println("⏳ Billing not applicable in checkout.");
        return false;
    }

    @Override
    public void checkoutGuest() {
        if (roomStatus.equalsIgnoreCase("OCCUPIED")) {
            roomStatus = "AVAILABLE";
            System.out.println("✅ Checkout successful for " + guestName + ". Room is now available.");
        } else {
            System.out.println("❌ Checkout failed: Room is already available.");
        }
    }

    @Override
    public void generateBill() {
        System.out.println("⏳ Billing not applicable in checkout.");
    }
}
