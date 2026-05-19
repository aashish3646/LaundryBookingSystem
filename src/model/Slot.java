package model;

public class Slot {
    private int slotId;
    private int vendorId;
    private String slotDate;
    private String slotTime;
    private String availabilityStatus;
    private String vendorName;

    public Slot() {
    }

    public Slot(int slotId, int vendorId, String slotDate, String slotTime, String availabilityStatus) {
        this.slotId = slotId;
        this.vendorId = vendorId;
        this.slotDate = slotDate;
        this.slotTime = slotTime;
        this.availabilityStatus = availabilityStatus;
    }

    public Slot(int vendorId, String slotDate, String slotTime, String availabilityStatus) {
        this.vendorId = vendorId;
        this.slotDate = slotDate;
        this.slotTime = slotTime;
        this.availabilityStatus = availabilityStatus;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
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

    public String getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(String availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }
}
