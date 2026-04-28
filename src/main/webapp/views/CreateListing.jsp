<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> errorMessages = (List<String>) request.getAttribute("errorMessages");
    User currentUser = (User) request.getAttribute("currentUser");

    String titleValue = request.getAttribute("titleValue") != null ? (String) request.getAttribute("titleValue") : "";
    String descriptionValue = request.getAttribute("descriptionValue") != null ? (String) request.getAttribute("descriptionValue") : "";
    String categoryIdValue = request.getAttribute("categoryIdValue") != null ? (String) request.getAttribute("categoryIdValue") : "";
    String priceValue = request.getAttribute("priceValue") != null ? (String) request.getAttribute("priceValue") : "";
    String pricingUnitValue = request.getAttribute("pricingUnitValue") != null ? (String) request.getAttribute("pricingUnitValue") : "";
    String contactMethodValue = request.getAttribute("contactMethodValue") != null ? (String) request.getAttribute("contactMethodValue") : "";
    String contactInfoValue = request.getAttribute("contactInfoValue") != null
            ? (String) request.getAttribute("contactInfoValue")
            : (currentUser != null && currentUser.getEmail() != null ? currentUser.getEmail() : "");
    String fulfillmentMethodValue = request.getAttribute("fulfillmentMethodValue") != null ? (String) request.getAttribute("fulfillmentMethodValue") : "";
    String imageLinksValue = request.getAttribute("imageLinksValue") != null ? (String) request.getAttribute("imageLinksValue") : "";
    String listingIdValue = request.getAttribute("listingIdValue") != null ? (String) request.getAttribute("listingIdValue") : "";
    String[] selectedPaymentMethods = request.getAttribute("selectedPaymentMethods") != null
            ? (String[]) request.getAttribute("selectedPaymentMethods")
            : new String[0];
    Boolean editModeAttr = (Boolean) request.getAttribute("editMode");
    boolean editMode = editModeAttr != null && editModeAttr.booleanValue();

    String defaultPhone = currentUser != null && currentUser.getPhoneNumber() != null ? currentUser.getPhoneNumber() : "";
    String defaultEmail = currentUser != null && currentUser.getEmail() != null ? currentUser.getEmail() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editMode ? "Edit Listing" : "Create a Listing" %> - Lendr</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/create-listing.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <a class="logo" href="<%= contextPath %>/views/JDBCDemo.jsp">Lendr</a>
        <div class="nav-links">
            <a href="<%= contextPath %>/BrowseServlet">Browse</a>
            <a href="<%= contextPath %>/SettingsServlet">Settings</a>
        </div>
    </nav>

    <main class="listing-shell">
        <section class="listing-intro">
            <span class="eyebrow">Lister View</span>
            <h1><%= editMode ? "Update your listing" : "Create a listing that is ready to rent" %></h1>
            <p><%= editMode
                    ? "Adjust the item details, pricing, payment methods, contact info, and image links. Save when your changes are ready to go live."
                    : "Add the item details, your rate, accepted payment methods, contact info, and image links. Once the required fields are filled, the publish button appears and the listing can go live." %></p>
        </section>

        <section class="listing-card">
            <% if (errorMessages != null && !errorMessages.isEmpty()) { %>
                <div class="alert alert-error">
                    <% for (String errorMessage : errorMessages) { %>
                        <p><%= errorMessage %></p>
                    <% } %>
                </div>
            <% } %>

            <form id="create-listing-form" action="<%= contextPath %>/<%= editMode ? "EditListingServlet" : "CreateListingServlet" %>" method="post">
                <% if (editMode) { %>
                    <input type="hidden" name="listingId" value="<%= listingIdValue %>">
                <% } %>
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label for="title">Listing Title</label>
                        <input type="text" id="title" name="title" value="<%= titleValue %>" placeholder="Cordless drill, DSLR camera, kayak..." required>
                    </div>

                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">Choose a category</option>
                            <% if (categories != null) {
                                   for (Category category : categories) { %>
                                <option value="<%= category.getCategoryId() %>" <%= String.valueOf(category.getCategoryId()).equals(categoryIdValue) ? "selected" : "" %>>
                                    <%= category.getCategoryName() %>
                                </option>
                            <%   }
                               } %>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="5" placeholder="Describe the item, what is included, and anything renters should know." required><%= descriptionValue %></textarea>
                </div>

                <div class="form-grid three-col">
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="number" id="price" name="price" min="1" step="0.01" value="<%= priceValue %>" placeholder="25.00" required>
                    </div>

                    <div class="form-group">
                        <label for="pricingUnit">Rate Type</label>
                        <select id="pricingUnit" name="pricingUnit" required>
                            <option value="">Choose one</option>
                            <option value="day" <%= "day".equals(pricingUnitValue) ? "selected" : "" %>>Per day</option>
                            <option value="hour" <%= "hour".equals(pricingUnitValue) ? "selected" : "" %>>Per hour</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="fulfillmentMethod">Pickup / Drop-off</label>
                        <select id="fulfillmentMethod" name="fulfillmentMethod" required>
                            <option value="">Choose one</option>
                            <option value="pickup" <%= "pickup".equals(fulfillmentMethodValue) ? "selected" : "" %>>Pickup only</option>
                            <option value="drop-off" <%= "drop-off".equals(fulfillmentMethodValue) ? "selected" : "" %>>Drop-off only</option>
                            <option value="either" <%= "either".equals(fulfillmentMethodValue) ? "selected" : "" %>>Either</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Accepted Payment Methods</label>
                    <div class="checkbox-grid">
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="credit card" <%= contains(selectedPaymentMethods, "credit card") ? "checked" : "" %>> Credit Card</label>
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="debit card" <%= contains(selectedPaymentMethods, "debit card") ? "checked" : "" %>> Debit Card</label>
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="paypal" <%= contains(selectedPaymentMethods, "paypal") ? "checked" : "" %>> PayPal</label>
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="apple pay" <%= contains(selectedPaymentMethods, "apple pay") ? "checked" : "" %>> Apple Pay</label>
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="cash" <%= contains(selectedPaymentMethods, "cash") ? "checked" : "" %>> Cash</label>
                        <label class="checkbox-pill"><input type="checkbox" name="paymentMethods" value="zelle" <%= contains(selectedPaymentMethods, "zelle") ? "checked" : "" %>> Zelle</label>
                    </div>
                </div>

                <div class="form-grid two-col">
                    <div class="form-group">
                        <label for="contactMethod">Preferred Contact Method</label>
                        <select id="contactMethod" name="contactMethod" required data-default-email="<%= defaultEmail %>" data-default-phone="<%= defaultPhone %>">
                            <option value="">Choose one</option>
                            <option value="email" <%= "email".equals(contactMethodValue) ? "selected" : "" %>>Email</option>
                            <option value="phone" <%= "phone".equals(contactMethodValue) ? "selected" : "" %>>Phone</option>
                            <option value="text" <%= "text".equals(contactMethodValue) ? "selected" : "" %>>Text</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="contactInfo">Contact Info</label>
                        <input type="text" id="contactInfo" name="contactInfo" value="<%= contactInfoValue %>" placeholder="email@example.com or 555-555-5555" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="image-link-input">Image Links</label>
                    <div id="drop-zone" class="drop-zone">
                        <p>Drag in image links, paste them, or add them manually.</p>
                        <p class="drop-subtext">Each link should start with `http://` or `https://`.</p>
                    </div>

                    <div class="image-input-row">
                        <input type="url" id="image-link-input" placeholder="https://example.com/your-image.jpg">
                        <button type="button" id="add-image-btn" class="ghost-btn">Add Image Link</button>
                    </div>

                    <div id="image-link-list" class="image-link-list"></div>
                    <textarea id="imageLinks" name="imageLinks" class="hidden-textarea"><%= imageLinksValue %></textarea>
                </div>

                <div class="form-footer">
                    <p class="helper-text"><%= editMode
                            ? "Save changes to update this listing immediately."
                            : "Your listing will be added to the marketplace immediately after submission." %></p>
                    <button type="submit" id="submit-btn" class="primary-btn hidden-action"><%= editMode ? "Save Changes" : "Create Listing" %></button>
                </div>
            </form>
        </section>
    </main>

    <script>
        (function () {
            const form = document.getElementById('create-listing-form');
            const submitBtn = document.getElementById('submit-btn');
            const imageInput = document.getElementById('image-link-input');
            const imageLinksField = document.getElementById('imageLinks');
            const imageLinkList = document.getElementById('image-link-list');
            const addImageBtn = document.getElementById('add-image-btn');
            const dropZone = document.getElementById('drop-zone');
            const contactMethod = document.getElementById('contactMethod');
            const contactInfo = document.getElementById('contactInfo');

            let imageLinks = imageLinksField.value
                ? imageLinksField.value.split(/\r?\n/).map((link) => link.trim()).filter(Boolean)
                : [];

            function syncImageField() {
                imageLinksField.value = imageLinks.join('\n');
            }

            function renderImageLinks() {
                imageLinkList.innerHTML = '';

                if (!imageLinks.length) {
                    imageLinkList.innerHTML = '<p class="empty-links">No image links added yet.</p>';
                    return;
                }

                imageLinks.forEach((link, index) => {
                    const item = document.createElement('div');
                    item.className = 'image-link-pill';
                    item.innerHTML = '<span>' + link + '</span><button type="button" data-index="' + index + '">Remove</button>';
                    imageLinkList.appendChild(item);
                });
            }

            function isValidUrl(value) {
                return value.startsWith('http://') || value.startsWith('https://');
            }

            function addImageLink(link) {
                const normalizedLink = link.trim();
                if (!normalizedLink || !isValidUrl(normalizedLink) || imageLinks.includes(normalizedLink)) {
                    return;
                }

                imageLinks.push(normalizedLink);
                syncImageField();
                renderImageLinks();
                updateSubmitState();
            }

            function updateSubmitState() {
                const requiredFields = [
                    document.getElementById('title').value.trim(),
                    document.getElementById('description').value.trim(),
                    document.getElementById('categoryId').value.trim(),
                    document.getElementById('price').value.trim(),
                    document.getElementById('pricingUnit').value.trim(),
                    document.getElementById('contactMethod').value.trim(),
                    document.getElementById('contactInfo').value.trim(),
                    document.getElementById('fulfillmentMethod').value.trim()
                ];

                const hasPaymentMethod = form.querySelectorAll('input[name="paymentMethods"]:checked').length > 0;
                const isReady = requiredFields.every(Boolean) && hasPaymentMethod && imageLinks.length > 0;

                submitBtn.disabled = !isReady;
                submitBtn.classList.toggle('hidden-action', !isReady);
            }

            addImageBtn.addEventListener('click', function () {
                addImageLink(imageInput.value);
                imageInput.value = '';
            });

            imageInput.addEventListener('keydown', function (event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    addImageLink(imageInput.value);
                    imageInput.value = '';
                }
            });

            imageLinkList.addEventListener('click', function (event) {
                if (event.target.tagName === 'BUTTON') {
                    const index = Number(event.target.getAttribute('data-index'));
                    imageLinks.splice(index, 1);
                    syncImageField();
                    renderImageLinks();
                    updateSubmitState();
                }
            });

            dropZone.addEventListener('dragover', function (event) {
                event.preventDefault();
                dropZone.classList.add('dragging');
            });

            dropZone.addEventListener('dragleave', function () {
                dropZone.classList.remove('dragging');
            });

            dropZone.addEventListener('drop', function (event) {
                event.preventDefault();
                dropZone.classList.remove('dragging');
                const droppedText = event.dataTransfer.getData('text/uri-list') || event.dataTransfer.getData('text/plain');
                if (droppedText) {
                    droppedText.split(/\r?\n/).forEach(addImageLink);
                }
            });

            dropZone.addEventListener('paste', function (event) {
                const pastedText = (event.clipboardData || window.clipboardData).getData('text');
                if (pastedText) {
                    pastedText.split(/\r?\n/).forEach(addImageLink);
                    event.preventDefault();
                }
            });

            contactMethod.addEventListener('change', function () {
                if (contactInfo.value.trim()) {
                    updateSubmitState();
                    return;
                }

                if (this.value === 'email') {
                    contactInfo.value = this.dataset.defaultEmail || '';
                } else if (this.value === 'phone' || this.value === 'text') {
                    contactInfo.value = this.dataset.defaultPhone || '';
                }

                updateSubmitState();
            });

            form.addEventListener('input', updateSubmitState);
            form.addEventListener('change', updateSubmitState);

            syncImageField();
            renderImageLinks();
            updateSubmitState();
        })();
    </script>
</body>
</html>

<%! 
    private boolean contains(String[] values, String expected) {
        if (values == null) {
            return false;
        }
        for (String value : values) {
            if (expected.equals(value)) {
                return true;
            }
        }
        return false;
    }
%>
