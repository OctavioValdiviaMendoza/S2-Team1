<!DOCTYPE html>
<html>

<head>
	<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet"> 
	<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">
</head>

<body>
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
	<div id="errorDiv" class="error"></div>
	<h2>Create Account</h2> 
	<p>Join Lendr today</p> 
	
	<form action="${pageContext.request.contextPath}/SignupServlet" method="post"> 
		<input type="text" name="firstName" placeholder="First Name" required> 
		<input type="text" name="lastName" placeholder="Last Name" required> 
		<input type="email" name="email" placeholder="Email Address" required> 
		<input type="text" name="phoneNumber"  id="phoneNumber" maxlength="14" placeholder="Phone Number" required> 
		<input type="text" name="govId" id="govId" placeholder="Government ID" required> 
		<input type="password" id="password" name="password" placeholder="Password" required> 
		<input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
		<button type="submit" class="auth-btn login-btn">Sign Up</button> 
	</form> 
	
	<p class="switch-text"> Already have an account? 
		<a href="${pageContext.request.contextPath}/views/Login.jsp">Log in here</a> 
	</p> 
		<a href="${pageContext.request.contextPath}/views/JDBCDemo.jsp" class="back-link">Back to Home</a> </div> 
	
	<script>
		//This tracks the user input and forbids user from entering anything besides Capital Letters and digits
		document.getElementById("govId").addEventListener("input", function(e) {
		    let value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, ""); 
	
		    	//Limited to 8 characters to mimic CA Driver's License
		    if (value.length > 8) {
		        value = value.slice(0, 8);
		    }
			
		    	//Refining Second portion to ensure only digtis
		    if (value.length > 0) {
		        value = value[0] + value.slice(1).replace(/\D/g, "");
		    }
	
		    e.target.value = value;
		});
		
		//Formating phone number
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
		const errorDiv = document.getElementById("errorDiv");
		
		const hasUpper = /[A-Z]/.test(pw);
		const hasLower = /[a-z]/.test(pw);
		const hasNum = /[0-9]/.test(pw);
		const hasSpecialChar = /[^A-Za-z0-9]/.test(pw);
	    
	    if (pw !== cpw) {
	        errorDiv.innerHTML = "<p>Passwords do not match</p>";
	        e.preventDefault();
	    }
	    else if (pw.length < 8){
	    		errorDiv.innerHTML ="<p>Your password needs to be at least 8 characters</p>";
	    		e.preventDefault();
	    }  
	    else if (!hasUpper) {errorDiv.innerHTML = "<p>Your password requires an uppercase letter</p>"; e.preventDefault();}
	    else if (!hasLower) {errorDiv.innerHTML = "<p>Your password requires a lowercase letter</p>"; e.preventDefault();}
	    else if (!hasNum) {errorDiv.innerHTML = "<p>Your password requires a number</p>"; e.preventDefault();}
	    else if (!hasSpecialChar) {errorDiv.innerHTML = "<p>Your password requires a special character</p>"; e.preventDefault();}
		});
	</script>
</div>
</body>
</html>