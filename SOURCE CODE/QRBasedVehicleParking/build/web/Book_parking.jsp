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
        <script src="https://cdn.jsdelivr.net/timepicker.js/latest/timepicker.min.js"></script>
        <link href="https://cdn.jsdelivr.net/timepicker.js/latest/timepicker.min.css" rel="stylesheet"/>  


        <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery-timepicker/1.8.9/jquery.timepicker.min.css" rel="stylesheet" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-timepicker/1.8.9/jquery.timepicker.min.js"></script>

    </head>

    <%
        if (request.getParameter("Slot_booked") != null) {
    %>
    <script>alert('Slot Booked');</script>
    <%            }
    %>
    <script>
        $(function () {
            for (var i = 1; i <= 6; i += 1) {
                $('#meeting').append('<option value="0' + i + '">' + i + '   hrs' + '</option>');
            }

            for (var i = 6; i <= 18; i += 1) {
                $('#stime1').append('<option value="' + i + ':00">' + i + '   :00' + '</option>');
            }
            function setEndTime() {
                var meetingLength = parseInt($('#meeting').find('option:selected').val() || 0);
                var selectedTime = $('#stime').timepicker('getTime');
                if (selectedTime == null || selectedTime == "") {
                    alert("Please select the start time.");
                } else {
                    selectedTime.setMinutes(selectedTime.getMinutes() + parseInt(meetingLength, 10), 0);
                    $('#etime').timepicker('setTime', selectedTime);
                }
            }

            $('#stime').timepicker({
                'timeFormat': 'h:i a',
                'minTime': '8:00 AM',
                'maxTime': '5:00 PM',
                'step': 30
            }).on(function () {
                setEndTime();
            });

            $('#etime').timepicker({
                'timeFormat': 'h:i a',
                'minTime': '8:00 AM',
                'maxTime': '5:00 PM',
                'step': 5
            });

            $('#meeting').bind('change', function () {
                setEndTime();
            });
        });



    </script>
    <script>
        function getInputDateFormat(date) {
            return date.toISOString().split('T')[0];
        }

        function validDate() {
            var today = new Date();
            var maxDate = new Date();
            maxDate.setDate(maxDate.getDate() + 365);

            document.getElementsByName("date")[0].setAttribute('min', getInputDateFormat(today));
            document.getElementsByName("date")[0].setAttribute('max', getInputDateFormat(maxDate));
        }
    </script>
    <%
      if (request.getParameter("Already") != null) {%>
    <script>alert('Slot Already Booked');</script>  
    <%}
    %>
  <body onload="validDate()">
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
        <%
            Connection con = SQLconnection.getconnection();
            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery("SELECT * FROM parking_cost");
            rs.next();
        %>
        <!-- Call To Action Start -->
        <div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-8 col-md-6">
                        <h6 class="text-primary text-uppercase">// Booking //</h6>
                        <h1 class="mb-4">Slot Booking</h1>
                        <br><br><br><br>
                        <p class="mb-0"></p>
                    </div>
                    <center><div  class="col-md-4">
                            <form  action="Bookparking.jsp" method="get">
                                            <div class="form-group">
                                                &nbsp;&nbsp;<label>Select Date :</label>
                                                <input type="date" class="form-control" name="date" id="date" required="required">
                                            </div>
                                            <div class="form-group">
                                                &nbsp;&nbsp;<label>Select Parking Time :</label>
                                                <select name="stime" required="required" class="form-control">
                                                    <option value="">--Select Time--</option>
                                                    <option>06:00</option>
                                                    <option>07:00</option>
                                                    <option>08:00</option>
                                                    <option>09:00</option>
                                                    <option>10:00</option>
                                                    <option>11:00</option>
                                                    <option>12:00</option>
                                                    <option>13:00</option>
                                                    <option>14:00</option>
                                                    <option>15:00</option>
                                                    <option>16:00</option>
                                                    <option>17:00</option>
                                                    <option>18:00</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                &nbsp;&nbsp;<label>Enter Parking Hours :</label>
                                                <select name="phrs" id="meeting" class="form-control" required="required">
                                                    <option value="">--Select Hours--</option>
                                                </select>
                                            </div>
                                <br><br>
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary">Select Slot</button>
                                            </div>
                                        </form>
                        </div></center>

                </div>
            </div>
        </div>
        <%
            rs.close();
            con.close();
        %>
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
        <script>
            var timepicker = new TimePicker('time', {
                lang: 'en',
                theme: 'dark'
            });
            timepicker.on('change', function (evt) {

                var value = (evt.hour || '00') + ':' + (evt.minute || '00');
                evt.element.value = value;

            });
        </script>
    </body>

</html>
