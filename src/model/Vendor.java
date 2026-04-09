package model;

public class Vendor {

    private int vendorId;
    private String vendorName;
    private String area;
    private String contact;
    private String serviceType;
    private String priceRange;

    public Vendor() {
    }

    public Vendor(int vendorId, String vendorName, String area, String contact, String serviceType, String priceRange) {
        this.vendorId = vendorId;
        this.vendorName = vendorName;
        this.area = area;
        this.contact = contact;
        this.serviceType = serviceType;
        this.priceRange = priceRange;
    }

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getPriceRange() {
        return priceRange;
    }

    public void setPriceRange(String priceRange) {
        this.priceRange = priceRange;
    }
}