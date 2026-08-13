<%@page import="mypack.connectionManager"%>

<%
String email = request.getParameter("d");

String command = "delete from feedback where email='"+email+"'";

connectionManager cm = new connectionManager();

if(cm.ExecuteInsertUpdateOrDelete(command))
{
    out.print("<script>alert('Review deleted');window.location.href='../Adminzone/Reviewmgmt.jsp'</script>");
}
else
{
    out.print("<script>alert('Review not deleted');window.location.href='../Adminzone/Reviewmgmt.jsp'</script>");
}
%>