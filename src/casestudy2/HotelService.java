package casestudy2;

public abstract class HotelService {
    // Common guest attributes
    protected String guestId;
    protected String guestName;
    protected String roomType;
    protected int stayDays;
    protected String roomStatus;

    // Constructor
    public HotelService(String guestId, String guestName, String roomType, int stayDays, String roomStatus) {
        this.guestId = guestId;
        this.guestName = guestName;
        this.roomType = roomType;
        this.stayDays = stayDays;
        this.roomStatus = roomStatus;
    }

    // Abstract methods
    public abstract boolean bookRoom();
    public abstract void checkoutGuest();
    public abstract void generateBill();
}

