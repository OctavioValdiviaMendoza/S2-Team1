<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Listing" %>
<%
    String contextPath = request.getContextPath();

    Listing listing = (Listing) request.getAttribute("listing");

    if (listing == null) {
        response.sendRedirect(contextPath + "/BrowseServlet");
        return;
    }

    int listingId = listing.getListingId();
    String listingTitle = listing.getTitle() != null ? listing.getTitle() : "Untitled Listing";
    String categoryName = listing.getCategoryName() != null ? listing.getCategoryName() : "Uncategorized";
    String location = listing.getLocation() != null ? listing.getLocation() : "Location not available";
    String bookingStatus = listing.isAvailability() ? "Available" : "Unavailable";
    double dailyRate = listing.getPrice();

    String startDate = request.getParameter("startDate") != null ? request.getParameter("startDate") : "";
    String endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : "";
    String paymentMethodValue = request.getParameter("paymentMethod") != null ? request.getParameter("paymentMethod") : "";
    String emailValue = request.getParameter("email") != null ? request.getParameter("email") : "";

    String imageUrl = listing.getImageUrl();
    String imageSrc = (imageUrl != null && !imageUrl.trim().isEmpty())
            ? contextPath + "/images/" + imageUrl
            : "https://via.placeholder.com/640x420?text=Listing+Image";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - <%= listingTitle %></title>
    <link rel="stylesheet" href="<%= contextPath %>/css/checkout.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

    <nav class="navbar">
        <a class="logo" href="<%= contextPath %>/BrowseServlet">Lendr</a>
        <div class="nav-links">
            <a href="<%= contextPath %>/BrowseServlet">Browse</a>
            <a href="<%= contextPath %>/SettingsServlet">Settings</a>
        </div>
    </nav>

    <main class="checkout-shell">
        <header class="checkout-header">
            <h1>Secure Checkout</h1>
            <p>Complete your rental request for this listing.</p>
        </header>

        <div class="checkout-layout">

            <section class="checkout-card">
                <h2>Booking Details</h2>

                <form action="<%= contextPath %>/BookingServlet" method="post" id="checkoutForm">
                    <input type="hidden" name="listingId" value="<%= listingId %>">
                    <input type="hidden" id="dailyRate" value="<%= dailyRate %>">

                    <div class="section-title">
                        <h3>Rental Period</h3>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="startDate">Start Date</label>
                            <input type="date" id="startDate" name="startDate" value="<%= startDate %>" required>
                        </div>

                        <div class="form-group">
                            <label for="endDate">End Date</label>
                            <input type="date" id="endDate" name="endDate" value="<%= endDate %>" required>
                        </div>
                    </div>

                    <div class="section-title">
                        <h3>Billing Information</h3>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" placeholder="Enter first name" required>
                        </div>

                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" placeholder="Enter last name" required>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= emailValue %>" placeholder="Enter your email" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" placeholder="Enter phone number">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="addressLine1">Address Line 1</label>
                        <input type="text" id="addressLine1" name="addressLine1" placeholder="Street address" required>
                    </div>

                    <div class="form-group">
                        <label for="addressLine2">Address Line 2</label>
                        <input type="text" id="addressLine2" name="addressLine2" placeholder="Apartment, suite, etc. (optional)">
                    </div>

                    <div class="form-grid three-col">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" name="city" placeholder="City" required>
                        </div>

                        <div class="form-group">
                            <label for="state">State</label>
                            <input type="text" id="state" name="state" placeholder="State" required>
                        </div>

                        <div class="form-group">
                            <label for="zip">ZIP Code</label>
                            <input type="text" id="zip" name="zip" placeholder="ZIP" required>
                        </div>
                    </div>

                    <div class="section-title">
                        <h3>Payment Information</h3>
                    </div>

                    <div class="form-group">
                        <label for="paymentMethod">Payment Method</label>
                        <select id="paymentMethod" name="paymentMethod" required>
                            <option value="">Select payment method</option>
                            <option value="credit_card" <%= "credit_card".equals(paymentMethodValue) ? "selected" : "" %>>Credit Card</option>
                            <option value="debit_card" <%= "debit_card".equals(paymentMethodValue) ? "selected" : "" %>>Debit Card</option>
                            <option value="paypal" <%= "paypal".equals(paymentMethodValue) ? "selected" : "" %>>PayPal</option>
                            <option value="apple_pay" <%= "apple_pay".equals(paymentMethodValue) ? "selected" : "" %>>Apple Pay</option>
                        </select>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="cardName">Name on Card</label>
                            <input type="text" id="cardName" name="cardName" placeholder="Cardholder name" required>
                        </div>

                        <div class="form-group">
                            <label for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                        </div>
                    </div>

                    <div class="form-grid three-col">
                        <div class="form-group">
                            <label for="expiryMonth">Expiry Month</label>
                            <input type="text" id="expiryMonth" name="expiryMonth" placeholder="MM" required>
                        </div>

                        <div class="form-group">
                            <label for="expiryYear">Expiry Year</label>
                            <input type="text" id="expiryYear" name="expiryYear" placeholder="YYYY" required>
                        </div>

                        <div class="form-group">
                            <label for="cvv">CVV</label>
                            <input type="text" id="cvv" name="cvv" placeholder="CVV" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="notes">Additional Notes</label>
                        <textarea id="notes" name="notes" rows="4" placeholder="Any extra details for this booking"></textarea>
                    </div>

                    <div class="checkout-actions">
                        <a class="btn btn-secondary" href="<%= contextPath %>/ListingDetailServlet?listingId=<%= listingId %>">Back to Listing</a>
                        <button type="submit" class="btn btn-primary">Confirm Booking</button>
                    </div>
                </form>
            </section>

            <aside class="summary-card">
                <div class="summary-image">
                    <img src="<%= imageSrc %>" alt="<%= listingTitle %>">
                    <span class="status-badge <%= listing.isAvailability() ? "status-available" : "status-unavailable" %>">
                        <%= bookingStatus %>
                    </span>
                </div>

                <div class="summary-content">
                    <h2><%= listingTitle %></h2>
                    <span class="summary-category"><%= categoryName %></span>

                    <div class="summary-row">
                        <span>Location</span>
                        <strong><%= location %></strong>
                    </div>

                    <div class="summary-row">
                        <span>Rate</span>
                        <strong id="summaryRate">$<%= String.format("%.2f", dailyRate) %> / day</strong>
                    </div>

