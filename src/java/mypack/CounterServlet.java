package mypack;   // <-- agar tumhari purani CounterServlet.java me alag package likha hai to wahi rakhna

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// NOTE: agar web.xml me CounterServlet ka <servlet-mapping> pehle se hai, to neeche wali @WebServlet line hata dena
@WebServlet("/CounterServlet")
public class CounterServlet extends HttpServlet {

    /* ===== CONFIG: yahan apne table / column ke naam check karo ===== */
    // Happy Travelers = feedback (review) table ki count
    static final String TRAVELERS_SQL = "SELECT COUNT(*) FROM feedback";
    // States & UTs Covered = bookings me alag-alag destinations/states ki count
    static final String STATES_SQL    = "SELECT COUNT(DISTINCT destination) FROM bookings";
    // review.html ka "Reviews collected so far" = feedback (review) table ki count
    static final String REVIEWS_SQL   = "SELECT COUNT(*) FROM feedback";
    // Traveler Rating = feedback ki average rating
    static final String RATING_SQL    = "SELECT AVG(rating) FROM feedback";

    // connectionManager me jo bhi method String leke ResultSet deta hai, wahi auto-detect hoga
    private ResultSet runQuery(String sql) throws Exception {
        mypack.connectionManager cm = new mypack.connectionManager();
        for (java.lang.reflect.Method m : cm.getClass().getMethods()) {
            Class<?>[] p = m.getParameterTypes();
            if (p.length == 1 && p[0] == String.class && ResultSet.class.isAssignableFrom(m.getReturnType())) {
                return (ResultSet) m.invoke(cm, sql);
            }
        }
        throw new Exception("connectionManager me ResultSet dene wala method nahi mila");
    }

    // Value mile to number, fail ho to "null" (index.html me 0 hi rahega)
    private String value(String sql, boolean decimal) {
        try {
            ResultSet rs = runQuery(sql);
            if (rs.next()) {
                double v = rs.getDouble(1);
                if (rs.wasNull()) return "null";
                return decimal ? String.format(java.util.Locale.ENGLISH, "%.1f", v) : String.valueOf((long) v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "null";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"travelers\":" + value(TRAVELERS_SQL, false)
                    + ",\"states\":"    + value(STATES_SQL, false)
                    + ",\"rating\":"    + value(RATING_SQL, true)
                    + ",\"reviews\":"   + value(REVIEWS_SQL, false) + "}");
        }
    }
}
