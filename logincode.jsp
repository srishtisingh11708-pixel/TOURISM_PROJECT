<%@page import="mypack.connectionManager" %>
<%@page import="java.sql.ResultSet" %>

<%
    String email, pass;

    email = request.getParameter("email");
    pass = request.getParameter("pass");

    connectionManager cm = new connectionManager();

    String command = "select * from login where email='" + email + "' and pass='" + pass + "'";

    ResultSet rs = cm.getData(command);

    if(rs.next())
    {
        String role = rs.getString("role");

        session.setAttribute("ad", email);
        session.setAttribute("role", role);

        if(role.equals("admin"))
        {
            out.print("<script>");
            out.print("alert('Welcome Admin!');");
            out.print("window.location.href='../Adminzone/dashboard.jsp';");
            out.print("</script>");
        }
        else
        {
            out.print("<script>");
            out.print("alert('Login Successful!');");
            out.print("window.location.href='../booknow.html';");
            out.print("</script>");
        }
    }
    else
    {
        out.print("<script>");
        out.print("alert('Invalid user id and password');");
        out.print("window.location.href='../login.html';");
        out.print("</script>");
    }
%>