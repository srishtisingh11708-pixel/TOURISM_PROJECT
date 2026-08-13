<%@page import="mypack.connectionManager"%>
<%
String mob=request.getParameter("d");
String command="delete from bookings where name='"+mob+"'";
connectionManager cm=new connectionManager();
 if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('This  data is deleted');"+"window.location.href='../Adminzone/bookmgmt.jsp'</script>");
     }
 else
 {
          out.print("<script>alert('This data is not deleted');"+"window.location.href='../Adminzone/.jsp'</script>");

 }
%>