<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login / Sign Up</title>

<!-- Google Font (matches your style) -->

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet">
<link href="../css/auth.css" rel="stylesheet">

</head>

<body>

<!-- NAVBAR -->
<div class="navbar"> 
	<div class="logo">Lendr</div> 
</div> 
<!-- LOGIN --> 
<div class="auth-container"> 

	<div class="auth-card"> 
	
		<h2>Welcome Back</h2> 
		<p>Login to your account</p> 
		
		<form action="LoginServlet" method="post"> 
			<input type="text" name="username" placeholder="Username" required> 
			<input type="password" name="password" placeholder="Password" required> 
			<button type="submit" class="auth-btn login-btn">Log In</button> 
		</form> 
		
		<div class="divider"></div> 
		
		<p class="switch-text"> Don't have an account? 
		<a href="SignUp.jsp">Sign up here</a> </p> 
		<a href="JDBCDemo.jsp" class="back-link">Back to Home</a> 
		</div> 
</div>
</body>
</html>
