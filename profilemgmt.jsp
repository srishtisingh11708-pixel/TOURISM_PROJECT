<!DOCTYPE html>
<html lang="en">
    <%@page import="mypack.connectionManager"%>
 <%@page import="java.sql.ResultSet" %>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Sahyatri ? Tourism Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
  :root{
    --ink:#0F3D30;
    --ink-soft:#155843;
    --ink-deep:#0A2B21;
    --paper:#FFFFFF;
    --card:#FFFFFF;
    --saffron:#E8A33D;
    --saffron-deep:#C4802A;
    --teal:#17A673;
    --teal-tint:#EAF7F1;
    --advisory:#C1502E;
    --line:#DCEBE3;
    --muted:#5E7A6D;
    --sidebar-w:236px;

    --blue:#2F6FED; --blue-tint:#EAF1FE;
    --purple:#7C5CFC; --purple-tint:#F1EEFE;
    --amber:#E8A33D; --amber-tint:#FDF3E3;
    --rose:#D6486B; --rose-tint:#FBEAEF;
    --slate:#5E6B7A; --slate-tint:#EEF1F4;

    --shadow-sm:0 1px 2px rgba(15,61,48,0.06), 0 1px 1px rgba(15,61,48,0.04);
    --shadow-md:0 8px 24px -8px rgba(15,61,48,0.18);
    --shadow-lg:0 20px 48px -12px rgba(15,61,48,0.28);
  }
  *{box-sizing:border-box;}
  body{margin:0;background:#F3F8F5;color:var(--ink);font-family:'Inter',sans-serif;font-size:13.5px;-webkit-font-smoothing:antialiased;}
  a{text-decoration:none;color:inherit;}
  ul{margin:0;padding:0;list-style:none;}
  button{font-family:'Inter',sans-serif;}
  @media (prefers-reduced-motion:reduce){ *{animation:none !important; transition:none !important;} }

  @keyframes riseIn{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }
  .rise{animation:riseIn .5s cubic-bezier(.2,.8,.2,1) both;}

  /* ============ ADVISORY TICKER ============ */
  .advisory-bar{
    background:var(--ink-deep);color:#F5EFE3;display:flex;align-items:stretch;
    font-size:12px;overflow:hidden;position:relative;
  }
  .advisory-tag{
    flex-shrink:0;display:flex;align-items:center;gap:7px;padding:9px 16px;
    background:var(--advisory);font-weight:700;font-family:'IBM Plex Mono',monospace;
    font-size:10.5px;letter-spacing:1px;text-transform:uppercase;
  }
  .advisory-track{flex:1;overflow:hidden;position:relative;}
  .advisory-track::after{
    content:"";position:absolute;top:0;right:0;bottom:0;width:60px;
    background:linear-gradient(90deg,transparent,var(--ink-deep));pointer-events:none;
  }
  .advisory-scroll{
    display:flex;gap:48px;white-space:nowrap;padding:9px 0;
    animation:ticker 32s linear infinite;width:max-content;
  }
  .advisory-track:hover .advisory-scroll{animation-play-state:paused;}
  @keyframes ticker{ from{transform:translateX(0);} to{transform:translateX(-50%);} }
  .advisory-scroll span{display:inline-flex;align-items:center;gap:8px;color:rgba(245,239,227,0.9);}
  .advisory-scroll i{color:var(--saffron);}
  .advisory-close{
    flex-shrink:0;border:none;background:none;color:rgba(245,239,227,0.55);cursor:pointer;
    padding:0 16px;font-size:14px;position:relative;z-index:1;
  }
  .advisory-close:hover{color:#fff;}
  .advisory-bar.hidden{display:none;}

  /* ============ SHELL ============ */
  .app-shell{display:flex;min-height:100vh;}

  /* ============ SIDEBAR ============ */
  .sidebar{
    width:var(--sidebar-w);flex-shrink:0;
    background:linear-gradient(190deg,var(--ink) 0%, var(--ink-deep) 100%);
    color:#EAF0E8;display:flex;flex-direction:column;overflow:hidden;
    transition:width .25s ease, opacity .2s ease;position:relative;
  }
  .sidebar::before{
    content:"";position:absolute;inset:0;pointer-events:none;opacity:0.5;
    background:radial-gradient(circle at 15% 8%, rgba(232,163,61,0.10) 0%, transparent 45%);
  }
  .sidebar > *{min-width:var(--sidebar-w);position:relative;}
  .app-shell.collapsed .sidebar{width:0;opacity:0;}

  .brand-row{display:flex;align-items:center;gap:11px;padding:22px 20px 18px;border-bottom:1px solid rgba(255,255,255,0.06);}
  .brand-mark{
    width:36px;height:36px;border-radius:10px;background:linear-gradient(145deg,var(--saffron),var(--saffron-deep));
    display:flex;align-items:center;justify-content:center;flex-shrink:0;
    font-size:16px;color:var(--ink-deep);box-shadow:0 4px 10px rgba(232,163,61,0.35);
  }
  .brand-row h1{font-family:'Fraunces',serif;font-size:18px;font-weight:700;margin:0;color:#fff;letter-spacing:0.2px;}
  .brand-row .sub{font-size:10px;color:rgba(234,240,232,0.5);letter-spacing:1.2px;text-transform:uppercase;margin-top:2px;font-family:'IBM Plex Mono',monospace;}

  .nav-scroll{flex:1;overflow-y:auto;padding:10px 12px;}
  .nav-eyebrow{
    font-family:'IBM Plex Mono',monospace;font-size:10px;letter-spacing:1.5px;color:rgba(234,240,232,0.35);
    padding:16px 10px 7px;text-transform:uppercase;
  }
  .nav-list li{position:relative;}
  .nav-list li a{
    display:flex;align-items:center;gap:11px;padding:9px 10px;border-radius:8px;
    font-size:13px;font-weight:500;color:rgba(234,240,232,0.72);margin-bottom:2px;
    transition:background .15s ease, color .15s ease, padding-left .15s ease;
  }
  .nav-list li a .ic{width:17px;text-align:center;font-size:13px;color:rgba(234,240,232,0.5);transition:color .15s ease;}
  .nav-list li a .count{
    margin-left:auto;font-family:'IBM Plex Mono',monospace;font-size:10px;font-weight:600;
    color:rgba(234,240,232,0.4);
  }
  .nav-list li a:hover{background:rgba(255,255,255,0.06);color:#fff;padding-left:14px;}
  .nav-list li a:hover .ic{color:var(--saffron);}
  .nav-list li.active::before{
    content:"";position:absolute;left:0;top:8px;bottom:8px;width:3px;border-radius:3px;background:var(--saffron);
  }
  .nav-list li.active a{background:rgba(232,163,61,0.14);color:#fff;font-weight:600;}
  .nav-list li.active a .ic{color:var(--saffron);}
  .nav-list li.active a .count{color:var(--saffron);opacity:0.9;}

  .sidebar-foot{padding:16px 20px 20px;border-top:1px solid rgba(255,255,255,0.08);}
  .sidebar-foot a{display:flex;align-items:center;gap:9px;font-size:12px;color:rgba(234,240,232,0.55);transition:color .15s ease;}
  .sidebar-foot a:hover{color:#fff;}

  /* ============ MAIN ============ */
  .main{flex:1;min-width:0;display:flex;flex-direction:column;}

  .topbar{
    display:flex;align-items:center;gap:16px;padding:14px 28px;background:var(--card);border-bottom:1px solid var(--line);
    position:sticky;top:0;z-index:10;
  }
  .sidebar-toggle{
    border:1px solid var(--line);background:var(--card);width:34px;height:34px;border-radius:9px;
    display:flex;align-items:center;justify-content:center;cursor:pointer;color:var(--ink);font-size:14px;flex-shrink:0;
    transition:background .15s ease, border-color .15s ease;
  }
  .sidebar-toggle:hover{background:var(--teal-tint);border-color:var(--teal);}
  .search-box{flex:1;max-width:380px;display:flex;align-items:center;gap:9px;background:#F7FBF9;border:1px solid var(--line);border-radius:9px;padding:8px 13px;transition:border-color .15s ease, background .15s ease;}
  .search-box:focus-within{border-color:var(--teal);background:#fff;}
  .search-box input{border:none;background:none;outline:none;flex:1;font-size:13px;color:var(--ink);}
  .search-box i{color:var(--muted);font-size:13px;}
  .top-right{margin-left:auto;display:flex;align-items:center;gap:18px;}
  .top-right .ic-btn{position:relative;color:var(--muted);font-size:15px;cursor:pointer;transition:color .15s ease;}
  .top-right .ic-btn:hover{color:var(--ink);}
  .top-right .ic-btn .dot{position:absolute;top:-2px;right:-3px;width:6px;height:6px;border-radius:50%;background:var(--advisory);box-shadow:0 0 0 2px #fff;}
  .top-right .avatar{display:flex;align-items:center;gap:8px;}
  .top-right .avatar img{width:30px;height:30px;border-radius:50%;object-fit:cover;border:1.5px solid var(--saffron);}
  .top-right .avatar span{font-size:12.5px;font-weight:600;}

  .content{padding:26px 28px 40px;flex:1;}

  /* ============ PAGE HEAD ============ */
  .page-head{display:flex;align-items:flex-end;justify-content:space-between;gap:16px;margin-bottom:22px;flex-wrap:wrap;}
  .page-head .eyebrow{font-family:'IBM Plex Mono',monospace;font-size:10.5px;letter-spacing:1.5px;text-transform:uppercase;color:var(--teal);margin-bottom:5px;font-weight:600;}
  .page-head h2{font-family:'Fraunces',serif;font-size:26px;font-weight:700;margin:0;color:var(--ink);letter-spacing:-0.2px;}
  .page-head .btn-edit{
    display:inline-flex;align-items:center;gap:8px;background:var(--ink);color:#fff;border:none;
    padding:11px 19px;border-radius:10px;font-size:12.5px;font-weight:600;cursor:pointer;
    transition:background .15s ease, transform .15s ease, box-shadow .15s ease;box-shadow:var(--shadow-sm);
  }
  .page-head .btn-edit:hover{background:var(--ink-soft);transform:translateY(-1px);box-shadow:var(--shadow-md);}

  /* ============ PROFILE HERO CARD ============ */
  .profile-hero{
    background:linear-gradient(120deg,var(--ink) 0%, var(--ink-soft) 55%, #1C6A52 100%);
    border-radius:18px;padding:34px 34px 30px;display:flex;align-items:center;gap:26px;
    color:#fff;position:relative;overflow:hidden;margin-bottom:22px;box-shadow:var(--shadow-lg);
  }
  /* signature element: layered terrain silhouette, standing in for the traveler's route */
  .profile-hero .terrain{position:absolute;left:0;right:0;bottom:0;height:64%;pointer-events:none;opacity:0.9;}
  .profile-hero .terrain svg{width:100%;height:100%;display:block;}
  .profile-hero::after{
    content:"";position:absolute;right:-60px;top:-70px;width:240px;height:240px;border-radius:50%;
    background:radial-gradient(circle,rgba(232,163,61,0.22) 0%,transparent 70%);
  }
  .profile-hero .ph-avatar{
    width:92px;height:92px;border-radius:50%;object-fit:cover;flex-shrink:0;
    border:3px solid var(--saffron);position:relative;z-index:1;box-shadow:0 0 0 5px rgba(232,163,61,0.16);
  }
  .profile-hero .ph-info{position:relative;z-index:1;}
  .profile-hero .ph-info h3{font-family:'Fraunces',serif;font-size:23px;font-weight:700;margin:0 0 5px;letter-spacing:-0.2px;}
  .profile-hero .ph-info .ph-role{
    display:inline-flex;align-items:center;gap:7px;background:rgba(232,163,61,0.18);
    border:1px solid rgba(232,163,61,0.4);color:var(--saffron);font-size:11px;font-weight:700;
    letter-spacing:0.4px;text-transform:uppercase;padding:4px 11px;border-radius:20px;margin-bottom:11px;
  }
  .profile-hero .ph-meta{display:flex;gap:20px;flex-wrap:wrap;font-size:12.5px;color:rgba(255,255,255,0.75);}
  .profile-hero .ph-meta span{display:flex;align-items:center;gap:7px;}
  .profile-hero .ph-meta i{color:var(--saffron);width:14px;text-align:center;}

  .profile-hero .ph-stats{
    margin-left:auto;display:flex;gap:28px;position:relative;z-index:1;padding-left:26px;
    border-left:1px dashed rgba(255,255,255,0.25);
  }
  .profile-hero .ph-stats div{text-align:center;}
  .profile-hero .ph-stats strong{display:block;font-family:'Fraunces',serif;font-size:20px;font-weight:700;color:var(--saffron);}
  .profile-hero .ph-stats span{font-size:10.5px;color:rgba(255,255,255,0.65);text-transform:uppercase;letter-spacing:0.4px;}

  /* ============ SPLIT LAYOUT ============ */
  .profile-grid{display:grid;grid-template-columns:1.4fr 1fr;gap:20px;align-items:start;}

  .p-card{background:var(--card);border:1px solid var(--line);border-radius:15px;padding:23px 25px;margin-bottom:20px;box-shadow:var(--shadow-sm);transition:box-shadow .2s ease, transform .2s ease;}
  .p-card:hover{box-shadow:var(--shadow-md);transform:translateY(-1px);}
  .p-card h4{
    font-family:'Fraunces',serif;font-size:15.5px;font-weight:700;margin:0 0 17px;color:var(--ink);
    display:flex;align-items:center;gap:9px;
  }
  .p-card h4 i{color:var(--teal);font-size:13px;}

  .p-card .about-text{font-size:13px;line-height:1.8;color:var(--muted);margin:0;}

  .detail-row{display:flex;justify-content:space-between;align-items:center;padding:11px 0;border-bottom:1px solid var(--line);}
  .detail-row:last-child{border-bottom:none;}
  .detail-row .d-label{display:flex;align-items:center;gap:9px;font-size:12.5px;color:var(--muted);font-weight:500;}
  .detail-row .d-label i{width:15px;text-align:center;color:var(--teal);}
  .detail-row .d-value{font-size:12.5px;font-weight:600;color:var(--ink);}

  .tag-row{display:flex;flex-wrap:wrap;gap:8px;}
  .tag-chip{
    background:var(--teal-tint);color:var(--ink-soft);font-size:11.5px;font-weight:600;
    padding:6px 13px;border-radius:20px;border:1px solid var(--line);transition:background .15s ease, border-color .15s ease;
  }
  .tag-chip:hover{background:#fff;border-color:var(--teal);}

  .field-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
  .field-grid .full{grid-column:1 / -1;}
  .field-group label{display:block;font-size:11px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.4px;margin-bottom:7px;}
  .field-group .field-static{
    display:flex;align-items:center;gap:9px;background:var(--teal-tint);border:1px solid var(--line);
    border-radius:9px;padding:10px 13px;font-size:12.5px;font-weight:600;color:var(--ink);
  }
  .field-group .field-static i{color:var(--teal);width:14px;text-align:center;}

  /* ---- Workload as a route: checkpoints along a trail, not plain bars ---- */
  .trail{position:relative;padding-left:2px;}
  .trail-item{position:relative;display:flex;gap:14px;padding-bottom:20px;}
  .trail-item:last-child{padding-bottom:0;}
  .trail-item::before{
    content:"";position:absolute;left:10px;top:22px;bottom:-4px;width:2px;
    background:repeating-linear-gradient(180deg,var(--line) 0 4px, transparent 4px 8px);
  }
  .trail-item:last-child::before{display:none;}
  .trail-dot{
    width:22px;height:22px;border-radius:50%;flex-shrink:0;position:relative;z-index:1;
    background:var(--teal-tint);border:2px solid var(--teal);display:flex;align-items:center;justify-content:center;
    font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;color:var(--ink-soft);
  }
  .trail-body{flex:1;padding-top:1px;}
  .trail-top{display:flex;justify-content:space-between;font-size:12.5px;font-weight:600;color:var(--ink);margin-bottom:7px;}
  .trail-top span:last-child{font-family:'IBM Plex Mono',monospace;color:var(--teal);font-weight:600;}
  .trail-track{height:6px;border-radius:20px;background:var(--slate-tint);overflow:hidden;}
  .trail-fill{height:100%;border-radius:20px;background:linear-gradient(90deg,var(--teal),var(--saffron));}

  .activity-item{display:flex;gap:12px;padding:11px 0;border-bottom:1px solid var(--line);}
  .activity-item:last-child{border-bottom:none;}
  .activity-item .a-ic{
    width:31px;height:31px;border-radius:9px;background:var(--teal-tint);color:var(--teal);
    display:flex;align-items:center;justify-content:center;font-size:12px;flex-shrink:0;
  }
  .activity-item .a-body p{margin:0;font-size:12.5px;font-weight:600;color:var(--ink);}
  .activity-item .a-body span{font-size:11px;color:var(--muted);}

  @media (max-width:1050px){
    .profile-grid{grid-template-columns:1fr;}
    .profile-hero{flex-direction:column;align-items:flex-start;}
    .profile-hero .ph-stats{margin-left:0;border-left:none;border-top:1px dashed rgba(255,255,255,0.25);padding-left:0;padding-top:16px;width:100%;justify-content:space-between;}
    .field-grid{grid-template-columns:1fr;}
  }

  /* ============ FOOTER ============ */
  .site-footer{
    background:var(--ink-deep);color:rgba(234,240,232,0.7);
    padding:18px 28px;display:flex;align-items:center;gap:24px;flex-wrap:wrap;margin-top:auto;
  }
  .site-footer .f-brand{display:flex;align-items:center;gap:9px;font-family:'Fraunces',serif;color:#fff;font-weight:600;font-size:13px;}
  .site-footer .f-brand .f-mark{width:22px;height:22px;border-radius:6px;background:var(--saffron);color:var(--ink-deep);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;}
  .site-footer .f-links{display:flex;gap:16px;flex-wrap:wrap;}
  .site-footer .f-links a{font-size:11.5px;font-weight:500;color:rgba(234,240,232,0.65);transition:color .15s ease;}
  .site-footer .f-links a:hover{color:#fff;}
  .site-footer .f-meta{margin-left:auto;display:flex;gap:14px;font-size:11px;color:rgba(234,240,232,0.45);}

  @media (max-width:640px){
    .app-shell:not(.collapsed) .sidebar{position:fixed;left:0;top:0;bottom:0;z-index:30;box-shadow:8px 0 24px rgba(0,0,0,0.2);}
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
        <li><a href="dashboard.jsp" data-page="Dashboard"><span class="ic"><i class="fa-solid fa-gauge-high"></i></span> Dashboard</a></li>
        <li><a href="contactmgmt.jsp" data-page="Contact Data"><span class="ic"><i class="fa-solid fa-address-book"></i></span> Contact Data <span class="count">250</span></a></li>
        <li><a href="Enquirymgmt.jsp" data-page="Enquiry Data"><span class="ic"><i class="fa-solid fa-comment-dots"></i></span> Enquiry Data <span class="count">232</span></a></li>
        <li><a href="Registrationmgmt.jsp" data-page="Registration Data"><span class="ic"><i class="fa-solid fa-clipboard-list"></i></span> Registration Data <span class="count">190</span></a></li>
        <li><a href="Reviewmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Review Data <span class="count">128</span></a></li>
        <li><a href="bookmgmt.jsp" data-page="Book Data"><span class="ic"><i class="fa-solid fa-book"></i></span> Book Data <span class="count">128</span></a></li>
      </ul>

      <div class="nav-eyebrow">Account</div>
      <ul class="nav-list">
        <li><a href="changepassword.jsp" data-page="Change Password"><span class="ic"><i class="fa-solid fa-lock"></i></span> Change Password</a></li>
        <li class="active"><a href="profilemgmt.jsp" data-page="Profile"><span class="ic"><i class="fa-solid fa-user"></i></span> Profile</a></li>
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

    <!-- CONTENT -->
    <div class="content">

      <div class="page-head rise">
        <div>
          <div class="eyebrow">Account</div>
          <h2>My Profile</h2>
        </div>
        <button class="btn-edit"><i class="fa-solid fa-pen"></i> Edit Profile</button>
      </div>

      <!-- PROFILE HERO -->
      <div class="profile-hero rise" style="animation-delay:.05s">
        <div class="terrain" aria-hidden="true">
          <svg viewBox="0 0 900 200" preserveAspectRatio="none">
            <path d="M0,160 L120,90 L210,140 L320,60 L430,150 L520,100 L630,170 L740,110 L820,150 L900,120 L900,200 L0,200 Z" fill="rgba(255,255,255,0.05)"/>
            <path d="M0,190 L150,130 L260,175 L380,110 L500,180 L610,140 L720,190 L820,160 L900,185 L900,200 L0,200 Z" fill="rgba(255,255,255,0.08)"/>
          </svg>
        </div>
        <img class="ph-avatar" src="images/imgsri.jpeg" alt="Srishti Singh">
        <div class="ph-info">
          <div class="ph-role"><i class="fa-solid fa-shield-halved"></i> Tourism Admin</div>
          <h3>Srishti Singh</h3>
          <div class="ph-meta">
            <span><i class="fa-solid fa-envelope"></i> srishtisingh11708@gmail.com</span>
            <span><i class="fa-solid fa-phone"></i> +91 8726597075</span>
            <span><i class="fa-solid fa-location-dot"></i> New Delhi, India</span>
          </div>
        </div>
        <div class="ph-stats">
          <div><strong>250</strong><span>Contacts</span></div>
          <div><strong>190</strong><span>Registrations</span></div>
          <div><strong>128</strong><span>Reviews</span></div>
        </div>
      </div>

      <!-- SPLIT LAYOUT -->
      <div class="profile-grid">

        <!-- LEFT COLUMN -->
        <div>

          <div class="p-card rise" style="animation-delay:.1s">
            <h4><i class="fa-solid fa-circle-info"></i> About</h4>
            <p class="about-text">
              Hi, I'm Srishti Singh ? the admin behind Sahyatri Tourism. I manage everything from traveler
              enquiries and event registrations to reviews and bookings across the platform, making sure every
              journey Sahyatri plans runs smoothly from the first click to the final checkout.
            </p>
          </div>

          <div class="p-card rise" style="animation-delay:.15s">
            <h4><i class="fa-solid fa-id-card"></i> Personal Details</h4>
            <div class="field-grid">
              <div class="field-group">
                <label>Full Name</label>
                <div class="field-static"><i class="fa-solid fa-user"></i> Srishti Singh</div>
              </div>
              <div class="field-group">
                <label>Role</label>
                <div class="field-static"><i class="fa-solid fa-shield-halved"></i> Tourism Admin</div>
              </div>
              <div class="field-group">
                <label>Email Address</label>
                <div class="field-static"><i class="fa-solid fa-envelope"></i> srishtisingh@sahyatri.in</div>
              </div>
              <div class="field-group">
                <label>Mobile Number</label>
                <div class="field-static"><i class="fa-solid fa-phone"></i> +91 8726597075</div>
              </div>
              <div class="field-group">
                <label>Location</label>
                <div class="field-static"><i class="fa-solid fa-location-dot"></i> New Delhi, India</div>
              </div>
              <div class="field-group">
                <label>Joined On</label>
                <div class="field-static"><i class="fa-solid fa-calendar-days"></i> 12 March 2026</div>
              </div>
              <div class="field-group full">
                <label>Focus Areas</label>
                <div class="tag-row">
                  <span class="tag-chip">Bookings</span>
                  <span class="tag-chip">Enquiry Management</span>
                  <span class="tag-chip">Reviews</span>
                  <span class="tag-chip">Registrations</span>
                  <span class="tag-chip">Web Development</span>
                </div>
              </div>
            </div>
          </div>

        </div>

        <!-- RIGHT COLUMN -->
        <div>

          <div class="p-card rise" style="animation-delay:.1s">
            <h4><i class="fa-solid fa-route"></i> Workload Overview</h4>
            <div class="trail">
              <div class="trail-item">
                <div class="trail-dot">1</div>
                <div class="trail-body">
                  <div class="trail-top"><span>Enquiries resolved</span><span>86%</span></div>
                  <div class="trail-track"><div class="trail-fill" style="width:86%"></div></div>
                </div>
              </div>
              <div class="trail-item">
                <div class="trail-dot">2</div>
                <div class="trail-body">
                  <div class="trail-top"><span>Registrations verified</span><span>72%</span></div>
                  <div class="trail-track"><div class="trail-fill" style="width:72%"></div></div>
                </div>
              </div>
              <div class="trail-item">
                <div class="trail-dot">3</div>
                <div class="trail-body">
                  <div class="trail-top"><span>Reviews moderated</span><span>94%</span></div>
                  <div class="trail-track"><div class="trail-fill" style="width:94%"></div></div>
                </div>
              </div>
            </div>
          </div>

          <div class="p-card rise" style="animation-delay:.15s">
            <h4><i class="fa-solid fa-clock-rotate-left"></i> Recent Activity</h4>
            <div class="activity-item">
              <div class="a-ic"><i class="fa-solid fa-star"></i></div>
              <div class="a-body"><p>Approved 4 new traveler reviews</p><span>2 hours ago</span></div>
            </div>
            <div class="activity-item">
              <div class="a-ic"><i class="fa-solid fa-clipboard-check"></i></div>
              <div class="a-body"><p>Verified 6 event registrations</p><span>5 hours ago</span></div>
            </div>
            <div class="activity-item">
              <div class="a-ic"><i class="fa-solid fa-comment-dots"></i></div>
              <div class="a-body"><p>Replied to 3 traveler enquiries</p><span>Yesterday</span></div>
            </div>
            <div class="activity-item">
              <div class="a-ic"><i class="fa-solid fa-lock"></i></div>
              <div class="a-body"><p>Updated account password</p><span>3 days ago</span></div>
            </div>
          </div>

        </div>

      </div>

    </div>
    <!-- CONTENT END -->

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
