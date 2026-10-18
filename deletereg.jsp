<%@page import="mypack.connectionManager"%>
<%
String mob=request.getParameter("d");
String command="delete from reg where email='"+mob+"'";
connectionManager cm=new connectionManager();
 if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('This Contact data is deleted');"+"window.location.href='../Adminzone/Registrationmgmt.jsp'</script>");
     }
 else
 {
          out.print("<script>alert('This Contact data is not deleted');"+"window.location.href='../Adminzone/Registrationmgmt.jsp'</script>");

 }
%>