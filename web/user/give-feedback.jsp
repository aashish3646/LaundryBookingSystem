<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rate Service | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .star-rating { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 10px; font-size: 32px; }
        .star-rating input { display: none; }
        .star-rating label { color: #ccc; cursor: pointer; transition: color 0.2s; }
        .star-rating input:checked ~ label { color: #ffc107; }
        .star-rating label:hover, .star-rating label:hover ~ label { color: #ffdb70; }
    </style>
</head>
<body>
<header class="site-header">
    <nav class="navbar">
        <a class="brand" href="<%= contextPath %>/user/dashboard.jsp"><span class="brand-mark">QW</span><span>QuickWash</span></a>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <h2>Rate Your Experience</h2>
        <p class="muted">Your feedback helps vendors improve their service quality.</p>
    </section>

    <section class="card p-4" style="max-width: 600px; margin: auto;">
        <form action="<%= contextPath %>/feedback" method="post">
            <input type="hidden" name="booking_id" value="<%= request.getAttribute("bookingId") %>">
            
            <div class="form-group mb-2">
                <label>Overall Rating</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required /><label for="star5">★</label>
                    <input type="radio" id="star4" name="rating" value="4" /><label for="star4">★</label>
                    <input type="radio" id="star3" name="rating" value="3" /><label for="star3">★</label>
                    <input type="radio" id="star2" name="rating" value="2" /><label for="star2">★</label>
                    <input type="radio" id="star1" name="rating" value="1" /><label for="star1">★</label>
                </div>
            </div>

            <div class="form-group mb-2">
                <label for="comment">Your Comments</label>
                <textarea id="comment" name="comment" rows="4" placeholder="Tell us about the wash quality, timing, etc..." required></textarea>
            </div>

            <div class="form-actions mt-2">
                <button type="submit" class="btn btn-primary">Submit Feedback</button>
                <a href="<%= contextPath %>/bookings?action=my-orders" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </section>
</main>
</body>
</html>
