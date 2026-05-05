<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    Booking booking = (Booking) request.getAttribute("booking");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Receipt | QuickWash</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; padding: 40px; }
        .receipt-container { 
            max-width: 700px; margin: auto; background: white; padding: 40px; 
            border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
            border-top: 10px solid #0056b3; 
        }
        .receipt-header { display: flex; justify-content: space-between; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 30px; }
        .brand { font-size: 24px; font-weight: bold; color: #0056b3; }
        .invoice-label { text-align: right; }
        .invoice-label h1 { margin: 0; font-size: 28px; color: #333; }
        .details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; }
        .detail-box h3 { font-size: 14px; text-transform: uppercase; color: #777; margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 5px; }
        .detail-box p { margin: 5px 0; font-size: 16px; color: #333; font-weight: 500; }
        .item-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .item-table th { text-align: left; background: #f8f9fa; padding: 12px; border-bottom: 2px solid #eee; }
        .item-table td { padding: 12px; border-bottom: 1px solid #eee; }
        .total-section { text-align: right; }
        .total-section .total-row { display: flex; justify-content: flex-end; gap: 20px; margin-bottom: 10px; }
        .total-section .grand-total { font-size: 22px; font-weight: bold; color: #0056b3; }
        .footer { margin-top: 50px; text-align: center; color: #999; font-size: 14px; border-top: 1px solid #eee; padding-top: 20px; }
        .btn-print { 
            display: block; width: 100%; text-align: center; padding: 12px; background: #0056b3; color: white; 
            text-decoration: none; border-radius: 6px; font-weight: bold; margin-top: 20px;
        }
        @media print {
            body { background: white; padding: 0; }
            .receipt-container { box-shadow: none; border: 1px solid #eee; }
            .btn-print { display: none; }
        }
    </style>
</head>
<body>

<div class="receipt-container">
    <header class="receipt-header">
        <div class="brand">QuickWash</div>
        <div class="invoice-label">
            <h1>INVOICE</h1>
            <p>#QW-<%= booking.getBookingId() %></p>
        </div>
    </header>

    <div class="details-grid">
        <div class="detail-box">
            <h3>Billed To</h3>
            <p><%= booking.getCustomerName() %></p>
            <p><%= booking.getPickupAddress() %></p>
        </div>
        <div class="detail-box">
            <h3>Service Provider</h3>
            <p><%= booking.getVendorName() %></p>
            <p>Booking Date: <%= booking.getCreatedAt() %></p>
        </div>
    </div>

    <table class="item-table">
        <thead>
            <tr>
                <th>Description</th>
                <th>Quantity</th>
                <th>Status</th>
                <th style="text-align: right;">Total</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <strong><%= booking.getServiceName() %></strong><br>
                    <small>Type: <%= booking.getClothesType() %></small>
                </td>
                <td><%= booking.getQuantity() %> units</td>
                <td><%= booking.getBookingStatus() %></td>
                <td style="text-align: right;">Rs. <%= String.format("%.2f", booking.getServicePrice()) %></td>
            </tr>
        </tbody>
    </table>

    <div class="total-section">
        <div class="total-row">
            <span>Subtotal:</span>
            <span>Rs. <%= String.format("%.2f", booking.getServicePrice()) %></span>
        </div>
        <div class="total-row grand-total">
            <span>Amount Due:</span>
            <span>Rs. <%= String.format("%.2f", booking.getServicePrice()) %></span>
        </div>
    </div>

    <div class="footer">
        <p>Thank you for choosing QuickWash Laundry Services!</p>
        <p>Pickup Slot: <%= booking.getSlotDate() %> | <%= booking.getSlotTime() %></p>
    </div>

    <a href="javascript:window.print()" class="btn-print">Print Receipt</a>
    <p style="text-align: center; margin-top: 10px;">
        <a href="<%= contextPath %>/bookings?action=my-orders" style="color: #666; text-decoration: none;">&larr; Back to Orders</a>
    </p>
</div>

</body>
</html>
