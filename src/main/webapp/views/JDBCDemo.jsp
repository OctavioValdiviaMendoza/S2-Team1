<%@ page import="java.sql.*"%>
<! DOCTYPE html>
<html>
<head>
<title>Lendr</title>

<link rel="stylesheet" href="../css/styles.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

</head>

<body>

<div class="navbar">
    <div class="logo">Lendr</div>

    <div class="nav-buttons">
    	<a href = "../views/Login.jsp">
       		<button class="login" onclick="../Login.jsp">Log in</button>
        </a>
        <a href = "SignUp.jsp">
        <button class="signup">Sign up</button>
        </a>
    </div>
</div>

<div class="hero">

    <h1>Lendr</h1>

    <p class="tagline">
        Rent what you need. Lend what you own.
    </p>

    <p class="subtext">
        A modern rental marketplace for everyday items: skis, speakers,
        clothes, tools, cameras and more.
    </p>

    <div class="cta">
    		<a href = "../BrowseServlet">
    			<button class="primary">Browse Items</button>
    		</a>

        <a href="../CreateListingServlet">
            <button class="secondary">List an Item</button>
        </a>
    </div>

</div>


<div class="features">

    <div class="card">
        <h3>Find Items Nearby</h3>
        <p>Search locally for useful items without buying something you'll only use once.</p>
    </div>

    <div class="card">
        <h3>Earn From Your Stuff</h3>
        <p>Turn everyday items sitting at home into passive income.</p>
    </div>

    <div class="card">
        <h3>Easy Scheduling</h3>
        <p>Choose rental dates, coordinate pickup, and return items effortlessly.</p>
    </div>

</div>
</body>
</html>