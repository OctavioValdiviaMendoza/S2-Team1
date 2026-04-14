<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings - Lendr</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/styles.css">
    <link rel="stylesheet" href="../css/settings.css">
</head>
<body>
    <div class="settings-shell">
        <div class="settings-container">
            <div class="settings-header">
                <h1>Account Settings</h1>
            </div>

            <div class="tabs">
                <button class="tab-btn active" type="button" data-tab="profile">
                    Profile Settings
                </button>
                <button class="tab-btn" type="button" data-tab="listings">
                    My Listings
                </button>
                <button class="tab-btn" type="button" data-tab="requests">
                    Rental Requests
                </button>
            </div>

            <div id="profile" class="tab-content active">
                <div class="profile-info">
                    <div class="profile-info-row">
                        <span class="profile-info-label">Name:</span>
                        <span class="profile-info-value">Alex Johnson</span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Email:</span>
                        <span class="profile-info-value">alex.johnson@example.com</span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Phone:</span>
                        <span class="profile-info-value">(555) 123-4567</span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Identity Verification:</span>
                        <span class="profile-info-value">
                            <span class="status-badge status-confirmed">Verified</span>
                        </span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Payment Method on File:</span>
                        <span class="profile-info-value">Visa ending in 4242</span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Account Created:</span>
                        <span class="profile-info-value">April 13, 2026</span>
                    </div>
                </div>

                <h3>Change Password</h3>
                <form onsubmit="return false;">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Current password">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" placeholder="New password">
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-primary">Update Password</button>
                    </div>
                </form>

                <hr style="margin: 40px 0; border: none; border-top: 1px solid #e0e0e0;">

                <h3>Delete Account</h3>
                <div class="confirmation-alert">
                    <p><strong>Warning:</strong> This action cannot be undone.</p>
                    <p>Deleting your account will permanently remove all your data from the system, including:</p>
                    <ul>
                        <li>Your profile information</li>
                        <li>All your listings</li>
                        <li>All your booking history</li>
                        <li>All your payment information</li>
                    </ul>
                    <p>Are you sure you want to proceed?</p>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-danger">Delete My Account</button>
                </div>
            </div>

            <div id="listings" class="tab-content">
                <h3>Your Listings</h3>
                <div class="empty-state">
                    <div class="empty-state-icon">📦</div>
                    <h4>No Listings Yet</h4>
                    <p>Your listings will show up here once you add them.</p>
                </div>
            </div>

            <div id="requests" class="tab-content">
                <h3>Rental Requests</h3>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h4>No Rental Requests</h4>
                    <p>Incoming rental requests will appear here when someone books one of your items.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tabName, button) {
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach((tab) => tab.classList.remove('active'));

            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach((btn) => btn.classList.remove('active'));

            document.getElementById(tabName).classList.add('active');
            if (button) {
                button.classList.add('active');
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(function (button) {
                button.addEventListener('click', function () {
                    switchTab(button.dataset.tab, button);
                });
            });
        });
    </script>
</body>
</html>
