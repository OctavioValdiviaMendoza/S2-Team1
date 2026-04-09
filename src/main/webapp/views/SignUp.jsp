<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet"> 
<link href="../css/auth.css" rel="stylesheet">

<!-- NAVBAR --> 
<div class="navbar"> 
	<div class="logo">Lendr</div> 
</div> 

<!-- SIGNUP --> 
<div class="auth-container"> 
	<div class="auth-card"> 
	<h2>Create Account</h2> 
	<p>Join Lendr today</p> 
	
	<form action="${pageContext.request.contextPath}/SignupServlet" method="post"> 
		<input type="text" name="firstName" placeholder="First Name" required> 
		<input type="text" name="lastName" placeholder="Last Name" required> 
		<input type="email" name="email" placeholder="Email Address" required> 
		<input type="text" name="phoneNumber" placeholder="Phone Number" required> 
		<input type="text" name="govId" placeholder="Government ID" required> 
		<input type="password" id="password" name="password" placeholder="Password" required> 
		<input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
		<button type="submit" class="auth-btn login-btn">Sign Up</button> 
	</form> 
	
	<div class="divider"></div> 
	
	<p class="switch-text"> Already have an account? 
	<a href="Login.jsp">Log in here</a> 
	</p> 
	<a href="JDBCDemo.jsp" class="back-link">Back to Home</a> </div> 
	
	<script>
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