<%@page import="mypack.connectionManager" %>
<%
    String name,mob,email,des,trav,month,msg;
    name=request.getParameter("name");
    mob=request.getParameter("mob");
    email=request.getParameter("email");
    des=request.getParameter("des");
    trav=request.getParameter("trav");
     month=request.getParameter("month");
     msg=request.getParameter("msg");
     String command="insert into contact values('"+name+"','"+mob+"','"+email+"','"+des+"','"+trav+"','"+month+"','"+msg+"')";
     connectionManager cm=new connectionManager();
     if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('Thanks For Contact!As Soon As we Contact ');window.location.href='../Contact.html'</script>");
     }
     else
     {
     out.print("<script>alert('Contact NOT Save');window.location.href='../Contact.html'</script>");    
     }
     
    %>