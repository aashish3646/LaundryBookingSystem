package model;

import java.time.LocalDateTime;

public class Booking {

    private int bookingId;
    private int userId;
    private int vendorId;
    private int slotId;
    private String pickupAddress;
    private String clothesType;
    private int quantity;
    private String pickupNote;
    private String bookingStatus;
    private LocalDateTime createdAt;

    public Booking() {
    }

    public Booking(int bookingId, int userId, int vendorId, int slotId, String pickupAddress,
                   String clothesType, int quantity, String pickupNote,
                   String bookingStatus, LocalDateTime createdAt) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.vendorId = vendorId;
        this.slotId = slotId;
        this.pickupAddress = pickupAddress;
        this.clothesType = clothesType;
        this.quantity = quantity;
        this.pickupNote = pickupNote;
        this.bookingStatus = bookingStatus;
        this.createdAt = createdAt;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getClothesType() {
        return clothesType;
    }

    public void setClothesType(String clothesType) {
        this.clothesType = clothesType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getPickupNote() {
        return pickupNote;
    }

    public void setPickupNote(String pickupNote) {
        this.pickupNote = pickupNote;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}