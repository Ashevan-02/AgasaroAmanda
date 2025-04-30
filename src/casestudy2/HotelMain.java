package casestudy2;

import java.util.Scanner;

public class HotelMain {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("🏨 Welcome to Lemigo Hotel Management System!");
        System.out.println("Please enter guest details to proceed:\n");

        // Get guest input
        System.out.print("🆔 Enter Guest ID: ");
        String guestId = sc.nextLine();

        System.out.print("👤 Enter Guest Name: ");
        String guestName = sc.nextLine();

        System.out.print("🛏️ Enter Room Type (STANDARD / DELUXE / SUITE): ");
        String roomType = sc.nextLine().toUpperCase();

        System.out.print("📅 Enter Number of Stay Days (1-30): ");
        int stayDays = sc.nextInt();
        sc.nextLine();  // consume newline

        System.out.print("🏷️ Enter Room Status (AVAILABLE / OCCUPIED): ");
        String roomStatus = sc.nextLine().toUpperCase();

        System.out.println("\n--- Booking Process ---");
        RoomBooking booking = new RoomBooking(guestId, guestName, roomType, stayDays, roomStatus);
        boolean isBooked = booking.bookRoom();

        if (isBooked) {
            System.out.println("\n--- Checkout Process ---");
            GuestCheckout checkout = new GuestCheckout(guestId, guestName, roomType, stayDays, booking.roomStatus);
            checkout.checkoutGuest();

            System.out.println("\n--- Billing Process ---");
            Billing billing = new Billing(guestId, guestName, roomType, stayDays, "AVAILABLE");
            billing.generateBill();
        } else {
            System.out.println("\n⚠️ Cannot proceed with checkout or billing. Booking was not successful.");
        }

        System.out.println("\n✅ Thank you for using Lemigo Hotel System!");
        sc.close();
    }
}
