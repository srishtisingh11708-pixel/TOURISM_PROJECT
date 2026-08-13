package org.apache.jsp.Adminzone;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import mypack.connectionManager;
import java.sql.ResultSet;

public final class Reviewmgmt_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("    \n");
      out.write(" \n");
      out.write("<head>\n");
      out.write("<meta charset=\"UTF-8\" />\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n");
      out.write("<title>Sahyatri ? Tourism Admin</title>\n");
      out.write("<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n");
      out.write("<link href=\"https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap\" rel=\"stylesheet\">\n");
      out.write("<script src=\"https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js\"></script>\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css\">\n");
      out.write("<style>\n");
      out.write("  :root{\n");
      out.write("    --ink:#0F3D30;\n");
      out.write("    --paper:#FFFFFF;\n");
      out.write("    --card:#FFFFFF;\n");
      out.write("    --saffron:#E8A33D;\n");
      out.write("    --teal:#17A673;\n");
      out.write("    --teal-tint:#EAF7F1;\n");
      out.write("    --advisory:#C1502E;\n");
      out.write("    --line:#DCEBE3;\n");
      out.write("    --muted:#5E7A6D;\n");
      out.write("    --sidebar-w:230px;\n");
      out.write("    --rose:#D6486B;\n");
      out.write("  }\n");
      out.write("  *{box-sizing:border-box;}\n");
      out.write("  body{margin:0;background:var(--teal-tint);color:var(--ink);font-family:'Inter',sans-serif;font-size:13.5px;}\n");
      out.write("  a{text-decoration:none;color:inherit;}\n");
      out.write("  ul{margin:0;padding:0;list-style:none;}\n");
      out.write("\n");
      out.write("  .advisory-bar{background:var(--ink);color:#F5EFE3;display:flex;align-items:stretch;font-size:12px;overflow:hidden;position:relative;}\n");
      out.write("  .advisory-tag{flex-shrink:0;display:flex;align-items:center;gap:7px;padding:9px 16px;background:var(--advisory);font-weight:700;font-family:'IBM Plex Mono',monospace;font-size:10.5px;letter-spacing:1px;text-transform:uppercase;}\n");
      out.write("  .advisory-track{flex:1;overflow:hidden;position:relative;}\n");
      out.write("  .advisory-scroll{display:flex;gap:48px;white-space:nowrap;padding:9px 0;animation:ticker 32s linear infinite;width:max-content;}\n");
      out.write("  .advisory-scroll span{display:inline-flex;align-items:center;gap:8px;}\n");
      out.write("  .advisory-track:hover .advisory-scroll{animation-play-state:paused;}\n");
      out.write("  @keyframes ticker{ from{transform:translateX(0);} to{transform:translateX(-50%);} }\n");
      out.write("  .advisory-close{flex-shrink:0;border:none;background:none;color:rgba(245,239,227,0.55);cursor:pointer;padding:0 16px;font-size:14px;}\n");
      out.write("  .advisory-bar.hidden{display:none;}\n");
      out.write("\n");
      out.write("  .app-shell{display:flex;min-height:100vh;position:relative;z-index:1;}\n");
      out.write("  .sidebar{width:var(--sidebar-w);flex-shrink:0;background:var(--ink);color:#EAF0E8;display:flex;flex-direction:column;overflow:hidden;transition:width .25s ease, opacity .2s ease;}\n");
      out.write("  .sidebar > *{min-width:var(--sidebar-w);}\n");
      out.write("  .app-shell.collapsed .sidebar{width:0;opacity:0;}\n");
      out.write("\n");
      out.write("  .brand-row{display:flex;align-items:center;gap:11px;padding:20px 20px 16px;}\n");
      out.write("  .brand-mark{width:34px;height:34px;border-radius:9px;background:var(--saffron);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:16px;color:var(--ink);}\n");
      out.write("  .brand-row h1{font-family:'Fraunces',serif;font-size:17px;font-weight:600;margin:0;color:#fff;}\n");
      out.write("  .brand-row .sub{font-size:10px;color:rgba(234,240,232,0.5);letter-spacing:0.5px;text-transform:uppercase;margin-top:1px;}\n");
      out.write("\n");
      out.write("  .nav-scroll{flex:1;overflow-y:auto;padding:8px 12px;}\n");
      out.write("  .nav-eyebrow{font-family:'IBM Plex Mono',monospace;font-size:10px;letter-spacing:1.5px;color:rgba(234,240,232,0.35);padding:14px 10px 6px;text-transform:uppercase;}\n");
      out.write("  .nav-list li a{display:flex;align-items:center;gap:11px;padding:9px 10px;border-radius:8px;font-size:13px;font-weight:500;color:rgba(234,240,232,0.75);margin-bottom:2px;transition:background .15s ease, color .15s ease;}\n");
      out.write("  .nav-list li a .ic{width:16px;text-align:center;font-size:13px;}\n");
      out.write("  .nav-list li a .count{margin-left:auto;font-family:'IBM Plex Mono',monospace;font-size:10px;font-weight:600;color:rgba(234,240,232,0.45);}\n");
      out.write("  .nav-list li a:hover{background:rgba(255,255,255,0.07);color:#fff;}\n");
      out.write("  .nav-list li.active a{background:var(--saffron);color:var(--ink);font-weight:700;}\n");
      out.write("  .nav-list li.active a .count{color:var(--ink);opacity:0.6;}\n");
      out.write("\n");
      out.write("  .sidebar-foot{padding:14px 20px 18px;border-top:1px solid rgba(255,255,255,0.08);}\n");
      out.write("  .sidebar-foot a{display:flex;align-items:center;gap:9px;font-size:12px;color:rgba(234,240,232,0.55);}\n");
      out.write("  .sidebar-foot a:hover{color:#fff;}\n");
      out.write("\n");
      out.write("  .main{flex:1;min-width:0;display:flex;flex-direction:column;}\n");
      out.write("  .topbar{display:flex;align-items:center;gap:16px;padding:14px 28px;background:var(--card);border-bottom:1px solid var(--line);}\n");
      out.write("  .sidebar-toggle{border:1px solid var(--line);background:var(--card);width:34px;height:34px;border-radius:8px;display:flex;align-items:center;justify-content:center;cursor:pointer;color:var(--ink);font-size:14px;flex-shrink:0;}\n");
      out.write("  .sidebar-toggle:hover{background:var(--paper);}\n");
      out.write("  .search-box{flex:1;max-width:380px;display:flex;align-items:center;gap:9px;background:var(--paper);border:1px solid var(--line);border-radius:8px;padding:8px 13px;}\n");
      out.write("  .search-box input{border:none;background:none;outline:none;flex:1;font-size:13px;color:var(--ink);}\n");
      out.write("  .search-box i{color:var(--muted);font-size:13px;}\n");
      out.write("  .top-right{margin-left:auto;display:flex;align-items:center;gap:16px;}\n");
      out.write("  .top-right .ic-btn{position:relative;color:var(--muted);font-size:15px;cursor:pointer;}\n");
      out.write("  .top-right .ic-btn .dot{position:absolute;top:-2px;right:-3px;width:6px;height:6px;border-radius:50%;background:var(--advisory);}\n");
      out.write("  .top-right .avatar{display:flex;align-items:center;gap:8px;}\n");
      out.write("  .top-right .avatar img{width:30px;height:30px;border-radius:50%;object-fit:cover;border:1.5px solid var(--saffron);}\n");
      out.write("  .top-right .avatar span{font-size:12.5px;font-weight:600;}\n");
      out.write("\n");
      out.write("  .content{padding:24px 28px 36px;flex:1;}\n");
      out.write("  .site-footer{background:var(--ink);color:rgba(234,240,232,0.7);padding:18px 28px;display:flex;align-items:center;gap:24px;flex-wrap:wrap;margin-top:auto;}\n");
      out.write("  .site-footer .f-brand{display:flex;align-items:center;gap:9px;font-family:'Fraunces',serif;color:#fff;font-weight:600;font-size:13px;}\n");
      out.write("  .site-footer .f-brand .f-mark{width:22px;height:22px;border-radius:6px;background:var(--saffron);color:var(--ink);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;}\n");
      out.write("  .site-footer .f-links{display:flex;gap:16px;flex-wrap:wrap;}\n");
      out.write("  .site-footer .f-links a{font-size:11.5px;font-weight:500;color:rgba(234,240,232,0.65);}\n");
      out.write("  .site-footer .f-links a:hover{color:#fff;}\n");
      out.write("  .site-footer .f-meta{margin-left:auto;display:flex;gap:14px;font-size:11px;color:rgba(234,240,232,0.45);}\n");
      out.write("\n");
      out.write("  @media (max-width:640px){\n");
      out.write("    .app-shell:not(.collapsed) .sidebar{position:fixed;left:0;top:0;bottom:0;z-index:30;box-shadow:8px 0 24px rgba(0,0,0,0.2);}\n");
      out.write("    .site-footer .f-meta{margin-left:0;}\n");
      out.write("  }\n");
      out.write("\n");
      out.write("  .table-wrap{background:var(--card);border:1px solid var(--line);border-radius:14px;margin:24px auto;max-width:1150px;overflow-x:auto;box-shadow:0 4px 18px rgba(15,61,48,0.06);}\n");
      out.write("  .contact-table{width:100%;border-collapse:collapse;min-width:1100px;font-size:13px;}\n");
      out.write("  .contact-table thead th{background:var(--ink);color:#EAF0E8;font-family:'IBM Plex Mono',monospace;font-size:11px;letter-spacing:0.8px;text-transform:uppercase;font-weight:600;padding:13px 14px;text-align:left;white-space:nowrap;}\n");
      out.write("  .contact-table thead th:first-child{border-top-left-radius:14px;}\n");
      out.write("  .contact-table thead th:last-child{border-top-right-radius:14px;}\n");
      out.write("  .contact-table tbody tr{border-bottom:1px solid var(--line);transition:background .15s ease;}\n");
      out.write("  .contact-table tbody tr:last-child{border-bottom:none;}\n");
      out.write("  .contact-table tbody tr:hover{background:var(--teal-tint);}\n");
      out.write("  .contact-table tbody tr:nth-child(even){background:#FAFDFC;}\n");
      out.write("  .contact-table tbody tr:nth-child(even):hover{background:var(--teal-tint);}\n");
      out.write("  .contact-table td{padding:12px 14px;color:#000000;font-weight:700;vertical-align:middle;white-space:nowrap;}\n");
      out.write("  .contact-table td.msg-cell{white-space:normal;max-width:220px;}\n");
      out.write("  .contact-table td.action-cell{text-align:center;}\n");
      out.write("  .rating-stars{color:var(--saffron);letter-spacing:2px;font-weight:700;}\n");
      out.write("\n");
      out.write("  .icon-btn{display:inline-flex;align-items:center;justify-content:center;width:34px;height:34px;border-radius:50%;transition:transform .15s ease, box-shadow .15s ease;}\n");
      out.write("  .icon-btn:hover{transform:translateY(-2px);}\n");
      out.write("  .icon-btn.delete-btn{background:var(--rose);box-shadow:0 3px 10px rgba(214,72,107,0.35);}\n");
      out.write("  .icon-btn.delete-btn i{color:#fff;font-size:14px;}\n");
      out.write("  .icon-btn.whatsapp-btn{background:#25D366;box-shadow:0 3px 10px rgba(37,211,102,0.35);}\n");
      out.write("  .icon-btn.whatsapp-btn i{color:#fff;font-size:15px;}\n");
      out.write("\n");
      out.write("  .table-center-row{display:flex;justify-content:center;padding:24px 20px;}\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("   ");

String admin = (String)session.getAttribute("ad");

if(admin == null || admin.equals(""))
{

      out.write("\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("alert(\"Please first login then go to admin zone\");\n");
      out.write("window.location.href=\"../../TOURISM_PROJECT/login.html\";\n");
      out.write("</script>\n");
      out.write("\n");

return;
}

      out.write("\n");
      out.write("\n");
      out.write("<div class=\"advisory-bar\" id=\"advisoryBar\">\n");
      out.write("  <div class=\"advisory-tag\"><i class=\"fa-solid fa-triangle-exclamation\"></i> Advisory</div>\n");
      out.write("  <div class=\"advisory-track\">\n");
      out.write("    <div class=\"advisory-scroll\">\n");
      out.write("      <span><i class=\"fa-solid fa-cloud-showers-heavy\"></i> Monsoon watch: Kerala backwater routes may see delays this week</span>\n");
      out.write("      <span><i class=\"fa-solid fa-arrow-trend-up\"></i> Festival surge: Jaipur Heritage Walk bookings up 40% this month</span>\n");
      out.write("      <span><i class=\"fa-solid fa-mountain\"></i> Manali high-altitude passes reopening ? update guide rosters</span>\n");
      out.write("      <span><i class=\"fa-solid fa-umbrella-beach\"></i> Goa coastal packages fully booked through the weekend</span>\n");
      out.write("      <span><i class=\"fa-solid fa-bell\"></i> 12 new enquiries awaiting a response</span>\n");
      out.write("    </div>\n");
      out.write("  </div>\n");
      out.write("  <button class=\"advisory-close\" id=\"advisoryClose\" title=\"Dismiss advisories\" aria-label=\"Dismiss advisories\"><i class=\"fa-solid fa-xmark\"></i></button>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<div class=\"app-shell\" id=\"appShell\">\n");
      out.write("\n");
      out.write("  <nav class=\"sidebar\" id=\"sidebar\" aria-label=\"Admin navigation\">\n");
      out.write("    <div class=\"brand-row\">\n");
      out.write("      <div class=\"brand-mark\"><i class=\"fa-solid fa-mountain-sun\"></i></div>\n");
      out.write("      <div>\n");
      out.write("        <h1>Sahyatri</h1>\n");
      out.write("        <div class=\"sub\">Tourism Admin</div>\n");
      out.write("      </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"nav-scroll\">\n");
      out.write("      <div class=\"nav-eyebrow\">Operations</div>\n");
      out.write("      <ul class=\"nav-list\">\n");
      out.write("        <li><a href=\"dashboard.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-gauge-high\"></i></span> Dashboard</a></li>\n");
      out.write("        <li><a href=\"contactmgmt.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-address-book\"></i></span> Contact Data</a></li>\n");
      out.write("        <li><a href=\"Enquirymgmt.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-comment-dots\"></i></span> Enquiry Data</a></li>\n");
      out.write("        <li><a href=\"Registrationmgmt.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-clipboard-list\"></i></span> Registration Data</a></li>\n");
      out.write("        <li class=\"active\"><a href=\"Reviewmgmt.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-star\"></i></span> Review Data</a></li>\n");
      out.write("      </ul>\n");
      out.write("\n");
      out.write("      <div class=\"nav-eyebrow\">Account</div>\n");
      out.write("      <ul class=\"nav-list\">\n");
      out.write("        <li><a href=\"changepassword.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-lock\"></i></span> Change Password</a></li>\n");
      out.write("        <li><a href=\"profilemgmt.jsp\"><span class=\"ic\"><i class=\"fa-solid fa-user\"></i></span> Profile</a></li>\n");
      out.write("      </ul>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"sidebar-foot\">\n");
      out.write("      <a href=\"../login.html\"><i class=\"fa-solid fa-right-from-bracket\"></i> Logout</a>\n");
      out.write("    </div>\n");
      out.write("  </nav>\n");
      out.write("\n");
      out.write("  <div class=\"main\">\n");
      out.write("    <div class=\"topbar\">\n");
      out.write("      <button class=\"sidebar-toggle\" id=\"sidebarToggle\"><i class=\"fa-solid fa-bars\"></i></button>\n");
      out.write("      <div class=\"search-box\">\n");
      out.write("        <i class=\"fa-solid fa-magnifying-glass\"></i>\n");
      out.write("        <input type=\"search\" placeholder=\"Search bookings, travelers, packages...\">\n");
      out.write("      </div>\n");
      out.write("      <div class=\"top-right\">\n");
      out.write("        <div class=\"avatar\">\n");
      out.write("          <img src=\"images/imgsri.jpeg\" alt=\"Admin avatar\">\n");
      out.write("          <span>Srishti</span>\n");
      out.write("        </div>\n");
      out.write("      </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"content\">\n");
      out.write("\n");
      out.write("      <marquee direction=\"right\">\n");
      out.write("          <h2>WELCOME MY REVIEW MANAGEMENT PAGE</h2>\n");
      out.write("      </marquee>\n");
      out.write("\n");
      out.write("      <div class=\"table-center-row\">\n");
      out.write("        <div class=\"table-wrap\">\n");
      out.write("          <table class=\"contact-table\">\n");
      out.write("            <thead>\n");
      out.write("              <tr>\n");
      out.write("                <th>Full Name</th>\n");
      out.write("                <th>Email</th>\n");
      out.write("                <th>Destination</th>\n");
      out.write("                <th>Travel Date</th>\n");
      out.write("                <th>Rating</th>\n");
      out.write("                <th>Feedback Title</th>\n");
      out.write("                <th>Feedback Message</th>\n");
      out.write("                <th>Delete</th>\n");
      out.write("                <th>Response</th>\n");
      out.write("              </tr>\n");
      out.write("            </thead>\n");
      out.write("            <tbody>\n");
      out.write("              ");

                connectionManager cm = new connectionManager();
                String command = "select * from feedback";
                ResultSet rs = cm.getData(command);

                while(rs.next())
                {
                    int ratingValue = 0;
                    try { ratingValue = Integer.parseInt(rs.getString(5).trim()); } catch(Exception e) { ratingValue = 0; }
                    String stars = "";
                    for(int i=1;i<=5;i++){
                        stars += (i <= ratingValue) ? "&#9733;" : "&#9734;";
                    }
              
      out.write("\n");
      out.write("              <tr>\n");
      out.write("                <td>");
      out.print(rs.getString(1));
      out.write("</td>\n");
      out.write("                <td>");
      out.print(rs.getString(2));
      out.write("</td>\n");
      out.write("                <td>");
      out.print(rs.getString(3));
      out.write("</td>\n");
      out.write("                <td>");
      out.print(rs.getString(4));
      out.write("</td>\n");
      out.write("                <td><span class=\"rating-stars\">");
      out.print(stars);
      out.write("</span></td>\n");
      out.write("                <td>");
      out.print(rs.getString(6));
      out.write("</td>\n");
      out.write("                <td class=\"msg-cell\">");
      out.print(rs.getString(7));
      out.write("</td>\n");
      out.write("                <td class=\"action-cell\">\n");
      out.write("                  <a href=\"../codes/deleterev.jsp?d=");
      out.print(rs.getString(2));
      out.write("\" class=\"icon-btn delete-btn\" title=\"Delete\">\n");
      out.write("                    <i class=\"fa fa-trash\"></i>\n");
      out.write("                  </a>\n");
      out.write("                </td>\n");
      out.write("                <td class=\"action-cell\">\n");
      out.write("                  <a href=\"https://api.whatsapp.com/send?text=Hello\" class=\"icon-btn whatsapp-btn\" title=\"Message on WhatsApp\" target=\"_blank\" rel=\"noopener\">\n");
      out.write("                    <i class=\"fab fa-whatsapp\"></i>\n");
      out.write("                  </a>\n");
      out.write("                </td>\n");
      out.write("              </tr>\n");
      out.write("              ");

                }
              
      out.write("\n");
      out.write("            </tbody>\n");
      out.write("          </table>\n");
      out.write("        </div>\n");
      out.write("      </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <footer class=\"site-footer\">\n");
      out.write("      <div class=\"f-brand\"><span class=\"f-mark\"><i class=\"fa-solid fa-mountain-sun\"></i></span> Sahyatri Admin</div>\n");
      out.write("      <div class=\"f-links\">\n");
      out.write("        <a href=\"dashboard.jsp\">Dashboard</a>\n");
      out.write("        <a href=\"contactmgmt.jsp\">Contacts</a>\n");
      out.write("        <a href=\"Enquirymgmt.jsp\">Enquiries</a>\n");
      out.write("        <a href=\"Registrationmgmt.jsp\">Registrations</a>\n");
      out.write("        <a href=\"Reviewmgmt.jsp\">Reviews</a>\n");
      out.write("      </div>\n");
      out.write("      <div class=\"f-meta\">\n");
      out.write("        <span>Support: 24×7</span>\n");
      out.write("        <span>© 2026 Sahyatri Tourism</span>\n");
      out.write("      </div>\n");
      out.write("    </footer>\n");
      out.write("  </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("  const appShell = document.getElementById('appShell');\n");
      out.write("  const sidebarToggle = document.getElementById('sidebarToggle');\n");
      out.write("  if(sidebarToggle){\n");
      out.write("    sidebarToggle.addEventListener('click', function(){\n");
      out.write("      appShell.classList.toggle('collapsed');\n");
      out.write("    });\n");
      out.write("  }\n");
      out.write("  const advisoryBar = document.getElementById('advisoryBar');\n");
      out.write("  const advisoryClose = document.getElementById('advisoryClose');\n");
      out.write("  if(advisoryClose){\n");
      out.write("    advisoryClose.addEventListener('click', function(){\n");
      out.write("      advisoryBar.classList.add('hidden');\n");
      out.write("    });\n");
      out.write("  }\n");
      out.write("</script>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
