<%@page import="mypack.connectionManager" %>
<%
    String name,mob,email,des,depDate,retDate,adults,children,transportMode,carrier,travelClass,hotel,paymentMethod,totalAmount;
name=request.getParameter("name");
mob=request.getParameter("mob");
email=request.getParameter("email");

des=request.getParameter("destination");
depDate=request.getParameter("dep_date");
retDate=request.getParameter("ret_date");

adults=request.getParameter("adults");
children=request.getParameter("children");

transportMode=request.getParameter("transport_mode");
carrier=request.getParameter("carrier");
travelClass=request.getParameter("travel_class");

hotel=request.getParameter("hotel");
paymentMethod=request.getParameter("payment_method");
totalAmount=request.getParameter("total_amount");

String command="insert into bookings(name,mob,email,destination,dep_date,ret_date,adults,children,transport_mode,carrier,travel_class,hotel,payment_method,total_amount) values('"
+name+"','"
+mob+"','"
+email+"','"
+des+"','"
+depDate+"','"
+retDate+"',"
+adults+","
+children+",'"
+transportMode+"','"
+carrier+"','"
+travelClass+"','"
+hotel+"','"
+paymentMethod+"',"
+totalAmount+")";
    connectionManager cm=new connectionManager();
    if(cm.ExecuteInsertUpdateOrDelete(command))
    {
    out.print("<script>alert('Booking Confirmed! Our team will contact you shortly.');window.location.href='../booknow.html'</script>");
    }
    else
    {
    out.print("<script>alert('Booking NOT Saved');window.location.href='../booknow.html'</script>");    
    }
%>
