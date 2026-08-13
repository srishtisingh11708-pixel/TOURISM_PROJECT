<%@page import="mypack.connectionManager" %>
<%
    String name,mob,email,des,mon,adu,child,tour,budg,hotel,trans,requir,con,cr;
    name=request.getParameter("name");
    mob=request.getParameter("mob");
    email=request.getParameter("email");
    des=request.getParameter("des");
    mon=request.getParameter("mon");
    adu=request.getParameter("adu");
    child=request.getParameter("child");
    tour=request.getParameter("tour");
    budg=request.getParameter("budg");
    hotel=request.getParameter("hotel");
    trans=request.getParameter("trans");
    requir=request.getParameter("requir");
    con=request.getParameter("con");
    cr=request.getParameter("cr");
   String command="INSERT INTO enquiry(name,mob,email,des,mon,adu,child,tour,budg,hotel,trans,requir,con,cr) VALUES('"+name+"','"+mob+"','"+email+"','"+des+"','"+mon+"','"+adu+"','"+child+"','"+tour+"','"+budg+"','"+hotel+"','"+trans+"','"+requir+"','"+con+"','"+cr+"')";
     connectionManager cm=new connectionManager();
     if(cm.ExecuteInsertUpdateOrDelete(command))
     {
     out.print("<script>alert('Thanks For Enquiry!As Soon As we Contact ');window.location.href='../enquiry.html'</script>");
     }
     else
     {
     out.print("<script>alert('enquiry NOT Save');window.location.href='../enquiry.html'</script>");    
     }
     %>