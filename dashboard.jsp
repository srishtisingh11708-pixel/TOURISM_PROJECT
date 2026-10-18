<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mypack.connectionManager"%>
<%@page import="java.sql.ResultSet" %>
<%!
  /* =====================================================================
     CONFIG - sirf yahin apne table / column ke naam check karo
     (baaki poore page me kahin change karne ki zarurat nahi)
     ===================================================================== */
  // Table names (jo tumne bataye)
  static final String T_BOOK    = "bookings";
  static final String T_CONTACT = "contact";
  static final String T_ENQ     = "enquiry";
  static final String T_FB      = "feedback";
  static final String T_REG     = "reg";

  // Har table ka DATE / DATETIME column (chart aur "last 7 days" ke liye)
  static final String D_BOOK    = "booking_date";
  static final String D_CONTACT = "created_at";
  static final String D_ENQ     = "created_at";
  static final String D_FB      = "created_at";
  static final String D_REG     = "created_at";

  // bookings table ke columns (Recent Bookings list ke liye)
  static final String BK_ID      = "id";
  static final String BK_NAME    = "name";
  static final String BK_PACKAGE = "destination";
  static final String BK_DATE    = "booking_date";

  // feedback table ka rating column (1 se 5)
  static final String FB_RATING  = "rating";

  /* =====================================================================
     DB helper - connectionManager sirf yahin use ho raha hai.
     Agar tumhari connectionManager class me method ka naam alag hai
     (jaise selectData / getData), to bas neeche wali ek line badlo.
     ===================================================================== */
  ResultSet runQuery(String sql) throws Exception {
      connectionManager cm = new connectionManager();
      // connectionManager me jo bhi method "String lekar ResultSet deta hai", wahi auto-detect karke chalega.
      // (Method ka naam pata chal jaye to yahan seedha cm.tumharaMethod(sql) likh sakti ho.)
      for(java.lang.reflect.Method m : cm.getClass().getMethods()){
          Class<?>[] p = m.getParameterTypes();
          if(p.length == 1 && p[0] == String.class && ResultSet.class.isAssignableFrom(m.getReturnType())){
              return (ResultSet) m.invoke(cm, sql);
          }
      }
      throw new Exception("connectionManager me ResultSet dene wala method nahi mila");
  }

  // COUNT(*) type query ke liye. Error aaye to -1 (matlab data nahi mila)
  int getInt(String sql){
      try{
          ResultSet rs = runQuery(sql);
          if(rs.next()) return rs.getInt(1);
          return 0;
      }catch(Exception e){ return -1; }
  }

  // AVG(rating) ke liye. Data na ho to -1
  double getAvg(String sql){
      try{
          ResultSet rs = runQuery(sql);
          if(rs.next()){
              double v = rs.getDouble(1);
              if(rs.wasNull()) return -1;
              return v;
          }
          return -1;
      }catch(Exception e){ return -1; }
  }

  // Last N din ka day-wise count (index 0 = sabse purana din)
  int[] dailyCounts(String table, String col, int days){
      int[] out = new int[days];
      try{
          ResultSet rs = runQuery("SELECT DATE("+col+") d, COUNT(*) c FROM "+table+
              " WHERE DATE("+col+") >= DATE_SUB(CURDATE(), INTERVAL "+(days-1)+" DAY) GROUP BY DATE("+col+")");
          java.time.LocalDate start = java.time.LocalDate.now().minusDays(days-1);
          while(rs.next()){
              java.sql.Date d = rs.getDate(1);
              if(d == null) continue;
              long idx = java.time.temporal.ChronoUnit.DAYS.between(start, d.toLocalDate());
              if(idx >= 0 && idx < days) out[(int)idx] = rs.getInt(2);
          }
      }catch(Exception e){ /* column/table galat ho to zero dikhega */ }
      return out;
  }

  // Last 12 mahine ka month-wise count (index 11 = current month)
  int[] monthlyCounts(String table, String col){
      int[] out = new int[12];
      try{
          ResultSet rs = runQuery("SELECT YEAR("+col+") y, MONTH("+col+") m, COUNT(*) c FROM "+table+
              " WHERE "+col+" >= DATE_SUB(DATE_FORMAT(CURDATE(),'%Y-%m-01'), INTERVAL 11 MONTH)"+
              " GROUP BY YEAR("+col+"), MONTH("+col+")");
          java.time.YearMonth cur = java.time.YearMonth.now();
          while(rs.next()){
              java.time.YearMonth ym = java.time.YearMonth.of(rs.getInt(1), rs.getInt(2));
              long idx = 11 - java.time.temporal.ChronoUnit.MONTHS.between(ym, cur);
              if(idx >= 0 && idx < 12) out[(int)idx] = rs.getInt(3);
          }
      }catch(Exception e){ }
      return out;
  }

  String[] dayLabels(int days){
      String[] a = new String[days];
      java.time.LocalDate start = java.time.LocalDate.now().minusDays(days-1);
      java.time.format.DateTimeFormatter f = java.time.format.DateTimeFormatter.ofPattern("dd MMM", java.util.Locale.ENGLISH);
      for(int i=0;i<days;i++) a[i] = start.plusDays(i).format(f);
      return a;
  }
  String[] monthLabels(){
      String[] a = new String[12];
      java.time.YearMonth cur = java.time.YearMonth.now();
      java.time.format.DateTimeFormatter f = java.time.format.DateTimeFormatter.ofPattern("MMM yy", java.util.Locale.ENGLISH);
      for(int i=0;i<12;i++) a[i] = cur.minusMonths(11-i).format(f);
      return a;
  }

  String jsArr(int[] a){
      StringBuilder sb = new StringBuilder("[");
      for(int i=0;i<a.length;i++){ if(i>0) sb.append(","); sb.append(a[i]); }
      return sb.append("]").toString();
  }
  String jsStrArr(String[] a){
      StringBuilder sb = new StringBuilder("[");
      for(int i=0;i<a.length;i++){ if(i>0) sb.append(","); sb.append("\"").append(a[i]).append("\""); }
      return sb.append("]").toString();
  }

  // HTML safe banane ke liye
  String esc(String s){
      if(s == null) return "";
      return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
  }
  // Column na mile to empty string (page crash nahi hoga)
  String safe(ResultSet rs, String col){
      try{ String v = rs.getString(col); return v == null ? "" : v; }catch(Exception e){ return ""; }
  }
  String initial(String s){
      if(s == null || s.trim().length() == 0) return "?";
      return s.trim().substring(0,1).toUpperCase();
  }
  String num(int n){ return n < 0 ? "&mdash;" : String.valueOf(n); }

  // Ek stat card ka HTML banata hai
  String statCard(String cls, String icon, String label, int total, int week, String link){
      StringBuilder sb = new StringBuilder();
      sb.append("<a class=\"stat-card ").append(cls).append("\" href=\"").append(link).append("\">");
      sb.append("<div class=\"sc-ic\"><i class=\"fa-solid ").append(icon).append("\"></i></div>");
      sb.append("<div class=\"sc-label\">").append(label).append("</div>");
      sb.append("<div class=\"sc-row\"><span class=\"sc-num\">").append(num(total)).append("</span>");
      if(week >= 0){
          sb.append("<span class=\"sc-delta\"><i class=\"fa-solid fa-arrow-trend-up\"></i> +").append(week).append("</span>");
      }
      sb.append("</div>");
      sb.append("<div class=\"sc-sub\">").append(week >= 0 ? "Last 7 days" : "All time").append("</div>");
      sb.append("</a>");
      return sb.toString();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Sahyatri — Tourism Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
  :root{
    --ink:#0F3D30;
    --ink-soft:#155843;
    --paper:#FFFFFF;
    --card:#FFFFFF;
    --saffron:#E8A33D;
    --teal:#17A673;
    --teal-tint:#EAF7F1;
    --advisory:#C1502E;
    --line:#DCEBE3;
    --muted:#5E7A6D;
    --sidebar-w:230px;

    --blue:#2F6FED;
    --blue-tint:#EAF1FE;
    --purple:#7C5CFC;
    --purple-tint:#F1EEFE;
    --amber:#E8A33D;
    --amber-tint:#FDF3E3;
    --rose:#D6486B;
    --rose-tint:#FBEAEF;
    --slate:#5E6B7A;
    --slate-tint:#EEF1F4;
  }
  *{box-sizing:border-box;}
  body{margin:0;background:var(--teal-tint);color:var(--ink);font-family:'Inter',sans-serif;font-size:13.5px;-webkit-font-smoothing:antialiased;}
  a{text-decoration:none;color:inherit;}
  ul{margin:0;padding:0;list-style:none;}
  button{font-family:'Inter',sans-serif;}
  @media (prefers-reduced-motion:reduce){ *{animation:none !important; transition:none !important;} }

  .advisory-bar{
    background:var(--ink);color:#F5EFE3;display:flex;align-items:stretch;
    font-size:12px;overflow:hidden;position:relative;
  }
  .advisory-tag{
    flex-shrink:0;display:flex;align-items:center;gap:7px;padding:9px 16px;
    background:var(--advisory);font-weight:700;font-family:'IBM Plex Mono',monospace;
    font-size:10.5px;letter-spacing:1px;text-transform:uppercase;
  }
  .advisory-track{flex:1;overflow:hidden;position:relative;}
  .advisory-scroll{
    display:flex;gap:48px;white-space:nowrap;padding:9px 0;
    animation:ticker 32s linear infinite;width:max-content;
  }
  .advisory-track:hover .advisory-scroll{animation-play-state:paused;}
  @keyframes ticker{ from{transform:translateX(0);} to{transform:translateX(-50%);} }
  .advisory-scroll span{display:inline-flex;align-items:center;gap:8px;color:rgba(245,239,227,0.9);}
  .advisory-close{
    flex-shrink:0;border:none;background:none;color:rgba(245,239,227,0.55);cursor:pointer;
    padding:0 16px;font-size:14px;
  }
  .advisory-close:hover{color:#fff;}
  .advisory-bar.hidden{display:none;}

  .app-shell{display:flex;min-height:100vh;}

  .sidebar{
    width:var(--sidebar-w);flex-shrink:0;background:var(--ink);color:#EAF0E8;
    display:flex;flex-direction:column;overflow:hidden;
    transition:width .25s ease, opacity .2s ease;
  }
  .sidebar > *{min-width:var(--sidebar-w);}
  .app-shell.collapsed .sidebar{width:0;opacity:0;}

  .brand-row{display:flex;align-items:center;gap:11px;padding:20px 20px 16px;}
  .brand-mark{
    width:34px;height:34px;border-radius:9px;background:var(--saffron);
    display:flex;align-items:center;justify-content:center;flex-shrink:0;
    font-size:16px;color:var(--ink);
  }
  .brand-row h1{font-family:'Fraunces',serif;font-size:17px;font-weight:600;margin:0;color:#fff;}
  .brand-row .sub{font-size:10px;color:rgba(234,240,232,0.5);letter-spacing:0.5px;text-transform:uppercase;margin-top:1px;}

  .nav-scroll{flex:1;overflow-y:auto;padding:8px 12px;}
  .nav-eyebrow{
    font-family:'IBM Plex Mono',monospace;font-size:10px;letter-spacing:1.5px;color:rgba(234,240,232,0.35);
    padding:14px 10px 6px;text-transform:uppercase;
  }
  .nav-list li a{
    display:flex;align-items:center;gap:11px;padding:9px 10px;border-radius:8px;
    font-size:13px;font-weight:500;color:rgba(234,240,232,0.75);margin-bottom:2px;
    transition:background .15s ease, color .15s ease;
  }
  .nav-list li a .ic{width:16px;text-align:center;font-size:13px;}
  .nav-list li a .count{
    margin-left:auto;font-family:'IBM Plex Mono',monospace;font-size:10px;font-weight:600;
    color:rgba(234,240,232,0.45);
  }
  .nav-list li a:hover{background:rgba(255,255,255,0.07);color:#fff;}
  .nav-list li.active a{background:var(--saffron);color:var(--ink);font-weight:700;}
  .nav-list li.active a .count{color:var(--ink);opacity:0.6;}

  .sidebar-foot{padding:14px 20px 18px;border-top:1px solid rgba(255,255,255,0.08);}
  .sidebar-foot a{display:flex;align-items:center;gap:9px;font-size:12px;color:rgba(234,240,232,0.55);}
  .sidebar-foot a:hover{color:#fff;}

  .main{flex:1;min-width:0;display:flex;flex-direction:column;}

  .topbar{
    display:flex;align-items:center;gap:16px;padding:14px 28px;background:var(--card);border-bottom:1px solid var(--line);
  }
  .sidebar-toggle{
    border:1px solid var(--line);background:var(--card);width:34px;height:34px;border-radius:8px;
    display:flex;align-items:center;justify-content:center;cursor:pointer;color:var(--ink);font-size:14px;flex-shrink:0;
  }
  .sidebar-toggle:hover{background:var(--paper);}
  .search-box{flex:1;max-width:380px;display:flex;align-items:center;gap:9px;background:var(--paper);border:1px solid var(--line);border-radius:8px;padding:8px 13px;}
  .search-box input{border:none;background:none;outline:none;flex:1;font-size:13px;color:var(--ink);}
  .search-box i{color:var(--muted);font-size:13px;}
  .top-right{margin-left:auto;display:flex;align-items:center;gap:16px;}
  .top-right .ic-btn{position:relative;color:var(--muted);font-size:15px;cursor:pointer;}
  .top-right .ic-btn .dot{position:absolute;top:-2px;right:-3px;width:6px;height:6px;border-radius:50%;background:var(--advisory);}
  .top-right .avatar{display:flex;align-items:center;gap:8px;}
  .top-right .avatar img{width:30px;height:30px;border-radius:50%;object-fit:cover;border:1.5px solid var(--saffron);}
  .top-right .avatar span{font-size:12.5px;font-weight:600;}

  .content{padding:24px 28px 36px;flex:1;}

  /* ================= OVERVIEW (naya middle section) ================= */
  .ov-head h2{font-family:'Fraunces',serif;font-size:26px;font-weight:700;margin:0;color:var(--ink);}
  .ov-head p{margin:3px 0 20px;color:var(--muted);font-size:12.5px;}

  /* stat cards */
  .stat-grid{display:grid;grid-template-columns:repeat(5,1fr);gap:16px;margin-bottom:22px;}
  .stat-card{
    display:block;background:var(--card);border:1px solid var(--line);border-radius:16px;padding:16px 16px 14px;
    box-shadow:0 6px 18px rgba(15,61,48,0.06);
    transition:transform .18s ease, box-shadow .18s ease, border-color .18s ease;
  }
  .stat-card:hover{transform:translateY(-3px);box-shadow:0 14px 26px rgba(15,61,48,0.12);}
  .sc-ic{width:38px;height:38px;border-radius:11px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:16px;margin-bottom:14px;}
  .sc-label{font-size:12px;font-weight:600;color:var(--muted);}
  .sc-row{display:flex;align-items:baseline;gap:10px;margin-top:4px;}
  .sc-num{font-size:26px;font-weight:700;color:var(--ink);line-height:1.1;}
  .sc-delta{font-size:11px;font-weight:700;color:var(--teal);white-space:nowrap;}
  .sc-sub{font-size:10.5px;color:var(--muted);margin-top:6px;}
  .sc-book .sc-ic{background:var(--saffron);}
  .sc-enq  .sc-ic{background:var(--blue);}
  .sc-reg  .sc-ic{background:var(--teal);}
  .sc-contact .sc-ic{background:var(--purple);}
  .sc-review .sc-ic{background:var(--rose);}
  .sc-book:hover{border-color:var(--saffron);} .sc-enq:hover{border-color:var(--blue);}
  .sc-reg:hover{border-color:var(--teal);} .sc-contact:hover{border-color:var(--purple);}
  .sc-review:hover{border-color:var(--rose);}

  /* main grid */
  .ov-grid{display:grid;grid-template-columns:minmax(0,1fr) 340px;gap:22px;align-items:start;}

  .panel{background:var(--card);border:1px solid var(--line);border-radius:18px;padding:20px 22px;box-shadow:0 6px 18px rgba(15,61,48,0.05);}
  .panel-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;gap:10px;}
  .panel-head h3{font-family:'Fraunces',serif;font-size:17px;font-weight:600;margin:0;}
  .panel-head .see-all{font-size:11.5px;color:var(--teal);font-weight:600;}

  /* chart panel */
  .chart-top{display:flex;justify-content:space-between;align-items:flex-end;flex-wrap:wrap;gap:12px;margin-bottom:6px;}
  .range-toggle{display:flex;gap:4px;align-items:center;}
  .range-toggle button{border:none;background:none;padding:6px 12px;border-radius:20px;font-size:11.5px;font-weight:600;color:var(--muted);cursor:pointer;transition:background .15s ease,color .15s ease;}
  .range-toggle button:hover{color:var(--ink);}
  .range-toggle button.on{background:var(--blue);color:#fff;}
  .chart-total{text-align:right;}
  .chart-total .lbl{font-size:11px;color:var(--muted);font-weight:600;}
  .chart-total .val{font-size:22px;font-weight:700;color:var(--ink);}
  .chart-total .per{font-size:10.5px;color:var(--muted);font-weight:500;}
  .legend-row{display:flex;gap:18px;margin:8px 0 6px;font-size:11.5px;color:var(--muted);font-weight:500;}
  .legend-row span{display:inline-flex;align-items:center;gap:6px;}
  .legend-row i{width:8px;height:8px;border-radius:50%;display:inline-block;}
  .chart-wrap{height:270px;position:relative;}

  /* satisfaction panel */
  .sat-panel{background:linear-gradient(180deg,#F3F7FF 0%,#E6EEFC 100%);border-color:#D6E3FA;margin-bottom:22px;}
  .sat-panel h3{font-size:15px;}
  .gauge-wrap{position:relative;height:150px;margin:6px auto 0;max-width:260px;}
  .gauge-text{position:absolute;left:0;right:0;bottom:2px;text-align:center;}
  .gauge-text .t{font-size:10.5px;color:var(--muted);font-weight:600;}
  .gauge-text .s{font-size:26px;font-weight:700;color:var(--ink);line-height:1.1;}
  .gauge-text .s small{font-size:14px;color:var(--muted);font-weight:600;}
  .sat-note{text-align:center;font-size:11.5px;color:var(--muted);margin:10px 8px 14px;}
  .sat-btn{
    display:block;text-align:center;background:#fff;border-radius:30px;padding:11px;font-weight:700;font-size:12.5px;color:var(--ink);
    box-shadow:0 6px 16px rgba(47,111,237,0.14);transition:transform .15s ease, box-shadow .15s ease;
  }
  .sat-btn:hover{transform:translateY(-2px);box-shadow:0 10px 20px rgba(47,111,237,0.22);}

  /* recent bookings */
  .rb-row{display:flex;align-items:center;gap:12px;padding:12px 4px;border-bottom:1px solid var(--line);border-radius:10px;transition:background .15s ease;}
  .rb-row:last-child{border-bottom:none;}
  .rb-row:hover{background:var(--teal-tint);}
  .rb-av{width:38px;height:38px;border-radius:50%;background:var(--amber-tint);color:var(--saffron);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;}
  .rb-row:nth-child(2n) .rb-av{background:var(--blue-tint);color:var(--blue);}
  .rb-row:nth-child(3n) .rb-av{background:var(--rose-tint);color:var(--rose);}
  .rb-row:nth-child(4n) .rb-av{background:var(--purple-tint);color:var(--purple);}
  .rb-body{flex:1;min-width:0;}
  .rb-name{font-size:13px;font-weight:700;color:var(--ink);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
  .rb-sub{font-size:11px;color:var(--muted);margin-top:1px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
  .rb-go{color:var(--muted);font-size:11px;}
  .empty-note{font-size:12px;color:var(--muted);padding:14px 4px;}

  .site-footer{
    background:var(--ink);color:rgba(234,240,232,0.7);
    padding:18px 28px;display:flex;align-items:center;gap:24px;flex-wrap:wrap;margin-top:auto;
  }
  .site-footer .f-brand{display:flex;align-items:center;gap:9px;font-family:'Fraunces',serif;color:#fff;font-weight:600;font-size:13px;}
  .site-footer .f-brand .f-mark{width:22px;height:22px;border-radius:6px;background:var(--saffron);color:var(--ink);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;}
  .site-footer .f-links{display:flex;gap:16px;flex-wrap:wrap;}
  .site-footer .f-links a{font-size:11.5px;font-weight:500;color:rgba(234,240,232,0.65);}
  .site-footer .f-links a:hover{color:#fff;}
  .site-footer .f-meta{margin-left:auto;display:flex;gap:14px;font-size:11px;color:rgba(234,240,232,0.45);}

  @media (max-width:1250px){ .stat-grid{grid-template-columns:repeat(3,1fr);} }
  @media (max-width:1050px){ .ov-grid{grid-template-columns:1fr;} }
  @media (max-width:640px){
    .app-shell:not(.collapsed) .sidebar{position:fixed;left:0;top:0;bottom:0;z-index:30;box-shadow:8px 0 24px rgba(0,0,0,0.2);}
    .stat-grid{grid-template-columns:repeat(2,1fr);}
    .content{padding:18px 16px 30px;}
    .site-footer .f-meta{margin-left:0;}
  }

  a:focus-visible, button:focus-visible, input:focus-visible{outline:2px solid var(--teal);outline-offset:2px;}
</style>
</head>
<body>
     <%
        try
        {
            if(session.getAttribute("ad").equals(""))
            {
                 out.print("<script>alert('Please first login then go my adminzoe');window.location.href='../../TOURISM_PROJECT/login.html'</script>");
            }
            else
            {
                
            }
        }
        catch(Exception ex)
        {
            out.print("<script>alert('Please first login then go my adminzoe');window.location.href='../../TOURISM_PROJECT/login.html'</script>");
        }

        /* ================= DATABASE SE REAL DATA ================= */
        // Total counts (poori table ka)
        int cBook    = getInt("SELECT COUNT(*) FROM " + T_BOOK);
        int cEnq     = getInt("SELECT COUNT(*) FROM " + T_ENQ);
        int cReg     = getInt("SELECT COUNT(*) FROM " + T_REG);
        int cContact = getInt("SELECT COUNT(*) FROM " + T_CONTACT);
        int cFb      = getInt("SELECT COUNT(*) FROM " + T_FB);

        // Last 7 din ke counts
        int wBook    = getInt("SELECT COUNT(*) FROM " + T_BOOK    + " WHERE DATE(" + D_BOOK    + ") >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)");
        int wEnq     = getInt("SELECT COUNT(*) FROM " + T_ENQ     + " WHERE DATE(" + D_ENQ     + ") >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)");
        int wReg     = getInt("SELECT COUNT(*) FROM " + T_REG     + " WHERE DATE(" + D_REG     + ") >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)");
        int wContact = getInt("SELECT COUNT(*) FROM " + T_CONTACT + " WHERE DATE(" + D_CONTACT + ") >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)");
        int wFb      = getInt("SELECT COUNT(*) FROM " + T_FB      + " WHERE DATE(" + D_FB      + ") >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)");

        // Average rating (feedback table se)
        double avgRating = getAvg("SELECT AVG(" + FB_RATING + ") FROM " + T_FB);
        String avgTxt = avgRating < 0 ? "0" : String.format(java.util.Locale.ENGLISH, "%.2f", avgRating);

        // Chart ka data: Week (7 din), Month (30 din), Year (12 mahine)
        String wLabels = jsStrArr(dayLabels(7));
        String mLabels = jsStrArr(dayLabels(30));
        String yLabels = jsStrArr(monthLabels());

        String wB = jsArr(dailyCounts(T_BOOK, D_BOOK, 7)),  mB = jsArr(dailyCounts(T_BOOK, D_BOOK, 30)),  yB = jsArr(monthlyCounts(T_BOOK, D_BOOK));
        String wE = jsArr(dailyCounts(T_ENQ,  D_ENQ,  7)),  mE = jsArr(dailyCounts(T_ENQ,  D_ENQ,  30)),  yE = jsArr(monthlyCounts(T_ENQ,  D_ENQ));
        String wR = jsArr(dailyCounts(T_REG,  D_REG,  7)),  mR = jsArr(dailyCounts(T_REG,  D_REG,  30)),  yR = jsArr(monthlyCounts(T_REG,  D_REG));
     %>

<!-- ADVISORY TICKER -->
<div class="advisory-bar" id="advisoryBar">
  <div class="advisory-tag"><i class="fa-solid fa-triangle-exclamation"></i> Advisory</div>
  <div class="advisory-track">
    <div class="advisory-scroll">
      <span><i class="fa-solid fa-cloud-showers-heavy"></i> Monsoon watch: Kerala backwater routes may see delays this week</span>
      <span><i class="fa-solid fa-arrow-trend-up"></i> Festival surge: Jaipur Heritage Walk bookings up 40% this month</span>
      <span><i class="fa-solid fa-mountain"></i> Manali high-altitude passes reopening — update guide rosters</span>
      <span><i class="fa-solid fa-umbrella-beach"></i> Goa coastal packages fully booked through the weekend</span>
      <span><i class="fa-solid fa-bell"></i> 12 new enquiries awaiting a response</span>
      <span><i class="fa-solid fa-cloud-showers-heavy"></i> Monsoon watch: Kerala backwater routes may see delays this week</span>
      <span><i class="fa-solid fa-arrow-trend-up"></i> Festival surge: Jaipur Heritage Walk bookings up 40% this month</span>
      <span><i class="fa-solid fa-mountain"></i> Manali high-altitude passes reopening — update guide rosters</span>
      <span><i class="fa-solid fa-umbrella-beach"></i> Goa coastal packages fully booked through the weekend</span>
      <span><i class="fa-solid fa-bell"></i> 12 new enquiries awaiting a response</span>
    </div>
  </div>
  <button class="advisory-close" id="advisoryClose" title="Dismiss advisories" aria-label="Dismiss advisories"><i class="fa-solid fa-xmark"></i></button>
</div>

<div class="app-shell" id="appShell">

  <!-- SIDEBAR (design same hai, bas counts ab database se aa rahe hain) -->
  <nav class="sidebar" id="sidebar" aria-label="Admin navigation">
    <div class="brand-row">
      <div class="brand-mark"><i class="fa-solid fa-mountain-sun"></i></div>
      <div>
        <h1>Sahyatri</h1>
        <div class="sub">Tourism Admin</div>
      </div>
    </div>

    <div class="nav-scroll">
      <div class="nav-eyebrow">Operations</div>
      <ul class="nav-list">
        <li class="active"><a href="dashboard.jsp" data-page="Dashboard"><span class="ic"><i class="fa-solid fa-gauge-high"></i></span> Dashboard</a></li>
        <li><a href="contactmgmt.jsp" data-page="Contact Data"><span class="ic"><i class="fa-solid fa-address-book"></i></span> Contact Data <span class="count"><%= cContact < 0 ? "-" : cContact %></span></a></li>
        <li><a href="Enquirymgmt.jsp" data-page="Enquiry Data"><span class="ic"><i class="fa-solid fa-comment-dots"></i></span> Enquiry Data <span class="count"><%= cEnq < 0 ? "-" : cEnq %></span></a></li>
        <li><a href="Registrationmgmt.jsp" data-page="Registration Data"><span class="ic"><i class="fa-solid fa-clipboard-list"></i></span> Registration Data <span class="count"><%= cReg < 0 ? "-" : cReg %></span></a></li>
        <li><a href="Reviewmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Review Data <span class="count"><%= cFb < 0 ? "-" : cFb %></span></a></li>
              <li><a href="bookmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Book Data<span class="count"><%= cBook < 0 ? "-" : cBook %></span></a></li>

      </ul>

      <div class="nav-eyebrow">Account</div>
      <ul class="nav-list">
        <li><a href="changepassword.jsp" data-page="Change Password"><span class="ic"><i class="fa-solid fa-lock"></i></span> Change Password</a></li>
        <li><a href="profilemgmt.jsp" data-page="Profile"><span class="ic"><i class="fa-solid fa-user"></i></span> Profile</a></li>
      </ul>
    </div>

    <div class="sidebar-foot">
      <a href="../login.html"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
  </nav>

  <!-- MAIN -->
  <div class="main">
    <div class="topbar">
      <button class="sidebar-toggle" id="sidebarToggle" title="Show/hide navigation" aria-label="Toggle sidebar"><i class="fa-solid fa-bars"></i></button>
      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="search" placeholder="Search bookings, travelers, packages...">
      </div>
      <div class="top-right">
        <span class="ic-btn"><i class="fa-solid fa-bell"></i><span class="dot"></span></span>
        <span class="ic-btn"><i class="fa-solid fa-envelope"></i><span class="dot"></span></span>
        <div class="avatar">
          <img src="images/imgsri.jpeg" alt="Admin avatar">
          <span>Srishti</span>
        </div>
      </div>
    </div>

    <div class="content">

      <!-- ================= OVERVIEW ================= -->
      <div class="ov-head">
        <h2>Overview</h2>
        <p>Whole data about your business here</p>
      </div>

      <!-- STAT CARDS (sab real counts) -->
      <div class="stat-grid">
        <%= statCard("sc-book",    "fa-suitcase-rolling", "Total Bookings",      cBook,    wBook,    "bookmgmt.jsp") %>
        <%= statCard("sc-enq",     "fa-comment-dots",     "Total Enquiries",     cEnq,     wEnq,     "Enquirymgmt.jsp") %>
        <%= statCard("sc-reg",     "fa-clipboard-list",   "Total Registrations", cReg,     wReg,     "Registrationmgmt.jsp") %>
        <%= statCard("sc-contact", "fa-address-book",     "Total Contacts",      cContact, wContact, "contactmgmt.jsp") %>
        <%= statCard("sc-review",  "fa-star",             "Total Reviews",       cFb,      wFb,      "Reviewmgmt.jsp") %>
      </div>

      <div class="ov-grid">

        <!-- LEFT: Activity chart -->
        <div class="panel">
          <div class="panel-head" style="margin-bottom:6px;">
            <h3>Activity Stat</h3>
            <div class="range-toggle" id="rangeToggle">
              <button data-range="week">Week</button>
              <button data-range="month" class="on">Month</button>
              <button data-range="year">Year</button>
            </div>
          </div>
          <div class="chart-top">
            <div class="legend-row">
              <span><i style="background:#2F6FED"></i> Bookings</span>
              <span><i style="background:#17A673"></i> Registrations</span>
              <span><i style="background:#E8A33D"></i> Enquiries</span>
            </div>
            <div class="chart-total">
              <div class="lbl">Total Bookings</div>
              <div class="val" id="totalVal">0</div>
              <div class="per" id="totalPer">Last 30 days</div>
            </div>
          </div>
          <div class="chart-wrap"><canvas id="reportChart"></canvas></div>
        </div>

        <!-- RIGHT: Satisfaction + Recent bookings -->
        <div>
          <div class="panel sat-panel">
            <div class="panel-head"><h3>Customers Satisfaction</h3></div>
            <div class="gauge-wrap">
              <canvas id="gaugeChart"></canvas>
              <div class="gauge-text">
                <div class="t">Total Score</div>
                <div class="s"><%= avgRating < 0 ? "&mdash;" : avgTxt %><small>/5</small></div>
              </div>
            </div>
            <div class="sat-note">
              <%= avgRating < 0 ? "Abhi tak koi rating nahi mili." : "Average rating " + cFb + " reviews ke basis par." %>
            </div>
            <a class="sat-btn" href="Reviewmgmt.jsp">See Customer Reviews</a>
          </div>

          <div class="panel">
            <div class="panel-head"><h3>Recent Bookings</h3><a class="see-all" href="bookmgmt.jsp">See all</a></div>
            <%
                boolean anyBooking = false;
                try{
                    ResultSet rb = runQuery("SELECT * FROM " + T_BOOK + " ORDER BY " + BK_ID + " DESC LIMIT 4");
                    while(rb.next()){
                        anyBooking = true;
                        String bName = safe(rb, BK_NAME);
                        String bPkg  = safe(rb, BK_PACKAGE);
                        String bDate = safe(rb, BK_DATE);
                        String bSub  = bPkg;
                        if(bDate.length() > 0) bSub = (bSub.length() > 0 ? bSub + " · " : "") + bDate;
            %>
            <a class="rb-row" href="bookmgmt.jsp">
              <div class="rb-av"><%= esc(initial(bName)) %></div>
              <div class="rb-body">
                <div class="rb-name"><%= esc(bName) %></div>
                <div class="rb-sub"><%= esc(bSub) %></div>
              </div>
              <i class="fa-solid fa-chevron-right rb-go"></i>
            </a>
            <%
                    }
                }catch(Exception e){ /* query fail ho to niche empty note dikhega */ }
                if(!anyBooking){
            %>
            <div class="empty-note">Abhi koi booking nahi hai.</div>
            <% } %>
          </div>
        </div>

      </div>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
      <div class="f-brand"><span class="f-mark"><i class="fa-solid fa-mountain-sun"></i></span> Sahyatri Admin</div>
      <div class="f-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="contactmgmt.jsp">Contacts</a>
        <a href="Enquirymgmt.jsp">Enquiries</a>
        <a href="Registrationmgmt.jsp">Registrations</a>
        <a href="Reviewmgmt.jsp">Reviews</a>
      </div>
      <div class="f-meta">
        <span>Support: 24×7</span>
        <span>© 2026 Sahyatri Tourism</span>
        <span>Developed by:Er.Srishti singh</span>

      </div>
    </footer>
  </div>
</div>

<script>
  const appShell = document.getElementById('appShell');
  document.getElementById('sidebarToggle').addEventListener('click', () => {
    appShell.classList.toggle('collapsed');
  });
  if (window.matchMedia('(max-width:640px)').matches){ appShell.classList.add('collapsed'); }

  document.querySelectorAll('.nav-list a[data-page]').forEach(link => {
    link.addEventListener('click', () => {
      document.querySelectorAll('.nav-list li').forEach(li => li.classList.remove('active'));
      link.closest('li').classList.add('active');
    });
  });

  document.getElementById('advisoryClose').addEventListener('click', () => {
    document.getElementById('advisoryBar').classList.add('hidden');
  });

  /* ================= ACTIVITY CHART (database ka real data) ================= */
  const RANGES = {
    week:  { label:'Last 7 days',   labels: <%= wLabels %>, book: <%= wB %>, reg: <%= wR %>, enq: <%= wE %> },
    month: { label:'Last 30 days',  labels: <%= mLabels %>, book: <%= mB %>, reg: <%= mR %>, enq: <%= mE %> },
    year:  { label:'Last 12 months',labels: <%= yLabels %>, book: <%= yB %>, reg: <%= yR %>, enq: <%= yE %> }
  };
  const sum = arr => arr.reduce((a,b) => a + b, 0);

  const chartCtx = document.getElementById('reportChart').getContext('2d');
  // Bookings line ke neeche halka blue gradient
  const grad = chartCtx.createLinearGradient(0, 0, 0, 270);
  grad.addColorStop(0, 'rgba(47,111,237,0.22)');
  grad.addColorStop(1, 'rgba(47,111,237,0)');

  const mkLine = (label, color, fill) => ({
    label: label, data: [], borderColor: color, backgroundColor: fill || color,
    fill: !!fill, tension: 0.4, borderWidth: 2.5, pointRadius: 0, pointHoverRadius: 5,
    pointBackgroundColor: '#fff', pointBorderColor: color, pointBorderWidth: 2
  });

  const activityChart = new Chart(chartCtx, {
    type: 'line',
    data: {
      labels: [],
      datasets: [
        mkLine('Bookings', '#2F6FED', grad),
        mkLine('Registrations', '#17A673'),
        mkLine('Enquiries', '#E8A33D')
      ]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      interaction: { mode: 'index', intersect: false },
      plugins: {
        legend: { display: false },
        tooltip: {
          backgroundColor: '#0F3D30', padding: 10, cornerRadius: 8, boxPadding: 4,
          titleFont: { family: 'Inter', size: 11 }, bodyFont: { family: 'Inter', size: 11 }
        }
      },
      scales: {
        y: { beginAtZero: true, ticks: { precision: 0, font: { size: 10 }, color: '#5E7A6D' },
             grid: { color: '#EEF3F0', borderDash: [4,4] }, border: { display: false } },
        x: { ticks: { font: { size: 10 }, color: '#5E7A6D', maxTicksLimit: 10 }, grid: { display: false }, border: { display: false } }
      }
    }
  });

  function setRange(key){
    const r = RANGES[key];
    activityChart.data.labels = r.labels;
    activityChart.data.datasets[0].data = r.book;
    activityChart.data.datasets[1].data = r.reg;
    activityChart.data.datasets[2].data = r.enq;
    activityChart.update();
    document.getElementById('totalVal').textContent = sum(r.book);
    document.getElementById('totalPer').textContent = r.label;
  }
  document.querySelectorAll('#rangeToggle button').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('#rangeToggle button').forEach(b => b.classList.remove('on'));
      btn.classList.add('on');
      setRange(btn.dataset.range);
    });
  });
  setRange('month');   // default: Month

  /* ================= SATISFACTION GAUGE (feedback ki average rating) ================= */
  const avg = <%= avgRating < 0 ? "0" : avgTxt %>;
  new Chart(document.getElementById('gaugeChart'), {
    type: 'doughnut',
    data: { datasets: [{ data: [avg, 5 - avg], backgroundColor: ['#2F6FED', '#D9E5FA'], borderWidth: 0, borderRadius: 6 }] },
    options: {
      rotation: -90, circumference: 180, cutout: '72%',
      responsive: true, maintainAspectRatio: false,
      plugins: { legend: { display: false }, tooltip: { enabled: false } }
    }
  });
</script>
</body>
</html>
