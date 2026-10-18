package mypack;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/*
 * "/Adminzone/*" ke saare pages ko protect karta hai
 * taaki customer ya bina-login visitor seedha dashboard.jsp
 * (ya Adminzone ki koi bhi file) URL se na khol sake.
 *
 * NOTE: Folder ka naam "Adminzone" hai (capital A) — urlPattern
 * me case exactly match karna zaroori hai, warna Tomcat/Linux
 * deployment par filter kaam nahi karega.
 */
@WebFilter(urlPatterns = {"/Adminzone/*"})
public class AdminCheckFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String contextPath = request.getContextPath();

        Object roleAttr = (session != null) ? session.getAttribute("role") : null;

        if (roleAttr != null && roleAttr.toString().equals("admin")) {
            chain.doFilter(req, res);
        } else {
            // Customer ya non-logged-in user -> login page par bhej do
            response.sendRedirect(contextPath + "/login.html");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) { }

    @Override
    public void destroy() { }
}
