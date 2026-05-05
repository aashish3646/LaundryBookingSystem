package model;

public class Vendor {
    private int vendorId;
    private Integer userId;
    private String vendorName;
    private String area;
    private String contact;
    private String serviceType;
    private String priceRange;
    private String documentPath;
    private String status;
    private String createdAt;
    private double averageRating;
    private int reviewCount;

    private String ownerName;
    private String documentType;
    private String approvalStatus;
    private String adminRemarks;

    public Vendor() {
    }

    public Vendor(int vendorId, Integer userId, String vendorName, String ownerName, String area, String contact, String serviceType, String priceRange, String documentType, String documentPath, String approvalStatus, String adminRemarks, String status, String createdAt) {
        this.vendorId = vendorId;
        this.userId = userId;
        this.vendorName = vendorName;
        this.ownerName = ownerName;
        this.area = area;
        this.contact = contact;
        this.serviceType = serviceType;
        this.priceRange = priceRange;
        this.documentType = documentType;
        this.documentPath = documentPath;
        this.approvalStatus = approvalStatus;
        this.adminRemarks = adminRemarks;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
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

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentPath() {
        return documentPath;
    }

    public void setDocumentPath(String documentPath) {
        this.documentPath = documentPath;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public String getAdminRemarks() {
        return adminRemarks;
    }

    public void setAdminRemarks(String adminRemarks) {
        this.adminRemarks = adminRemarks;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
}
