<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Database</title>
</head>
<body>
    <h2>Verifica Connessione Database:</h2>
    <%
        Connection conn = null;
        try {
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/ShirtInvasionDB");
            conn = ds.getConnection();
            
            if (conn != null && !conn.isClosed()) {
                out.println("<h3 style='color:green;'>SÌ! Connessione riuscita a MySQL! 🎉</h3>");
                out.println("<p>Il server Tomcat e il database si parlano a meraviglia.</p>");
            }
        } catch (Exception e) {
            out.println("<h3 style='color:red;'>ERRORE DI CONNESSIONE! ❌</h3>");
            out.println("<pre style='color:red;'>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException e) {} }
        }
    %>
</body>
</html>