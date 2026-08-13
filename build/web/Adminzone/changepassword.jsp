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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
  :root{
    --ink:#0F3D30;         /* deep forest green ? sidebar & footer only */
    --ink-soft:#155843;
    --paper:#FFFFFF;
    --card:#FFFFFF;
    --saffron:#E8A33D;     /* ratings / registration accent */
    --teal:#17A673;        /* brand accent */
    --teal-tint:#EAF7F1;
    --advisory:#C1502E;    /* terracotta-red, alerts only */
    --line:#DCEBE3;
    --muted:#5E7A6D;
    --sidebar-w:230px;

    /* extra accent palette for quick-access + notifications */
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

  /* ============ CHANGE PASSWORD CARD (new design) ============ */
  .cp-wrap{
    display:flex;justify-content:center;align-items:flex-start;
    padding:44px 20px 56px;
  }
  .cp-card{
    width:100%;max-width:460px;background:var(--card);
    border:1px solid var(--line);border-radius:18px;
    box-shadow:0 18px 40px -20px rgba(15,61,48,0.25);
    overflow:hidden;
  }
  .cp-head{
    background:linear-gradient(135deg,var(--ink) 0%,var(--ink-soft) 100%);
    padding:26px 30px 22px;color:#fff;position:relative;
  }
  .cp-head .cp-icon{
    width:42px;height:42px;border-radius:11px;background:var(--saffron);
    color:var(--ink);display:flex;align-items:center;justify-content:center;
    font-size:18px;margin-bottom:12px;
  }
  .cp-head h2{
    font-family:'Fraunces',serif;font-size:20px;font-weight:600;margin:0 0 4px;letter-spacing:0.2px;
  }
  .cp-head p{margin:0;font-size:12.5px;color:rgba(255,255,255,0.65);}

  .cp-body{padding:26px 30px 30px;}
  .cp-field{margin-bottom:18px;}
  .cp-field:last-of-type{margin-bottom:26px;}
  .cp-field label{
    display:block;font-size:11.5px;font-weight:600;color:var(--ink-soft);
    letter-spacing:0.3px;text-transform:uppercase;margin-bottom:7px;
  }
  .cp-input-wrap{position:relative;display:flex;align-items:center;}
  .cp-input-wrap i.cp-lock{
    position:absolute;left:14px;color:var(--muted);font-size:13px;pointer-events:none;
  }
  .cp-input-wrap input{
    width:100%;padding:11px 42px 11px 38px;border:1.5px solid var(--line);
    border-radius:10px;font-size:13.5px;color:var(--ink);background:var(--teal-tint);
    outline:none;transition:border-color .15s ease, background .15s ease, box-shadow .15s ease;
  }
  .cp-input-wrap input::placeholder{color:var(--muted);opacity:0.75;}
  .cp-input-wrap input:focus{
    border-color:var(--teal);background:var(--paper);
    box-shadow:0 0 0 3px rgba(23,166,115,0.14);
  }
  .cp-toggle{
    position:absolute;right:12px;border:none;background:none;color:var(--muted);
    cursor:pointer;font-size:13px;padding:4px;display:flex;align-items:center;
  }
  .cp-toggle:hover{color:var(--ink);}

  .cp-hint{
    display:flex;align-items:center;gap:8px;background:var(--teal-tint);
    border:1px solid var(--line);border-radius:10px;padding:10px 13px;
    font-size:11.5px;color:var(--muted);margin-bottom:24px;
  }
  .cp-hint i{color:var(--teal);font-size:13px;flex-shrink:0;}

  .cp-submit{
    width:100%;padding:12px 18px;border:none;border-radius:10px;
    background:var(--teal);color:#fff;font-size:14px;font-weight:700;
    letter-spacing:0.2px;cursor:pointer;display:flex;align-items:center;
    justify-content:center;gap:9px;transition:background .15s ease, transform .1s ease;
  }
  .cp-submit i{font-size:13px;}
  .cp-submit:hover{background:var(--ink-soft);}
  .cp-submit:active{transform:translateY(1px);}

  @media (max-width:1050px){.split-grid{grid-template-columns:1fr;} .bp-main{flex-direction:column;align-items:flex-start;} .bp-greet{border-right:none;padding-right:0;}}
  @media (max-width:640px){
    .app-shell:not(.collapsed) .sidebar{position:fixed;left:0;top:0;bottom:0;z-index:30;box-shadow:8px 0 24px rgba(0,0,0,0.2);}
    .boarding-pass{flex-direction:column;} .bp-stub{width:auto;border-left:none;border-top:1px dashed rgba(255,255,255,0.25);flex-direction:row;}
    .bp-stub .pnr{writing-mode:horizontal-tb;}
    .site-footer .f-meta{margin-left:0;}
    .cp-wrap{padding:28px 14px 40px;}
    .cp-head, .cp-body{padding-left:20px;padding-right:20px;}
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
         <li><a href="bookmgmt.jsp" data-page="Review Data"><span class="ic"><i class="fa-solid fa-star"></i></span> Book Data <span class="count">128</span></a></li>

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

    <div class="cp-wrap">
      <div class="cp-card">
        <div class="cp-head">
          <div class="cp-icon"><i class="fa-solid fa-key"></i></div>
          <h2>Change Password</h2>
          <p>Update your admin account password below.</p>
        </div>

        <form action="../codes/changepass.jsp" method="post">
          <div class="cp-body">

            <div class="cp-field">
              <label for="oldpass">Old Password</label>
              <div class="cp-input-wrap">
                <i class="fa-solid fa-lock cp-lock"></i>
                <input type="password" id="oldpass" name="oldpass" placeholder="Enter old password" required />
                <button type="button" class="cp-toggle" data-target="oldpass" aria-label="Show password"><i class="fa-solid fa-eye"></i></button>
              </div>
            </div>

            <div class="cp-field">
              <label for="newpass">New Password</label>
              <div class="cp-input-wrap">
                <i class="fa-solid fa-lock cp-lock"></i>
                <input type="password" id="newpass" name="newpass" placeholder="Enter new password" required />
                <button type="button" class="cp-toggle" data-target="newpass" aria-label="Show password"><i class="fa-solid fa-eye"></i></button>
              </div>
            </div>

            <div class="cp-field">
              <label for="cpass">Confirm Password</label>
              <div class="cp-input-wrap">
                <i class="fa-solid fa-lock cp-lock"></i>
                <input type="password" id="cpass" name="cpass" placeholder="Re-enter new password" required />
                <button type="button" class="cp-toggle" data-target="cpass" aria-label="Show password"><i class="fa-solid fa-eye"></i></button>
              </div>
            </div>

            <div class="cp-hint">
              <i class="fa-solid fa-circle-info"></i>
              Use a strong password you haven't used before.
            </div>

            <button type="submit" class="cp-submit"><i class="fa-solid fa-check"></i> Change Password</button>
          </div>
        </form>
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

  // ---- Password show/hide toggle ----
  document.querySelectorAll('.cp-toggle').forEach(btn => {
    btn.addEventListener('click', () => {
      const targetInput = document.getElementById(btn.getAttribute('data-target'));
      const icon = btn.querySelector('i');
      if (targetInput.type === 'password') {
        targetInput.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
      } else {
        targetInput.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
      }
    });
  });
</script>
</body>
</html>
