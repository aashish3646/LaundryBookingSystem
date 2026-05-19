package model;

public class Booking {
    private int bookingId;
    private int userId;
    private int vendorId;
    private int serviceId;
    private int slotId;
    private String pickupAddress;
    private String clothesType;
    private int quantity;
    private String pickupNote;
    private String bookingStatus;
    private String createdAt;

    private String customerName;
    private String vendorName;
    private String serviceName;
    private String slotDate;
    private String slotTime;
    private double servicePrice;

    public Booking() {
    }

    public Booking(int bookingId, int userId, int vendorId, int serviceId, int slotId, String pickupAddress, String clothesType, int quantity, String pickupNote, String bookingStatus, String createdAt) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.vendorId = vendorId;
        this.serviceId = serviceId;
        this.slotId = slotId;
        this.pickupAddress = pickupAddress;
        this.clothesType = clothesType;
        this.quantity = quantity;
        this.pickupNote = pickupNote;
        this.bookingStatus = bookingStatus;
        this.createdAt = createdAt;
    }

    public Booking(int userId, int vendorId, int serviceId, int slotId, String pickupAddress, String clothesType, int quantity, String pickupNote) {
        this.userId = userId;
        this.vendorId = vendorId;
        this.serviceId = serviceId;
        this.slotId = slotId;
        this.pickupAddress = pickupAddress;
        this.clothesType = clothesType;
        this.quantity = quantity;
        this.pickupNote = pickupNote;
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

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
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

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(String slotDate) {
        this.slotDate = slotDate;
    }

    public String getSlotTime() {
        return slotTime;
    }

    public void setSlotTime(String slotTime) {
        this.slotTime = slotTime;
    }

    public double getServicePrice() {
        return servicePrice;
    }

    public void setServicePrice(double servicePrice) {
        this.servicePrice = servicePrice;
    }
}
