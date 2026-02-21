<%@ page import="java.sql.*"%>
<html>
<head>
	<title>Three Tier Architecture Demo</title>
</head>
<body>
	<h1>3-tier Connection Example</h1>
	<table border="1">
		<tr>
			<td>SJSU ID</td>
			<td>Name</td>
			<td>Major</td>
		</tr>
	<%
	String db = "valdiviamendoza";
	String user; // assumes database name is the same as username
	user = "root";
	String password = "Mendoza_101!";

	try {
	java.sql.Connection con;
	Class.forName("com.mysql.jdbc.Driver");
	con =
	DriverManager.getConnection("jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",user
	, password);
	out.println(db + " database successfully opened.<br/><br/>");
	out.println("Initial entries in table \"Student\": <br/>");
	Statement stmt = con.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT * FROM valdiviamendoza.Student");
	while (rs.next()) {
	out.println("<tr>" + "<td>" + rs.getInt(1) + "</td>"+ "<td>" + rs.getString(2) + "</td>"+
	"<td>" + rs.getString(3) + "</td>" + "</tr>");	
	}
	rs.close();
	stmt.close();
	con.close();
	} catch(SQLException e) {
		out.println("SQLException caught: " + e.getMessage());
}
%>
</body>
</html>
