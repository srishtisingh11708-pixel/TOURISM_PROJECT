<%
    // Session completely invalidate kar do
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("index.html");
%>
