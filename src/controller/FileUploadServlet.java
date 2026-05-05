package controller;

import dao.VendorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Vendor;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Locale;

@WebServlet("/vendor/upload-document")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class FileUploadServlet extends HttpServlet {
    private static final long MAX_FILE_SIZE = 2L * 1024L * 1024L;
    private final VendorDAO vendorDAO = new VendorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"vendor".equals(session.getAttribute("userRole")) || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        Vendor vendor = vendorDAO.getVendorByUserId(userId);
        boolean isNew = (vendor == null);

        if (isNew) {
            vendor = new Vendor();
            vendor.setUserId(userId);
        }

        try {
            // Read form fields
            vendor.setVendorName(request.getParameter("vendor_name"));
            vendor.setOwnerName(request.getParameter("owner_name"));
            vendor.setArea(request.getParameter("area"));
            vendor.setContact(request.getParameter("contact"));
            vendor.setServiceType(request.getParameter("service_type"));
            vendor.setPriceRange(request.getParameter("price_range"));
            vendor.setDocumentType(request.getParameter("document_type"));
            vendor.setApprovalStatus("pending"); // Reset to pending on resubmission
            vendor.setStatus("active");

            // Handle file upload
            Part document = request.getPart("document");
            if (document != null && document.getSize() > 0) {
                String validationError = validateDocument(document);
                if (validationError != null) {
                    redirect(response, request, validationError, true);
                    return;
                }

                String extension = getExtension(document.getSubmittedFileName());
                String fileName = "vendor_" + userId + "_" + System.currentTimeMillis() + "." + extension;
                File uploadDir = new File(getServletContext().getRealPath("/uploads/vendor-documents"));
                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    redirect(response, request, "Unable to prepare upload folder.", true);
                    return;
                }

                document.write(new File(uploadDir, fileName).getAbsolutePath());
                vendor.setDocumentPath("uploads/vendor-documents/" + fileName);
            } else if (isNew) {
                redirect(response, request, "Please choose a document to upload.", true);
                return;
            }

            boolean saved = vendorDAO.saveVendor(vendor);
            redirect(response, request, saved ? "Verification profile submitted for approval." : "Unable to save verification profile.", !saved);
        } catch (IllegalStateException e) {
            e.printStackTrace();
            redirect(response, request, "File is too large. Please upload a file up to 2MB.", true);
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            redirect(response, request, "Unable to process verification request. Please try again.", true);
        }
    }

    private String validateDocument(Part document) {
        if (document == null || document.getSize() <= 0 || document.getSubmittedFileName() == null || document.getSubmittedFileName().trim().isEmpty()) {
            return "Please choose a document to upload.";
        }
        if (document.getSize() > MAX_FILE_SIZE) {
            return "File is too large. Please upload a file up to 2MB.";
        }

        String extension = getExtension(document.getSubmittedFileName());
        String contentType = document.getContentType() == null ? "" : document.getContentType().toLowerCase(Locale.ROOT);
        boolean allowedExtension = "jpg".equals(extension) || "jpeg".equals(extension) || "png".equals(extension) || "pdf".equals(extension);
        boolean allowedContentType = "image/jpeg".equals(contentType) || "image/png".equals(contentType) || "application/pdf".equals(contentType);

        return allowedExtension && allowedContentType ? null : "Only JPG, PNG, and PDF documents are allowed.";
    }

    private String getExtension(String fileName) {
        if (fileName == null) {
            return "";
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String message, boolean error) throws IOException {
        String key = error ? "error" : "success";
        response.sendRedirect(request.getContextPath() + "/vendor?action=availability&" + key + "=" + URLEncoder.encode(message, "UTF-8"));
    }
}
