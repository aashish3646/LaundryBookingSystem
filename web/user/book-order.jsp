<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vendor" %>
<html>
<head>
    <title>Book Laundry - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <h1>Book Your Laundry</h1>
        <a href="dashboard.jsp">Back to Dashboard</a>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/bookings?action=book" method="post">
                <label>Select Vendor:</label><br>
                <select name="vendorId" id="vendorSelect" required onchange="fetchSlots()">
                    <option value="">-- Choose a Vendor --</option>
                    <%
                        List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
                        if (vendors != null) {
                            for (Vendor v : vendors) {
                    %>
                        <option value="<%= v.getVendorId() %>"><%= v.getVendorName() %> (<%= v.getArea() %>)</option>
                    <%
                            }
                        }
                    %>
                </select><br><br>

                <label>Select Time Slot:</label><br>
                <select name="slotId" id="slotSelect" required>
                    <option value="">-- First select a vendor --</option>
                </select><br><br>

                <label>Pickup Address:</label><br>
                <textarea name="address" required placeholder="Enter full address"></textarea><br><br>

                <label>Type of Clothes:</label><br>
                <input type="text" name="clothesType" required placeholder="e.g. Cotton, Woolen, Mix"><br><br>

                <label>Approx Quantity (kg):</label><br>
                <input type="number" name="quantity" required min="1"><br><br>

                <label>Additional Note:</label><br>
                <textarea name="note" placeholder="Any special instructions..."></textarea><br><br>

                <button type="submit" class="btn">Confirm Booking</button>
            </form>
        </div>
    </div>

    <script>
        function fetchSlots() {
            const vendorId = document.getElementById('vendorSelect').value;
            const slotSelect = document.getElementById('slotSelect');
            
            if (!vendorId) {
                slotSelect.innerHTML = '<option value="">-- First select a vendor --</option>';
                return;
            }

            fetch('${pageContext.request.contextPath}/get-slots?vendorId=' + vendorId)
                .then(response => response.json())
                .then(data => {
                    slotSelect.innerHTML = '<option value="">-- Choose a Slot --</option>';
                    data.forEach(slot => {
                        const option = document.createElement('option');
                        option.value = slot.slotId;
                        option.textContent = slot.slotDate + ' | ' + slot.slotTime;
                        slotSelect.appendChild(option);
                    });
                });
        }
    </script>
</body>
</html>
