/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VehicleParking.QRCODE;

import VehicleParking.SQLconnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author NARESH
 */
public class ParkingDetails extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            String name = request.getParameter("name");
            String codeval = request.getParameter("codeval");
            String uid = request.getParameter("uid");
            String uname = request.getParameter("uname");
            String slotName = request.getParameter("slot_name");
            
            
            try {
            // Establish a database connection
            Connection connection = SQLconnection.getconnection();

            // SQL query to insert data into the table (replace 'your_table_name' with your actual table name)
            String sql = "INSERT INTO parking_details  (vnumber, codeval, uid, uname, slot_name) VALUES (?, ?, ?, ?, ?)";

            // Create a PreparedStatement to safely execute the SQL query
            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            // Set the values for the PreparedStatement
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, codeval);
            preparedStatement.setString(3, uid);
            preparedStatement.setString(4, uname);
            preparedStatement.setString(5, slotName);

            // Execute the SQL query to insert the data
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                Statement st2 = connection.createStatement();
                  int l = st2.executeUpdate("update slot_booking set ustatus='Yes' where codeval='" + codeval + "'  ");
                // Data was successfully inserted into the table
                // You can perform further actions or send a response to the client here
                response.sendRedirect("TCHome.jsp?LogAdded");
            } else {
                // Data insertion failed
                // You can handle this case accordingly
                response.sendRedirect("TCHome.jsp?LogFailed");
            }

            // Close the database connection and PreparedStatement
            preparedStatement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            // Handle any database-related exceptions here
        }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
