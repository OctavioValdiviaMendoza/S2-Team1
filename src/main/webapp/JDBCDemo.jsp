<%@ page import="java.sql.*"%>
<html>
<head>
<title>Lendr</title>

<link rel="stylesheet" href="css/styles.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

</head>

<body>

<div class="navbar">
    <div class="logo">Lendr</div>

    <div class="nav-buttons">
        <button class="login">Log in</button>
        <button class="signup">Sign up</button>
    </div>
</div>

<div class="hero">

    <h1>Lendr</h1>

    <p class="tagline">
        Rent what you need. Lend what you own.
    </p>

    <p class="subtext">
        A modern rental marketplace for everyday items — skis, speakers,
        clothes, tools, cameras and more.
    </p>

    <div class="cta">
        <button class="primary">Browse Items</button>
        <button class="secondary">List an Item</button>
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


<%
/* SQL runs but prints nothing */

String db = "valdiviamendoza";
String user = "root";
String password = "Mendoza_101!";

try {

java.sql.Connection con;
Class.forName("com.mysql.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
user,
password
);

Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM valdiviamendoza.Student");

while(rs.next()){
    // intentionally empty
}

rs.close();
stmt.close();
con.close();

} catch(SQLException e) {
    // do nothing
}

%>

</body>
</html>