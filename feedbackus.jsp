<%@page import="mypack.connectionManager"%>

<%
String fullname,email,destination,travel_date,rating,feedback_title,feedback_message,recommend;

fullname=request.getParameter("fullname");
email=request.getParameter("email");
destination=request.getParameter("destination");
travel_date=request.getParameter("travel_date");
rating=request.getParameter("rating");
feedback_title=request.getParameter("feedback_title");
feedback_message=request.getParameter("feedback_message");

String command="insert into feedback values('"
+fullname+"','"
+email+"','"
+destination+"','"
+travel_date+"','"
+rating+"','"
+feedback_title+"','"
+feedback_message+"')";

connectionManager cm=new connectionManager();

if(cm.ExecuteInsertUpdateOrDelete(command))
{
    out.print("<script>alert('Feedback Submitted Successfully');window.location.href='../feedback.html'</script>");
}
else
{
    out.print("<script>alert('Record not saved');window.location.href='../feedback.html'</script>");
}
%>