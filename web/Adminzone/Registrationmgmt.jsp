<!DOCTYPE html>
<html lang="en">
    <%@page import="mypack.connectionManager"%>
 <%@page import="java.sql.ResultSet" %>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Sahyatri ? Tourism Admin</title>
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

  /* ============ ADVISORY TICKER ============ */
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

  /* ============ SHELL ============ */
  .app-shell{display:flex;min-height:100vh;}

  /* ============ SIDEBAR ============ */
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

  /* ============ MAIN ============ */
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
  /* ============ FOOTER ============ */
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

  @media (max-width:1050px){.split-grid{grid-template-columns:1fr;} .bp-main{flex-direction:column;align-items:flex-start;} .bp-greet{border-right:none;padding-right:0;}}
  @media (max-width:640px){
    .app-shell:not(.collapsed) .sidebar{position:fixed;left:0;top:0;bottom:0;z-index:30;box-shadow:8px 0 24px rgba(0,0,0,0.2);}
    .boarding-pass{flex-direction:column;} .bp-stub{width:auto;border-left:none;border-top:1px dashed rgba(255,255,255,0.25);flex-direction:row;}
    .bp-stub .pnr{writing-mode:horizontal-tb;}
    .site-footer .f-meta{margin-left:0;}
  }

  a:focus-visible, button:focus-visible, input:focus-visible{outline:2px solid var(--teal);outline-offset:2px;}

  /* ============ REGISTRATION DATA TABLE (new design) ============ */
  .table-wrap{
    background:var(--card);
    border:1px solid var(--line);
    border-radius:14px;
    margin:24px auto;
    max-width:1150px;
    overflow-x:auto;
    box-shadow:0 4px 18px rgba(15,61,48,0.06);
  }
  .contact-table{
    width:100%;
    border-collapse:collapse;
    min-width:1100px;
    font-size:13px;
  }
  .contact-table thead th{
    background:var(--ink);
    color:#EAF0E8;
    font-family:'IBM Plex Mono',monospace;
    font-size:11px;
    letter-spacing:0.8px;
    text-transform:uppercase;
    font-weight:600;
    padding:13px 14px;
    text-align:left;
    white-space:nowrap;
  }
  .contact-table thead th:first-child{border-top-left-radius:14px;}
  .contact-table thead th:last-child{border-top-right-radius:14px;}
  .contact-table tbody tr{
    border-bottom:1px solid var(--line);
    transition:background .15s ease;
  }
  .contact-table tbody tr:last-child{border-bottom:none;}
  .contact-table tbody tr:hover{background:var(--teal-tint);}
  .contact-table tbody tr:nth-child(even){background:#FAFDFC;}
  .contact-table tbody tr:nth-child(even):hover{background:var(--teal-tint);}
  .contact-table td{
    padding:12px 14px;
    color:#000000;
    font-weight:700;
    vertical-align:middle;
    white-space:nowrap;
  }
  .contact-table td.action-cell{text-align:center;}
  .contact-table td.profile-cell{text-align:center;}
  .contact-table td.profile-cell img{
    width:52px;
    height:52px;
    border-radius:50%;
    object-fit:cover;
    border:2px solid var(--saffron);
  }

  .icon-btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    width:34px;
    height:34px;
    border-radius:50%;
    transition:transform .15s ease, box-shadow .15s ease;
  }
  .icon-btn:hover{transform:translateY(-2px);}
  .icon-btn.delete-btn{
    background:var(--rose);
    box-shadow:0 3px 10px rgba(214,72,107,0.35);
  }
  .icon-btn.delete-btn i{color:#fff;font-size:14px;}
  .icon-btn.whatsapp-btn{
    background:#25D366;
    box-shadow:0 3px 10px rgba(37,211,102,0.35);
  }
  .icon-btn.whatsapp-btn i{color:#fff;font-size:15px;}

  /* ============ PAGE-WIDE ANIMATED BUBBLES BACKGROUND ============ */
  .page-bubbles{
    position:fixed;
    inset:0;
    overflow:hidden;
    z-index:0;
    pointer-events:none;
  }
  .app-shell{position:relative; z-index:1;}
  .page-bubbles .bubble{
    position:absolute;
    bottom:-120px;
    border-radius:50%;
    animation:rise linear infinite;
  }
  .page-bubbles .bubble.white{background:rgba(255,255,255,0.55);}
  .page-bubbles .bubble.green{background:rgba(23,166,115,0.20);}
  @keyframes rise{
    0%{ transform:translateY(0) translateX(0) scale(1); opacity:0; }
    10%{ opacity:0.9; }
    50%{ transform:translateY(-48vh) translateX(18px) scale(1.05); }
    100%{ transform:translateY(-105vh) translateX(-14px) scale(0.9); opacity:0; }
  }
  .page-bubbles .b1{left:4%;  width:18px; height:18px; animation-duration:14s; animation-delay:0s;}
  .page-bubbles .b2{left:12%; width:34px; height:34px; animation-duration:19s; animation-delay:1.2s;}
  .page-bubbles .b3{left:20%; width:12px; height:12px; animation-duration:12s; animation-delay:2.4s;}
  .page-bubbles .b4{left:29%; width:26px; height:26px; animation-duration:17s; animation-delay:0.6s;}
  .page-bubbles .b5{left:38%; width:16px; height:16px; animation-duration:13s; animation-delay:3s;}
  .page-bubbles .b6{left:47%; width:40px; height:40px; animation-duration:21s; animation-delay:1.8s;}
  .page-bubbles .b7{left:56%; width:14px; height:14px; animation-duration:12.5s; animation-delay:2.8s;}
  .page-bubbles .b8{left:65%; width:28px; height:28px; animation-duration:18s; animation-delay:0.3s;}
  .page-bubbles .b9{left:74%; width:20px; height:20px; animation-duration:15s; animation-delay:2s;}
  .page-bubbles .b10{left:82%;width:32px; height:32px; animation-duration:20s; animation-delay:1s;}
  .page-bubbles .b11{left:90%;width:15px; height:15px; animation-duration:12.2s; animation-delay:3.4s;}
  .page-bubbles .b12{left:96%;width:22px; height:22px; animation-duration:16.5s; animation-delay:2.6s;}
  .page-bubbles .b13{left:8%; width:24px; height:24px; animation-duration:16s;  animation-delay:5s;}
  .page-bubbles .b14{left:34%;width:15px; height:15px; animation-duration:13.5s;animation-delay:6.2s;}
  .page-bubbles .b15{left:61%;width:30px; height:30px; animation-duration:19.5s;animation-delay:4.4s;}
  .page-bubbles .b16{left:88%;width:19px; height:19px; animation-duration:14.5s;animation-delay:7s;}
  @media (prefers-reduced-motion:reduce){ .page-bubbles .bubble{animation:none; opacity:0.15;} }

  /* ============ TABLE CENTERING WRAPPER ============ */
  .table-center-row{
    display:flex;
    justify-content:center;
    padding:24px 20px;
  }
</style>
</head>
<body>
   <%
String admin = (String)session.getAttribute("ad");

if(admin == null || admin.equals(""))
{
%>

<script>
alert("Please first login then go to admin zone");
window.location.href="../../TOURISM_PROJECT/login.html";
</script>

<%
return;
}
%>

<!-- PAGE-WIDE BUBBLES BACKGROUND -->
<div class="page-bubbles">
  <span class="bubble white b1"></span>
  <span class="bubble green b2"></span>
  <span class="bubble white b3"></span>
  <span class="bubble green b4"></span>
  <span class="bubble white b5"></span>
  <span class="bubble green b6"></span>
  <span class="bubble white b7"></span>
  <span class="bubble green b8"></span>
  <span class="bubble white b9"></span>
  <span class="bubble green b10"></span>
  <span class="bubble white b11"></span>
  <span class="bubble green b12"></span>
  <span class="bubble white b13"></span>
  <span class="bubble green b14"></span>
  <span class="bubble white b15"></span>
  <span class="bubble green b16"></span>
</div>

<!-- ADVISORY TICKER -->
<div class="advisory-bar" id="advisoryBar">
  <div class="advisory-tag"><i class="fa-solid fa-triangle-exclamation"></i> Advisory</div>
  <div class="advisory-track">
    <div class="advisory-scroll">
      <span><i class="fa-solid fa-cloud-showers-heavy"></i> Monsoon watch: Kerala backwater routes may see delays this week</span>
      <span><i class="fa-solid fa-arrow-trend-up"></i> Festival surge: Jaipur Heritage Walk bookings up 40% this month</span>
      <span><i class="fa-solid fa-mountain"></i> Manali high-altitude passes reopening ? update guide rosters</span>
      <span><i class="fa-solid fa-umbrella-beach"></i> Goa coastal packages fully booked through the weekend</span>
      <span><i class="fa-solid fa-bell"></i> 12 new enquiries awaiting a response</span>
      <span><i class="fa-solid fa-cloud-showers-heavy"></i> Monsoon watch: Kerala backwater routes may see delays this week</span>
      <span><i class="fa-solid fa-arrow-trend-up"></i> Festival surge: Jaipur Heritage Walk bookings up 40% this month</span>
      <span><i class="fa-solid fa-mountain"></i> Manali high-altitude passes reopening ? update guide rosters</span>
      <span><i class="fa-solid fa-umbrella-beach"></i> Goa coastal packages fully booked through the weekend</span>
      <span><i class="fa-solid fa-bell"></i> 12 new enquiries awaiting a response</span>
    </div>
  </div>
  <button class="advisory-close" id="advisoryClose" title="Dismiss advisories" aria-label="Dismiss advisories"><i class="fa-solid fa-xmark"></i></button>
</div>

<div class="app-shell" id="appShell">

  <!-- SIDEBAR -->
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
        <li><a href="dashboard.jsp" data-page="Dashboard"><span class="ic"><i class="fa-solid fa-gauge-high"></i></span> Dashboard</a></li>
        <li><a href="contactmgmt.jsp" data-page="Contact Data"><span class="ic"><i class="fa-solid fa-address-book"></i></span> Contact Data <span class="count">250</span></a></li>
        <li><a href="Enquirymgmt.jsp" data-page="Enquiry Data"><span class="ic"><i class="fa-solid fa-comment-dots"></i></span> Enquiry Data <span class="count">232</span></a></li>
        <li class="active"><a href="Registrationmgmt.jsp" data-page="Registration Data"><span class="ic"><i class="fa-solid fa-clipboard-list"></i></span> Registration Data <span class="count">190</span></a></li>
        <li><a href="Reviewmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Review Data <span class="count">128</span></a></li>
                   <li><a href="bookmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Book Data <span class="count">128</span></a></li>

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

        <marquee direction="right">
            <h2>WELCOME MY REGISTRATION MANAGEMENT PAGE</h2>
        </marquee>
        <div class="table-center-row">
                <div class="table-wrap">
      <table class="contact-table">
                        <thead>
                        <tr>
                           
                            <th>Name</th>
                            <th>Father name</th>
                            <th>Mother name</th>
                            <th>Gender</th>
                            <th>Qualification</th>
                            <th>Mobile</th>
                             <th>City</th>
                               <th>Email</th>
                                 <th>Profile</th>
                                   <th>State</th>
                            <th>Delete</th>
                            <th>Response</th>
                            
                        </tr>
                        </thead>
                        <tbody>
                       <%

connectionManager cm = new connectionManager();

String command = "select * from reg";

ResultSet rs = cm.getData(command);


while(rs.next())
{

%>


<tr>

<td class="name-cell"><%=rs.getString(1)%></td>

<td><%=rs.getString(2)%></td>

<td><%=rs.getString(3)%></td>

<td><%=rs.getString(4)%></td>

<td><%=rs.getString(5)%></td>

<td><%=rs.getString(6)%></td>

<td><%=rs.getString(7)%></td>

<td><%=rs.getString(8)%></td>


<td class="profile-cell">
<img src="../userpic/<%=rs.getString(9)%>" height="100px" width="100px"
alt="Profile photo">
</td>


<td><%=rs.getString(10)%></td>


<td class="action-cell">

<a href="../codes/deletereg.jsp?d=<%=rs.getString(8)%>" class="icon-btn delete-btn" title="Delete">

<i class="fa fa-trash"></i>

</a>

</td>

    <td class="action-cell">
<a href="https://api.whatsapp.com/send?text=Hello" class="icon-btn whatsapp-btn" title="Message on WhatsApp" target="_blank" rel="noopener">
<i class="fab fa-whatsapp"></i>
</a>
</td>

</tr>


<%

}

%>
                        </tbody>
                    </table>
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
      </div>
    </footer>
  </div>
</div>

<script>
  // ---- Sidebar toggle ----
  const appShell = document.getElementById('appShell');
  document.getElementById('sidebarToggle').addEventListener('click', () => {
    appShell.classList.toggle('collapsed');
  });
  if (window.matchMedia('(max-width:640px)').matches){ appShell.classList.add('collapsed'); }

  // ---- Active nav highlighting ----
  document.querySelectorAll('.nav-list a[data-page]').forEach(link => {
    link.addEventListener('click', () => {
      document.querySelectorAll('.nav-list li').forEach(li => li.classList.remove('active'));
      link.closest('li').classList.add('active');
    });
  });

  // ---- Dismiss advisory ticker ----
  document.getElementById('advisoryClose').addEventListener('click', () => {
    document.getElementById('advisoryBar').classList.add('hidden');
  });
</script>
</body>
</html>