package model;

import java.time.LocalDate;

public class Slot {

    private int slotId;
    private int vendorId;
    private LocalDate slotDate;
    private String slotTime;
    private String availabilityStatus;

    public Slot() {
    }

    public Slot(int slotId, int vendorId, LocalDate slotDate, String slotTime, String availabilityStatus) {
        this.slotId = slotId;
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

    public LocalDate getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(LocalDate slotDate) {
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
}