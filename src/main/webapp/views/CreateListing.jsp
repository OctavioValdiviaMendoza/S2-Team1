<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="model.User" %>
<%@ page import="model.Address" %>
<%
    String contextPath = request.getContextPath();
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> errorMessages = (List<String>) request.getAttribute("errorMessages");
    User currentUser = (User) request.getAttribute("currentUser");
    List<Address> userAddresses = (List<Address>) request.getAttribute("userAddresses");

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

    String addressChoiceValue = request.getAttribute("addressChoiceValue") != null
            ? (String) request.getAttribute("addressChoiceValue")
            : "existing";
    String addressIdValue = request.getAttribute("addressIdValue") != null ? (String) request.getAttribute("addressIdValue") : "";

    String newLine1Value = request.getAttribute("newLine1Value") != null ? (String) request.getAttribute("newLine1Value") : "";
    String newLine2Value = request.getAttribute("newLine2Value") != null ? (String) request.getAttribute("newLine2Value") : "";
    String newCityValue = request.getAttribute("newCityValue") != null ? (String) request.getAttribute("newCityValue") : "";
    String newStateValue = request.getAttribute("newStateValue") != null ? (String) request.getAttribute("newStateValue") : "";
    String newZipValue = request.getAttribute("newZipValue") != null ? (String) request.getAttribute("newZipValue") : "";
    String newAddressTypeValue = request.getAttribute("newAddressTypeValue") != null ? (String) request.getAttribute("newAddressTypeValue") : "pickup";
    String newIsDefaultValue = request.getAttribute("newIsDefaultValue") != null ? (String) request.getAttribute("newIsDefaultValue") : "";
    String newLatitudeValue = request.getAttribute("newLatitudeValue") != null ? (String) request.getAttribute("newLatitudeValue") : "";
    String newLongitudeValue = request.getAttribute("newLongitudeValue") != null ? (String) request.getAttribute("newLongitudeValue") : "";
    String newPlaceIdValue = request.getAttribute("newPlaceIdValue") != null ? (String) request.getAttribute("newPlaceIdValue") : "";

    String[] selectedPaymentMethods = request.getAttribute("selectedPaymentMethods") != null
            ? (String[]) request.getAttribute("selectedPaymentMethods")
            : new String[0];

    String defaultPhone = currentUser != null && currentUser.getPhoneNumber() != null ? currentUser.getPhoneNumber() : "";
    String defaultEmail = currentUser != null && currentUser.getEmail() != null ? currentUser.getEmail() : "";
    String googleMapsApiKey = (String) request.getAttribute("googleMapsApiKey");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create a Listing - Lendr</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/create-listing.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .hidden-section { display: none; }
        .address-choice-row { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 12px; }
        .address-block { margin-top: 10px; }
        .address-help { font-size: 0.9rem; opacity: 0.8; margin-top: 6px; }
    </style>
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
            <h1>Create a listing that is ready to rent</h1>
            <p>Add the item details, your rate, payment methods, contact info, photos, and pickup address.</p>
        </section>

        <section class="listing-card">
            <% if (errorMessages != null && !errorMessages.isEmpty()) { %>
                <div class="alert alert-error">
                    <% for (String errorMessage : errorMessages) { %>
                        <p><%= errorMessage %></p>
                    <% } %>
                </div>
            <% } %>

            <form id="create-listing-form" action="<%= contextPath %>/CreateListingServlet" method="post">
                <div class="form-grid two-col">
                    <div class="form-group">
                        <label for="title">Listing Title</label>
                        <input type="text" id="title" name="title" value="<%= titleValue %>" required>
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
                    <textarea id="description" name="description" rows="5" required><%= descriptionValue %></textarea>
                </div>

                <div class="form-grid three-col">
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="number" id="price" name="price" min="1" step="0.01" value="<%= priceValue %>" required>
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
                            <!-- <option value="drop-off" < //"drop-off".equals(fulfillmentMethodValue) ? "selected" : "" %>>Drop-off only</option>-->
                            <!-- <option value="either" < //"either".equals(fulfillmentMethodValue) ? "selected" : "" %>>Either</option> -->
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Pickup Address</label>

                    <div class="address-choice-row">
                        <label>
                            <input type="radio" name="addressChoice" value="existing"
                                   <%= !"new".equals(addressChoiceValue) ? "checked" : "" %>>
                            Use an existing address
                        </label>
                        <label>
                            <input type="radio" name="addressChoice" value="new"
                                   <%= "new".equals(addressChoiceValue) ? "checked" : "" %>>
                            Add a new address
                        </label>
                    </div>

                    <div id="existing-address-block" class="address-block">
                        <label for="addressId">Existing Address</label>
                        <select name="addressId" id="addressId">
                            <option value="">-- Select a pickup address --</option>
                            <% if (userAddresses != null) {
                                   for (Address address : userAddresses) { %>
                                <option value="<%= address.getAddressId() %>"
                                    <%= String.valueOf(address.getAddressId()).equals(addressIdValue) ? "selected" : "" %>>
                                    <%= address.getLine1() %>
                                    <%= (address.getLine2() != null && !address.getLine2().trim().isEmpty()) ? ", " + address.getLine2() : "" %>,
                                    <%= address.getCity() %>, <%= address.getState() %> <%= address.getZip() %>
                                </option>
                            <%   }
                               } %>
                        </select>
                    </div>

                    <div id="new-address-block" class="address-block hidden-section">
                        <p class="address-help">Start typing an address and pick a Google suggestion to auto-fill location details.</p>

                        <div class="form-grid two-col">
                            <div class="form-group">
                                <label for="newLine1">Address Line 1</label>
                                <input type="text" id="newLine1" name="newLine1" value="<%= newLine1Value %>" autocomplete="street-address">
                            </div>

                            <div class="form-group">
                                <label for="newLine2">Address Line 2</label>
                                <input type="text" id="newLine2" name="newLine2" value="<%= newLine2Value %>" autocomplete="address-line2">
                            </div>
                        </div>

                        <div class="form-grid three-col">
                            <div class="form-group">
                                <label for="newCity">City</label>
                                <input type="text" id="newCity" name="newCity" value="<%= newCityValue %>" autocomplete="address-level2">
                            </div>

                            <div class="form-group">
                                <label for="newState">State</label>
                                <input type="text" id="newState" name="newState" maxlength="2" value="<%= newStateValue %>" autocomplete="address-level1">
                            </div>

                            <div class="form-group">
                                <label for="newZip">ZIP</label>
                                <input type="text" id="newZip" name="newZip" value="<%= newZipValue %>" autocomplete="postal-code">
                            </div>
                        </div>

                        <input type="hidden" name="newLatitude" id="newLatitude" value="<%= newLatitudeValue %>">
                        <input type="hidden" name="newLongitude" id="newLongitude" value="<%= newLongitudeValue %>">
                        <input type="hidden" name="newPlaceId" id="newPlaceId" value="<%= newPlaceIdValue %>">

                        <div class="form-grid two-col">
                            <div class="form-group">
                                <label for="newAddressType">Address Type</label>
                                <select id="newAddressType" name="newAddressType">
                                    <option value="pickup" <%= "pickup".equals(newAddressTypeValue) ? "selected" : "" %>>Pickup</option>
                                    <option value="home" <%= "home".equals(newAddressTypeValue) ? "selected" : "" %>>Home</option>
                                    <option value="billing" <%= "billing".equals(newAddressTypeValue) ? "selected" : "" %>>Billing</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="newIsDefault" value="true"
                                        <%= "true".equalsIgnoreCase(newIsDefaultValue) || "on".equalsIgnoreCase(newIsDefaultValue) ? "checked" : "" %>>
                                    Set as default address
                                </label>
                            </div>
                        </div>
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
                        <input type="text" id="contactInfo" name="contactInfo" value="<%= contactInfoValue %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="image-link-input">Image Links</label>
                    <div id="drop-zone" class="drop-zone">
                        <p>Drag in image links, paste them, or add them manually.</p>
                        <p class="drop-subtext">Each link should start with http:// or https://.</p>
                    </div>

                    <div class="image-input-row">
                        <input type="url" id="image-link-input" placeholder="https://example.com/your-image.jpg">
                        <button type="button" id="add-image-btn" class="ghost-btn">Add Image Link</button>
                    </div>

                    <div id="image-link-list" class="image-link-list"></div>
                    <textarea id="imageLinks" name="imageLinks" class="hidden-textarea"><%= imageLinksValue %></textarea>
                </div>

                <div class="form-footer">
                    <p class="helper-text">Your listing will be added to the marketplace immediately after submission.</p>
					<button type="submit" id="submit-btn" class="primary-btn">Create Listing</button>                </div>
            </form>
        </section>
    </main>

    <script>
        let lendrAutocomplete = null;

        function initLendrAddressAutocomplete() {
            const addressInput = document.getElementById('newLine1');
            if (!addressInput || !window.google || !google.maps || !google.maps.places) {
                return;
            }

            lendrAutocomplete = new google.maps.places.Autocomplete(addressInput, {
                types: ['address'],
                componentRestrictions: { country: 'us' },
                fields: ['address_components', 'geometry', 'place_id']
            });

            lendrAutocomplete.addListener('place_changed', function () {
                const place = lendrAutocomplete.getPlace();
                if (!place) {
                    return;
                }

                let streetNumber = '';
                let route = '';
                let city = '';
                let state = '';
                let zip = '';

                if (place.address_components) {
                    place.address_components.forEach(function (component) {
                        const types = component.types || [];

                        if (types.indexOf('street_number') !== -1) {
                            streetNumber = component.long_name;
                        }
                        if (types.indexOf('route') !== -1) {
                            route = component.long_name;
                        }
                        if (types.indexOf('locality') !== -1) {
                            city = component.long_name;
                        }
                        if (types.indexOf('administrative_area_level_1') !== -1) {
                            state = component.short_name;
                        }
                        if (types.indexOf('postal_code') !== -1) {
                            zip = component.long_name;
                        }
                    });
                }

                document.getElementById('newLine1').value = (streetNumber + ' ' + route).trim();
                document.getElementById('newCity').value = city;
                document.getElementById('newState').value = state;
                document.getElementById('newZip').value = zip;
                document.getElementById('newPlaceId').value = place.place_id || '';

                if (place.geometry && place.geometry.location) {
                    document.getElementById('newLatitude').value = place.geometry.location.lat();
                    document.getElementById('newLongitude').value = place.geometry.location.lng();
                }

                const form = document.getElementById('create-listing-form');
                if (form) {
                    form.dispatchEvent(new Event('input', { bubbles: true }));
                    form.dispatchEvent(new Event('change', { bubbles: true }));
                }
            });
        }

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

            const addressChoiceInputs = document.querySelectorAll('input[name="addressChoice"]');
            const existingAddressBlock = document.getElementById('existing-address-block');
            const newAddressBlock = document.getElementById('new-address-block');
            const addressId = document.getElementById('addressId');

            const newLine1 = document.getElementById('newLine1');
            const newCity = document.getElementById('newCity');
            const newState = document.getElementById('newState');
            const newZip = document.getElementById('newZip');
            const newLatitude = document.getElementById('newLatitude');
            const newLongitude = document.getElementById('newLongitude');
            const newPlaceId = document.getElementById('newPlaceId');

            let imageLinks = imageLinksField.value
                ? imageLinksField.value.split(/\r?\n/).map(function (link) { return link.trim(); }).filter(Boolean)
                : [];

            function usingNewAddress() {
                const checked = document.querySelector('input[name="addressChoice"]:checked');
                return checked && checked.value === 'new';
            }

            function toggleAddressBlocks() {
                const showNew = usingNewAddress();
                existingAddressBlock.classList.toggle('hidden-section', showNew);
                newAddressBlock.classList.toggle('hidden-section', !showNew);
                updateSubmitState();
            }

            function syncImageField() {
                imageLinksField.value = imageLinks.join('\n');
            }

            function renderImageLinks() {
                imageLinkList.innerHTML = '';

                if (!imageLinks.length) {
                    imageLinkList.innerHTML = '<p class="empty-links">No image links added yet.</p>';
                    return;
                }

                imageLinks.forEach(function (link, index) {
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
                if (!normalizedLink || !isValidUrl(normalizedLink) || imageLinks.indexOf(normalizedLink) !== -1) {
                    return;
                }

                imageLinks.push(normalizedLink);
                syncImageField();
                renderImageLinks();
                updateSubmitState();
            }

            function clearGeoFieldsIfManualAddressChanges() {
                if (!usingNewAddress()) {
                    return;
                }

                newLatitude.value = '';
                newLongitude.value = '';
                newPlaceId.value = '';
            }

            function addressReady() {
                if (!usingNewAddress()) {
                    return addressId.value.trim().length > 0;
                }

                const requiredNewAddressFields = [
                    newLine1.value.trim(),
                    newCity.value.trim(),
                    newState.value.trim(),
                    newZip.value.trim()
                ];

                return requiredNewAddressFields.every(Boolean);
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
                const isReady = requiredFields.every(Boolean) && hasPaymentMethod && imageLinks.length > 0 && addressReady();

                submitBtn.disabled = !isReady;
                //submitBtn.classList.toggle('hidden-action', !isReady);
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

            addressChoiceInputs.forEach(function (input) {
                input.addEventListener('change', toggleAddressBlocks);
            });

            [newLine1, newCity, newState, newZip].forEach(function (field) {
                field.addEventListener('input', function () {
                    clearGeoFieldsIfManualAddressChanges();
                    updateSubmitState();
                });
            });

            form.addEventListener('input', updateSubmitState);
            form.addEventListener('change', updateSubmitState);

            syncImageField();
            renderImageLinks();
            toggleAddressBlocks();
            updateSubmitState();
        })();
    </script>

    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=<%= googleMapsApiKey %>&libraries=places&callback=initLendrAddressAutocomplete">
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