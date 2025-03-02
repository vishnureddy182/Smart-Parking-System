/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package VehicleParking.QRCODE;

import static VehicleParking.QRCODE.QRGen.createQR;
import VehicleParking.SQLconnection;
import com.google.zxing.EncodeHintType;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author NARESH
 */
public class slot_booking extends HttpServlet {

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
            HttpSession session = request.getSession();
            String pdate = request.getParameter("pdate");
            String stime1 = request.getParameter("stime") + ":00";
            String phrs = request.getParameter("phrs") + ":00";
            String slot_name = request.getParameter("Slot");
            String totalcost = request.getParameter("totalcost");

            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
            timeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

            Date date1 = timeFormat.parse(stime1);
            Date date2 = timeFormat.parse(phrs);

            long sum = date1.getTime() + date2.getTime();
            String etime1 = timeFormat.format(new Date(sum));

            System.out.println("start time : " + stime1);
            System.out.println("parking hrs : " + phrs);

            LocalTime originalTime1 = LocalTime.parse(stime1);

            // Add 1 second
            LocalTime stime2 = originalTime1.minusSeconds(1);
            String stime = stime2.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
            LocalTime originalTime = LocalTime.parse(etime1);

            // Subtract 1 second
            LocalTime etime2 = originalTime.minusSeconds(1);
            String etime = etime2.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
            // Print the new time
            System.out.println(etime);
            System.out.println("End time : " + etime);

            String uid = (String) session.getAttribute("uid");
            String uname = (String) session.getAttribute("uname");
            String umail = (String) session.getAttribute("umail");
            Connection con = SQLconnection.getconnection();
            Statement st = con.createStatement();
            Statement st1 = con.createStatement();
            try {
                ResultSet rs = st.executeQuery("SELECT * FROM slot_booking WHERE pdate ='" + pdate + "' AND stime = '" + stime + "' AND slot_name = '" + slot_name + "' ");
                if (rs.next() == true) {
                    response.sendRedirect("Book_parking.jsp?Already");
                } else {
                    String path = "D://QRParking";
                    String pathf = path;
                    File newFolder = new File(pathf);

                    boolean created = newFolder.mkdirs();

                    if (created) {
                        System.out.println("Folder was created !");
                    } else {
                        System.out.println("Unable to create folder");
                    }

                    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                    Date date = new Date();
                    String time = dateFormat.format(date);
                    System.out.println("Date and Time : " + time);
                    Random RANDOM = new SecureRandom();
                    int PASSWORD_LENGTH = 10;
                    String letters = "378AIJKLM5CD4NOP126EFGHB9";
                    String codeval = "";
                    for (int k = 0; k < PASSWORD_LENGTH; k++) {
                        int index = (int) (RANDOM.nextDouble() * letters.length());
                        codeval += letters.substring(index, index + 1);
                    }
                    String codeval1 = codeval;

                    String pathQR = pathf + "/" + umail + ".png";

                    // Encoding charset
                    String charset = "UTF-8";

                    Map<EncodeHintType, ErrorCorrectionLevel> hashMap
                            = new HashMap<EncodeHintType, ErrorCorrectionLevel>();

                    hashMap.put(EncodeHintType.ERROR_CORRECTION,
                            ErrorCorrectionLevel.L);

                    // Create the QR code and save
                    // in the specified folder
                    // as a jpg file
                    createQR(codeval1, pathQR, charset, hashMap, 200, 200);
                    System.out.println("QR Code Generated!!! ");
                    String imagePath = pathQR;
                    File file = new File(imagePath);
                    InputStream inputStream = new FileInputStream(file);

                    // Read the image file into a byte array
                    File imageFile = new File(imagePath);
                    byte[] imageData = readImageBytes(imageFile);
                    String sql = "INSERT INTO slot_booking (uname, uid, pdate, stime, phrs, umail, slot_name, time, endtime, pcost,image_data,codeval) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)";

                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setString(1, uname);
                    pstmt.setString(2, uid);
                    pstmt.setString(3, pdate);
                    pstmt.setString(4, stime);
                    pstmt.setString(5, phrs);
                    pstmt.setString(6, umail);
                    pstmt.setString(7, slot_name);
                    pstmt.setString(8, time);
                    pstmt.setString(9, etime);
                    pstmt.setString(10, totalcost);
                    pstmt.setBytes(11, imageData);
                    pstmt.setString(12, codeval1);

                    int i = pstmt.executeUpdate();

                    if (i != 0) {
                        response.sendRedirect("Book_parking.jsp?Slot_booked");
                    } else {
                        response.sendRedirect("Book_parking.jsp?Failed");
                    }

                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } catch (SQLException ex) {
            Logger.getLogger(slot_booking.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(slot_booking.class.getName()).log(Level.SEVERE, null, ex);
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

    private static byte[] readImageBytes(File file) throws IOException {
        FileInputStream fis = new FileInputStream(file);
        byte[] buffer = new byte[(int) file.length()];
        fis.read(buffer);
        fis.close();
        return buffer;
    }
}
