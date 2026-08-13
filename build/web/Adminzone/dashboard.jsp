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

  .quick-grid{display:grid;grid-template-columns:repeat(6,1fr);gap:14px;margin-bottom:22px;}
  .quick-card{
    background:var(--card);border:1px solid var(--line);border-radius:14px;padding:18px 12px;
    display:flex;flex-direction:column;align-items:center;gap:9px;position:relative;text-align:center;
    transition:transform .15s ease, box-shadow .15s ease, border-color .15s ease;
  }
  .quick-card:hover{transform:translateY(-2px);box-shadow:0 10px 20px rgba(15,61,48,0.1);}
  .quick-card .count{
    position:absolute;top:10px;right:10px;font-family:'IBM Plex Mono',monospace;font-size:10px;font-weight:700;
    background:var(--teal-tint);color:var(--ink);padding:1px 7px;border-radius:20px;
  }
  .quick-card .qicon{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px;color:#fff;background:var(--teal);}
  .quick-card .qlabel{font-size:11.5px;font-weight:600;color:var(--ink);}

  .quick-card.qc-contact .qicon{background:var(--blue);}
  .quick-card.qc-contact:hover{border-color:var(--blue);}
  .quick-card.qc-enquiry .qicon{background:var(--purple);}
  .quick-card.qc-enquiry:hover{border-color:var(--purple);}
  .quick-card.qc-registration .qicon{background:var(--teal);}
  .quick-card.qc-registration:hover{border-color:var(--teal);}
  .quick-card.qc-review .qicon{background:var(--amber);}
  .quick-card.qc-review:hover{border-color:var(--amber);}
  .quick-card.qc-profile .qicon{background:var(--slate);}
  .quick-card.qc-profile:hover{border-color:var(--slate);}
  .quick-card.qc-password .qicon{background:var(--rose);}
  .quick-card.qc-password:hover{border-color:var(--rose);}

  .notif-viewport{
    height:300px;
    overflow:hidden;
    position:relative;
    -webkit-mask-image:linear-gradient(to bottom, transparent 0, #000 18px, #000 calc(100% - 18px), transparent 100%);
    mask-image:linear-gradient(to bottom, transparent 0, #000 18px, #000 calc(100% - 18px), transparent 100%);
  }
  .notif-scroll{
    display:flex;flex-direction:column;
    animation:notifAutoScroll 16s linear infinite;
  }
  .notif-viewport:hover .notif-scroll{ animation-play-state:paused; }
  @keyframes notifAutoScroll{
    from{ transform:translateY(0); }
    to{ transform:translateY(-50%); }
  }
  .notif-row{
    display:flex;gap:11px;padding:11px 8px;border-bottom:1px solid var(--line);align-items:flex-start;
    border-radius:10px;cursor:pointer;
    transition:background .18s ease, transform .18s ease, box-shadow .18s ease;
  }
  .notif-row:last-child{border-bottom:none;}
  .notif-ic{
    width:30px;height:30px;border-radius:9px;flex-shrink:0;display:flex;align-items:center;justify-content:center;
    font-size:13px;background:var(--teal-tint);color:var(--ink);
  }
  .notif-body{flex:1;min-width:0;}
  .notif-title{font-size:12.5px;font-weight:600;color:var(--ink);}
  .notif-sub{font-size:11.5px;color:var(--muted);margin-top:1px;}
  .notif-time{font-size:10.5px;color:var(--muted);white-space:nowrap;padding-top:2px;}
  .notif-row.unread .notif-ic{background:var(--saffron);color:#fff;}

  .notif-row .notif-ic.nt-enquiry{background:var(--blue-tint);color:var(--blue);}
  .notif-row.unread .notif-ic.nt-enquiry{background:var(--blue);color:#fff;}
  .notif-row .notif-ic.nt-confirmed{background:var(--teal-tint);color:var(--teal);}
  .notif-row.unread .notif-ic.nt-confirmed{background:var(--teal);color:#fff;}
  .notif-row .notif-ic.nt-review{background:var(--amber-tint);color:var(--amber);}
  .notif-row .notif-ic.nt-pending{background:var(--rose-tint);color:var(--rose);}
  .notif-row .notif-ic.nt-refund{background:var(--purple-tint);color:var(--purple);}

  .panel{background:var(--card);border:1px solid var(--line);border-radius:14px;padding:20px 22px;}
  .panel-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;}
  .panel-head h3{font-family:'Fraunces',serif;font-size:15.5px;font-weight:600;margin:0;}
  .panel-head .see-all{font-size:11.5px;color:var(--teal);font-weight:600;}
  .range-toggle{display:flex;gap:3px;background:var(--paper);border-radius:8px;padding:3px;}
  .range-toggle button{border:none;background:none;padding:6px 11px;border-radius:6px;font-size:11px;font-weight:600;color:var(--muted);cursor:pointer;}
  .range-toggle button.on{background:var(--ink);color:#fff;}

  .report-panel{margin-bottom:20px;}
  .chart-wrap{height:220px;}

  .compare-row{display:flex;margin-top:18px;border-top:1px solid var(--line);padding-top:14px;}
  .compare-item{flex:1;padding:0 16px;border-left:1px solid var(--line);}
  .compare-item:first-child{border-left:none;padding-left:0;}
  .compare-item .c-top{display:flex;justify-content:space-between;font-size:11.5px;font-weight:700;}
  .compare-item .c-sub{font-size:10px;color:var(--muted);letter-spacing:0.3px;margin-top:2px;}
  .compare-item .c-bar{height:3px;border-radius:2px;margin-top:9px;}

  .split-grid{display:grid;grid-template-columns:1.15fr 1fr;gap:18px;}

  table.mini{width:100%;border-collapse:collapse;}
  table.mini th{font-size:10px;text-transform:uppercase;letter-spacing:0.5px;color:var(--muted);text-align:left;padding:7px 6px;border-bottom:1px solid var(--line);}
  table.mini td{font-size:12.5px;padding:10px 6px;border-bottom:1px solid var(--line);}
  table.mini tr:last-child td{border-bottom:none;}
  .traveler-cell{display:flex;align-items:center;gap:8px;}
  .traveler-cell img{width:24px;height:24px;border-radius:50%;object-fit:cover;}
  .rating-pill{color:var(--saffron);font-weight:700;}

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
        %>

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
        <li class="active"><a href="dashboard.jsp" data-page="Dashboard"><span class="ic"><i class="fa-solid fa-gauge-high"></i></span> Dashboard</a></li>
        <li><a href="contactmgmt.jsp" data-page="Contact Data"><span class="ic"><i class="fa-solid fa-address-book"></i></span> Contact Data <span class="count">250</span></a></li>
        <li><a href="Enquirymgmt.jsp" data-page="Enquiry Data"><span class="ic"><i class="fa-solid fa-comment-dots"></i></span> Enquiry Data <span class="count">232</span></a></li>
        <li><a href="Registrationmgmt.jsp" data-page="Registration Data"><span class="ic"><i class="fa-solid fa-clipboard-list"></i></span> Registration Data <span class="count">190</span></a></li>
        <li><a href="Reviewmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Review Data <span class="count">128</span></a></li>
              <li><a href="bookmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Book Data<span class="count">128</span></a></li>

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

      <!-- QUICK-ACCESS -->
      <div class="quick-grid">
        <a class="quick-card qc-contact" href="contactmgmt.jsp">
          <span class="count">250</span>
          <div class="qicon"><i class="fa-solid fa-address-book"></i></div>
          <div class="qlabel">Contact Data</div>
        </a>
        <a class="quick-card qc-enquiry" href="Enquirymgmt.jsp">
          <span class="count">232</span>
          <div class="qicon"><i class="fa-solid fa-comment-dots"></i></div>
          <div class="qlabel">Enquiry Data</div>
        </a>
        <a class="quick-card qc-registration" href="Registrationmgmt.jsp">
          <span class="count">190</span>
          <div class="qicon"><i class="fa-solid fa-clipboard-list"></i></div>
          <div class="qlabel">Registration</div>
        </a>
        <a class="quick-card qc-review" href="Reviewmgmt.jsp">
          <span class="count">128</span>
          <div class="qicon"><i class="fa-solid fa-star"></i></div>
          <div class="qlabel">Review Data</div>
        </a>
        <a class="quick-card qc-profile" href="profilemgmt.jsp">
          <div class="qicon"><i class="fa-solid fa-user"></i></div>
          <div class="qlabel">Profile</div>
        </a>
        <a class="quick-card qc-password" href="changepassword.jsp">
          <div class="qicon"><i class="fa-solid fa-lock"></i></div>
          <div class="qlabel">Password</div>
        </a>
      </div>

      <div class="split-grid">
        <div class="panel">
          <div class="panel-head"><h3>Notifications</h3><span class="see-all">Mark all read</span></div>
          <div class="notif-viewport" id="notifViewport">
            <div class="notif-scroll" id="notifScroll">
            <div class="notif-row unread"
                 onmouseover="this.style.background='var(--blue-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(47,111,237,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-enquiry"><i class="fa-solid fa-comment-dots"></i></div>
              <div class="notif-body">
                <div class="notif-title">New enquiry from Rohan Shah</div>
                <div class="notif-sub">Interested in Manali Hillside Retreat</div>
              </div>
              <div class="notif-time">5m ago</div>
            </div>
            <div class="notif-row unread"
                 onmouseover="this.style.background='var(--teal-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(23,166,115,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-confirmed"><i class="fa-solid fa-circle-check"></i></div>
              <div class="notif-body">
                <div class="notif-title">Booking confirmed</div>
                <div class="notif-sub">Kerala Backwater Trail · Meera Diwan</div>
              </div>
              <div class="notif-time">32m ago</div>
            </div>
            <div class="notif-row"
                 onmouseover="this.style.background='var(--amber-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(232,163,61,0.14)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-review"><i class="fa-solid fa-star"></i></div>
              <div class="notif-body">
                <div class="notif-title">New 5-star review posted</div>
                <div class="notif-sub">Goa Coastal Escape · Priya Nair</div>
              </div>
              <div class="notif-time">1h ago</div>
            </div>
            <div class="notif-row"
                 onmouseover="this.style.background='var(--rose-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(214,72,107,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-pending"><i class="fa-solid fa-hourglass-half"></i></div>
              <div class="notif-body">
                <div class="notif-title">Registration pending payment</div>
                <div class="notif-sub">Jaipur Heritage Walk · Sana Iqbal</div>
              </div>
              <div class="notif-time">2h ago</div>
            </div>
            <div class="notif-row"
                 onmouseover="this.style.background='var(--purple-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(124,92,252,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-refund"><i class="fa-solid fa-money-bill-transfer"></i></div>
              <div class="notif-body">
                <div class="notif-title">Refund request submitted</div>
                <div class="notif-sub">Rishikesh River Camp · Arjun Verma</div>
              </div>
              <div class="notif-time">3h ago</div>
            </div>

            <!-- duplicate set - makes the auto-scroll loop seamlessly -->
            <div class="notif-row unread" aria-hidden="true"
                 onmouseover="this.style.background='var(--blue-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(47,111,237,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-enquiry"><i class="fa-solid fa-comment-dots"></i></div>
              <div class="notif-body">
                <div class="notif-title">New enquiry from Rohan Shah</div>
                <div class="notif-sub">Interested in Manali Hillside Retreat</div>
              </div>
              <div class="notif-time">5m ago</div>
            </div>
            <div class="notif-row unread" aria-hidden="true"
                 onmouseover="this.style.background='var(--teal-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(23,166,115,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-confirmed"><i class="fa-solid fa-circle-check"></i></div>
              <div class="notif-body">
                <div class="notif-title">Booking confirmed</div>
                <div class="notif-sub">Kerala Backwater Trail · Meera Diwan</div>
              </div>
              <div class="notif-time">32m ago</div>
            </div>
            <div class="notif-row" aria-hidden="true"
                 onmouseover="this.style.background='var(--amber-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(232,163,61,0.14)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-review"><i class="fa-solid fa-star"></i></div>
              <div class="notif-body">
                <div class="notif-title">New 5-star review posted</div>
                <div class="notif-sub">Goa Coastal Escape · Priya Nair</div>
              </div>
              <div class="notif-time">1h ago</div>
            </div>
            <div class="notif-row" aria-hidden="true"
                 onmouseover="this.style.background='var(--rose-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(214,72,107,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-pending"><i class="fa-solid fa-hourglass-half"></i></div>
              <div class="notif-body">
                <div class="notif-title">Registration pending payment</div>
                <div class="notif-sub">Jaipur Heritage Walk · Sana Iqbal</div>
              </div>
              <div class="notif-time">2h ago</div>
            </div>
            <div class="notif-row" aria-hidden="true"
                 onmouseover="this.style.background='var(--purple-tint)'; this.style.transform='translateX(3px)'; this.style.boxShadow='0 4px 12px rgba(124,92,252,0.12)';"
                 onmouseout="this.style.background='transparent'; this.style.transform='translateX(0)'; this.style.boxShadow='none';">
              <div class="notif-ic nt-refund"><i class="fa-solid fa-money-bill-transfer"></i></div>
              <div class="notif-body">
                <div class="notif-title">Refund request submitted</div>
                <div class="notif-sub">Rishikesh River Camp · Arjun Verma</div>
              </div>
              <div class="notif-time">3h ago</div>
            </div>
            </div>
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

  new Chart(document.getElementById('reportChart'), {
    data: {
      labels: ["01 Jan","02 Jan","03 Jan","04 Jan","05 Jan","06 Jan","07 Jan","08 Jan","09 Jan","10 Jan","11 Jan","12 Jan"],
      datasets: [
        { type:'bar', label:'Bookings', data:[420,500,410,670,210,410,190,340,760,310,255,120], backgroundColor:'#17A673', borderRadius:4, barThickness:14, yAxisID:'y' },
        { type:'line', label:'Revenue (?k)', data:[30,45,42,32,45,25,22,30,28,25,18,15], borderColor:'#E8A33D', backgroundColor:'#E8A33D', tension:0.4, yAxisID:'y1', pointRadius:3 }
      ]
    },
    options: {
      responsive:true, maintainAspectRatio:false,
      plugins:{ legend:{ position:'bottom', labels:{ boxWidth:10, font:{ size:11 } } } },
      scales:{
        y:{ position:'left', grid:{ color:'#EEF2EA' }, title:{ display:true, text:'Bookings', font:{ size:10 } } },
        y1:{ position:'right', grid:{ display:false }, title:{ display:true, text:'Revenue', font:{ size:10 } } },
        x:{ grid:{ display:false } }
      }
    }
  });
</script>
</body>
</html>