<%@page import="mypack.connectionManager" %>
<%@page import="java.sql.ResultSet" %>
<%
    String email,pass;
    email=request.getParameter("email");
    pass=request.getParameter("pass");
    connectionManager cm=new connectionManager();
    String command="select *from login where email='"+email+"' and pass='"+pass+"'";
    ResultSet rs=cm.getData(command);
    if(rs.next())
    {
        session.setAttribute("ad", email);
        out.print("<script>alert('Welcometo my adminzone!As Soon As we Contact ');"+"window.location.href='../Adminzone/dashboard.jsp'</script>");
     
    }
    else
    
    {
             out.print("<script>alert('invalid user id and password');"+"window.location.href='../login.html'</script>");   
    }
    
    %>