<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="VehicleParking.SQLconnection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>QR Code-based Smart Vehicle Parking Management System</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@600;700&family=Ubuntu:wght@400;500&display=swap" rel="stylesheet"> 

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <link href="lib/animate/book.css" rel="stylesheet">
    </head>
    <%
        if (request.getParameter("Failed") != null) {%>
    <script>alert('Incorrect id and password');</script>  
    <%}
    %>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var selectOneElements = document.querySelectorAll('.slectOne');
            var resultElement = document.getElementById('result');

            for (var i = 0; i < selectOneElements.length; i++) {
                selectOneElements[i].addEventListener('change', function () {
                    for (var j = 0; j < selectOneElements.length; j++) {
                        if (selectOneElements[j] !== this) {
                            selectOneElements[j].checked = false;
                        }
                    }

                    resultElement.innerHTML = this.dataset.id;

                    if (this.checked) {
                        resultElement.innerHTML = this.dataset.id+' is available';
                    } else {
                        resultElement.innerHTML = 'Empty';
                    }
                });
            }
        });

    </script>
    <body>
        <!-- Spinner Start -->
        <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
        <!-- Spinner End -->


        <!-- Navbar Start -->
        <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
            <a href="#" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
                <h2 class="m-0 text-primary"><i class="fa fa-car me-3"></i>Vehicle Parking</h2>
            </a>
            <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto p-4 p-lg-0">
                    <a href="UserHome.jsp" class="nav-item nav-link">Home</a>
                    <a href="parking_cost1.jsp" class="nav-item nav-link">Parking Cost</a>
                    <a href="Book_parking.jsp"class="nav-item nav-link active">Book Parking Slot</a>
                    <a href="your_bookings.jsp"class="nav-item nav-link">Your Bookings</a>
                    <a href="logout.jsp" class="nav-item nav-link">Logout</a>
                </div>
                <!--<a href="" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Get A Quote<i class="fa fa-arrow-right ms-3"></i></a>-->
            </div>
        </nav>

        <!-- Page Header Start -->
        <div class="container-fluid page-header mb-5 p-0">
            <div class="container-fluid page-header-inner py-5">
                <div class="container text-center">
                    <nav aria-label="breadcrumb">
                    </nav>
                </div>
            </div>
        </div>
        <!-- Page Header End -->
        <!-- Call To Action Start -->
        <div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
            <div class="container">
                <div class="col-lg-8 col-md-6">
                    <h6 class="text-primary text-uppercase">// Booking //</h6>
                    <h1 class="mb-4">Slot Booking</h1>
                    <br><br><br><br>
                    <p class="mb-0"></p>
                </div>
                <form  action="slot_booking" method="post">

                    <%
                        String pdate = request.getParameter("date");
                        String stime = request.getParameter("stime");
                        String phrs = request.getParameter("phrs");
                        System.out.println(phrs);
                        System.out.println(stime);

                        int pcost = 0;
                        int totalcost = 0;

                        String phrs1 = phrs + ":00";
                        String stime1 = stime + ":00";
                        String phrs2 = phrs1 + ":00";

                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
                        timeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

                        Date date1 = timeFormat.parse(stime1);
                        Date date2 = timeFormat.parse(phrs2);

                        long sum = date1.getTime() + date2.getTime();
                        String etime = timeFormat.format(new Date(sum));

                        System.out.println("start time : " + stime1);
                        System.out.println("parking hrs : " + phrs2);
                        System.out.println("End time : " + etime);

                        Connection con = SQLconnection.getconnection();
                        Statement st2 = con.createStatement();

                        try {
                            ResultSet rt = st2.executeQuery("SELECT * FROM parking_cost");
                            while (rt.next()) {
                                pcost = rt.getInt("cost");
                                System.out.println(pcost);
                            }
                            int hrs = Integer.parseInt(phrs);
                            totalcost = pcost * hrs;

                            System.out.println(totalcost);

                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    %>

                    <div class="row">
                        <div class="col">
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" name="pdate" value="<%=pdate%>" id="subject"  placeholder="Name" readonly="">
                                    <label for="subject">Date :</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" name="stime" value="<%=stime%>" id="subject"  placeholder="Name" readonly="">
                                    <label for="subject">Start Time :</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" name="phrs" value="<%=phrs1%>" id="subject"  placeholder="Name" readonly="">
                                    <label for="subject">Parking Hours :</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" name="totalcost" value="<%=totalcost%>" id="subject"  placeholder="Name" readonly="">
                                    <label for="subject">Parking cost in Rupees :</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <select class="form-control" id="subject" name="certype" placeholder="Name">
                                        <option value="Cash">Cash</option>
                                        <option value="UPI">UPI</option>
                                        <option value="Credit/Debit Card">Credit/Debit Card</option>
                                    </select>
                                    <label for="subject">Payment Mode :</label>
                                </div>
                            </div>
                        </div>

                        <div class="col" style="margin-left: 200px;margin-top: -150px">
                            <br><br><br><br><br>
                            <table id="seatsBlock">
                                <p id="notification"></p>
                                <tr>
                                    <td></td>
                                    <td style="color: black;">1</td>
                                    <td style="color: black;">2</td>
                                    <td style="color: black;">3</td>
                                    <td style="color: black;">4</td>
                                    <td style="color: black;">5</td>
                                    <td style="color: black;"></td>
                                    <td style="color: black;">6</td>
                                    <td style="color: black;">7</td>
                                    <td style="color: black;">8</td>
                                    <td style="color: black;">9</td>
                                    <td style="color: black;">10</td>
                                </tr>

                                <%
                                    String slot_name;

                                    ArrayList<String> s1 = new ArrayList<>();
                                    Statement st = con.createStatement();
                                    Statement st1 = con.createStatement();
                                    Statement st4 = con.createStatement();
                                    ResultSet rs = null;
                                    ResultSet rs1 = null;
                                    ResultSet rs2 = null;
                                    try {
                                        rs1 = st1.executeQuery("SELECT * FROM slot_booking WHERE pdate ='" + pdate + "' AND '" + stime + ":00' BETWEEN stime AND endtime");
                                        while (rs1.next()) {
                                            s1.add(rs1.getString("slot_name"));
                                            System.out.println(s1);
                                        }

                                        rs2 = st4.executeQuery("SELECT * FROM slot_booking WHERE pdate ='" + pdate + "' AND '" + etime + "' BETWEEN stime AND endtime");
                                        while (rs2.next()) {
                                            s1.add(rs2.getString("slot_name"));
                                            System.out.println(s1);
                                        }

                                        // The following query checks if there is any booking overlapping with the selected time
                                        rs = st.executeQuery("SELECT * FROM slot_booking WHERE pdate ='" + pdate + "' AND '" + stime + ":00' BETWEEN stime AND endtime OR '" + etime + "' BETWEEN stime AND endtime");

                                        if (!rs.next()) {
                                            // There are no overlapping bookings
                                %>



                                <tr>
                                    <td style="color: black;">A</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 1" data-id="Slot 1"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 2" data-id="Slot 2"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 3" data-id="Slot 3"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 4" data-id="Slot 4"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 5" data-id="Slot 5" />
                                    </td>
                                    <td class="seatGap"></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 6" value="Slot 1" data-id="Slot 6"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 7" data-id="Slot 7"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 8" data-id="Slot 8"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 9" data-id="Slot 9"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 10" data-id="Slot 10"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: black;">B</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 11" data-id="Slot 11"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 12" data-id="Slot 12"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 13" data-id="Slot 13"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 14" data-id="Slot 14"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 15" data-id="Slot 15"/>
                                    </td>
                                    <td></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 16" data-id="Slot 16"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 17" data-id="Slot 17"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 18" data-id="Slot 18"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 19" data-id="Slot 19"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 20" data-id="Slot 20"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="color: black;">C</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 21" data-id="Slot 21"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 22" data-id="Slot 22"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 23" data-id="Slot 23"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 24" data-id="Slot 24"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 25" data-id="Slot 25"/>
                                    </td>
                                    <td></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 26" data-id="Slot 26"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 27" data-id="Slot 27"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 28" data-id="Slot 28"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 29" data-id="Slot 29"/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 30" data-id="Slot 30"/>
                                    </td>
                                </tr>


                                <%} else {%>


                                <tr>
                                    <td style="color: black;">A</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 1" data-id="Slot 1" 
                                               <% if (s1.contains("Slot 1")) {
                                                       out.print("disabled=\'disabled \'");
                                                   }%> />
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 2" data-id="Slot 2"
                                               <% if (s1.contains("Slot 2")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 3" data-id="Slot 3"
                                               <%if (s1.contains("Slot 3")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 4" data-id="Slot 4"
                                               <% if (s1.contains("Slot 4")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 5" data-id="Slot 5"
                                               <% if (s1.contains("Slot 5")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%> />
                                    </td>
                                    <td class="seatGap"></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 6" value="Slot 1" data-id="Slot 6"
                                               <% if (s1.contains("Slot 6")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 7" data-id="Slot 7"
                                               <% if (s1.contains("Slot 7")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 8" data-id="Slot 8"
                                               <% if (s1.contains("Slot 8")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 9" data-id="Slot 9"
                                               <% if (s1.contains("Slot 9")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 10" data-id="Slot 10"
                                               <% if (s1.contains("Slot 10")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: black;">B</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 11" data-id="Slot 11"
                                               <% if (s1.contains("Slot 11")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 12" data-id="Slot 12"
                                               <% if (s1.contains("Slot 12")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 13" data-id="Slot 13"
                                               <% if (s1.contains("Slot 13")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 14" data-id="Slot 14"
                                               <% if (s1.contains("Slot 14")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 15" data-id="Slot 15"
                                               <% if (s1.contains("Slot 15")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 16" data-id="Slot 16"
                                               <% if (s1.contains("Slot 16")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 17" data-id="Slot 17"
                                               <% if (s1.contains("Slot 17")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 18" data-id="Slot 18"
                                               <% if (s1.contains("Slot 18")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 19" data-id="Slot 19"
                                               <% if (s1.contains("Slot 19")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 20" data-id="Slot 20"
                                               <% if (s1.contains("Slot 20")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="color: black;">C</td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 21" data-id="Slot 21"
                                               <% if (s1.contains("Slot 21")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 22" data-id="Slot 22"
                                               <% if (s1.contains("Slot 22")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 23" data-id="Slot 23"
                                               <% if (s1.contains("Slot 23")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 24" data-id="Slot 24"
                                               <% if (s1.contains("Slot 24")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 25" data-id="Slot 25"
                                               <% if (s1.contains("Slot 25")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td></td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 26" data-id="Slot 26"
                                               <% if (s1.contains("Slot 26")) {
                                                       out.print("checked=\'checked\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 27" data-id="Slot 27"
                                               <% if (s1.contains("Slot 27")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 28" data-id="Slot 28"
                                               <% if (s1.contains("Slot 28")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 29" data-id="Slot 29"
                                               <% if (s1.contains("Slot 29")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                    <td>
                                        <input type="checkbox" class="slectOne" name="Slot" value="Slot 30" data-id="Slot 30"
                                               <% if (s1.contains("Slot 30")) {
                                                       out.print("disabled=\'disabled\'");
                                                   }%>/>
                                    </td>
                                </tr>

                                <%
                                        }
                                    } catch (Exception ex) {
                                        ex.printStackTrace();
                                    }
                                %>
                            </table>
                            <br>  <br>  <br>
                            &nbsp;<span id="result" class="btn btn-warning"></span>
                            <br><br><br>
                        </div>
                    </div>
                    <center><div class="form-group">
                            <br><br><br>
                            <button type="submit" class="btn btn-primary btn-md">Book</button>
                        </div></center>
                </form>                    
            </div>
        </div>
        <!-- Call To Action End -->



        <!-- Footer Start -->
        <div class="container-fluid bg-dark text-light footer pt-5 mt-5 wow fadeIn" data-wow-delay="0.1s">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                    </div>
                    <div class="col-lg-3 col-md-6">

                    </div>
                    <div class="col-lg-3 col-md-6">
                    </div>
                    <div class="col-lg-3 col-md-6">
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="copyright">
                    <div class="row">
                        <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                            <a class="border-bottom" href="#">QR Code-based Smart Vehicle Parking Management System</a>
                        </div>
                        <div class="col-md-6 text-center text-md-end">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer End -->


        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>


        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/wow/wow.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/counterup/counterup.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
    </body>

</html>
