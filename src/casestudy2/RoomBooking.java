package casestudy2;

public class RoomBooking extends HotelService {

    public RoomBooking(String guestId, String guestName, String roomType, int stayDays, String roomStatus) {
        super(guestId, guestName, roomType, stayDays, roomStatus);
    }

    @Override
    public boolean bookRoom() {
        if (stayDays < 1 || stayDays > 30) {
            System.out.println("❌ Booking failed: Stay duration must be between 1 and 30 days.");
            return false;
        }

        if (!roomStatus.equals("AVAILABLE")) {
            System.out.println("❌ Booking failed: Room is not available.");
            return false;
        }

        this.roomStatus = "OCCUPIED";
        System.out.println("✅ Room booked successfully for " + guestName + ". Room is now OCCUPIED.");
        return true;
    }

    @Override
    public void checkoutGuest() {
        // Not used here
    }

    @Override
    public void generateBill() {
        // Not used here
    }
}
