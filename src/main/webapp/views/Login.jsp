<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login / Sign Up</title>

<!-- Google Font (matches your style) -->

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">

</head>

<body>

<!-- NAVBAR -->
<div class="navbar"> 
	<a href= "${pageContext.request.contextPath}/views/JDBCDemo.jsp" class="logo">
		Lendr
	</a>
</div> 
<!-- LOGIN --> 
<div class="auth-container"> 

	<div class="auth-card"> 
	
		<h2>Welcome Back</h2> 
		<p>Login to your account</p> 
		
		<form action="${pageContext.request.contextPath}/LoginServlet" method="post"> 
			<input type="text" name="email" placeholder="Email" required> 
			<input type="password" name="password" placeholder="Password" required> 
			<button type="submit" class="auth-btn login-btn">Log In</button> 
		</form> 
		
		<div class="divider"></div> 
		
		<p class="switch-text"> Don't have an account? 
		<a href="${pageContext.request.contextPath}/views/SignUp.jsp">Sign up here</a> </p> 
		<a href="${pageContext.request.contextPath}/views/JDBCDemo.jsp" class="back-link">Back to Home</a> 
		</div> 
</div>

<%
String errorMessage = (String) request.getAttribute("errorMessage");
if (errorMessage != null) {
%>
<script>
    alert("<%= errorMessage %>");
</script>
<%
}
%>

<script>
    const params = new URLSearchParams(window.location.search);
    const successMessage = params.get("success");

    if (successMessage) {
        alert(successMessage);

       
        window.history.replaceState({}, document.title, window.location.pathname);
    }
</script>

</body>
</html>
