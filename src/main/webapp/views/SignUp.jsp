<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet"> 
<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">

<!-- NAVBAR --> 
<div class="navbar"> 
	<a href= "${pageContext.request.contextPath}/views/JDBCDemo.jsp" class="logo">
		Lendr
	</a> 
</div> 

<!-- SIGNUP --> 
<div class="auth-container"> 
	<div class="auth-card">
	<% if (request.getAttribute("errorMessage") != null) { %>
	    <p style="color:red; font-weight:bold;">
	        <%= request.getAttribute("errorMessage") %>
	    </p>
	<% } %> 
	<h2>Create Account</h2> 
	<p>Join Lendr today</p> 
	
	<form action="${pageContext.request.contextPath}/SignupServlet" method="post"> 
		<input type="text" name="firstName" placeholder="First Name" required> 
		<input type="text" name="lastName" placeholder="Last Name" required> 
		<input type="email" name="email" placeholder="Email Address" required> 
		<input type="text" name="phoneNumber"  id="phoneNumber" maxlength="14"placeholder="Phone Number" required> 
		<input type="text" name="govId" id="govId" placeholder="Government ID" required> 
		<input type="password" id="password" name="password" placeholder="Password" required> 
		<input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
		<button type="submit" class="auth-btn login-btn">Sign Up</button> 
	</form> 
	
	
	<div class="divider"></div> 
	
	<p class="switch-text"> Already have an account? 
	<a href="${pageContext.request.contextPath}/views/Login.jsp">Log in here</a> 
	</p> 
	<a href="${pageContext.request.contextPath}/views/JDBCDemo.jsp" class="back-link">Back to Home</a> </div> 
	
	<script>
	document.getElementById("govId").addEventListener("input", function(e) {
	    let value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, "");

	    if (value.length > 8) {
	        value = value.slice(0, 8);
	    }

	    if (value.length > 0) {
	        value = value[0] + value.slice(1).replace(/\D/g, "");
	    }

	    e.target.value = value;
	});
	
	document.getElementById("phoneNumber").addEventListener("input", function(e) {
	    let value = e.target.value.replace(/\D/g, ""); // remove non-digits

	    if (value.length > 10) {
	        value = value.slice(0, 10);
	    }

	    let formatted = "";

	    if (value.length > 0) {
	        formatted = "(" + value.substring(0, 3);
	    }
	    if (value.length >= 4) {
	        formatted += ") " + value.substring(3, 6);
	    }
	    if (value.length >= 7) {
	        formatted += "-" + value.substring(6, 10);
	    }

	    e.target.value = formatted;
	});
	
	document.querySelector("form").addEventListener("submit", function(e) {
    const pw = document.getElementById("password").value;
    const cpw = document.getElementById("confirmPassword").value;

    if (pw !== cpw) {
        alert("Passwords do not match");
        e.preventDefault();
    }
	});
</script>
</div>