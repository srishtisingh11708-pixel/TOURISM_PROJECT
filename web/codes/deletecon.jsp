<%@page import="mypack.connectionManager"%>
<%
String mob=request.getParameter("d");
String command="delete from contact where email='"+mob+"'";
connectionManager cm=new connectionManager();
 if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('This Contact data is deleted');"+"window.location.href='../Adminzone/contactmgmt.jsp'</script>");
     }
 else
 {
          out.print("<script>alert('This Contact data is not deleted');"+"window.location.href='../Adminzone/contactmgmt.jsp'</script>");

 }
%>