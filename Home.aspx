<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="EventGlint.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Home</title>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* ── TOKENS ── */
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
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* ─── Variables ─────────────────────────────────────────── */
    :root {
      --violet:       #7C3AED;
      --violet-mid:   #9D5CF8;
      --violet-soft:  #EDE9FE;
      --violet-glow:  rgba(124,58,237,0.14);
      --bg:           #F7F5FF;
      --surface:      #FFFFFF;
      --surface2:     #F1EEF9;
      --surface3:     #EAE5F8;
      --border:       rgba(124,58,237,0.10);
      --border-soft:  rgba(0,0,0,0.06);
      --text:         #1A1033;
      --text-mid:     #3D2F6B;
      --muted:        #8B7BB0;
      --accent:       #F04E4E;
      --coral:        #FF6B6B;
      --gold:         #E88C1A;
      --green:        #16A34A;
      --shadow-sm:    0 1px 4px rgba(124,58,237,.07), 0 2px 12px rgba(0,0,0,.05);
      --shadow-md:    0 4px 20px rgba(124,58,237,.10), 0 2px 8px rgba(0,0,0,.06);
      --shadow-lg:    0 12px 40px rgba(124,58,237,.16), 0 4px 16px rgba(0,0,0,.08);
      --radius:       18px;
      --sidebar:      264px;
    }

    /* ─── Reset ─────────────────────────────────────────────── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
    }

    /* ─── Scrollbar ──────────────────────────────────────────── */
    ::-webkit-scrollbar { width: 5px; }
    ::-webkit-scrollbar-track { background: var(--bg); }
    ::-webkit-scrollbar-thumb { background: #C4B5FD; border-radius: 4px; }

    /* KEY FIX: form tag must not break flex layout */
    #form1 { display: contents; }

    /* ── LAYOUT SHELL ── */
    .layout { display: flex; min-height: 100vh; }

    /* ══════════════════════════════════════
       SIDEBAR
    ══════════════════════════════════════ */
    /* ═══════════════════════════════════════════════════════════
       SIDEBAR
    ═══════════════════════════════════════════════════════════ */
    .sidebar {
      width: var(--sidebar);
      min-height: 100vh;
      background: var(--surface);
      border-right: 1px solid var(--border-soft);
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0; left: 0;
      z-index: 100;
      padding: 30px 0;
      box-shadow: 2px 0 20px rgba(124,58,237,.06);
    }
    .sidebar::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
      background: linear-gradient(90deg, var(--violet), var(--violet-mid), #C084FC);
    }
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

    /* subtle decorative gradient at top of sidebar */
    .sidebar::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--violet), var(--violet-mid), #C084FC);
    }

    .sidebar-logo {
      display: flex;
      align-items: center;
      gap: 13px;
      padding: 0 24px 30px;
      border-bottom: 1px solid var(--border-soft);
    }
    .logo-icon {
      width: 44px; height: 44px;
      background: linear-gradient(135deg, var(--violet), var(--violet-mid));
      border-radius: 14px;
      display: grid;
      place-items: center;
      font-size: 20px;
      box-shadow: var(--shadow-md);
    }
    .logo-text {
      font-family: 'Playfair Display', serif;
      font-weight: 800;
      font-size: 17px;
      line-height: 1.2;
      color: var(--text);
    }
    .logo-text span {
      font-family: 'Plus Jakarta Sans', sans-serif;
      color: var(--muted);
      font-size: 11px;
      font-weight: 400;
      display: block;
      margin-top: 2px;
    }

    .nav {
      padding: 26px 14px;
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 3px;
      overflow-y: auto;
    }
    .nav-label {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: .14em;
      color: var(--muted);
      padding: 0 10px;
      margin: 14px 0 6px;
      font-weight: 600;
    }
    .nav-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 11px 14px;
      border-radius: 12px;
      cursor: pointer;
      transition: all .2s ease;
      font-size: 14px;
      font-weight: 500;
      color: var(--muted);
      text-decoration: none;
    }
    .nav-item:hover {
      background: var(--violet-soft);
      color: var(--violet);
    }
    .nav-item.active {
      background: linear-gradient(135deg, var(--violet-soft), #DDD6FE);
      color: var(--violet);
      font-weight: 600;
      box-shadow: inset 0 0 0 1px rgba(124,58,237,.2);
    }
    .nav-item .icon { font-size: 17px; width: 22px; text-align: center; }
    .nav-badge {
      margin-left: auto;
      background: var(--coral);
      color: #fff;
      font-size: 10px;
      font-weight: 700;
      padding: 2px 8px;
      border-radius: 20px;
    }

    .sidebar-bottom {
      padding: 20px;
      border-top: 1px solid var(--border-soft);
    }
    .user-card {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 14px;
      border-radius: 14px;
      background: var(--surface2);
      cursor: pointer;
      transition: background .2s, box-shadow .2s;
      border: 1px solid var(--border-soft);
    }
    .user-card:hover { background: var(--violet-soft); box-shadow: var(--shadow-sm); }
    .avatar {
      width: 38px; height: 38px;
      background: linear-gradient(135deg, var(--violet), #C084FC);
      border-radius: 50%;
      display: grid; place-items: center;
      font-weight: 700; font-size: 15px;
      color: #fff;
      flex-shrink: 0;
    }
    .user-info { flex: 1; }
    .user-name { font-size: 13px; font-weight: 600; color: var(--text); }
    .user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }
    .user-dots { color: var(--muted); font-size: 18px; }

    /* ══════════════════════════════════════
       MAIN AREA
    ══════════════════════════════════════ */
    /* ═══════════════════════════════════════════════════════════
       MAIN
    ═══════════════════════════════════════════════════════════ */
    .main {
      margin-left: var(--sidebar);
      flex: 1;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      width: calc(100% - var(--sidebar));
      overflow-x: hidden;
    }

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
    .content { padding: 30px 32px 40px; flex: 1; }

    /* ── HERO ── */
    .hero { border-radius: 26px; background: linear-gradient(130deg, #5B21B6 0%, #7C3AED 45%, #A855F7 80%, #C084FC 100%); padding: 46px 50px; display: flex; align-items: center; justify-content: space-between; gap: 28px; margin-bottom: 28px; position: relative; overflow: hidden; box-shadow: var(--shadow-lg); }
    .hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse at 80% 20%, rgba(255,255,255,.12) 0%, transparent 50%), radial-gradient(ellipse at 20% 80%, rgba(255,255,255,.06) 0%, transparent 40%); }
    .hero-dots { position: absolute; right: 270px; top: 20px; width: 110px; height: 110px; background-image: radial-gradient(circle, rgba(255,255,255,.18) 1.5px, transparent 1.5px); background-size: 16px 16px; border-radius: 50%; pointer-events: none; }
    .hero-left { position: relative; z-index: 1; flex: 1; min-width: 0; }
    .hero-label { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .16em; color: rgba(255,255,255,.75); background: rgba(255,255,255,.12); padding: 5px 14px; border-radius: 20px; margin-bottom: 14px; font-weight: 600; }
    .hero h1 { font-family: 'Playfair Display', serif; font-size: 40px; font-weight: 900; line-height: 1.12; color: #fff; margin-bottom: 12px; }
    .hero p { font-size: 14px; color: rgba(255,255,255,.75); max-width: 400px; line-height: 1.65; }
    .hero-btns { display: flex; gap: 12px; margin-top: 24px; flex-wrap: wrap; }
    .btn-primary { background: #fff; color: var(--violet); padding: 12px 26px; border-radius: 28px; font-weight: 700; font-size: 14px; border: none; cursor: pointer; transition: transform .15s, box-shadow .15s; box-shadow: 0 4px 20px rgba(0,0,0,.2); font-family: 'Plus Jakarta Sans', sans-serif; }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(0,0,0,.25); }
    .btn-outline { background: rgba(255,255,255,.15); color: #fff; padding: 12px 26px; border-radius: 28px; font-weight: 600; font-size: 14px; border: 1.5px solid rgba(255,255,255,.35); cursor: pointer; backdrop-filter: blur(8px); transition: background .2s; font-family: 'Plus Jakarta Sans', sans-serif; }
    .btn-outline:hover { background: rgba(255,255,255,.25); }
    .hero-image { width: 210px; height: 185px; border-radius: 20px; background: linear-gradient(135deg, rgba(255,200,100,.5), rgba(255,107,107,.4)); display: flex; align-items: center; justify-content: center; font-size: 72px; box-shadow: 0 16px 44px rgba(0,0,0,.3); position: relative; z-index: 1; border: 2px solid rgba(255,255,255,.25); flex-shrink: 0; }

    /* ── STATS ── */
    .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 20px 18px; display: flex; align-items: center; gap: 14px; box-shadow: var(--shadow-sm); transition: all .22s ease; }
    .stat-card:hover { border-color: rgba(124,58,237,.25); box-shadow: var(--shadow-md); transform: translateY(-3px); }
    .stat-icon { width: 48px; height: 48px; border-radius: 13px; display: grid; place-items: center; font-size: 22px; flex-shrink: 0; }
    }

    /* ─── Topbar ─────────────────────────────────────────────── */
    .topbar {
      height: 70px;
      background: rgba(247,245,255,.92);
      backdrop-filter: blur(24px);
      border-bottom: 1px solid var(--border-soft);
      display: flex;
      align-items: center;
      padding: 0 36px;
      gap: 18px;
      position: sticky; top: 0; z-index: 90;
    }

    .location-pill {
      display: flex;
      align-items: center;
      gap: 8px;
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: 24px;
      padding: 8px 16px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      transition: all .2s;
      box-shadow: var(--shadow-sm);
      color: var(--text-mid);
    }
    .location-pill:hover { border-color: var(--violet); box-shadow: var(--shadow-md); }
    .location-pill .dot {
      width: 8px; height: 8px;
      background: #22C55E;
      border-radius: 50%;
      box-shadow: 0 0 6px #22C55E;
    }

    .search-bar {
      flex: 1;
      max-width: 560px;
      display: flex;
      align-items: center;
      gap: 10px;
      background: var(--surface);
      border: 1.5px solid var(--border-soft);
      border-radius: 28px;
      padding: 0 20px;
      height: 44px;
      transition: border-color .25s, box-shadow .25s;
      box-shadow: var(--shadow-sm);
    }
    .search-bar:focus-within {
      border-color: var(--violet);
      box-shadow: 0 0 0 3px var(--violet-glow);
    }
    .search-bar input {
      flex: 1;
      background: none;
      border: none;
      outline: none;
      color: var(--text);
      font-size: 14px;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }
    .search-bar input::placeholder { color: var(--muted); }
    .search-icon { color: var(--muted); font-size: 17px; }

    .filter-btn {
      width: 36px; height: 36px;
      border-radius: 50%;
      background: var(--surface2);
      border: 1px solid var(--border-soft);
      display: grid; place-items: center;
      cursor: pointer;
      color: var(--muted);
      font-size: 15px;
      transition: all .2s;
    }
    .filter-btn:hover { background: var(--violet); color: #fff; border-color: var(--violet); }

    .topbar-right {
      margin-left: auto;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .icon-btn {
      width: 42px; height: 42px;
      border-radius: 50%;
      background: var(--surface);
      border: 1px solid var(--border-soft);
      display: grid; place-items: center;
      cursor: pointer;
      font-size: 18px;
      position: relative;
      transition: all .2s;
      box-shadow: var(--shadow-sm);
    }
    .icon-btn:hover { border-color: var(--violet); background: var(--violet-soft); }
    .notif-dot {
      position: absolute;
      top: 8px; right: 9px;
      width: 8px; height: 8px;
      background: var(--coral);
      border-radius: 50%;
      border: 2px solid var(--bg);
    }

    /* ─── Content ────────────────────────────────────────────── */
    .content { padding: 34px 36px; flex: 1; }

    /* ─── Hero Banner ────────────────────────────────────────── */
    .hero {
      border-radius: 26px;
      background: linear-gradient(130deg, #5B21B6 0%, #7C3AED 45%, #A855F7 80%, #C084FC 100%);
      padding: 50px 56px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 34px;
      position: relative;
      overflow: hidden;
      box-shadow: var(--shadow-lg);
    }
    .hero::before {
      content: '';
      position: absolute; inset: 0;
      background:
        radial-gradient(ellipse at 80% 20%, rgba(255,255,255,.12) 0%, transparent 50%),
        radial-gradient(ellipse at 20% 80%, rgba(255,255,255,.06) 0%, transparent 40%);
    }
    /* decorative dots pattern */
    .hero::after {
      content: '';
      position: absolute;
      right: 280px; top: 0; bottom: 0; width: 1px;
      background: rgba(255,255,255,.1);
    }
    .hero-dots {
      position: absolute;
      right: 20px; top: 20px;
      width: 120px; height: 120px;
      background-image: radial-gradient(circle, rgba(255,255,255,.18) 1.5px, transparent 1.5px);
      background-size: 16px 16px;
      border-radius: 50%;
    }
    .hero-label {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: .16em;
      color: rgba(255,255,255,.75);
      background: rgba(255,255,255,.12);
      padding: 5px 14px;
      border-radius: 20px;
      margin-bottom: 16px;
      font-weight: 600;
    }
    .hero h1 {
      font-family: 'Playfair Display', serif;
      font-size: 44px;
      font-weight: 900;
      line-height: 1.12;
      color: #fff;
      margin-bottom: 14px;
    }
    .hero p { font-size: 15px; color: rgba(255,255,255,.75); max-width: 400px; line-height: 1.65; }
    .hero-btns { display: flex; gap: 14px; margin-top: 28px; }
    .btn-primary {
      background: #fff;
      color: var(--violet);
      padding: 13px 28px;
      border-radius: 28px;
      font-weight: 700;
      font-size: 14px;
      border: none;
      cursor: pointer;
      transition: transform .15s, box-shadow .15s;
      box-shadow: 0 4px 20px rgba(0,0,0,.2);
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(0,0,0,.25); }
    .btn-outline {
      background: rgba(255,255,255,.15);
      color: #fff;
      padding: 13px 28px;
      border-radius: 28px;
      font-weight: 600;
      font-size: 14px;
      border: 1.5px solid rgba(255,255,255,.35);
      cursor: pointer;
      backdrop-filter: blur(8px);
      transition: background .2s;
    }
    .btn-outline:hover { background: rgba(255,255,255,.25); }
    .hero-image {
      width: 240px; height: 200px;
      border-radius: 22px;
      background: linear-gradient(135deg, rgba(255,200,100,.5), rgba(255,107,107,.4));
      display: flex; align-items: center; justify-content: center;
      font-size: 80px;
      box-shadow: 0 20px 48px rgba(0,0,0,.3);
      position: relative; z-index: 1;
      border: 2px solid rgba(255,255,255,.25);
    }

    /* ─── Stats Row ──────────────────────────────────────────── */
    .stats-row {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 18px;
      margin-bottom: 34px;
    }
    .stat-card {
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: var(--radius);
      padding: 22px 20px;
      display: flex;
      align-items: center;
      gap: 15px;
      box-shadow: var(--shadow-sm);
      transition: all .22s ease;
    }
    .stat-card:hover {
      border-color: rgba(124,58,237,.25);
      box-shadow: var(--shadow-md);
      transform: translateY(-3px);
    }
    .stat-icon {
      width: 50px; height: 50px;
      border-radius: 14px;
      display: grid; place-items: center;
      font-size: 22px;
      flex-shrink: 0;
    }
    .stat-icon.violet { background: var(--violet-soft); }
    .stat-icon.red    { background: #FEE2E2; }
    .stat-icon.gold   { background: #FEF3C7; }
    .stat-icon.green  { background: #DCFCE7; }
    .stat-body { flex: 1; min-width: 0; }
    .stat-num { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: 800; line-height: 1; color: var(--text); }
    .stat-label { font-size: 11px; color: var(--muted); margin-top: 4px; font-weight: 500; }
    .stat-badge { font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 20px; flex-shrink: 0; }
    .badge-up   { background: #DCFCE7; color: #15803D; }
    .badge-down { background: #FEE2E2; color: #DC2626; }

    /* ── SECTION HEADERS ── */
    .sec-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
    .sec-title { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 800; color: var(--text); }
    .see-all { font-size: 13px; font-weight: 600; color: var(--violet); display: flex; align-items: center; gap: 4px; transition: gap .2s; }
    .see-all:hover { gap: 8px; }

    /* ── TWO-COL ── */
    .two-col { display: grid; grid-template-columns: 1fr 330px; gap: 22px; margin-bottom: 28px; }

    /* ── EVENT CARDS ── */
    .events-grid { display: flex; flex-direction: column; gap: 12px; }
    .event-card { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 15px 18px; display: flex; align-items: center; gap: 15px; box-shadow: var(--shadow-sm); transition: all .22s ease; cursor: pointer; }
    .event-card:hover { border-color: rgba(124,58,237,.3); box-shadow: var(--shadow-md); transform: translateX(4px); }
    .event-img { width: 80px; height: 80px; border-radius: 13px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 32px; border: 2px solid rgba(255,255,255,.5); }
    .event-img.holi  { background: linear-gradient(135deg, #fde68a, #fca5a5, #c4b5fd); }
    .event-img.music { background: linear-gradient(135deg, #93c5fd, #c084fc); }
    .event-img.film  { background: linear-gradient(135deg, #6ee7b7, #67e8f9); }
    .event-info { flex: 1; min-width: 0; }
    .event-date { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--violet); margin-bottom: 4px; }
    .event-name { font-family: 'Playfair Display', serif; font-size: 15px; font-weight: 800; margin-bottom: 4px; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .event-loc { font-size: 12px; color: var(--muted); font-weight: 500; }
    .event-meta { display: flex; flex-direction: column; gap: 8px; align-items: flex-end; flex-shrink: 0; }
    .event-price { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: var(--gold); }
    .event-price.free { color: var(--green); font-size: 15px; }
    .attend-btn { background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 20px; padding: 7px 16px; font-size: 12px; font-weight: 700; cursor: pointer; transition: all .2s; box-shadow: 0 3px 10px rgba(124,58,237,.25); font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
    .attend-btn:hover { transform: scale(1.04); box-shadow: 0 6px 16px rgba(124,58,237,.35); }

    /* ── RIGHT COLUMN ── */
    .right-col { display: flex; flex-direction: column; gap: 18px; }

    /* ── PROMO CARD ── */
    .promo-card { background: linear-gradient(145deg, #5B21B6 0%, #7C3AED 55%, #A855F7 100%); border-radius: 20px; padding: 22px 24px; position: relative; overflow: hidden; box-shadow: var(--shadow-lg); }
    .promo-card::before { content: ''; position: absolute; right: -40px; top: -40px; width: 180px; height: 180px; border-radius: 50%; background: rgba(255,255,255,.07); }
    .promo-card::after  { content: ''; position: absolute; right: 50px; bottom: -55px; width: 130px; height: 130px; border-radius: 50%; background: rgba(255,255,255,.05); }
    .promo-tag { display: inline-block; background: rgba(255,255,255,.2); font-size: 10px; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; padding: 4px 11px; border-radius: 20px; margin-bottom: 10px; color: #fff; }
    .promo-title { font-family: 'Playfair Display', serif; font-size: 19px; font-weight: 900; line-height: 1.3; margin-bottom: 6px; color: #fff; }
    .promo-sub { font-size: 12px; color: rgba(255,255,255,.72); margin-bottom: 16px; line-height: 1.55; }
    .promo-row { display: flex; align-items: center; justify-content: space-between; position: relative; z-index: 1; gap: 12px; }
    .qr-block { text-align: center; flex-shrink: 0; }
    .qr-box { width: 64px; height: 64px; background: #fff; border-radius: 12px; display: grid; place-items: center; font-size: 30px; box-shadow: 0 4px 14px rgba(0,0,0,.2); margin: 0 auto; }
    .qr-label { font-size: 10px; color: rgba(255,255,255,.6); margin-top: 5px; }
    .claim-btn { background: #fff; color: var(--violet); font-weight: 800; font-size: 13px; padding: 10px 18px; border-radius: 20px; border: none; cursor: pointer; transition: transform .15s, box-shadow .15s; box-shadow: 0 4px 14px rgba(0,0,0,.2); font-family: 'Plus Jakarta Sans', sans-serif; }
    .claim-btn:hover { transform: scale(1.04); }

    /* ── CATEGORIES ── */
    .cat-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 20px; box-shadow: var(--shadow-sm); }
    .cats { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .cat-item { background: var(--surface2); border: 1.5px solid var(--border-soft); border-radius: 14px; padding: 14px 12px; display: flex; flex-direction: column; gap: 5px; cursor: pointer; transition: all .2s; }
    .cat-item:hover { background: var(--violet-soft); border-color: rgba(124,58,237,.3); transform: translateY(-2px); box-shadow: var(--shadow-sm); }
    .cat-emoji { font-size: 22px; }
    .cat-name  { font-size: 13px; font-weight: 700; color: var(--text); }
    .cat-count { font-size: 11px; color: var(--muted); font-weight: 500; }

    /* ── BOTTOM GRID ── */
    .bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 22px; padding-bottom: 40px; }
    .panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); padding: 22px; box-shadow: var(--shadow-sm); }

    /* ── TRENDING LIST ── */
    .popular-list { display: flex; flex-direction: column; gap: 2px; }
    .popular-item { display: flex; align-items: center; gap: 12px; padding: 10px; border-radius: 12px; transition: background .2s; cursor: pointer; }
    .popular-item:hover { background: var(--surface2); }
    .rank { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 900; color: #D1C9E8; width: 22px; text-align: center; flex-shrink: 0; }
    .rank.top { color: var(--gold); }
    .pop-img { width: 46px; height: 46px; border-radius: 11px; display: grid; place-items: center; font-size: 20px; flex-shrink: 0; }
    .pop-info { flex: 1; min-width: 0; }
    .pop-name { font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .pop-loc  { font-size: 11px; color: var(--muted); font-weight: 500; }
    .pop-price { font-family: 'Playfair Display', serif; font-weight: 800; font-size: 14px; color: var(--gold); flex-shrink: 0; }
    .pop-price.free { color: var(--green); font-size: 12px; font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; }

    /* ── MAP ── */
    .map-box { height: 200px; background: linear-gradient(145deg, #EEF2FF, #EDE9FE); border-radius: 14px; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; margin-bottom: 14px; border: 1px solid rgba(124,58,237,.1); }
    .map-grid { position: absolute; inset: 0; background-image: linear-gradient(rgba(124,58,237,.07) 1px, transparent 1px), linear-gradient(90deg, rgba(124,58,237,.07) 1px, transparent 1px); background-size: 32px 32px; }
    .map-pin { width: 44px; height: 44px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); border-radius: 50% 50% 50% 0; transform: rotate(-45deg); box-shadow: 0 8px 24px rgba(124,58,237,.35); position: relative; z-index: 1; }
    .map-pin::after  { content: '📍'; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%) rotate(45deg); font-size: 20px; }
    .map-pin::before { content: ''; position: absolute; inset: -12px; border-radius: 50%; background: rgba(124,58,237,.12); animation: pulse 2s ease-in-out infinite; }
    @keyframes pulse { 0%,100% { transform: scale(1); opacity: 1; } 50% { transform: scale(1.3); opacity: 0; } }
    .map-badges { display: flex; flex-wrap: wrap; gap: 7px; }
    .map-badge { background: var(--surface2); border: 1.5px solid var(--border-soft); padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; cursor: pointer; transition: all .2s; color: var(--text-mid); }
    .map-badge:hover, .map-badge.active { background: var(--violet); border-color: var(--violet); color: #fff; box-shadow: 0 3px 10px rgba(124,58,237,.25); }

    /* ── ANIMATIONS ── */
    @keyframes fadeUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
    .hero        { animation: fadeUp .55s ease both; }
    .stats-row   { animation: fadeUp .5s .10s ease both; }
    .two-col     { animation: fadeUp .5s .20s ease both; }
    .bottom-grid { animation: fadeUp .5s .30s ease both; }
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
      <a class="nav-item active" href="Home.aspx"><span class="icon">🏠</span> Home</a>
      <a class="nav-item" href="Event.aspx"><span class="icon">🎪</span> Event</a>
      <a class="nav-item" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
      <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
      <a class="nav-item" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
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
    .stat-num  {
      font-family: 'Playfair Display', serif;
      font-size: 26px;
      font-weight: 800;
      line-height: 1;
      color: var(--text);
    }
    .stat-label { font-size: 12px; color: var(--muted); margin-top: 4px; font-weight: 500; }
    .stat-badge {
      margin-left: auto;
      font-size: 11px;
      font-weight: 700;
      padding: 3px 10px;
      border-radius: 20px;
    }
    .badge-up   { background: #DCFCE7; color: #15803D; }
    .badge-down { background: #FEE2E2; color: #DC2626; }

    /* ─── 2-col Grid ─────────────────────────────────────────── */
    .two-col { display: grid; grid-template-columns: 1fr 370px; gap: 26px; margin-bottom: 34px; }

    /* ─── Section Header ─────────────────────────────────────── */
    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    .sec-title {
      font-family: 'Playfair Display', serif;
      font-size: 20px;
      font-weight: 800;
      color: var(--text);
    }
    .see-all {
      font-size: 13px;
      font-weight: 600;
      color: var(--violet);
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 4px;
      transition: gap .2s;
      text-decoration: none;
    }
    .see-all:hover { gap: 8px; }

    /* ─── Event Cards ────────────────────────────────────────── */
    .events-grid { display: flex; flex-direction: column; gap: 14px; }
    .event-card {
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: var(--radius);
      padding: 18px 20px;
      display: flex;
      align-items: center;
      gap: 18px;
      box-shadow: var(--shadow-sm);
      transition: all .22s ease;
      cursor: pointer;
    }
    .event-card:hover {
      border-color: rgba(124,58,237,.3);
      box-shadow: var(--shadow-md);
      transform: translateX(4px);
    }
    .event-img {
      width: 86px; height: 86px;
      border-radius: 14px;
      flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: 36px;
      border: 2px solid rgba(255,255,255,.6);
    }
    .event-img.holi  { background: linear-gradient(135deg, #fde68a, #fca5a5, #c4b5fd); }
    .event-img.music { background: linear-gradient(135deg, #93c5fd, #c084fc); }
    .event-img.film  { background: linear-gradient(135deg, #6ee7b7, #67e8f9); }
    .event-date {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: .08em;
      color: var(--violet);
      margin-bottom: 5px;
    }
    .event-name {
      font-family: 'Playfair Display', serif;
      font-size: 16px;
      font-weight: 800;
      margin-bottom: 5px;
      color: var(--text);
    }
    .event-loc {
      font-size: 13px;
      color: var(--muted);
      display: flex;
      align-items: center;
      gap: 4px;
      font-weight: 500;
    }
    .event-meta {
      margin-left: auto;
      text-align: right;
      display: flex;
      flex-direction: column;
      gap: 9px;
      align-items: flex-end;
    }
    .event-price {
      font-family: 'Playfair Display', serif;
      font-size: 20px;
      font-weight: 800;
      color: var(--gold);
    }
    .event-price.free { color: var(--green); font-size: 17px; }
    .attend-btn {
      background: linear-gradient(135deg, var(--violet), var(--violet-mid));
      color: #fff;
      border: none;
      border-radius: 20px;
      padding: 7px 18px;
      font-size: 12px;
      font-weight: 700;
      cursor: pointer;
      transition: all .2s;
      box-shadow: 0 3px 10px rgba(124,58,237,.25);
    }
    .attend-btn:hover { transform: scale(1.04); box-shadow: 0 6px 16px rgba(124,58,237,.35); }

    /* ─── Promo Card ─────────────────────────────────────────── */
    .promo-card {
      background: linear-gradient(145deg, #5B21B6 0%, #7C3AED 55%, #A855F7 100%);
      border-radius: 20px;
      padding: 26px 28px;
      margin-bottom: 20px;
      position: relative;
      overflow: hidden;
      box-shadow: var(--shadow-lg);
    }
    .promo-card::before {
      content: '';
      position: absolute;
      right: -40px; top: -40px;
      width: 200px; height: 200px;
      border-radius: 50%;
      background: rgba(255,255,255,.07);
    }
    .promo-card::after {
      content: '';
      position: absolute;
      right: 60px; bottom: -60px;
      width: 150px; height: 150px;
      border-radius: 50%;
      background: rgba(255,255,255,.05);
    }
    .promo-tag {
      display: inline-block;
      background: rgba(255,255,255,.2);
      font-size: 11px;
      font-weight: 700;
      letter-spacing: .1em;
      text-transform: uppercase;
      padding: 4px 12px;
      border-radius: 20px;
      margin-bottom: 12px;
      color: #fff;
    }
    .promo-title {
      font-family: 'Playfair Display', serif;
      font-size: 22px;
      font-weight: 900;
      line-height: 1.3;
      margin-bottom: 7px;
      color: #fff;
    }
    .promo-sub { font-size: 13px; color: rgba(255,255,255,.72); margin-bottom: 20px; line-height: 1.55; }
    .promo-row { display: flex; align-items: center; justify-content: space-between; position: relative; z-index: 1; }
    .qr-box {
      width: 76px; height: 76px;
      background: #fff;
      border-radius: 14px;
      display: grid; place-items: center;
      font-size: 38px;
      box-shadow: 0 6px 20px rgba(0,0,0,.25);
    }
    .qr-label { font-size: 10px; color: rgba(255,255,255,.6); margin-top: 6px; text-align: center; }
    .claim-btn {
      background: #fff;
      color: var(--violet);
      font-weight: 800;
      font-size: 13px;
      padding: 11px 22px;
      border-radius: 22px;
      border: none;
      cursor: pointer;
      transition: transform .15s, box-shadow .15s;
      box-shadow: 0 4px 16px rgba(0,0,0,.2);
    }
    .claim-btn:hover { transform: scale(1.04); box-shadow: 0 8px 24px rgba(0,0,0,.25); }

    /* ─── Categories Panel ───────────────────────────────────── */
    .cat-panel {
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: var(--radius);
      padding: 22px 22px;
      box-shadow: var(--shadow-sm);
    }
    .cats { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .cat-item {
      background: var(--surface2);
      border: 1.5px solid var(--border-soft);
      border-radius: 14px;
      padding: 16px 14px;
      display: flex;
      flex-direction: column;
      gap: 6px;
      cursor: pointer;
      transition: all .2s;
    }
    .cat-item:hover {
      background: var(--violet-soft);
      border-color: rgba(124,58,237,.3);
      transform: translateY(-2px);
      box-shadow: var(--shadow-sm);
    }
    .cat-emoji { font-size: 24px; }
    .cat-name { font-size: 13px; font-weight: 700; color: var(--text); }
    .cat-count { font-size: 11px; color: var(--muted); font-weight: 500; }

    /* ─── Bottom Grid ────────────────────────────────────────── */
    .bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 26px; }

    .panel {
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: var(--radius);
      padding: 26px;
      box-shadow: var(--shadow-sm);
    }

    /* ─── Popular List ───────────────────────────────────────── */
    .popular-list { display: flex; flex-direction: column; gap: 4px; }
    .popular-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 12px 12px;
      border-radius: 12px;
      transition: background .2s;
      cursor: pointer;
    }
    .popular-item:hover { background: var(--surface2); }
    .rank {
      font-family: 'Playfair Display', serif;
      font-size: 20px;
      font-weight: 900;
      color: #D1C9E8;
      width: 26px;
      text-align: center;
      flex-shrink: 0;
    }
    .rank.top { color: var(--gold); }
    .pop-img {
      width: 52px; height: 52px;
      border-radius: 12px;
      display: grid; place-items: center;
      font-size: 22px;
      flex-shrink: 0;
    }
    .pop-name { font-size: 14px; font-weight: 700; margin-bottom: 3px; color: var(--text); }
    .pop-loc { font-size: 12px; color: var(--muted); font-weight: 500; }
    .pop-price {
      margin-left: auto;
      font-family: 'Playfair Display', serif;
      font-weight: 800;
      font-size: 15px;
      color: var(--gold);
    }
    .pop-price.free { color: var(--green); font-size: 13px; font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; }

    /* ─── Map Box ────────────────────────────────────────────── */
    .map-box {
      height: 230px;
      background: linear-gradient(145deg, #EEF2FF, #EDE9FE);
      border-radius: 14px;
      position: relative;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 14px;
      border: 1px solid rgba(124,58,237,.1);
    }
    .map-grid {
      position: absolute; inset: 0;
      background-image:
        linear-gradient(rgba(124,58,237,.07) 1px, transparent 1px),
        linear-gradient(90deg, rgba(124,58,237,.07) 1px, transparent 1px);
      background-size: 34px 34px;
    }
    .map-pin {
      width: 50px; height: 50px;
      background: linear-gradient(135deg, var(--violet), var(--violet-mid));
      border-radius: 50% 50% 50% 0;
      transform: rotate(-45deg);
      box-shadow: 0 8px 24px rgba(124,58,237,.35);
      position: relative;
      z-index: 1;
    }
    .map-pin::after {
      content: '📍';
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%,-50%) rotate(45deg);
      font-size: 22px;
    }
    /* glowing ring around pin */
    .map-pin::before {
      content: '';
      position: absolute;
      inset: -12px;
      border-radius: 50%;
      background: rgba(124,58,237,.12);
      animation: pulse 2s ease-in-out infinite;
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 1; }
      50%       { transform: scale(1.3); opacity: 0; }
    }

    .map-badges {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }
    .map-badge {
      background: var(--surface2);
      border: 1.5px solid var(--border-soft);
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      transition: all .2s;
      color: var(--text-mid);
    }
    .map-badge:hover, .map-badge.active {
      background: var(--violet);
      border-color: var(--violet);
      color: #fff;
      box-shadow: 0 3px 10px rgba(124,58,237,.25);
    }

    /* ─── Animations ─────────────────────────────────────────── */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .hero          { animation: fadeUp .55s ease both; }
    .stats-row .stat-card:nth-child(1) { animation: fadeUp .5s .08s ease both; }
    .stats-row .stat-card:nth-child(2) { animation: fadeUp .5s .16s ease both; }
    .stats-row .stat-card:nth-child(3) { animation: fadeUp .5s .24s ease both; }
    .stats-row .stat-card:nth-child(4) { animation: fadeUp .5s .32s ease both; }
    .two-col       { animation: fadeUp .55s .2s  ease both; }
    .bottom-grid   { animation: fadeUp .55s .32s ease both; }
  </style>
</head>
<body>

  <!-- ═══════════════ SIDEBAR ═══════════════ -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">🎯</div>
      <div class="logo-text">
        EventNearMe
        <span>Discover Local Events</span>
      </div>
    </div>

    <nav class="nav">
      <div class="nav-label">Main</div>
      <a class="nav-item active" href="#">
        <span class="icon">🏠</span> Home
      </a>
      <a class="nav-item" href="#">
        <span class="icon">🗓️</span> Upcoming Events
      </a>
      <a class="nav-item" href="#">
        <span class="icon">🎟️</span> My Tickets
        <span class="nav-badge">3</span>
      </a>
      <a class="nav-item" href="#">
        <span class="icon">📍</span> Near Me
      </a>

      <div class="nav-label">Explore</div>
      <a class="nav-item" href="#">
        <span class="icon">🎵</span> Home
      </a>
      <a class="nav-item" href="#">
        <span class="icon">🎬</span> Events 
      </a>
      <a class="nav-item" href="#">
        <span class="icon">🎮</span> Gaming
      </a>
      <a class="nav-item" href="#">
        <span class="icon">🎨</span> Arts
      </a>

      <div class="nav-label">Account</div>
      <a class="nav-item" href="#">
        <span class="icon">❤️</span> Saved
      </a>
      <a class="nav-item" href="#">
        <span class="icon">⚙️</span> Settings
      </a>
    </nav>

    <div class="sidebar-bottom">
      <div class="user-card">
        <div class="avatar">R</div>
        <div class="user-info">
          <div class="user-name">Rahul Patel</div>
          <div class="user-role">Pro Member ✦</div>
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
        <asp:TextBox ID="txtSearch" runat="server"
          placeholder="Search events, artists, venues…"
          style="flex:1;background:none;border:none;outline:none;color:var(--text);font-size:14px;font-family:'Plus Jakarta Sans',sans-serif;min-width:0;width:100%" />
        <asp:Button ID="btnFilter" runat="server" CssClass="filter-btn" Text="⊞"
           style="font-size:15px" />
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
          <div class="hero-label">✦ Upcoming in Surat</div>
          <h1>Biggest Holi<br />Celebration 2026</h1>
          <p>Join thousands of people at the most vibrant festival of colours in Gujarat. Music, dance, food &amp; unlimited fun!</p>
          <div class="hero-btns">
            <asp:Button ID="btnGetTickets" runat="server" CssClass="btn-primary" Text="🎟️ Get Tickets" />
            <asp:Button ID="btnLearnMore"  runat="server" CssClass="btn-outline"  Text="Learn More →"  />
  <!-- ═══════════════ MAIN ═══════════════ -->
  <main class="main">

    <!-- Topbar -->
    <header class="topbar">
      <div class="location-pill">
        <span class="dot"></span>
        📍 Surat, Gujarat
        <span style="color:var(--muted);font-size:12px;margin-left:2px;">▾</span>
      </div>

      <div class="search-bar">
        <span class="search-icon">🔍</span>
        <input type="text" placeholder="Search events, artists, venues…" />
        <div class="filter-btn">⊞</div>
      </div>

      <div class="topbar-right">
        <div class="icon-btn">
          🔔
          <span class="notif-dot"></span>
        </div>
        <div class="icon-btn">💬</div>
        <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet);box-shadow:0 0 0 3px var(--violet-soft);">R</div>
      </div>
    </header>

    <!-- Content -->
    <div class="content">

      <!-- Hero -->
      <div class="hero">
        <div class="hero-dots"></div>
        <div>
          <div class="hero-label">✦ Upcoming in Surat</div>
          <h1>Biggest Holi<br>Celebration 2026</h1>
          <p>Join thousands of people at the most vibrant festival of colours in Gujarat. Music, dance, food & unlimited fun!</p>
          <div class="hero-btns">
            <button class="btn-primary">🎟️ Get Tickets</button>
            <button class="btn-outline">Learn More →</button>
          </div>
        </div>
        <div class="hero-image">🎨</div>
      </div>

      <!-- ── STATS ROW ── -->
      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-icon violet">🎪</div>
          <div class="stat-body">
            <div class="stat-num"><asp:Label ID="lblEventsCount" runat="server" Text="124" /></div>
            <div class="stat-label">Events This Month</div>
          </div>
          <span class="stat-badge badge-up"><asp:Label ID="lblEventsTrend" runat="server" Text="+12%" /></span>
        </div>
        <div class="stat-card">
          <div class="stat-icon red">🎟️</div>
          <div class="stat-body">
            <div class="stat-num"><asp:Label ID="lblTicketsSold" runat="server" Text="3,410" /></div>
            <div class="stat-label">Tickets Sold</div>
          </div>
          <span class="stat-badge badge-up"><asp:Label ID="lblTicketsTrend" runat="server" Text="+8%" /></span>
        </div>
        <div class="stat-card">
          <div class="stat-icon gold">⭐</div>
          <div class="stat-body">
            <div class="stat-num"><asp:Label ID="lblRating" runat="server" Text="4.9" /></div>
            <div class="stat-label">Avg. Rating</div>
          </div>
          <span class="stat-badge badge-up"><asp:Label ID="lblRatingTrend" runat="server" Text="+0.2" /></span>
        </div>
        <div class="stat-card">
          <div class="stat-icon green">👥</div>
          <div class="stat-body">
            <div class="stat-num"><asp:Label ID="lblUsers" runat="server" Text="52K" /></div>
            <div class="stat-label">Active Users</div>
          </div>
          <span class="stat-badge badge-down"><asp:Label ID="lblUsersTrend" runat="server" Text="-1%" /></span>
        </div>
      </div>

      <!-- ── TWO COLUMN ── -->
      <div class="two-col">

        <!-- LEFT: Upcoming Events -->
        <div>
          <div class="sec-header">
            <div class="sec-title">📅 Upcoming Events</div>
            <a class="see-all" href="Event.aspx">See All →</a>
      <!-- Stats Row -->
      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-icon violet">🎪</div>
          <div>
            <div class="stat-num">124</div>
            <div class="stat-label">Events This Month</div>
          </div>
          <span class="stat-badge badge-up">+12%</span>
        </div>
        <div class="stat-card">
          <div class="stat-icon red">🎟️</div>
          <div>
            <div class="stat-num">3,410</div>
            <div class="stat-label">Tickets Sold</div>
          </div>
          <span class="stat-badge badge-up">+8%</span>
        </div>
        <div class="stat-card">
          <div class="stat-icon gold">⭐</div>
          <div>
            <div class="stat-num">4.9</div>
            <div class="stat-label">Avg. Rating</div>
          </div>
          <span class="stat-badge badge-up">+0.2</span>
        </div>
        <div class="stat-card">
          <div class="stat-icon green">👥</div>
          <div>
            <div class="stat-num">52K</div>
            <div class="stat-label">Active Users</div>
          </div>
          <span class="stat-badge badge-down">-1%</span>
        </div>
      </div>

      <!-- Two Column -->
      <div class="two-col">

        <!-- Upcoming Events -->
        <div>
          <div class="sec-header">
            <div class="sec-title">📅 Upcoming Events</div>
            <a class="see-all" href="#">See All →</a>
          </div>
          <div class="events-grid">

            <div class="event-card">
              <div class="event-img holi">🎨</div>
              <div class="event-info">
              <div>
                <div class="event-date">4 March, 2026</div>
                <div class="event-name">Biggest Holi Celebration</div>
                <div class="event-loc">📍 Surat, Gujarat</div>
              </div>
              <div class="event-meta">
                <div class="event-price">₹499</div>
                <asp:Button ID="btnAttend1" runat="server" CssClass="attend-btn" Text="Attend" CommandArgument="1" />
                <button class="attend-btn">Attend</button>
              </div>
            </div>

            <div class="event-card">
              <div class="event-img music">🎵</div>
              <div>
                <div class="event-date">18 March, 2026</div>
                <div class="event-name">EDM Night Surat 2026</div>
                <div class="event-loc">📍 VNSGU Campus, Surat</div>
              </div>
              <div class="event-meta">
                <div class="event-price">₹799</div>
                <button class="attend-btn">Attend</button>
              </div>
            </div>

            <div class="event-card">
              <div class="event-img music">🎵</div>
              <div class="event-info">
                <div class="event-date">18 March, 2026</div>
                <div class="event-name">EDM Night Surat 2026</div>
                <div class="event-loc">📍 VNSGU Campus, Surat</div>
              </div>
              <div class="event-meta">
                <div class="event-price">₹799</div>
                <asp:Button ID="btnAttend2" runat="server" CssClass="attend-btn" Text="Attend" CommandArgument="2" />
              </div>
            </div>

            <div class="event-card">
              <div class="event-img film">🎬</div>
              <div class="event-info">
              <div class="event-img film">🎬</div>
              <div>
                <div class="event-date">25 March, 2026</div>
                <div class="event-name">Surat International Film Fest</div>
                <div class="event-loc">📍 Diamond City Hall, Surat</div>
              </div>
              <div class="event-meta">
                <div class="event-price free">Free</div>
                <asp:Button ID="btnAttend3" runat="server" CssClass="attend-btn" Text="Attend" CommandArgument="3" />
                <button class="attend-btn">Attend</button>
              </div>
            </div>

          </div>
        </div>

        <!-- RIGHT: Promo + Categories -->
        <div class="right-col">

        <!-- Right Column -->
        <div>
          <!-- Promo -->
          <div class="promo-card">
            <div class="promo-tag">🎁 Limited Offer</div>
            <div class="promo-title">Claim 4 Free Tickets!</div>
            <div class="promo-sub">Upgrade your account and unlock 4 free passes to any event of your choice.</div>
            <div class="promo-row">
              <asp:Button ID="btnUpgrade" runat="server" CssClass="claim-btn" Text="Upgrade Now" />
              <div class="qr-block">
              <button class="claim-btn">Upgrade Now</button>
              <div>
                <div class="qr-box">📱</div>
                <div class="qr-label">Scan to Download</div>
              </div>
            </div>
          </div>

          <div class="cat-panel">
            <div class="sec-header" style="margin-bottom:14px">
              <div class="sec-title" style="font-size:17px">Categories</div>
              <a class="see-all" style="font-size:12px" href="Event.aspx">View All →</a>
            </div>
            <div class="cats">
              <div class="cat-item"><span class="cat-emoji">🎵</span><div class="cat-name">Music</div><div class="cat-count">48 events</div></div>
              <div class="cat-item"><span class="cat-emoji">🎬</span><div class="cat-name">Film</div><div class="cat-count">22 events</div></div>
              <div class="cat-item"><span class="cat-emoji">🎮</span><div class="cat-name">Gaming</div><div class="cat-count">15 events</div></div>
              <div class="cat-item"><span class="cat-emoji">🎨</span><div class="cat-name">Arts</div><div class="cat-count">31 events</div></div>
            </div>
          </div>

        </div>
      </div><!-- /two-col -->

      <!-- ── BOTTOM GRID ── -->
      <div class="bottom-grid">

        <!-- Trending Events -->
        <div class="panel">
          <div class="sec-header">
            <div class="sec-title">🔥 Trending Events</div>
            <a class="see-all" href="Event.aspx">See All →</a>
          <!-- Categories -->
          <div class="cat-panel">
            <div class="sec-header" style="margin-bottom:14px">
              <div class="sec-title" style="font-size:17px">Categories</div>
              <a class="see-all" style="font-size:12px" href="#">View All →</a>
            </div>
            <div class="cats">
              <div class="cat-item">
                <span class="cat-emoji">🎵</span>
                <div class="cat-name">Music</div>
                <div class="cat-count">48 events</div>
              </div>
              <div class="cat-item">
                <span class="cat-emoji">🎬</span>
                <div class="cat-name">Film</div>
                <div class="cat-count">22 events</div>
              </div>
              <div class="cat-item">
                <span class="cat-emoji">🎮</span>
                <div class="cat-name">Gaming</div>
                <div class="cat-count">15 events</div>
              </div>
              <div class="cat-item">
                <span class="cat-emoji">🎨</span>
                <div class="cat-name">Arts</div>
                <div class="cat-count">31 events</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Bottom Grid -->
      <div class="bottom-grid">

        <!-- Popular Events -->
        <div class="panel">
          <div class="sec-header">
            <div class="sec-title">🔥 Trending Events</div>
            <a class="see-all" href="#">See All →</a>
          </div>
          <div class="popular-list">
            <div class="popular-item">
              <div class="rank top">1</div>
              <div class="pop-img" style="background:linear-gradient(135deg,#fde68a,#fca5a5)">🎨</div>
              <div class="pop-info"><div class="pop-name">Holi Color Run</div><div class="pop-loc">📍 Ring Road, Surat</div></div>
              <div>
                <div class="pop-name">Holi Color Run</div>
                <div class="pop-loc">📍 Ring Road, Surat</div>
              </div>
              <div class="pop-price">₹299</div>
            </div>
            <div class="popular-item">
              <div class="rank top">2</div>
              <div class="pop-img" style="background:linear-gradient(135deg,#93c5fd,#c084fc)">🎵</div>
              <div class="pop-info"><div class="pop-name">Summer Beats Festival</div><div class="pop-loc">📍 Dumas Beach, Surat</div></div>
              <div>
                <div class="pop-name">Summer Beats Festival</div>
                <div class="pop-loc">📍 Dumas Beach, Surat</div>
              </div>
              <div class="pop-price">₹599</div>
            </div>
            <div class="popular-item">
              <div class="rank">3</div>
              <div class="pop-img" style="background:linear-gradient(135deg,#6ee7b7,#67e8f9)">🎭</div>
              <div class="pop-info"><div class="pop-name">Comedy Night Live</div><div class="pop-loc">📍 Yuvraj Club, Surat</div></div>
              <div>
                <div class="pop-name">Comedy Night Live</div>
                <div class="pop-loc">📍 Yuvraj Club, Surat</div>
              </div>
              <div class="pop-price">₹349</div>
            </div>
            <div class="popular-item">
              <div class="rank">4</div>
              <div class="pop-img" style="background:linear-gradient(135deg,#fde68a,#fb923c)">🍽️</div>
              <div class="pop-info"><div class="pop-name">Food Carnival Surat</div><div class="pop-loc">📍 VR Mall, Surat</div></div>
              <div>
                <div class="pop-name">Food Carnival Surat</div>
                <div class="pop-loc">📍 VR Mall, Surat</div>
              </div>
              <div class="pop-price free">Free</div>
            </div>
          </div>
        </div>

        <!-- Map -->
        <div class="panel">
          <div class="sec-header">
            <div class="sec-title">🗺️ Events Near You</div>
            <a class="see-all" href="#">Open Map →</a>
          </div>
          <div class="map-box">
            <div class="map-grid"></div>
            <div class="map-pin"></div>
          </div>
          <div class="map-badges">
            <span class="map-badge active">All</span>
            <span class="map-badge">Music 🎵</span>
            <span class="map-badge">Film 🎬</span>
            <span class="map-badge">Food 🍽️</span>
            <span class="map-badge">Arts 🎨</span>
          </div>
        </div>

      </div><!-- /bottom-grid -->
    </div><!-- /content -->
  </main>

</div><!-- /layout -->
</form>

<script>
    document.querySelectorAll('.map-badge').forEach(b => {
        b.addEventListener('click', () => {
            document.querySelectorAll('.map-badge').forEach(x => x.classList.remove('active'));
            b.classList.add('active');
        });
    });
</script>
</body>

</html>
      </div>
    </div><!-- /content -->
  </main>

  <script runat="server">
    // ASP.NET code-behind placeholder
  </script>

  <script>
    document.querySelectorAll('.map-badge').forEach(b => {
      b.addEventListener('click', () => {
        document.querySelectorAll('.map-badge').forEach(x => x.classList.remove('active'));
        b.classList.add('active');
      });
    });
  </script>
</body>
</html>
