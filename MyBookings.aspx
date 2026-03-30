<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyBookings.aspx.cs" Inherits="EventGlint.Bookings" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | My Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        /* ── TOKENS (identical to Home) ── */
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

        /* ══ SIDEBAR ══ */
        .sidebar {
            width: var(--sidebar); min-height: 100vh; background: var(--surface);
            border-right: 1px solid var(--border-soft); display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; z-index: 100; padding: 30px 0;
            box-shadow: 2px 0 20px rgba(124,58,237,.06);
        }
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

        /* ══ MAIN ══ */
        .main { margin-left: var(--sidebar); flex: 1; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - var(--sidebar)); overflow-x: hidden; }

        /* ── TOPBAR ── */
        .topbar { height: 70px; background: rgba(247,245,255,.95); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; padding: 0 32px; gap: 16px; position: sticky; top: 0; z-index: 90; }
        .location-pill { display: flex; align-items: center; gap: 8px; background: var(--surface); border: 1px solid var(--border-soft); border-radius: 24px; padding: 8px 16px; font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s; box-shadow: var(--shadow-sm); color: var(--text-mid); white-space: nowrap; flex-shrink: 0; }
        .location-pill:hover { border-color: var(--violet); box-shadow: var(--shadow-md); }
        .location-pill .dot { width: 8px; height: 8px; background: #22C55E; border-radius: 50%; box-shadow: 0 0 6px #22C55E; flex-shrink: 0; }
        .search-wrap { flex: 1; display: flex; align-items: center; gap: 10px; background: var(--surface); border: 1.5px solid var(--border-soft); border-radius: 28px; padding: 0 16px; height: 44px; transition: border-color .25s, box-shadow .25s; box-shadow: var(--shadow-sm); min-width: 0; }
        .search-wrap:focus-within { border-color: var(--violet); box-shadow: 0 0 0 3px var(--violet-glow); }
        .search-wrap .s-icon { color: var(--muted); font-size: 17px; flex-shrink: 0; }
        .search-wrap input { flex: 1; background: none; border: none; outline: none; color: var(--text); font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; min-width: 0; width: 100%; }
        .search-wrap input::placeholder { color: var(--muted); }
        .filter-btn { width: 34px; height: 34px; border-radius: 50%; background: var(--surface2); border: 1px solid var(--border-soft); display: grid; place-items: center; cursor: pointer; color: var(--muted); font-size: 15px; transition: all .2s; flex-shrink: 0; padding: 0; }
        .filter-btn:hover { background: var(--violet); color: #fff; border-color: var(--violet); }
        .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
        .icon-btn { width: 42px; height: 42px; border-radius: 50%; background: var(--surface); border: 1px solid var(--border-soft); display: grid; place-items: center; cursor: pointer; font-size: 18px; position: relative; transition: all .2s; box-shadow: var(--shadow-sm); }
        .icon-btn:hover { border-color: var(--violet); background: var(--violet-soft); }
        .notif-dot { position: absolute; top: 8px; right: 9px; width: 8px; height: 8px; background: var(--coral); border-radius: 50%; border: 2px solid var(--bg); }

        /* ── CONTENT ── */
        .content { padding: 30px 32px 48px; flex: 1; }

        /* ── HERO BANNER ── */
        .page-banner {
            border-radius: 26px;
            background: linear-gradient(130deg, #5B21B6 0%, #7C3AED 45%, #A855F7 80%, #C084FC 100%);
            padding: 36px 44px; display: flex; align-items: center; justify-content: space-between;
            gap: 24px; margin-bottom: 26px; position: relative; overflow: hidden;
            box-shadow: var(--shadow-lg); animation: fadeUp .55s ease both;
        }
        .page-banner::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 80% 20%, rgba(255,255,255,.12) 0%, transparent 50%), radial-gradient(ellipse at 20% 80%, rgba(255,255,255,.06) 0%, transparent 40%); }
        .banner-dots { position: absolute; right: 240px; top: 16px; width: 100px; height: 100px; background-image: radial-gradient(circle, rgba(255,255,255,.18) 1.5px, transparent 1.5px); background-size: 16px 16px; border-radius: 50%; pointer-events: none; }
        .banner-left { position: relative; z-index: 1; }
        .banner-label { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .16em; color: rgba(255,255,255,.75); background: rgba(255,255,255,.12); padding: 5px 14px; border-radius: 20px; margin-bottom: 10px; font-weight: 600; }
        .banner-title { font-family: 'Playfair Display', serif; font-size: 32px; font-weight: 900; line-height: 1.15; color: #fff; margin-bottom: 8px; }
        .banner-sub { font-size: 13px; color: rgba(255,255,255,.72); line-height: 1.6; }
        .banner-right { position: relative; z-index: 1; display: flex; gap: 14px; flex-shrink: 0; }
        .banner-stat { background: rgba(255,255,255,.15); border: 1px solid rgba(255,255,255,.2); border-radius: 16px; padding: 16px 22px; text-align: center; backdrop-filter: blur(10px); min-width: 80px; }
        .banner-stat-num { font-family: 'Playfair Display', serif; font-size: 26px; font-weight: 900; color: #fff; line-height: 1; }
        .banner-stat-label { font-size: 10px; color: rgba(255,255,255,.65); margin-top: 5px; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }

        /* ── STATS ROW ── */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; animation: fadeUp .5s .10s ease both; }
        .stat-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 20px 18px; display: flex; align-items: center; gap: 14px; box-shadow: var(--shadow-sm); transition: all .22s ease; }
        .stat-card:hover { border-color: rgba(124,58,237,.25); box-shadow: var(--shadow-md); transform: translateY(-3px); }
        .stat-icon { width: 48px; height: 48px; border-radius: 13px; display: grid; place-items: center; font-size: 22px; flex-shrink: 0; }
        .stat-icon.violet { background: var(--violet-soft); }
        .stat-icon.red    { background: #FEE2E2; }
        .stat-icon.gold   { background: #FEF3C7; }
        .stat-icon.green  { background: #DCFCE7; }
        .stat-body { flex: 1; min-width: 0; }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 800; line-height: 1; color: var(--text); }
        .stat-label { font-size: 11px; color: var(--muted); margin-top: 4px; font-weight: 500; }

        /* ── FILTER TABS ── */
        .filter-bar { display: flex; align-items: center; gap: 8px; margin-bottom: 18px; flex-wrap: wrap; animation: fadeUp .5s .15s ease both; }
        .tab-btn { padding: 9px 20px; border-radius: 24px; font-size: 13px; font-weight: 600; border: 1.5px solid var(--border-soft); background: var(--surface); color: var(--muted); cursor: pointer; transition: all .2s; font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
        .tab-btn:hover { border-color: var(--violet); color: var(--violet); background: var(--violet-soft); }
        .tab-btn.tab-active { background: var(--violet); border-color: var(--violet); color: #fff; box-shadow: 0 4px 14px rgba(124,58,237,.3); }
        .result-info { margin-left: auto; font-size: 12px; color: var(--muted); font-weight: 500; white-space: nowrap; }

        /* ── BOOKINGS TABLE ── */
        .bookings-wrap { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); overflow: hidden; box-shadow: var(--shadow-sm); animation: fadeUp .5s .20s ease both; }

        .tbl-head {
            display: grid;
            grid-template-columns: 68px 1fr 80px 110px 120px 180px;
            align-items: center; gap: 14px;
            padding: 12px 22px;
            background: var(--surface2);
            border-bottom: 1px solid var(--border-soft);
        }
        .th { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .1em; color: var(--muted); }
        .th-right  { text-align: right; }
        .th-center { text-align: center; }

        .bk-row {
            display: grid;
            grid-template-columns: 68px 1fr 80px 110px 120px 180px;
            align-items: center; gap: 14px;
            padding: 16px 22px;
            border-bottom: 1px solid var(--border-soft);
            transition: background .18s;
        }
        .bk-row:last-child { border-bottom: none; }
        .bk-row:hover { background: #FAFAFE; }

        /* Thumb */
        .bk-thumb { width: 60px; height: 60px; border-radius: 13px; display: flex; align-items: center; justify-content: center; font-size: 26px; flex-shrink: 0; border: 2px solid rgba(255,255,255,.6); }
        .bk-thumb.holi   { background: linear-gradient(135deg, #fde68a, #fca5a5, #c4b5fd); }
        .bk-thumb.music  { background: linear-gradient(135deg, #93c5fd, #c084fc); }
        .bk-thumb.film   { background: linear-gradient(135deg, #6ee7b7, #67e8f9); }
        .bk-thumb.food   { background: linear-gradient(135deg, #fde68a, #fb923c); }
        .bk-thumb.sports { background: linear-gradient(135deg, #bbf7d0, #6ee7b7); }
        .bk-thumb.other  { background: linear-gradient(135deg, #e9d5ff, #ddd6fe); }

        /* Event Info */
        .bk-info { min-width: 0; }
        .bk-ref { font-size: 10px; font-weight: 700; color: var(--violet); background: var(--violet-soft); padding: 2px 8px; border-radius: 7px; letter-spacing: .04em; display: inline-block; margin-bottom: 5px; }
        .bk-title { font-family: 'Playfair Display', serif; font-size: 14px; font-weight: 800; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 4px; }
        .bk-sub { display: flex; gap: 10px; flex-wrap: wrap; }
        .bk-sub-item { font-size: 11px; color: var(--muted); font-weight: 500; }

        /* Seats */
        .bk-seats-cell { text-align: center; }
        .bk-seats-num { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--text); line-height: 1; }
        .bk-seats-lbl { font-size: 10px; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .06em; margin-top: 2px; }

        /* Amount */
        .bk-amount-cell { text-align: right; }
        .bk-price { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 800; color: var(--gold); line-height: 1; }
        .bk-price.free-price { color: var(--green); font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; }
        .bk-booked-on { font-size: 10px; color: var(--muted); margin-top: 3px; }

        /* Status */
        .bk-status-cell { display: flex; justify-content: center; }
        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .status-confirmed { background: #DCFCE7; color: #15803D; }
        .status-pending   { background: #FEF3C7; color: #92400E; }
        .status-cancelled { background: #FEE2E2; color: #DC2626; }
        .status-attended  { background: var(--violet-soft); color: var(--violet); }

        /* Actions */
        .bk-actions-cell { display: flex; gap: 6px; justify-content: flex-end; flex-wrap: wrap; }
        .action-btn { padding: 6px 13px; border-radius: 18px; font-size: 11px; font-weight: 700; border: none; cursor: pointer; transition: all .18s; font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
        .btn-view     { background: var(--violet-soft); color: var(--violet); border: 1.5px solid rgba(124,58,237,.2); }
        .btn-view:hover { background: var(--violet); color: #fff; }
        .btn-cancel   { background: #FEE2E2; color: #DC2626; border: 1.5px solid rgba(220,38,38,.15); }
        .btn-cancel:hover { background: #DC2626; color: #fff; }
        .btn-download { background: var(--surface2); color: var(--text-mid); border: 1.5px solid var(--border-soft); }
        .btn-download:hover { background: var(--text); color: #fff; border-color: var(--text); }

        /* ── EMPTY STATE ── */
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 72px 32px; text-align: center; }
        .empty-icon  { font-size: 64px; margin-bottom: 18px; opacity: .45; }
        .empty-title { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 800; color: var(--text); margin-bottom: 8px; }
        .empty-sub   { font-size: 14px; color: var(--muted); max-width: 300px; line-height: 1.65; margin-bottom: 22px; }
        .btn-browse  { background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; padding: 12px 28px; border-radius: 28px; font-weight: 700; font-size: 14px; border: none; cursor: pointer; transition: all .2s; box-shadow: 0 4px 14px rgba(124,58,237,.3); font-family: 'Plus Jakarta Sans', sans-serif; }
        .btn-browse:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(124,58,237,.4); }

        /* ── REMINDERS ── */
        .reminder-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 22px 24px; box-shadow: var(--shadow-sm); margin-top: 24px; animation: fadeUp .5s .28s ease both; }
        .sec-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; }
        .sec-title { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 800; color: var(--text); }
        .see-all { font-size: 13px; font-weight: 600; color: var(--violet); display: flex; align-items: center; gap: 4px; transition: gap .2s; }
        .see-all:hover { gap: 8px; }
        .reminder-list { display: flex; flex-direction: column; gap: 10px; }
        .reminder-item { display: flex; align-items: center; gap: 14px; padding: 14px 16px; border-radius: 14px; background: var(--surface2); border: 1px solid var(--border-soft); transition: all .2s; }
        .reminder-item:hover { background: var(--violet-soft); border-color: rgba(124,58,237,.2); }
        .r-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .dot-green  { background: #22C55E; box-shadow: 0 0 7px #22C55E; }
        .dot-yellow { background: #F59E0B; box-shadow: 0 0 7px #F59E0B; }
        .dot-violet { background: var(--violet); box-shadow: 0 0 7px var(--violet); }
        .r-thumb { width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
        .r-info { flex: 1; min-width: 0; }
        .r-name { font-size: 13px; font-weight: 700; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 2px; }
        .r-date { font-size: 11px; color: var(--muted); font-weight: 500; }
        .r-badge { font-size: 11px; font-weight: 700; padding: 4px 11px; border-radius: 20px; flex-shrink: 0; white-space: nowrap; }
        .rb-today  { background: #DCFCE7; color: #15803D; }
        .rb-soon   { background: #FEF3C7; color: #92400E; }
        .rb-future { background: var(--violet-soft); color: var(--violet); }

        /* ── ANIMATIONS ── */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
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
            <a class="nav-item"        href="Home.aspx">      <span class="icon">🏠</span> Home</a>
            <a class="nav-item"        href="Event.aspx">     <span class="icon">🎪</span> Event</a>
            <a class="nav-item"        href="Shows.aspx">     <span class="icon">🎭</span> Shows</a>
            <a class="nav-item"        href="Hall.aspx">      <span class="icon">🏛️</span> Hall</a>
            <a class="nav-item active" href="MyBookings.aspx"><span class="icon">🎟️</span> My Bookings</a>
            <a class="nav-item"        href="ContactUs.aspx"> <span class="icon">📞</span> Contact Us</a>
            <a class="nav-item"        href="AboutUs.aspx">   <span class="icon">ℹ️</span> About Us</a>
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

    <!-- ══════════ MAIN ══════════ -->
    <main class="main">

        <!-- TOPBAR -->
        <header class="topbar">
            <div class="location-pill">
                <span class="dot"></span>
                📍&nbsp;<asp:Label ID="lblLocation" runat="server" Text="India" />
                <span style="color:var(--muted);font-size:11px;margin-left:2px">▾</span>
            </div>
            <div class="search-wrap">
                <span class="s-icon">🔍</span>
                <asp:TextBox ID="txtSearch" runat="server"
                    placeholder="Search your bookings by event name…"
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

            <!-- ── HERO BANNER ── -->
            <div class="page-banner">
                <div class="banner-dots"></div>
                <div class="banner-left">
                    <div class="banner-label">🎟️ Your Reservations</div>
                    <div class="banner-title">My Bookings</div>
                    <div class="banner-sub">Track, manage &amp; download tickets for all your events in one place.</div>
                </div>
                <div class="banner-right">
                    <div class="banner-stat">
                        <div class="banner-stat-num"><asp:Label ID="lblTotalBookings" runat="server" Text="0" /></div>
                        <div class="banner-stat-label">Total</div>
                    </div>
                    <div class="banner-stat">
                        <div class="banner-stat-num"><asp:Label ID="lblUpcoming" runat="server" Text="0" /></div>
                        <div class="banner-stat-label">Upcoming</div>
                    </div>
                    <div class="banner-stat">
                        <div class="banner-stat-num"><asp:Label ID="lblTotalSpent" runat="server" Text="₹0" /></div>
                        <div class="banner-stat-label">Spent</div>
                    </div>
                </div>
            </div>

            <!-- ── STATS ROW ── -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon violet">🎪</div>
                    <div class="stat-body">
                        <div class="stat-num"><asp:Label ID="lblStatTotal" runat="server" Text="0" /></div>
                        <div class="stat-label">All Bookings</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">✅</div>
                    <div class="stat-body">
                        <div class="stat-num"><asp:Label ID="lblStatUpcoming" runat="server" Text="0" /></div>
                        <div class="stat-label">Upcoming Events</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon gold">🎉</div>
                    <div class="stat-body">
                        <div class="stat-num"><asp:Label ID="lblStatAttended" runat="server" Text="0" /></div>
                        <div class="stat-label">Events Attended</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">❌</div>
                    <div class="stat-body">
                        <div class="stat-num"><asp:Label ID="lblStatCancelled" runat="server" Text="0" /></div>
                        <div class="stat-label">Cancelled</div>
                    </div>
                </div>
            </div>

            <!-- ── FILTER TABS ── -->
            <div class="filter-bar">
                <asp:Button ID="btnTabAll"       runat="server" CssClass="tab-btn tab-active" Text="🎟️  All"       OnClick="lnkAll_Click"       />
                <asp:Button ID="btnTabUpcoming"  runat="server" CssClass="tab-btn"            Text="📅  Upcoming"  OnClick="lnkUpcoming_Click"  />
                <asp:Button ID="btnTabAttended"  runat="server" CssClass="tab-btn"            Text="🎉  Attended"  OnClick="lnkAttended_Click"  />
                <asp:Button ID="btnTabCancelled" runat="server" CssClass="tab-btn"            Text="❌  Cancelled" OnClick="lnkCancelled_Click" />
                <asp:Button ID="btnTabPending"   runat="server" CssClass="tab-btn"            Text="⏳  Pending"   OnClick="lnkPending_Click"   />
                <span class="result-info"><asp:Label ID="lblResultCount" runat="server" Text="" /></span>
            </div>

            <!-- ── BOOKINGS TABLE ── -->
            <asp:Panel ID="pnlBookings" runat="server">
                <div class="bookings-wrap">
                    <div class="tbl-head">
                        <div class="th"></div>
                        <div class="th">Event</div>
                        <div class="th th-center">Seats</div>
                        <div class="th th-right">Amount</div>
                        <div class="th th-center">Status</div>
                        <div class="th th-right">Actions</div>
                    </div>
                    <asp:Repeater ID="rptBookings" runat="server">
                        <ItemTemplate>
                            <div class="bk-row">

                                <!-- Thumb -->
                                <div class='bk-thumb <%# GetThumbClass(Eval("EventType")) %>'>
                                    <%# GetEventEmoji(Eval("EventType")) %>
                                </div>

                                <!-- Event Info -->
                                <div class="bk-info">
                                    <div class="bk-ref">#<%# Eval("BookingReference") %></div>
                                    <div class="bk-title"><%# Eval("EventTitle") %></div>
                                    <div class="bk-sub">
                                        <span class="bk-sub-item">📅 <%# FormatDate(Eval("ShowDate")) %>></span>
                                        <span class="bk-sub-item">📍 <%# Eval("VenueName") %>, <%# Eval("CityName") %></span>
                                        <span class="bk-sub-item">🗣️ <%# Eval("Language") %></span>
                                    </div>
                                </div>

                                <!-- Seats -->
                                <div class="bk-seats-cell">
                                    <div class="bk-seats-num"><%# Eval("SeatCount") %></div>
                                    <div class="bk-seats-lbl">Seats</div>
                                </div>

                                <!-- Amount -->
                                <div class="bk-amount-cell">
                                    <div class='bk-price <%# GetAmountClass(Eval("TotalAmount")) %>'>
                                        <%# FormatAmount(Eval("TotalAmount")) %>
                                    </div>
                                    <div class="bk-booked-on"><%# FormatBookingDate(Eval("BookingDate")) %></div>
                                </div>

                                <!-- Status -->
                                <div class="bk-status-cell">
                                    <span class='status-badge <%# GetStatusClass(Eval("BookingStatus")) %>'>
                                        <%# GetStatusEmoji(Eval("BookingStatus")) %>
                                        <%# Eval("BookingStatus") %>
                                    </span>
                                </div>

                                <!-- Actions -->
                                <div class="bk-actions-cell">
                                    <asp:Button ID="btnView" runat="server"
                                        CssClass="action-btn btn-view" Text="👁 View"
                                        CommandArgument='<%# Eval("BookingId") %>'
                                        OnClick="btnViewBooking_Click" />

                                    <asp:Button ID="btnDownload" runat="server"
                                        CssClass="action-btn btn-download" Text="⬇ Ticket"
                                        CommandArgument='<%# Eval("BookingId") %>'
                                        OnClick="btnDownloadTicket_Click"
                                        Visible='<%# CanDownload(Eval("BookingStatus")) %>' />

                                    <asp:Button ID="btnCancel" runat="server"
                                        CssClass="action-btn btn-cancel" Text="✕ Cancel"
                                        CommandArgument='<%# Eval("BookingId") %>'
                                        OnClick="btnCancelBooking_Click"
                                        OnClientClick="return confirm('Cancel this booking?');"
                                        Visible='<%# CanCancel(Eval("BookingStatus"), Eval("EndDate"), Eval("ReleaseDate")) %>' />
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>

            <!-- ── EMPTY STATE ── -->
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="bookings-wrap">
                    <div class="empty-state">
                        <div class="empty-icon">🎟️</div>
                        <div class="empty-title">No bookings found</div>
                        <div class="empty-sub">You haven't made any bookings in this category yet. Go explore and grab some tickets!</div>
                        <asp:Button ID="btnBrowse" runat="server" CssClass="btn-browse"
                            Text="🎪 Browse Events" OnClick="btnBrowseEvents_Click" />
                    </div>
                </div>
            </asp:Panel>

            <!-- ── UPCOMING REMINDERS ── -->
            <asp:Panel ID="pnlReminders" runat="server">
                <div class="reminder-panel">
                    <div class="sec-header">
                        <div class="sec-title">⏰ Upcoming Reminders</div>
                        <a class="see-all" href="MyBookings.aspx">View All →</a>
                    </div>
                    <div class="reminder-list">
                        <asp:Repeater ID="rptReminders" runat="server">
                            <ItemTemplate>
                                <div class="reminder-item">
                                    <div class='r-dot <%# GetReminderDotClass(Eval("DaysLeft")) %>'></div>
                                    <div class='r-thumb <%# GetThumbClass(Eval("EventType")) %>'>
                                        <%# GetEventEmoji(Eval("EventType")) %>
                                    </div>
                                    <div class="r-info">
                                        <div class="r-name"><%# Eval("EventTitle") %></div>
                                        <div class="r-date">📅 <%# FormatDate(Eval("ShowDate")) %></div>
                                    </div>
                                    <span class='r-badge <%# GetDaysLeftClass(Eval("DaysLeft")) %>'>
                                        <%# GetDaysLeftLabel(Eval("DaysLeft")) %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </asp:Panel>

        </div><!-- /content -->
    </main>
</div><!-- /layout -->
</form>

<script>
    // Tab visual toggle on click (server postback handles data filtering)
    document.querySelectorAll('.tab-btn').forEach(function (btn) {
        btn.addEventListener('mousedown', function () {
            document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('tab-active'); });
            this.classList.add('tab-active');
        });
    });
</script>
</body>
</html>