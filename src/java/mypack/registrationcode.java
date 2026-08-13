/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mypack;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author srish
 */
@MultipartConfig
@WebServlet(name = "registrationcode", urlPatterns = {"/registrationcode"})
public class registrationcode extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet registrationcode</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet registrationcode at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name=request.getParameter("name");
          String fname=request.getParameter("fname");
                    String mname=request.getParameter("mname");
                              String gender=request.getParameter("gender");
       String checkGender="";
        if(gender.equals(gender)){
        checkGender="Male";
        }
        else{
      checkGender="Female";}
      String quali=request.getParameter("quali");
        String mob=request.getParameter("mob");
        String city=request.getParameter("city");
          String email=request.getParameter("email");   
          Part part=request.getPart("profile");
          String fileName=part.getSubmittedFileName();
          InputStream is=part.getInputStream();
          File f=new File(request.getRealPath("/userpic"),email+fileName);
          Files.copy(is,f.toPath());
          System.out.println(f.getAbsolutePath());
            String state=request.getParameter("state");
            Date dt=new Date();
            connectionManager cm=new connectionManager();
            String captcha=request.getParameter("cc1");
            String ConfirmCaptcha=request.getParameter("hdn1");
            if(captcha.equals(ConfirmCaptcha))
            {
               String  command="insert into reg values('"+name+"','"+fname+"','"+mname+"','"+gender+"','"+quali+"','"+mob+"','"+city+"','"+email+"','"+email+fileName+"','"+state+"','"+dt.toString()+"')" ;
               PrintWriter out=response.getWriter();
               if(cm.ExecuteInsertUpdateOrDelete(command))
               {
                    out.print("<script>alert('Your registration is successfully!As Soon As we Contact ');window.location.href='../TOURISM_PROJECT/Registration.html'</script>");
               }
    else
     {
     out.print("<script>alert('sorry not successfully');window.location.href='../TOURISM_PROJECT/Registration.html'</script>");    
     }
       }
        else
          {
     PrintWriter out=response.getWriter();
                 out.print("<script>alert('invalid captcha code');window.location.href='../TOURISM_PROJECT/Registration.html'</script>");    

            }                                   
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