<!--
                    <div class="summary-row">
                        <span>Start Date</span>
                        <strong id="summaryStartDate"><%= !startDate.isEmpty() ? startDate : "Not selected" %></strong>
                    </div>

                    <div class="summary-row">
                        <span>End Date</span>
                        <strong id="summaryEndDate"><%= !endDate.isEmpty() ? endDate : "Not selected" %></strong>
                    </div>

-->

                    <div class="summary-row">
                        <span>Rental Days</span>
                        <strong id="summaryRentalDays">Not calculated</strong>
                    </div>

                    <hr>

                    <div class="summary-row total-row">
                        <span>Estimated Total</span>
                        <strong id="summaryEstimatedTotal">Select dates</strong>
                    </div>

                    <div class="security-note">
                        <h4>Booking Notes</h4>
                        <p id="bookingNoteMessage">
                            Choose valid start and end dates to see a live cost estimate before confirming.
                        </p>
                    </div>
                </div>
            </aside>

        </div>
    </main>

    <script>
        (function () {
            const startDateInput = document.getElementById("startDate");
            const endDateInput = document.getElementById("endDate");
            const dailyRateInput = document.getElementById("dailyRate");

  //          const summaryStartDate = document.getElementById("summaryStartDate");
    //        const summaryEndDate = document.getElementById("summaryEndDate");
            const summaryRentalDays = document.getElementById("summaryRentalDays");
            const summaryEstimatedTotal = document.getElementById("summaryEstimatedTotal");
            const bookingNoteMessage = document.getElementById("bookingNoteMessage");

            const dailyRate = parseFloat(dailyRateInput.value || "0");

            function formatDateForDisplay(dateString) {
                if (!dateString) {
                    return "Not selected";
                }

                const parts = dateString.split("-");
                if (parts.length !== 3) {
                    return dateString;
                }

                return parts[1] + "/" + parts[2] + "/" + parts[0];
            }

            function calculateRentalDays(startString, endString) {
                if (!startString || !endString) {
                    return null;
                }

                const start = new Date(startString + "T00:00:00");
                const end = new Date(endString + "T00:00:00");

                if (isNaN(start.getTime()) || isNaN(end.getTime())) {
                    return null;
                }

                const millisecondsPerDay = 1000 * 60 * 60 * 24;
                const diffMs = end.getTime() - start.getTime();
                const diffDays = Math.ceil(diffMs / millisecondsPerDay);

                return diffDays;
            }

            function updateSummary() {
                const startValue = startDateInput.value;
                const endValue = endDateInput.value;

             //   summaryStartDate.textContent = formatDateForDisplay(startValue);
              //  summaryEndDate.textContent = formatDateForDisplay(endValue);

                if (!startValue || !endValue) {
                    summaryRentalDays.textContent = "Not calculated";
                    summaryEstimatedTotal.textContent = "Select dates";
                    bookingNoteMessage.textContent = "Choose valid start and end dates to see a live cost estimate before confirming.";
                    return;
                }

                const rentalDays = calculateRentalDays(startValue, endValue);

                if (rentalDays === null) {
                    summaryRentalDays.textContent = "Invalid";
                    summaryEstimatedTotal.textContent = "Invalid dates";
                    bookingNoteMessage.textContent = "The selected dates could not be read.";
                    return;
                }

                if (rentalDays <= 0) {
                    summaryRentalDays.textContent = "Invalid";
                    summaryEstimatedTotal.textContent = "Invalid range";
                    bookingNoteMessage.textContent = "End date must be after start date.";
                    return;
                }

                const estimatedTotal = rentalDays * dailyRate;

                summaryRentalDays.textContent = rentalDays + (rentalDays === 1 ? " day" : " days");
                summaryEstimatedTotal.textContent = "$" + estimatedTotal.toFixed(2);
                bookingNoteMessage.textContent = "Live estimate based on " + rentalDays + (rentalDays === 1 ? " rental day." : " rental days.");
            }

            if (startDateInput) {
                startDateInput.addEventListener("change", updateSummary);
                startDateInput.addEventListener("input", updateSummary);
            }

            if (endDateInput) {
                endDateInput.addEventListener("change", updateSummary);
                endDateInput.addEventListener("input", updateSummary);
            }

            updateSummary();
        })();
    </script>

</body>
</html>