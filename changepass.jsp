<%@page import="mypack.connectionManager"%>
<%
    String oldpass=request.getParameter("oldpass");
     String newpass=request.getParameter("newpass");
      String cpass=request.getParameter("cpass");
      if(newpass.equals(cpass))
      {
          String email=session.getAttribute("ad").toString();
          String command="update login set pass='"+newpass+"'"+"where email='"+email+"' and pass='"+oldpass+"'";
          connectionManager cm=new connectionManager();
          boolean a=cm.ExecuteInsertUpdateOrDelete(command);
          if(a)
          {
               out.print("<script>alert('Your password change successfully');window.location.href='../login.html'</script>");
          }
          else
          {
               out.print("<script>alert('your password not change ');window.location.href='../Adminzone/changepassword.jsp'</script>");
          }
      }
      else
      {
           out.print("<script>alert('please enter confirm password ');window.location.href='../Adminzone/changepassword.jsp'</script>");
      }
    
    %>