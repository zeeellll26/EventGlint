<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="EventGlint.ContactUs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* ── TOKENS (identical to Home.aspx & Event.aspx) ── */
    :root {
      --violet:      #7C3AED;
      --violet-mid:  #9D5CF8;
      --violet-soft: #EDE9FE;
      --violet-glow: rgba(124,58,237,.14);
      --bg:          #F7F5FF;
      --surface:     #FFFFFF;
      --surface2:    #F1EEF9;
      --border-soft: rgba(0,0,0,.06);
      --text:        #1A1033;
      --text-mid:    #3D2F6B;
      --muted:       #8B7BB0;
      --coral:       #FF6B6B;
      --gold:        #E88C1A;
      --green:       #16A34A;
      --shadow-sm:   0 1px 4px rgba(124,58,237,.07), 0 2px 12px rgba(0,0,0,.05);
      --shadow-md:   0 4px 20px rgba(124,58,237,.10), 0 2px 8px rgba(0,0,0,.06);
      --shadow-lg:   0 12px 40px rgba(124,58,237,.16), 0 4px 16px rgba(0,0,0,.08);
      --radius:      18px;
      --sidebar:     264px;
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { height: 100%; }
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: var(--text); }
    a { text-decoration: none; }
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: var(--bg); }
    ::-webkit-scrollbar-thumb { background: #C4B5FD; border-radius: 4px; }
    #form1 { display: contents; }
    .layout { display: flex; min-height: 100vh; }

    /* ═══════════════════════════════════════
       SIDEBAR  (identical to Home.aspx)
    ═══════════════════════════════════════ */
    .sidebar { width: var(--sidebar); min-height: 100vh; background: var(--surface); border-right: 1px solid var(--border-soft); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; z-index: 100; padding: 30px 0; box-shadow: 2px 0 20px rgba(124,58,237,.06); }
    .sidebar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--violet), var(--violet-mid), #C084FC); }
    .sidebar-logo { display: flex; align-items: center; gap: 13px; padding: 0 24px 30px; border-bottom: 1px solid var(--border-soft); }
    .logo-icon { width: 44px; height: 44px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); border-radius: 14px; display: grid; place-items: center; font-size: 20px; box-shadow: var(--shadow-md); flex-shrink: 0; }
    .logo-text { font-family: 'Playfair Display', serif; font-weight: 800; font-size: 17px; line-height: 1.2; color: var(--text); }
    .logo-text span { font-family: 'Plus Jakarta Sans', sans-serif; color: var(--muted); font-size: 11px; font-weight: 400; display: block; margin-top: 2px; }
    .nav { padding: 26px 14px; flex: 1; display: flex; flex-direction: column; gap: 3px; overflow-y: auto; }
    .nav-label { font-size: 10px; text-transform: uppercase; letter-spacing: .14em; color: var(--muted); padding: 0 10px; margin: 14px 0 6px; font-weight: 600; }
    .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 12px; cursor: pointer; transition: all .2s ease; font-size: 14px; font-weight: 500; color: var(--muted); text-decoration: none; }
    .nav-item:hover { background: var(--violet-soft); color: var(--violet); }
    .nav-item.active { background: linear-gradient(135deg, var(--violet-soft), #DDD6FE); color: var(--violet); font-weight: 600; box-shadow: inset 0 0 0 1px rgba(124,58,237,.2); }
    .nav-item .icon { font-size: 17px; width: 22px; text-align: center; }
    .sidebar-bottom { padding: 20px; border-top: 1px solid var(--border-soft); }
    .user-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border-radius: 14px; background: var(--surface2); cursor: pointer; transition: background .2s, box-shadow .2s; border: 1px solid var(--border-soft); }
    .user-card:hover { background: var(--violet-soft); box-shadow: var(--shadow-sm); }
    .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--violet), #C084FC); border-radius: 50%; display: grid; place-items: center; font-weight: 700; font-size: 15px; color: #fff; flex-shrink: 0; }
    .user-info { flex: 1; }
    .user-name { font-size: 13px; font-weight: 600; color: var(--text); }
    .user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }
    .user-dots { color: var(--muted); font-size: 18px; }

    /* ═══════════════════════════════════════
       MAIN  (identical to Home.aspx)
    ═══════════════════════════════════════ */
    .main { margin-left: var(--sidebar); flex: 1; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - var(--sidebar)); overflow-x: hidden; }

    /* ── TOPBAR ── */
    .topbar { height: 70px; background: rgba(247,245,255,.95); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; padding: 0 32px; gap: 16px; position: sticky; top: 0; z-index: 90; }
    .location-pill { display: flex; align-items: center; gap: 8px; background: var(--surface); border: 1px solid var(--border-soft); border-radius: 24px; padding: 8px 16px; font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s; box-shadow: var(--shadow-sm); color: var(--text-mid); white-space: nowrap; flex-shrink: 0; }
    .location-pill:hover { border-color: var(--violet); }
    .location-pill .dot { width: 8px; height: 8px; background: #22C55E; border-radius: 50%; box-shadow: 0 0 6px #22C55E; flex-shrink: 0; }
    .search-wrap { flex: 1; display: flex; align-items: center; gap: 10px; background: var(--surface); border: 1.5px solid var(--border-soft); border-radius: 28px; padding: 0 16px; height: 44px; transition: border-color .25s, box-shadow .25s; box-shadow: var(--shadow-sm); min-width: 0; }
    .search-wrap:focus-within { border-color: var(--violet); box-shadow: 0 0 0 3px var(--violet-glow); }
    .search-wrap .s-icon { color: var(--muted); font-size: 17px; flex-shrink: 0; }
    .search-wrap input { flex: 1; background: none; border: none; outline: none; color: var(--text); font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; min-width: 0; width: 100%; }
    .search-wrap input::placeholder { color: var(--muted); }
    .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
    .icon-btn { width: 42px; height: 42px; border-radius: 50%; background: var(--surface); border: 1px solid var(--border-soft); display: grid; place-items: center; cursor: pointer; font-size: 18px; position: relative; transition: all .2s; box-shadow: var(--shadow-sm); }
    .icon-btn:hover { border-color: var(--violet); background: var(--violet-soft); }
    .notif-dot { position: absolute; top: 8px; right: 9px; width: 8px; height: 8px; background: var(--coral); border-radius: 50%; border: 2px solid var(--bg); }

    /* ── CONTENT ── */
    .content { padding: 30px 32px 48px; flex: 1; }

    /* ═══════════════════════════════════════
       HERO BANNER  (same purple gradient)
    ═══════════════════════════════════════ */
    .hero { border-radius: 26px; background: linear-gradient(130deg, #5B21B6 0%, #7C3AED 45%, #A855F7 80%, #C084FC 100%); padding: 44px 50px; display: flex; align-items: center; justify-content: space-between; gap: 28px; margin-bottom: 32px; position: relative; overflow: hidden; box-shadow: var(--shadow-lg); }
    .hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 80% 20%, rgba(255,255,255,.12) 0%, transparent 50%), radial-gradient(ellipse at 20% 80%, rgba(255,255,255,.06) 0%, transparent 40%); }
    .hero-dots { position: absolute; right: 240px; top: 18px; width: 110px; height: 110px; background-image: radial-gradient(circle, rgba(255,255,255,.18) 1.5px, transparent 1.5px); background-size: 16px 16px; border-radius: 50%; pointer-events: none; }
    .hero-left { position: relative; z-index: 1; flex: 1; }
    .hero-label { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .16em; color: rgba(255,255,255,.75); background: rgba(255,255,255,.12); padding: 5px 14px; border-radius: 20px; margin-bottom: 14px; font-weight: 600; }
    .hero h1 { font-family: 'Playfair Display', serif; font-size: 40px; font-weight: 900; line-height: 1.12; color: #fff; margin-bottom: 10px; }
    .hero p { font-size: 14px; color: rgba(255,255,255,.75); max-width: 400px; line-height: 1.7; }
    .hero-image { width: 200px; height: 180px; border-radius: 20px; background: linear-gradient(135deg, rgba(255,200,100,.5), rgba(255,107,107,.4)); display: flex; align-items: center; justify-content: center; font-size: 76px; box-shadow: 0 16px 44px rgba(0,0,0,.3); position: relative; z-index: 1; border: 2px solid rgba(255,255,255,.25); flex-shrink: 0; }

    /* ═══════════════════════════════════════
       QUICK CONTACT CARDS  (3 columns)
    ═══════════════════════════════════════ */
    .contact-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 32px; }
    .c-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 26px 24px; display: flex; align-items: flex-start; gap: 16px; box-shadow: var(--shadow-sm); transition: all .22s ease; cursor: pointer; }
    .c-card:hover { border-color: rgba(124,58,237,.3); box-shadow: var(--shadow-md); transform: translateY(-3px); }
    .c-card-icon { width: 50px; height: 50px; border-radius: 14px; display: grid; place-items: center; font-size: 22px; flex-shrink: 0; }
    .c-card-icon.violet { background: var(--violet-soft); }
    .c-card-icon.green  { background: #DCFCE7; }
    .c-card-icon.gold   { background: #FEF3C7; }
    .c-card-body h3 { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 800; color: var(--text); margin-bottom: 4px; }
    .c-card-body p  { font-size: 12px; color: var(--muted); font-weight: 500; margin-bottom: 8px; line-height: 1.5; }
    .c-card-link { font-size: 13px; font-weight: 700; color: var(--violet); display: inline-flex; align-items: center; gap: 4px; transition: gap .2s; }
    .c-card-link:hover { gap: 8px; }

    /* ═══════════════════════════════════════
       MAIN BODY  (info panel + form panel)
    ═══════════════════════════════════════ */
    .contact-body { display: grid; grid-template-columns: 380px 1fr; gap: 24px; margin-bottom: 32px; }

    /* ── LEFT INFO PANEL ── */
    .info-panel { display: flex; flex-direction: column; gap: 20px; }

    /* Map placeholder */
    .map-box { height: 220px; background: linear-gradient(145deg, #EEF2FF, #EDE9FE); border-radius: 16px; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; border: 1px solid rgba(124,58,237,.1); }
    .map-grid-bg { position: absolute; inset: 0; background-image: linear-gradient(rgba(124,58,237,.07) 1px, transparent 1px), linear-gradient(90deg, rgba(124,58,237,.07) 1px, transparent 1px); background-size: 30px 30px; }
    .map-pin { width: 46px; height: 46px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); border-radius: 50% 50% 50% 0; transform: rotate(-45deg); box-shadow: 0 8px 24px rgba(124,58,237,.4); position: relative; z-index: 1; }
    .map-pin::after { content: '📍'; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%) rotate(45deg); font-size: 20px; }
    .map-pin::before { content: ''; position: absolute; inset: -12px; border-radius: 50%; background: rgba(124,58,237,.12); animation: pulse 2s ease-in-out infinite; }
    @keyframes pulse { 0%,100% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.35); opacity: 0; } }

    /* Office details card */
    .office-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 24px; box-shadow: var(--shadow-sm); }
    .office-card h3 { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: var(--text); margin-bottom: 20px; }
    .office-row { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 18px; }
    .office-row:last-child { margin-bottom: 0; }
    .office-row-icon { width: 36px; height: 36px; border-radius: 10px; display: grid; place-items: center; font-size: 17px; flex-shrink: 0; }
    .office-row-icon.v  { background: var(--violet-soft); }
    .office-row-icon.g  { background: #DCFCE7; }
    .office-row-icon.b  { background: #DBEAFE; }
    .office-row-icon.o  { background: #FEF3C7; }
    .office-row-text strong { display: block; font-size: 12px; font-weight: 700; color: var(--text-mid); text-transform: uppercase; letter-spacing: .07em; margin-bottom: 3px; }
    .office-row-text span { font-size: 13px; color: var(--muted); font-weight: 500; line-height: 1.55; }
    .office-row-text a { font-size: 13px; color: var(--violet); font-weight: 600; }
    .office-row-text a:hover { text-decoration: underline; }

    /* Social links */
    .social-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 20px 24px; box-shadow: var(--shadow-sm); }
    .social-card h4 { font-size: 13px; font-weight: 700; color: var(--text-mid); text-transform: uppercase; letter-spacing: .1em; margin-bottom: 14px; }
    .social-icons { display: flex; gap: 10px; }
    .soc-btn { width: 40px; height: 40px; border-radius: 12px; display: grid; place-items: center; font-size: 18px; cursor: pointer; transition: all .2s; border: 1px solid var(--border-soft); background: var(--surface2); }
    .soc-btn:hover { transform: translateY(-3px); box-shadow: var(--shadow-sm); }
    .soc-fb:hover { background: #1877F2; color: #fff; border-color: #1877F2; }
    .soc-tw:hover { background: #1DA1F2; color: #fff; border-color: #1DA1F2; }
    .soc-ig:hover { background: #E1306C; color: #fff; border-color: #E1306C; }
    .soc-yt:hover { background: #FF0000; color: #fff; border-color: #FF0000; }
    .soc-wa:hover { background: #25D366; color: #fff; border-color: #25D366; }

    /* ── RIGHT FORM PANEL (SimplyBook-style) ── */
    .form-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 40px 44px; box-shadow: var(--shadow-md); }
    .form-panel-heading { text-align: center; margin-bottom: 36px; }
    .form-panel-heading h2 { font-family: 'Playfair Display', serif; font-size: 32px; font-weight: 900; color: var(--text); line-height: 1.2; }
    .form-panel-heading h2 span { color: var(--violet); }
    .form-panel-heading p { font-size: 14px; color: var(--muted); margin-top: 8px; font-weight: 500; }

    .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
    .form-group { display: flex; flex-direction: column; gap: 7px; margin-bottom: 18px; }
    .form-group.full { grid-column: 1 / -1; }
    .form-group label { font-size: 13px; font-weight: 700; color: var(--text-mid); display: flex; align-items: center; gap: 4px; }
    .form-group label .req { color: var(--coral); font-size: 14px; }

    .form-input { background: var(--surface2); border: 1.5px solid var(--border-soft); border-radius: 12px; padding: 12px 16px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); outline: none; width: 100%; transition: border-color .2s, box-shadow .2s; }
    .form-input:focus { border-color: var(--violet); box-shadow: 0 0 0 3px var(--violet-glow); background: var(--surface); }
    .form-input::placeholder { color: var(--muted); font-weight: 400; }
    .form-textarea { resize: vertical; min-height: 130px; }
    .form-select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%238B7BB0' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 14px center; padding-right: 36px; cursor: pointer; }

    /* Character counter */
    .char-counter { font-size: 11px; color: var(--muted); text-align: right; margin-top: -12px; }

    /* Submit button */
    .submit-btn { width: 100%; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 14px; padding: 16px; font-size: 15px; font-weight: 700; cursor: pointer; transition: all .22s ease; box-shadow: 0 4px 18px rgba(124,58,237,.35); font-family: 'Plus Jakarta Sans', sans-serif; display: flex; align-items: center; justify-content: center; gap: 10px; margin-top: 6px; }
    .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(124,58,237,.45); }
    .submit-btn:active { transform: translateY(0); }

    /* Success / Error alert */
    .alert { padding: 14px 18px; border-radius: 12px; font-size: 14px; font-weight: 600; margin-top: 16px; display: flex; align-items: center; gap: 10px; }
    .alert-success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
    .alert-error   { background: #FEE2E2; color: #DC2626; border: 1px solid #FECACA; }

    /* ═══════════════════════════════════════
       FAQ SECTION
    ═══════════════════════════════════════ */
    .faq-section { margin-bottom: 40px; }
    .faq-heading { font-family: 'Playfair Display', serif; font-size: 26px; font-weight: 800; color: var(--text); margin-bottom: 20px; }
    .faq-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .faq-item { background: var(--surface); border: 1px solid var(--border-soft); border-radius: 14px; overflow: hidden; box-shadow: var(--shadow-sm); }
    .faq-q { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px; font-size: 14px; font-weight: 600; color: var(--text); cursor: pointer; transition: background .18s; gap: 12px; }
    .faq-q:hover { background: var(--surface2); }
    .faq-toggle { width: 26px; height: 26px; border-radius: 50%; background: var(--violet-soft); color: var(--violet); display: grid; place-items: center; font-size: 16px; font-weight: 700; flex-shrink: 0; transition: all .2s; }
    .faq-item.open .faq-toggle { background: var(--violet); color: #fff; transform: rotate(45deg); }
    .faq-a { font-size: 13px; color: var(--muted); font-weight: 500; line-height: 1.7; padding: 0 20px; max-height: 0; overflow: hidden; transition: max-height .3s ease, padding .3s ease; }
    .faq-item.open .faq-a { max-height: 200px; padding: 0 20px 18px; }

    /* ═══════════════════════════════════════
       ANIMATIONS
    ═══════════════════════════════════════ */
    @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
    .hero          { animation: fadeUp .55s ease both; }
    .contact-cards { animation: fadeUp .5s .10s ease both; }
    .contact-body  { animation: fadeUp .5s .18s ease both; }
    .faq-section   { animation: fadeUp .5s .26s ease both; }
  </style>
</head>
<body>
<form id="form1" runat="server">
<div class="layout">

  <!-- ══════════ SIDEBAR ══════════ -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">🎯</div>
      <div class="logo-text">EventNearMe<span>Discover Local Events</span></div>
    </div>
    <nav class="nav">
      <div class="nav-label">Menu</div>
      <a class="nav-item" href="Home.aspx"><span class="icon">🏠</span> Home</a>
      <a class="nav-item" href="Event.aspx"><span class="icon">🎪</span> Event</a>
      <a class="nav-item" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
      <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
      <a class="nav-item active" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
      <a class="nav-item" href="AboutUs.aspx"><span class="icon">ℹ️</span> About Us</a>
    </nav>
    <div class="sidebar-bottom">
      <div class="user-card">
        <div class="avatar">
          <asp:Label ID="lblAvatarInitial" runat="server" Text="Y" />
        </div>
        <div class="user-info">
          <div class="user-name"><asp:Label ID="lblUserName" runat="server" Text="Yashvi Sarang" /></div>
          <div class="user-role"><asp:Label ID="lblUserRole" runat="server" Text="Pro Member ✦" /></div>
        </div>
        <div class="user-dots">⋯</div>
      </div>
    </div>
  </aside>

  <!-- ══════════ MAIN ══════════ -->
  <main class="main">

    <!-- TOPBAR -->
    <header class="topbar">
      <div class="location-pill">
        <span class="dot"></span>
        📍&nbsp;<asp:Label ID="lblLocation" runat="server" Text="Surat, Gujarat" />
        <span style="color:var(--muted);font-size:11px;margin-left:2px">▾</span>
      </div>
      <div class="search-wrap">
        <span class="s-icon">🔍</span>
        <asp:TextBox ID="txtSearchTop" runat="server"
          placeholder="Search events, artists, venues…"
          style="flex:1;background:none;border:none;outline:none;color:var(--text);font-size:14px;font-family:'Plus Jakarta Sans',sans-serif;min-width:0;width:100%" />
      </div>
      <div class="topbar-right">
        <div class="icon-btn">🔔<span class="notif-dot"></span></div>
        <div class="icon-btn">💬</div>
        <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet);box-shadow:0 0 0 3px var(--violet-soft)">
          <asp:Label ID="lblTopAvatar" runat="server" Text="Y" />
        </div>
      </div>
    </header>

    <!-- PAGE CONTENT -->
    <div class="content">

      <!-- ── HERO ── -->
      <div class="hero">
        <div class="hero-dots"></div>
        <div class="hero-left">
          <div class="hero-label">📞 Get in Touch</div>
          <h1>Have Any<br />Questions?</h1>
          <p>We're here to help with event bookings, venue enquiries, partnerships &amp; support. Reach out — we'd love to hear from you!</p>
        </div>
        <div class="hero-image">📞</div>
      </div>

      <!-- ── QUICK CONTACT CARDS ── -->
      <div class="contact-cards">

        <div class="c-card">
          <div class="c-card-icon violet">📧</div>
          <div class="c-card-body">
            <h3>Email Us</h3>
            <p>We reply within a few hours on business days.</p>
            <a class="c-card-link" href="mailto:hello@eventnearme.in">hello@eventnearme.in →</a>
          </div>
        </div>

        <div class="c-card">
          <div class="c-card-icon green">📱</div>
          <div class="c-card-body">
            <h3>Call Us</h3>
            <p>Mon – Sat · 10:00 AM to 7:00 PM IST</p>
            <a class="c-card-link" href="tel:+912612345678">+91 261 234 5678 →</a>
          </div>
        </div>

        <div class="c-card">
          <div class="c-card-icon gold">💬</div>
          <div class="c-card-body">
            <h3>Live Chat</h3>
            <p>Instant support from our team right now.</p>
            <a class="c-card-link" href="#">Start Conversation →</a>
          </div>
        </div>

      </div><!-- /contact-cards -->

      <!-- ── CONTACT BODY: info left + form right ── -->
      <div class="contact-body">

        <!-- LEFT: Office info + map + socials -->
        <div class="info-panel">

          <!-- Map -->
          <div class="map-box">
            <div class="map-grid-bg"></div>
            <div class="map-pin"></div>
          </div>

          <!-- Office Details -->
          <div class="office-card">
            <h3>🏢 Our Office</h3>

            <div class="office-row">
              <div class="office-row-icon v">📍</div>
              <div class="office-row-text">
                <strong>Address</strong>
                <span>403, Titanium One, Near VR Mall,<br />Dumas Road, Surat – 395006, Gujarat</span>
              </div>
            </div>

            <div class="office-row">
              <div class="office-row-icon g">📧</div>
              <div class="office-row-text">
                <strong>Email</strong>
                <a href="mailto:hello@eventnearme.in">hello@eventnearme.in</a>
              </div>
            </div>

            <div class="office-row">
              <div class="office-row-icon b">📞</div>
              <div class="office-row-text">
                <strong>Phone</strong>
                <a href="tel:+912612345678">+91 261 234 5678</a>
              </div>
            </div>

            <div class="office-row">
              <div class="office-row-icon o">⏰</div>
              <div class="office-row-text">
                <strong>Working Hours</strong>
                <span>Monday – Saturday: 10:00 AM – 7:00 PM</span>
              </div>
            </div>
          </div>

          <!-- Social Links -->
          <div class="social-card">
            <h4>Follow Us</h4>
            <div class="social-icons">
              <div class="soc-btn soc-fb" title="Facebook">🇫</div>
              <div class="soc-btn soc-tw" title="Twitter / X">𝕏</div>
              <div class="soc-btn soc-ig" title="Instagram">📸</div>
              <div class="soc-btn soc-yt" title="YouTube">▶</div>
              <div class="soc-btn soc-wa" title="WhatsApp">💬</div>
            </div>
          </div>

        </div><!-- /info-panel -->

        <!-- RIGHT: SimplyBook-style contact form -->
        <div class="form-panel">

          <div class="form-panel-heading">
            <h2>Have any <span>questions</span> ?</h2>
            <p>Feel free to contact us — we'll get back to you shortly.</p>
          </div>

          <div class="form-grid-2">

            <!-- Name -->
            <div class="form-group">
              <label>Your name <span class="req">*</span></label>
              <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="Your name" />
              <asp:RequiredFieldValidator ID="rfvName" runat="server"
                ControlToValidate="txtName" ErrorMessage="Name is required."
                Display="Dynamic" ForeColor="#DC2626"
                style="font-size:12px;font-weight:600;margin-top:-4px" />
            </div>

            <!-- Phone -->
            <div class="form-group">
              <label>Phone number</label>
              <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="+91 98765 43210" />
            </div>

            <!-- Email -->
            <div class="form-group full">
              <label>Email <span class="req">*</span></label>
              <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input" placeholder="Email" />
              <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                ControlToValidate="txtEmail" ErrorMessage="Email is required."
                Display="Dynamic" ForeColor="#DC2626"
                style="font-size:12px;font-weight:600;margin-top:-4px" />
              <asp:RegularExpressionValidator ID="revEmail" runat="server"
                ControlToValidate="txtEmail"
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                ErrorMessage="Please enter a valid email."
                Display="Dynamic" ForeColor="#DC2626"
                style="font-size:12px;font-weight:600;margin-top:-4px" />
            </div>

            <!-- Subject dropdown -->
            <div class="form-group full">
              <label>Subject</label>
              <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-input form-select">
                <asp:ListItem Text="Select a subject…" Value="" />
                <asp:ListItem Text="🎟️ Ticket Support" Value="ticket" />
                <asp:ListItem Text="🏛️ Venue / Hall Booking" Value="venue" />
                <asp:ListItem Text="🤝 Partnership / Sponsorship" Value="partner" />
                <asp:ListItem Text="🎪 List My Event" Value="list" />
                <asp:ListItem Text="💡 General Enquiry" Value="general" />
                <asp:ListItem Text="⚠️ Report an Issue" Value="issue" />
              </asp:DropDownList>
            </div>

            <!-- Message -->
            <div class="form-group full">
              <label>Message <span class="req">*</span></label>
              <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" CssClass="form-input form-textarea"
                placeholder="Message" onkeyup="updateCounter(this)" />
              <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                ControlToValidate="txtMessage" ErrorMessage="Message is required."
                Display="Dynamic" ForeColor="#DC2626"
                style="font-size:12px;font-weight:600;margin-top:-4px" />
              <div class="char-counter"><span id="charCount">0</span> / 500 characters</div>
            </div>

          </div><!-- /form-grid-2 -->

          <!-- Submit -->
          <asp:Button ID="btnSend" runat="server" CssClass="submit-btn"
            Text="Send now  ✈" />

          <!-- Feedback message -->
          <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="alert alert-success">
              ✅ &nbsp;<asp:Label ID="lblSuccess" runat="server" />
            </div>
          </asp:Panel>
          <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="alert alert-error">
              ⚠️ &nbsp;<asp:Label ID="lblError" runat="server" />
            </div>
          </asp:Panel>

        </div><!-- /form-panel -->
      </div><!-- /contact-body -->

      <!-- ── FAQ SECTION ── -->
      <div class="faq-section">
        <div class="faq-heading">❓ Frequently Asked Questions</div>
        <div class="faq-grid">

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              How do I book tickets for an event?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">Browse events on the Events page, click "Book Now", and complete the payment securely. A confirmation email with your e-ticket &amp; QR code will be sent instantly.</div>
          </div>

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              Can I get a refund for my ticket?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">Refunds are available up to 48 hours before the event. Contact us at support@eventnearme.in with your booking ID and we'll process it within 3–5 business days.</div>
          </div>

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              How do I list my event on EventNearMe?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">Create an organiser account, then use the "Add Event" option in your dashboard. Our team reviews and approves events within 24 hours. Select "List My Event" in the form above to get started.</div>
          </div>

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              Are there group booking discounts?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">Yes! Groups of 10 or more receive a 15% discount automatically. For groups of 50+, contact us directly for a custom quote and dedicated support.</div>
          </div>

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              How do I book a hall or venue?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">Visit the Hall page, browse available venues, and click "Enquire". Fill in your event details and our team will get back to you within 24 hours with availability and pricing.</div>
          </div>

          <div class="faq-item">
            <div class="faq-q" onclick="toggleFaq(this)">
              What payment methods do you accept?
              <span class="faq-toggle">+</span>
            </div>
            <div class="faq-a">We accept UPI, credit/debit cards, net banking, and popular wallets like Paytm &amp; PhonePe. All payments are processed securely via our payment gateway.</div>
          </div>

        </div><!-- /faq-grid -->
      </div><!-- /faq-section -->

    </div><!-- /content -->
  </main>

</div><!-- /layout -->
</form>

<script>
  /* FAQ accordion */
  function toggleFaq(qEl) {
    const item = qEl.closest('.faq-item');
    const isOpen = item.classList.contains('open');
    document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
    if (!isOpen) item.classList.add('open');
  }

  /* Character counter for message */
  function updateCounter(el) {
    const count = el.value.length;
    document.getElementById('charCount').textContent = count;
    if (count > 500) el.value = el.value.substring(0, 500);
  }
</script>
</body>

</html>
