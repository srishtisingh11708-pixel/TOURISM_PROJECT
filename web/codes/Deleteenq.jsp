<%@page import="mypack.connectionManager"%>
<%
String mob=request.getParameter("d");
String command="delete from enquiry where name='"+mob+"'";
connectionManager cm=new connectionManager();
 if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('This enquiry data is deleted');"+"window.location.href='../Adminzone/Enquirymgmt.jsp'</script>");
     }
 else
 {
          out.print("<script>alert('This enquiry data is not deleted');"+"window.location.href='../Adminzone/Enquirymgmtmgmt.jsp'</script>");

 }
%>