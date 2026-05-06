package service;

import java.sql.Timestamp;

import dao.BookingDAO;
import model.Booking;
import java.util.List;

public class BookingService {

    private final BookingDAO bookingDAO;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
    }

    public int createBookingRequest(int listingId, int renterUserId, Timestamp startTime, Timestamp endTime) {
        if (listingId <= 0 || renterUserId <= 0) {
            return -1;
        }

        if (startTime == null || endTime == null) {
            return -1;
        }

        if (!endTime.after(startTime)) {
            return -1;
        }

        Booking booking = new Booking();
        booking.setListingId(listingId);
        booking.setUserId(renterUserId);
        booking.setStartTime(startTime);
        booking.setEndTime(endTime);
        booking.setStatus("pending");

        return bookingDAO.createBookingRequest(booking);
    }
    
    public boolean hasOverlappingConfirmedBooking(Booking booking) {
        if (booking == null) {
            return true;
        }

        return bookingDAO.hasOverlappingConfirmedBooking(
                booking.getListingId(),
                booking.getBookingId(),
                booking.getStartTime(),
                booking.getEndTime()
        );
    }

    public List<Integer> getOverlappingPendingBookingIds(Booking booking) {
        if (booking == null) {
            return java.util.Collections.emptyList();
        }

        return bookingDAO.getOverlappingPendingBookingIds(
                booking.getListingId(),
                booking.getBookingId(),
                booking.getStartTime(),
                booking.getEndTime()
        );
    }

    public boolean denyBookingsByIds(List<Integer> bookingIds) {
        return bookingDAO.denyBookingsByIds(bookingIds);
    }
    
    
}