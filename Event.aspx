<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Event.aspx.cs" Inherits="EventGlint.Event" %>

<!DOCTYPE html>
<%@ Import Namespace="System.Web.Optimization" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Events</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
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

    /* ── SIDEBAR ── */
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
    .user-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border-radius: 14px; background: var(--surface2); cursor: pointer; border: 1px solid var(--border-soft); }
    .user-card:hover { background: var(--violet-soft); }
    .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--violet), #C084FC); border-radius: 50%; display: grid; place-items: center; font-weight: 700; font-size: 15px; color: #fff; flex-shrink: 0; }
    .user-info { flex: 1; }
    .user-name { font-size: 13px; font-weight: 600; color: var(--text); }
    .user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }
    .user-dots { color: var(--muted); font-size: 18px; }

    /* ── MAIN ── */
    .main { margin-left: var(--sidebar); flex: 1; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - var(--sidebar)); overflow-x: hidden; }

    /* ── TOPBAR ── */
    .topbar { height: 70px; background: rgba(247,245,255,.95); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; padding: 0 32px; gap: 16px; position: sticky; top: 0; z-index: 90; }
    .location-pill { display: flex; align-items: center; gap: 8px; background: var(--surface); border: 1px solid var(--border-soft); border-radius: 24px; padding: 8px 16px; font-size: 13px; font-weight: 500; cursor: pointer; box-shadow: var(--shadow-sm); color: var(--text-mid); white-space: nowrap; flex-shrink: 0; }
    .location-pill .dot { width: 8px; height: 8px; background: #22C55E; border-radius: 50%; box-shadow: 0 0 6px #22C55E; flex-shrink: 0; }
    .search-wrap { flex: 1; display: flex; align-items: center; gap: 10px; background: var(--surface); border: 1.5px solid var(--border-soft); border-radius: 28px; padding: 0 16px; height: 44px; box-shadow: var(--shadow-sm); min-width: 0; transition: border-color .25s, box-shadow .25s; }
    .search-wrap:focus-within { border-color: var(--violet); box-shadow: 0 0 0 3px var(--violet-glow); }
    .search-wrap .s-icon { color: var(--muted); font-size: 17px; flex-shrink: 0; }
    .search-wrap input { flex: 1; background: none; border: none; outline: none; color: var(--text); font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; min-width: 0; width: 100%; }
    .search-wrap input::placeholder { color: var(--muted); }
    .filter-btn { width: 34px; height: 34px; border-radius: 50%; background: var(--surface2); border: 1px solid var(--border-soft); display: grid; place-items: center; cursor: pointer; color: var(--muted); font-size: 15px; flex-shrink: 0; padding: 0; transition: all .2s; }
    .filter-btn:hover { background: var(--violet); color: #fff; border-color: var(--violet); }
    .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
    .icon-btn { width: 42px; height: 42px; border-radius: 50%; background: var(--surface); border: 1px solid var(--border-soft); display: grid; place-items: center; cursor: pointer; font-size: 18px; position: relative; box-shadow: var(--shadow-sm); }
    .icon-btn:hover { border-color: var(--violet); background: var(--violet-soft); }
    .notif-dot { position: absolute; top: 8px; right: 9px; width: 8px; height: 8px; background: var(--coral); border-radius: 50%; border: 2px solid var(--bg); }

    /* ── CONTENT ── */
    .content { padding: 30px 32px 48px; flex: 1; }

    /* ── HERO ── */
    .hero { border-radius: 26px; background: linear-gradient(130deg, #5B21B6 0%, #7C3AED 45%, #A855F7 80%, #C084FC 100%); padding: 44px 50px; display: flex; align-items: center; justify-content: space-between; gap: 28px; margin-bottom: 28px; position: relative; overflow: hidden; box-shadow: var(--shadow-lg); }
    .hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 80% 20%, rgba(255,255,255,.12) 0%, transparent 50%), radial-gradient(ellipse at 20% 80%, rgba(255,255,255,.06) 0%, transparent 40%); }
    .hero-dots { position: absolute; right: 260px; top: 18px; width: 110px; height: 110px; background-image: radial-gradient(circle, rgba(255,255,255,.18) 1.5px, transparent 1.5px); background-size: 16px 16px; border-radius: 50%; pointer-events: none; }
    .hero-left { position: relative; z-index: 1; flex: 1; }
    .hero-label { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .16em; color: rgba(255,255,255,.75); background: rgba(255,255,255,.12); padding: 5px 14px; border-radius: 20px; margin-bottom: 14px; font-weight: 600; }
    .hero h1 { font-family: 'Playfair Display', serif; font-size: 40px; font-weight: 900; line-height: 1.12; color: #fff; margin-bottom: 10px; }
    .hero p { font-size: 14px; color: rgba(255,255,255,.75); max-width: 420px; line-height: 1.65; }
    .hero-counters { display: flex; gap: 32px; margin-top: 22px; }
    .hero-counter-num { font-family: 'Playfair Display', serif; font-size: 28px; font-weight: 900; color: #fff; line-height: 1; }
    .hero-counter-label { font-size: 11px; color: rgba(255,255,255,.65); font-weight: 500; margin-top: 3px; }
    .hero-image { width: 200px; height: 180px; border-radius: 20px; background: linear-gradient(135deg, rgba(255,200,100,.5), rgba(255,107,107,.4)); display: flex; align-items: center; justify-content: center; font-size: 72px; box-shadow: 0 16px 44px rgba(0,0,0,.3); position: relative; z-index: 1; border: 2px solid rgba(255,255,255,.25); flex-shrink: 0; }

    /* ── CHIP ROW ── */
    .chip-row { display: flex; align-items: center; gap: 10px; margin-bottom: 28px; overflow-x: auto; padding-bottom: 4px; }
    .chip-row::-webkit-scrollbar { height: 0; }
    .chip { background: var(--surface); border: 1.5px solid var(--border-soft); padding: 9px 20px; border-radius: 24px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all .2s; color: var(--text-mid); white-space: nowrap; box-shadow: var(--shadow-sm); }
    .chip:hover { background: var(--violet-soft); border-color: rgba(124,58,237,.3); color: var(--violet); }
    .chip.active { background: var(--violet); border-color: var(--violet); color: #fff; box-shadow: 0 4px 14px rgba(124,58,237,.35); }
    .chip-divider { width: 1px; height: 30px; background: var(--border-soft); flex-shrink: 0; }
    .sort-select { background: var(--surface); border: 1.5px solid var(--border-soft); border-radius: 22px; padding: 8px 18px; font-size: 13px; font-weight: 600; color: var(--text-mid); outline: none; font-family: 'Plus Jakarta Sans', sans-serif; cursor: pointer; box-shadow: var(--shadow-sm); white-space: nowrap; margin-left: auto; flex-shrink: 0; }
    .sort-select:focus { border-color: var(--violet); }

    /* ── SECTION HEADER ── */
    .sec-row { display: flex; align-items: baseline; justify-content: space-between; margin-bottom: 18px; gap: 12px; }
    .sec-title { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 800; color: var(--text); }
    .sec-meta { font-size: 13px; color: var(--muted); font-weight: 500; margin-left: 8px; }
    .see-all { font-size: 13px; font-weight: 600; color: var(--violet); display: flex; align-items: center; gap: 4px; transition: gap .2s; flex-shrink: 0; }
    .see-all:hover { gap: 8px; }

    /* ── FEATURED WIDE CARDS ── */
    .featured-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 36px; }
    .ev-wide { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); overflow: hidden; box-shadow: var(--shadow-sm); display: flex; cursor: pointer; transition: all .22s; min-height: 170px; }
    .ev-wide:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); border-color: rgba(124,58,237,.2); }
    .ev-wide-thumb { width: 150px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 52px; position: relative; }
    .ev-wide-thumb::after { content: ''; position: absolute; right: 0; top: 0; bottom: 0; width: 36px; background: linear-gradient(to right, transparent, var(--surface)); }
    .ev-wide-body { flex: 1; padding: 20px 20px 20px 8px; display: flex; flex-direction: column; justify-content: space-between; }
    .ev-wide-cat { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--violet); margin-bottom: 5px; }
    .ev-wide-name { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 800; color: var(--text); line-height: 1.3; margin-bottom: 8px; }
    .ev-wide-meta { display: flex; flex-direction: column; gap: 3px; }
    .ev-wide-meta span { font-size: 12px; color: var(--muted); font-weight: 500; }
    .ev-wide-footer { display: flex; align-items: center; justify-content: space-between; margin-top: 12px; }
    .ev-wide-price { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 800; color: var(--gold); }
    .ev-wide-price.free { color: var(--green); font-family: 'Plus Jakarta Sans', sans-serif; font-size: 15px; font-weight: 700; }

    /* ── BOOK BUTTON (shared) ── */
    .ev-book-btn { background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 16px; padding: 9px 20px; font-size: 12px; font-weight: 700; cursor: pointer; transition: all .2s; box-shadow: 0 3px 10px rgba(124,58,237,.3); font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
    .ev-book-btn:hover { transform: scale(1.05); box-shadow: 0 6px 18px rgba(124,58,237,.4); }

    /* ── POSTER GRID ── */
    .event-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 36px; }
    .ev-poster { background: var(--surface); border-radius: 16px; overflow: hidden; box-shadow: var(--shadow-sm); border: 1px solid var(--border-soft); cursor: pointer; transition: transform .22s ease, box-shadow .22s ease; display: flex; flex-direction: column; }
    .ev-poster:hover { transform: translateY(-7px); box-shadow: var(--shadow-lg); border-color: rgba(124,58,237,.18); }
    .ev-poster-img { width: 100%; aspect-ratio: 3/4; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .ev-emoji-large { font-size: 80px; position: relative; z-index: 1; }

    /* Poster backgrounds */
    .bg1 { background: linear-gradient(160deg, #0f0c29, #302b63, #24243e); }
    .bg2 { background: linear-gradient(160deg, #1a0533, #6b21a8, #4c1d95); }
    .bg3 { background: linear-gradient(160deg, #7f1d1d, #991b1b, #c2410c); }
    .bg4 { background: linear-gradient(160deg, #064e3b, #065f46, #059669); }
    .bg5 { background: linear-gradient(160deg, #1e3a5f, #1d4ed8, #3b82f6); }
    .bg6 { background: linear-gradient(160deg, #4a1942, #7c3aed, #be185d); }
    .bg7 { background: linear-gradient(160deg, #422006, #92400e, #d97706); }
    .bg8 { background: linear-gradient(160deg, #0c4a6e, #0369a1, #0ea5e9); }

    .ev-poster-img::after { content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 55%; background: linear-gradient(to top, rgba(0,0,0,.7) 0%, transparent 100%); z-index: 2; }
    .ev-poster-top { position: absolute; top: 12px; left: 12px; right: 12px; display: flex; justify-content: space-between; align-items: flex-start; z-index: 3; }
    .ev-cat-tag { font-size: 10px; font-weight: 700; padding: 4px 10px; border-radius: 12px; backdrop-filter: blur(10px); text-transform: uppercase; letter-spacing: .05em; border: 1px solid rgba(255,255,255,.2); }
    .tag-music  { background: rgba(139,92,246,.8);  color: #fff; }
    .tag-film   { background: rgba(239,68,68,.8);   color: #fff; }
    .tag-arts   { background: rgba(234,179,8,.8);   color: #fff; }
    .tag-food   { background: rgba(34,197,94,.8);   color: #fff; }
    .tag-sports { background: rgba(59,130,246,.8);  color: #fff; }
    .tag-comedy { background: rgba(249,115,22,.8);  color: #fff; }
    .tag-dance  { background: rgba(236,72,153,.8);  color: #fff; }
    .tag-fest   { background: rgba(124,58,237,.8);  color: #fff; }
    .ev-heart { width: 30px; height: 30px; border-radius: 50%; background: rgba(255,255,255,.18); backdrop-filter: blur(8px); display: grid; place-items: center; font-size: 14px; color: #fff; cursor: pointer; transition: all .2s; border: 1px solid rgba(255,255,255,.25); user-select: none; }
    .ev-heart:hover { background: rgba(220,38,38,.7); }
    .ev-ribbon { position: absolute; top: 48px; right: -24px; font-size: 9px; font-weight: 800; padding: 4px 32px; transform: rotate(45deg); letter-spacing: .08em; z-index: 4; text-transform: uppercase; }
    .ribbon-trending { background: linear-gradient(90deg, #f59e0b, #ef4444); color: #fff; }
    .ribbon-free     { background: #16A34A; color: #fff; }
    .ribbon-hot      { background: var(--coral); color: #fff; }
    .ribbon-limited  { background: #7C3AED; color: #fff; }
    .ev-poster-bottom { position: absolute; bottom: 12px; left: 12px; right: 12px; z-index: 3; }
    .ev-poster-date { font-size: 11px; font-weight: 600; color: rgba(255,255,255,.88); }
    .ev-poster-body { padding: 14px 16px 16px; flex: 1; display: flex; flex-direction: column; gap: 10px; }
    .ev-poster-name { font-family: 'Playfair Display', serif; font-size: 15px; font-weight: 800; color: var(--text); line-height: 1.35; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .ev-poster-loc  { font-size: 12px; color: var(--muted); font-weight: 500; }
    .ev-poster-att  { font-size: 12px; color: var(--muted); font-weight: 500; }
    .ev-poster-footer { display: flex; align-items: center; justify-content: space-between; margin-top: auto; padding-top: 4px; }
    .ev-poster-price { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: var(--gold); }
    .ev-poster-price.free { color: var(--green); font-family: 'Plus Jakarta Sans', sans-serif; font-size: 14px; font-weight: 700; }

    /* ── PAGINATION ── */
    .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 12px; }
    .page-btn { width: 40px; height: 40px; border-radius: 12px; border: 1.5px solid var(--border-soft); background: var(--surface); display: grid; place-items: center; font-size: 14px; font-weight: 600; cursor: pointer; transition: all .2s; color: var(--text-mid); font-family: 'Plus Jakarta Sans', sans-serif; box-shadow: var(--shadow-sm); }
    .page-btn:hover { background: var(--violet-soft); border-color: rgba(124,58,237,.3); color: var(--violet); }
    .page-btn.active { background: var(--violet); border-color: var(--violet); color: #fff; box-shadow: 0 4px 14px rgba(124,58,237,.35); }
    .page-btn.arrow { font-size: 20px; }

    /* ── ANIMATIONS ── */
    @keyframes fadeUp { from { opacity: 0; transform: translateY(18px); } to { opacity: 1; transform: translateY(0); } }
    .hero          { animation: fadeUp .55s ease both; }
    .chip-row      { animation: fadeUp .5s .08s ease both; }
    .featured-grid { animation: fadeUp .5s .14s ease both; }
    .event-grid    { animation: fadeUp .5s .22s ease both; }
  </style>
</head>
<body>
<form id="form1" runat="server">
<div class="layout">

  <!-- ══ SIDEBAR ══ -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">🎯</div>
      <div class="logo-text">EventNearMe<span>Discover Local Events</span></div>
    </div>
    <nav class="nav">
      <div class="nav-label">Menu</div>
      <a class="nav-item" href="Home.aspx"><span class="icon">🏠</span> Home</a>
      <a class="nav-item active" href="Event.aspx"><span class="icon">🎪</span> Event</a>
      <a class="nav-item" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
      <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
      <a class="nav-item" href="Bookings.aspx"><span class="icon">🎟️</span> My Bookings</a>
      <a class="nav-item" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
      <a class="nav-item" href="AboutUs.aspx"><span class="icon">ℹ️</span> About Us</a>
    </nav>
    <div class="sidebar-bottom">
      <div class="user-card">
        <div class="avatar"><asp:Label ID="lblAvatarInitial" runat="server" Text="U" /></div>
        <div class="user-info">
          <div class="user-name"><asp:Label ID="lblUserName" runat="server" Text="User" /></div>
          <div class="user-role"><asp:Label ID="lblUserRole" runat="server" Text="Member" /></div>
        </div>
        <div class="user-dots">⋯</div>
      </div>
    </div>
  </aside>

  <!-- ══ MAIN ══ -->
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
        <asp:TextBox ID="txtSearch" runat="server"
          placeholder="Search events, artists, venues…"
          style="flex:1;background:none;border:none;outline:none;color:var(--text);font-size:14px;font-family:'Plus Jakarta Sans',sans-serif;min-width:0;width:100%" />
        <asp:Button ID="btnSearch" runat="server" CssClass="filter-btn" Text="⊞"
          OnClick="btnSearch_Click" style="font-size:15px" />
      </div>
      <div class="topbar-right">
        <div class="icon-btn">🔔<span class="notif-dot"></span></div>
        <div class="icon-btn">💬</div>
        <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet);box-shadow:0 0 0 3px var(--violet-soft)">
          <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
        </div>
      </div>
    </header>

    <!-- PAGE CONTENT -->
    <div class="content">

      <!-- ── HERO ── -->
      <div class="hero">
        <div class="hero-dots"></div>
        <div class="hero-left">
          <div class="hero-label">🎪 All Events in Surat</div>
          <h1>Discover Events<br />Near You</h1>
          <p>Music concerts, film festivals, food carnivals, comedy nights &amp; more — all happening around Surat.</p>
          <div class="hero-counters">
            <div>
              <div class="hero-counter-num"><asp:Label ID="lblTotalCount" runat="server" Text="124" /></div>
              <div class="hero-counter-label">Total Events</div>
            </div>
            <div>
              <div class="hero-counter-num"><asp:Label ID="lblWeekCount" runat="server" Text="18" /></div>
              <div class="hero-counter-label">This Week</div>
            </div>
            <div>
              <div class="hero-counter-num"><asp:Label ID="lblFreeCount" runat="server" Text="32" /></div>
              <div class="hero-counter-label">Free Entry</div>
            </div>
          </div>
        </div>
        <div class="hero-image">🎪</div>
      </div>

      <!-- ── CATEGORY CHIPS ── -->
      <div class="chip-row">
        <asp:LinkButton ID="chipAll"    runat="server" CssClass="chip active" CommandArgument="All"    OnClick="Chip_Click">🎯 All</asp:LinkButton>
        <asp:LinkButton ID="chipFilm"   runat="server" CssClass="chip"        CommandArgument="Film"   OnClick="Chip_Click">🎬 Film</asp:LinkButton>
        <asp:LinkButton ID="chipArts"   runat="server" CssClass="chip"        CommandArgument="Arts"   OnClick="Chip_Click">🎨 Arts</asp:LinkButton>
        <asp:LinkButton ID="chipComedy" runat="server" CssClass="chip"        CommandArgument="Comedy" OnClick="Chip_Click">🎭 Comedy</asp:LinkButton>
        <asp:LinkButton ID="chipFood"   runat="server" CssClass="chip"        CommandArgument="Food"   OnClick="Chip_Click">🍽️ Food</asp:LinkButton>
        <asp:LinkButton ID="chipDance"  runat="server" CssClass="chip"        CommandArgument="Dance"  OnClick="Chip_Click">💃 Dance</asp:LinkButton>
        <asp:LinkButton ID="chipSports" runat="server" CssClass="chip"        CommandArgument="Sports" OnClick="Chip_Click">🏅 Sports</asp:LinkButton>
        <asp:LinkButton ID="chipFree"   runat="server" CssClass="chip"        CommandArgument="Free"   OnClick="Chip_Click">🎁 Free</asp:LinkButton>
        <asp:LinkButton ID="chipMusic"  runat="server" CssClass="chip"        CommandArgument="Music"  OnClick="Chip_Click">🎵 Music</asp:LinkButton>
        <div class="chip-divider"></div>
        <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_Changed">
          <asp:ListItem Text="Sort: Upcoming"       Value="upcoming"    Selected="True" />
          <asp:ListItem Text="Sort: Price Low–High" Value="price_asc" />
          <asp:ListItem Text="Sort: Price High–Low" Value="price_desc" />
          <asp:ListItem Text="Sort: Most Popular"   Value="popular" />
        </asp:DropDownList>
      </div>

      <!-- ── FEATURED EVENTS ── -->
<div class="sec-row">
    <div><span class="sec-title">⭐ Featured Events</span></div>
    <a class="see-all" href="#">See All →</a>
</div>

<asp:Repeater ID="rptFeatured" runat="server">
    <HeaderTemplate>
        <div class="featured-grid">
    </HeaderTemplate>
    <ItemTemplate>
        <div class="ev-wide">
            <div class='ev-wide-thumb <%# GetBackgroundClass(Container.ItemIndex) %>'>
                <%# GetEventEmoji(Eval("EventType")) %>
            </div>
            <div class="ev-wide-body">
                <div>
                    <div class="ev-wide-cat"><%# GetEventEmoji(Eval("EventType")) %> <%# Eval("EventType") %></div>
                    <div class="ev-wide-name"><%# Eval("Title") %></div>
                    <div class="ev-wide-meta">
                        <span>📅 <%# FormatEventDate(Eval("ReleaseDate")) %></span>
                        <span>⏱️ <%# Eval("DurationMins") %> mins</span>
                        <span>🗣️ <%# Eval("Language") %></span>
                    </div>
                </div>
                <div class="ev-wide-footer">
                    <div class="ev-wide-price free">Book Now</div>
                    <asp:Button ID="btnFeatBook" runat="server" CssClass="ev-book-btn" Text="Book Now"
                        OnClick="btnBook_Click" CommandArgument='<%# Eval("EventId") %>' />
                </div>
            </div>
        </div>
    </ItemTemplate>
    <FooterTemplate>
        </div>
    </FooterTemplate>
</asp:Repeater>

<!-- ── POSTER GRID ── -->
<div class="sec-row">
    <div>
        <span class="sec-title">📅 Upcoming Events</span>
        <span class="sec-meta">
            — Showing <asp:Label ID="lblShowing" runat="server" Text="0" /> of
            <asp:Label ID="lblTotal" runat="server" Text="0" /> events
            <asp:Label ID="lblFilterLabel" runat="server" Text="" style="color:var(--violet);font-weight:700" />
        </span>
    </div>
</div>

<asp:Repeater ID="rptEvents" runat="server">
    <HeaderTemplate>
        <div class="event-grid">
    </HeaderTemplate>
    <ItemTemplate>
        <div class="ev-poster">
            <div class='ev-poster-img <%# GetBackgroundClass(Container.ItemIndex) %>'>
                <div class="ev-poster-top">
                    <span class='ev-cat-tag <%# GetTagClass(Eval("EventType")) %>'><%# Eval("EventType") %></span>
                    <span class="ev-heart" onclick="toggleHeart(this)">♡</span>
                </div>
                <span class="ev-emoji-large"><%# GetEventEmoji(Eval("EventType")) %></span>
                <div class="ev-poster-bottom">
                    <div class="ev-poster-date">📅 <%# FormatEventDate(Eval("ReleaseDate")) %></div>
                </div>
            </div>
            <div class="ev-poster-body">
                <div class="ev-poster-name"><%# Eval("Title") %></div>
                <div class="ev-poster-loc">🗣️ <%# Eval("Language") %></div>
                <div class="ev-poster-att">⏱️ <%# Eval("DurationMins") %> mins</div>
                <div class="ev-poster-footer">
                    <div class="ev-poster-price free"><%# Eval("Genre") %></div>
                    <asp:Button ID="btnBookPoster" runat="server" CssClass="ev-book-btn" Text="Book Now"
                        OnClick="btnBook_Click" CommandArgument='<%# Eval("EventId") %>' />
                </div>
            </div>
        </div>
    </ItemTemplate>
    <FooterTemplate>
        </div>
    </FooterTemplate>
</asp:Repeater>

      <!-- ── PAGINATION ── -->
      <div class="pagination">
        <asp:LinkButton ID="btnPrev"  runat="server" CssClass="page-btn arrow" OnClick="btnPrev_Click">‹</asp:LinkButton>
        <asp:LinkButton ID="btnPage1" runat="server" CssClass="page-btn active" CommandArgument="1" OnClick="btnPageNum_Click">1</asp:LinkButton>
        <asp:LinkButton ID="btnPage2" runat="server" CssClass="page-btn"        CommandArgument="2" OnClick="btnPageNum_Click">2</asp:LinkButton>
        <asp:LinkButton ID="btnPage3" runat="server" CssClass="page-btn"        CommandArgument="3" OnClick="btnPageNum_Click">3</asp:LinkButton>
        <asp:LinkButton ID="btnPage4" runat="server" CssClass="page-btn"        CommandArgument="4" OnClick="btnPageNum_Click">4</asp:LinkButton>
        <asp:LinkButton ID="btnNext"  runat="server" CssClass="page-btn arrow" OnClick="btnNext_Click">›</asp:LinkButton>
      </div>

    </div><!-- /content -->
  </main>

</div><!-- /layout -->
</form>

<script>
    function toggleHeart(btn) {
        var liked = btn.textContent === '♥';
        btn.textContent = liked ? '♡' : '♥';
        btn.style.background = liked ? 'rgba(255,255,255,.18)' : 'rgba(220,38,38,.75)';
    }
</script>
</body>
</html>
