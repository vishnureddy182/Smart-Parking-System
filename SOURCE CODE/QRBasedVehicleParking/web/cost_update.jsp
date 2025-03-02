<%@page import="VehicleParking.SQLconnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String pcost = request.getParameter("pcost");

    Connection con = null;
    Statement st = null;
    Statement st1 = null;
    Connection conn = SQLconnection.getconnection();
    Statement sto = conn.createStatement();
    st = conn.createStatement();

    try {
        int i = sto.executeUpdate("UPDATE parking_cost SET cost='"+ pcost +"' ");
        System.out.println("parking Cost" + pcost);
        if (i != 0) {
                response.sendRedirect("ParkingCost.jsp?Cost_updated");
            } else {

                System.out.println("failed");
                response.sendRedirect("ParkingCost.jsp?Failed");
            }
        
    } catch (Exception ex) {
        ex.printStackTrace();
    }
%>

