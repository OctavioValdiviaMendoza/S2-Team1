<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();

    /*
     * Placeholder backend wiring for future servlet integration:
     *
     * Future servlet can do things like:
     * request.setAttribute("listingId", 7);
     * request.setAttribute("listingTitle", "DSLR Camera");
     * request.setAttribute("categoryName", "Photography");
     * request.setAttribute("ownerName", "Grace Kim");
     * request.setAttribute("location", "San Jose, CA");
     * request.setAttribute("bookingStatus", "Available");
     * request.setAttribute("imageUrl", "camera1.jpg");
     * request.setAttribute("dailyRate", 30.00);
     * request.setAttribute("startDate", "2026-04-20");
     * request.setAttribute("endDate", "2026-04-22");
     * request.setAttribute("paymentMethod", "credit_card");
     */

    Object listingIdObj = request.getAttribute("listingId");
    Object listingTitleObj = request.getAttribute("listingTitle");
    Object categoryNameObj = request.getAttribute("categoryName");
    Object ownerNameObj = request.getAttribute("ownerName");
    Object locationObj = request.getAttribute("location");
    Object bookingStatusObj = request.getAttribute("bookingStatus");
    Object imageUrlObj = request.getAttribute("imageUrl");
    Object dailyRateObj = request.getAttribute("dailyRate");
    Object startDateObj = request.getAttribute("startDate");
    Object endDateObj = request.getAttribute("endDate");
    Object paymentMethodObj = request.getAttribute("paymentMethod");

    int listingId = 1;
    String listingTitle = "DSLR Camera";
    String categoryName = "Photography";
    String ownerName = "Grace Kim";
    String location = "San Jose, CA";
    String bookingStatus = "Available";
    String imageUrl = "https://via.placeholder.com/640x420?text=Listing+Image";
    double dailyRate = 30.00;
    String startDate = "";
    String endDate = "";
    String paymentMethodValue = "";

    if (listingIdObj != null) {
        try {
            listingId = Integer.parseInt(String.valueOf(listingIdObj));
        } catch (Exception e) {
            listingId = 1;
        }
    }

    if (listingTitleObj != null) {
        listingTitle = String.valueOf(listingTitleObj);
    }

    if (categoryNameObj != null) {
        categoryName = String.valueOf(categoryNameObj);
    }

    if (ownerNameObj != null) {
        ownerName = String.valueOf(ownerNameObj);
    }

    if (locationObj != null) {
        location = String.valueOf(locationObj);
    }

    if (bookingStatusObj != null) {
        bookingStatus = String.valueOf(bookingStatusObj);
    }

    if (imageUrlObj != null) {
        imageUrl = String.valueOf(imageUrlObj);
    }

    if (dailyRateObj != null) {
        try {
            dailyRate = Double.parseDouble(String.valueOf(dailyRateObj));
        } catch (Exception e) {
            dailyRate = 30.00;
        }
    }

    if (startDateObj != null) {
        startDate = String.valueOf(startDateObj);
    } else if (request.getParameter("startDate") != null) {
        startDate = request.getParameter("startDate");
    }

    if (endDateObj != null) {
        endDate = String.valueOf(endDateObj);
    } else if (request.getParameter("endDate") != null) {
        endDate = request.getParameter("endDate");
    }

    if (paymentMethodObj != null) {
        paymentMethodValue = String.valueOf(paymentMethodObj);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout - Lendr</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="../css/checkout.css" rel="stylesheet">
</head>
<body>

    <div class="navbar">
        <a href="<%= contextPath %>/views/JDBCDemo.jsp" class="logo">Lendr</a>

        <div class="nav-links">
            <a href="<%= contextPath %>/views/Browse.jsp">Browse</a>
            <a href="<%= contextPath %>/views/Login.jsp">Login</a>
            <a href="<%= contextPath %>/views/SignUp.jsp">Sign Up</a>
        </div>
    </div>

    <div class="checkout-shell">
        <div class="checkout-header">
            <h1>Booking &amp; Secure Checkout</h1>
            <p>Review your rental details, select dates, and enter billing information.</p>
        </div>

        <div class="checkout-layout">
            <section class="checkout-main">
                <div class="checkout-card">
                    <h2>Rental Details</h2>

                    <!-- Future servlet target -->
                    <form action="<%= contextPath %>/CheckoutServlet" method="post" id="checkoutForm">
                        <input type="hidden" name="listingId" value="<%= listingId %>">
                        <input type="hidden" name="dailyRate" id="dailyRate" value="<%= dailyRate %>">

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

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="pickupMethod">Pickup / Delivery</label>
                                <select id="pickupMethod" name="pickupMethod" required>
                                    <option value="">Select an option</option>
                                    <option value="pickup">Pickup</option>
                                    <option value="delivery">Delivery</option>
                                </select>
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
                        </div>

                        <div class="section-title">
                            <h3>Billing Information</h3>
                        </div>

                        <div class="form-group">
                            <label for="fullName">Cardholder Full Name</label>
                            <input type="text" id="fullName" name="fullName" placeholder="Enter full name" required>
                        </div>

                        <div class="form-group">
                            <label for="billingAddress">Billing Address</label>
                            <input type="text" id="billingAddress" name="billingAddress" placeholder="Street address" required>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="city">City</label>
                                <input type="text" id="city" name="city" placeholder="City" required>
                            </div>

                            <div class="form-group">
                                <label for="state">State</label>
                                <input type="text" id="state" name="state" placeholder="CA" maxlength="2" required>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="zipCode">ZIP Code</label>
                                <input type="text" id="zipCode" name="zipCode" placeholder="95112" required>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber">Phone Number</label>
                                <input type="text" id="phoneNumber" name="phoneNumber" placeholder="(408) 555-1234" required>
                            </div>
                        </div>

                        <div class="section-title">
                            <h3>Card Details</h3>
                        </div>

                        <div class="form-group">
                            <label for="cardNumber">Card Number</label>
                            <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                        </div>

                        <div class="form-grid three-col">
                            <div class="form-group">
                                <label for="expiryMonth">Expiry Month</label>
                                <select id="expiryMonth" name="expiryMonth" required>
                                    <option value="">MM</option>
                                    <option value="01">01</option>
                                    <option value="02">02</option>
                                    <option value="03">03</option>
                                    <option value="04">04</option>
                                    <option value="05">05</option>
                                    <option value="06">06</option>
                                    <option value="07">07</option>
                                    <option value="08">08</option>
                                    <option value="09">09</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="expiryYear">Expiry Year</label>
                                <select id="expiryYear" name="expiryYear" required>
                                    <option value="">YYYY</option>
                                    <option value="2026">2026</option>
                                    <option value="2027">2027</option>
                                    <option value="2028">2028</option>
                                    <option value="2029">2029</option>
                                    <option value="2030">2030</option>
                                    <option value="2031">2031</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="cvv">CVV</label>
                                <input type="password" id="cvv" name="cvv" placeholder="123" maxlength="4" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="specialInstructions">Special Instructions</label>
                            <textarea id="specialInstructions" name="specialInstructions" rows="4" placeholder="Any pickup, drop-off, or booking notes..."></textarea>
                        </div>

                        <div class="checkout-actions">
                            <a href="<%= contextPath %>/views/Browse.jsp" class="btn btn-secondary">Back to Browse</a>
                            <button type="submit" class="btn btn-primary">Confirm Booking</button>
                        </div>
                    </form>
                </div>
            </section>

            <aside class="checkout-sidebar">
                <div class="summary-card">
                    <div class="summary-image">
                        <img src="<%= imageUrl %>" alt="<%= listingTitle %>">
                        <span class="status-badge <%= "Available".equalsIgnoreCase(bookingStatus) ? "status-available" : "status-unavailable" %>">
                            <%= bookingStatus %>
                        </span>
                    </div>

                    <div class="summary-content">
                        <h2><%= listingTitle %></h2>
                        <p class="summary-category"><%= categoryName %></p>

                        <div class="summary-row">
                            <span>Owner</span>
                            <strong><%= ownerName %></strong>
                        </div>

                        <div class="summary-row">
                            <span>Location</span>
                            <strong><%= location %></strong>
                        </div>

                        <div class="summary-row">
                            <span>Rate</span>
                            <strong>$<%= String.format("%.2f", dailyRate) %>/day</strong>
                        </div>

                        <hr>

                        <div class="summary-row">
                            <span>Rental Days</span>
                            <strong id="rentalDays">0</strong>
                        </div>

                        <div class="summary-row">
                            <span>Subtotal</span>
                            <strong id="subtotalAmount">$0.00</strong>
                        </div>

                        <div class="summary-row">
                            <span>Service Fee</span>
                            <strong id="serviceFee">$5.00</strong>
                        </div>

                        <div class="summary-row total-row">
                            <span>Total</span>
                            <strong id="totalAmount">$5.00</strong>
                        </div>

                        <div class="security-note">
                            <h4>Secure Checkout</h4>
                            <p>Your booking form is ready. The backend servlet can be connected later through <strong>CheckoutServlet</strong>.</p>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </div>

    <script>
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const dailyRateInput = document.getElementById('dailyRate');
        const rentalDaysEl = document.getElementById('rentalDays');
        const subtotalEl = document.getElementById('subtotalAmount');
        const serviceFeeEl = document.getElementById('serviceFee');
        const totalEl = document.getElementById('totalAmount');

        function updateTotals() {
            const startValue = startDateInput.value;
            const endValue = endDateInput.value;
            const dailyRate = parseFloat(dailyRateInput.value) || 0;
            const serviceFee = 5.00;

            if (!startValue || !endValue) {
                rentalDaysEl.textContent = '0';
                subtotalEl.textContent = '$0.00';
                serviceFeeEl.textContent = '$' + serviceFee.toFixed(2);
                totalEl.textContent = '$' + serviceFee.toFixed(2);
                return;
            }

            const start = new Date(startValue);
            const end = new Date(endValue);
            const diffTime = end.getTime() - start.getTime();
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays <= 0) {
                rentalDaysEl.textContent = '0';
                subtotalEl.textContent = '$0.00';
                serviceFeeEl.textContent = '$' + serviceFee.toFixed(2);
                totalEl.textContent = '$' + serviceFee.toFixed(2);
                return;
            }

            const subtotal = diffDays * dailyRate;
            const total = subtotal + serviceFee;

            rentalDaysEl.textContent = diffDays;
            subtotalEl.textContent = '$' + subtotal.toFixed(2);
            serviceFeeEl.textContent = '$' + serviceFee.toFixed(2);
            totalEl.textContent = '$' + total.toFixed(2);
        }

        startDateInput.addEventListener('change', updateTotals);
        endDateInput.addEventListener('change', updateTotals);

        updateTotals();
    </script>

</body>
</html>