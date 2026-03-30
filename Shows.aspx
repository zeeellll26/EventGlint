<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Shows.aspx.cs" Inherits="EventGlint.Shows" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shows — EventGlint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --violet: #7C3AED;
            --violet-mid: #9D5CF8;
            --violet-soft: #EDE9FE;
            --violet-glow: rgba(124,58,237,.14);
            --bg: #F7F5FF;
            --surface: #FFFFFF;
            --surface2: #F1EEF9;
            --border-soft: rgba(0,0,0,.06);
            --text: #1A1033;
            --text-mid: #3D2F6B;
            --muted: #8B7BB0;
            --coral: #FF6B6B;
            --gold: #E88C1A;
            --green: #16A34A;
            --shadow-sm: 0 1px 4px rgba(124,58,237,.07),0 2px 12px rgba(0,0,0,.05);
            --shadow-md: 0 4px 20px rgba(124,58,237,.10),0 2px 8px rgba(0,0,0,.06);
            --shadow-lg: 0 12px 40px rgba(124,58,237,.16),0 4px 16px rgba(0,0,0,.08);
            --radius: 18px;
            --sidebar: 264px;
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Plus Jakarta Sans',sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        a {
            text-decoration: none;
        }

        ::-webkit-scrollbar {
            width: 5px;
        }

        ::-webkit-scrollbar-track {
            background: var(--bg);
        }

        ::-webkit-scrollbar-thumb {
            background: #C4B5FD;
            border-radius: 4px;
        }

        #form1 {
            display: contents;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
        .sidebar {
            width: var(--sidebar);
            min-height: 100vh;
            background: var(--surface);
            border-right: 1px solid var(--border-soft);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            padding: 30px 0;
            box-shadow: 2px 0 20px rgba(124,58,237,.06);
        }

            .sidebar::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg,var(--violet),var(--violet-mid),#C084FC);
            }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 0 24px 30px;
            border-bottom: 1px solid var(--border-soft);
        }

        .logo-icon {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg,var(--violet),var(--violet-mid));
            border-radius: 14px;
            display: grid;
            place-items: center;
            font-size: 20px;
            flex-shrink: 0;
        }

        .logo-text {
            font-family: 'Playfair Display',serif;
            font-weight: 800;
            font-size: 17px;
            line-height: 1.2;
            color: var(--text);
        }

            .logo-text span {
                font-family: 'Plus Jakarta Sans',sans-serif;
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
            font-size: 14px;
            font-weight: 500;
            color: var(--muted);
            text-decoration: none;
            transition: all .2s;
        }

            .nav-item:hover {
                background: var(--violet-soft);
                color: var(--violet);
            }

            .nav-item.active {
                background: linear-gradient(135deg,var(--violet-soft),#DDD6FE);
                color: var(--violet);
                font-weight: 600;
                box-shadow: inset 0 0 0 1px rgba(124,58,237,.2);
            }

            .nav-item .icon {
                font-size: 17px;
                width: 22px;
                text-align: center;
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
            border: 1px solid var(--border-soft);
        }

        .avatar {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg,var(--violet),#C084FC);
            border-radius: 50%;
            display: grid;
            place-items: center;
            font-weight: 700;
            font-size: 15px;
            color: #fff;
            flex-shrink: 0;
        }

        .user-info {
            flex: 1;
        }

        .user-name {
            font-size: 13px;
            font-weight: 600;
            color: var(--text);
        }

        .user-role {
            font-size: 11px;
            color: var(--muted);
        }

        .user-dots {
            color: var(--muted);
            font-size: 18px;
        }

        /* MAIN */
        .main {
            margin-left: var(--sidebar);
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            width: calc(100% - var(--sidebar));
            overflow-x: hidden;
        }

        /* TOPBAR */
        .topbar {
            height: 70px;
            background: rgba(247,245,255,.95);
            backdrop-filter: blur(24px);
            border-bottom: 1px solid var(--border-soft);
            display: flex;
            align-items: center;
            padding: 0 32px;
            gap: 16px;
            position: sticky;
            top: 0;
            z-index: 90;
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
            box-shadow: var(--shadow-sm);
            color: var(--text-mid);
            white-space: nowrap;
            flex-shrink: 0;
        }

            .location-pill .dot {
                width: 8px;
                height: 8px;
                background: #22C55E;
                border-radius: 50%;
                box-shadow: 0 0 6px #22C55E;
                flex-shrink: 0;
            }

        .search-wrap {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--surface);
            border: 1.5px solid var(--border-soft);
            border-radius: 28px;
            padding: 0 16px;
            height: 44px;
            box-shadow: var(--shadow-sm);
            min-width: 0;
        }

            .search-wrap:focus-within {
                border-color: var(--violet);
                box-shadow: 0 0 0 3px var(--violet-glow);
            }

            .search-wrap .s-icon {
                color: var(--muted);
                font-size: 17px;
                flex-shrink: 0;
            }

            .search-wrap input {
                flex: 1;
                background: none;
                border: none;
                outline: none;
                color: var(--text);
                font-size: 14px;
                font-family: 'Plus Jakarta Sans',sans-serif;
                min-width: 0;
                width: 100%;
            }

                .search-wrap input::placeholder {
                    color: var(--muted);
                }

        .topbar-right {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .icon-btn {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: var(--surface);
            border: 1px solid var(--border-soft);
            display: grid;
            place-items: center;
            cursor: pointer;
            font-size: 18px;
            position: relative;
            box-shadow: var(--shadow-sm);
        }

        .notif-dot {
            position: absolute;
            top: 8px;
            right: 9px;
            width: 8px;
            height: 8px;
            background: var(--coral);
            border-radius: 50%;
            border: 2px solid var(--bg);
        }

        /* CONTENT */
        .content {
            padding: 30px 32px 48px;
            flex: 1;
        }

        /* HERO */
        .hero {
            border-radius: 26px;
            background: linear-gradient(130deg,#5B21B6 0%,#7C3AED 45%,#A855F7 80%,#C084FC 100%);
            padding: 44px 50px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 28px;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }

            .hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: radial-gradient(ellipse at 80% 20%,rgba(255,255,255,.12) 0%,transparent 50%);
            }

        .hero-dots {
            position: absolute;
            right: 260px;
            top: 18px;
            width: 110px;
            height: 110px;
            background-image: radial-gradient(circle,rgba(255,255,255,.18) 1.5px,transparent 1.5px);
            background-size: 16px 16px;
            border-radius: 50%;
        }

        .hero-left {
            position: relative;
            z-index: 1;
            flex: 1;
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
            margin-bottom: 14px;
            font-weight: 600;
        }

        .hero h1 {
            font-family: 'Playfair Display',serif;
            font-size: 40px;
            font-weight: 900;
            line-height: 1.12;
            color: #fff;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 14px;
            color: rgba(255,255,255,.75);
            max-width: 420px;
            line-height: 1.65;
        }

        .hero-counters {
            display: flex;
            gap: 32px;
            margin-top: 22px;
        }

        .hero-counter-num {
            font-family: 'Playfair Display',serif;
            font-size: 28px;
            font-weight: 900;
            color: #fff;
            line-height: 1;
        }

        .hero-counter-label {
            font-size: 11px;
            color: rgba(255,255,255,.65);
            font-weight: 500;
            margin-top: 3px;
        }

        .hero-image {
            width: 200px;
            height: 180px;
            border-radius: 20px;
            background: linear-gradient(135deg,rgba(255,200,100,.5),rgba(255,107,107,.4));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 72px;
            box-shadow: 0 16px 44px rgba(0,0,0,.3);
            position: relative;
            z-index: 1;
            border: 2px solid rgba(255,255,255,.25);
            flex-shrink: 0;
        }

        /* CHIPS */
        .chip-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 28px;
            overflow-x: auto;
            padding-bottom: 4px;
        }

            .chip-row::-webkit-scrollbar {
                height: 0;
            }

        .chip {
            background: var(--surface);
            border: 1.5px solid var(--border-soft);
            padding: 9px 20px;
            border-radius: 24px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all .2s;
            color: var(--text-mid);
            white-space: nowrap;
            box-shadow: var(--shadow-sm);
        }

            .chip:hover {
                background: var(--violet-soft);
                border-color: rgba(124,58,237,.3);
                color: var(--violet);
            }

            .chip.active {
                background: var(--violet);
                border-color: var(--violet);
                color: #fff;
                box-shadow: 0 4px 14px rgba(124,58,237,.35);
            }

        .chip-divider {
            width: 1px;
            height: 30px;
            background: var(--border-soft);
            flex-shrink: 0;
        }

        .sort-select {
            background: var(--surface);
            border: 1.5px solid var(--border-soft);
            border-radius: 22px;
            padding: 8px 18px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-mid);
            outline: none;
            font-family: 'Plus Jakarta Sans',sans-serif;
            cursor: pointer;
            box-shadow: var(--shadow-sm);
            margin-left: auto;
            flex-shrink: 0;
        }

        /* SECTION HEADER */
        .sec-row {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            margin-bottom: 18px;
            gap: 12px;
        }

        .sec-title {
            font-family: 'Playfair Display',serif;
            font-size: 22px;
            font-weight: 800;
            color: var(--text);
        }

        .see-all {
            font-size: 13px;
            font-weight: 600;
            color: var(--violet);
            display: flex;
            align-items: center;
            gap: 4px;
        }

            .see-all:hover {
                gap: 8px;
            }

        /* SHOW CARD GRID  — same structure as ev-poster in Event.aspx */
        .show-grid {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 20px;
            margin-bottom: 36px;
        }

        .show-card {
            background: var(--surface);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-soft);
            cursor: pointer;
            transition: transform .22s,box-shadow .22s;
            display: flex;
            flex-direction: column;
        }

            .show-card:hover {
                transform: translateY(-7px);
                box-shadow: var(--shadow-lg);
                border-color: rgba(124,58,237,.18);
            }

        .show-img {
            width: 100%;
            aspect-ratio: 3/4;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

            .show-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform .5s;
            }

        .show-card:hover .show-img img {
            transform: scale(1.07);
        }

        .show-emoji {
            font-size: 72px;
            position: relative;
            z-index: 1;
        }

        /* bg classes same as Event.aspx */
        .bg1 {
            background: linear-gradient(160deg,#0f0c29,#302b63,#24243e);
        }

        .bg2 {
            background: linear-gradient(160deg,#1a0533,#6b21a8,#4c1d95);
        }

        .bg3 {
            background: linear-gradient(160deg,#7f1d1d,#991b1b,#c2410c);
        }

        .bg4 {
            background: linear-gradient(160deg,#064e3b,#065f46,#059669);
        }

        .bg5 {
            background: linear-gradient(160deg,#1e3a5f,#1d4ed8,#3b82f6);
        }

        .bg6 {
            background: linear-gradient(160deg,#4a1942,#7c3aed,#be185d);
        }

        .bg7 {
            background: linear-gradient(160deg,#422006,#92400e,#d97706);
        }

        .bg8 {
            background: linear-gradient(160deg,#0c4a6e,#0369a1,#0ea5e9);
        }

        .show-img::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 55%;
            background: linear-gradient(to top,rgba(0,0,0,.72) 0%,transparent 100%);
            z-index: 2;
            pointer-events: none;
        }

        .show-img-top {
            position: absolute;
            top: 12px;
            left: 12px;
            right: 12px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 3;
        }

        .show-cat-tag {
            font-size: 10px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 12px;
            backdrop-filter: blur(10px);
            text-transform: uppercase;
            letter-spacing: .05em;
            border: 1px solid rgba(255,255,255,.2);
        }

        .tag-movie {
            background: rgba(239,68,68,.8);
            color: #fff;
        }

        .tag-music {
            background: rgba(139,92,246,.8);
            color: #fff;
        }

        .tag-comedy {
            background: rgba(249,115,22,.8);
            color: #fff;
        }

        .tag-drama {
            background: rgba(59,130,246,.8);
            color: #fff;
        }

        .tag-concert {
            background: rgba(139,92,246,.8);
            color: #fff;
        }

        .tag-other {
            background: rgba(124,58,237,.8);
            color: #fff;
        }

        .show-heart {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: rgba(255,255,255,.18);
            backdrop-filter: blur(8px);
            display: grid;
            place-items: center;
            font-size: 14px;
            color: #fff;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,.25);
            user-select: none;
        }

            .show-heart:hover {
                background: rgba(220,38,38,.7);
            }

        .show-info-bar {
            position: absolute;
            bottom: 12px;
            left: 12px;
            right: 12px;
            z-index: 3;
        }

        .show-badge {
            font-size: 11px;
            font-weight: 600;
            color: rgba(255,255,255,.9);
            background: rgba(0,0,0,.45);
            backdrop-filter: blur(6px);
            padding: 4px 10px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,.15);
        }

        .show-body {
            padding: 14px 16px 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .show-name {
            font-family: 'Playfair Display',serif;
            font-size: 15px;
            font-weight: 800;
            color: var(--text);
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .show-meta {
            font-size: 12px;
            color: var(--muted);
            font-weight: 500;
        }

        .show-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 8px;
        }

        .show-price {
            font-family: 'Playfair Display',serif;
            font-size: 18px;
            font-weight: 800;
            color: var(--gold);
        }

            .show-price.free {
                color: var(--green);
                font-family: 'Plus Jakarta Sans',sans-serif;
                font-size: 14px;
                font-weight: 700;
            }

        .show-btn {
            background: linear-gradient(135deg,var(--violet),var(--violet-mid));
            color: #fff;
            border: none;
            border-radius: 16px;
            padding: 9px 18px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all .2s;
            box-shadow: 0 3px 10px rgba(124,58,237,.3);
            font-family: 'Plus Jakarta Sans',sans-serif;
            white-space: nowrap;
        }

            .show-btn:hover {
                transform: scale(1.05);
                box-shadow: 0 6px 18px rgba(124,58,237,.4);
            }

        /* Empty state */
        .empty-sec {
            text-align: center;
            padding: 40px 20px;
            color: var(--muted);
            font-size: 14px;
            grid-column: 1/-1;
        }

            .empty-sec .em {
                font-size: 36px;
                margin-bottom: 8px;
            }

        /* ANIMATIONS */
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(18px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero {
            animation: fadeUp .55s ease both;
        }

        .chip-row {
            animation: fadeUp .5s .08s ease both;
        }

        .sec-movies {
            animation: fadeUp .5s .14s ease both;
        }

        .sec-music {
            animation: fadeUp .5s .20s ease both;
        }

        .sec-comedy {
            animation: fadeUp .5s .26s ease both;
        }
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
                    <a class="nav-item" href="Event.aspx"><span class="icon">🎪</span> Event</a>
                    <a class="nav-item active" href="shows.aspx"><span class="icon">🎭</span> Shows</a>
                    <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
                    <a class="nav-item" href="Bookings.aspx"><span class="icon">🎟️</span> My Bookings</a>
                    <a class="nav-item" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
                </nav>
                <div class="sidebar-bottom">
                    <div class="user-card">
                        <div class="avatar">
                            <asp:Label ID="lblAvatarInitial" runat="server" Text="U" /></div>
                        <div class="user-info">
                            <div class="user-name">
                                <asp:Label ID="lblUserName" runat="server" Text="User" /></div>
                            <div class="user-role">
                                <asp:Label ID="lblUserRole" runat="server" Text="Member" /></div>
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
                        <span style="color: var(--muted); font-size: 11px; margin-left: 2px">▾</span>
                    </div>
                    <div class="search-wrap">
                        <span class="s-icon">🔍</span>
                        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search movies, shows, artists…"
                            Style="flex: 1; background: none; border: none; outline: none; color: var(--text); font-size: 14px; font-family: 'Plus Jakarta Sans',sans-serif; min-width: 0; width: 100%" />
                    </div>
                    <div class="topbar-right">
                        <div class="icon-btn">🔔<span class="notif-dot"></span></div>
                        <div class="icon-btn">💬</div>
                        <div class="avatar" style="width: 42px; height: 42px; border: 2.5px solid var(--violet); box-shadow: 0 0 0 3px var(--violet-soft)">
                            <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
                        </div>
                    </div>
                </header>

                <!-- CONTENT -->
                <div class="content">

                    <!-- HERO -->
                    <div class="hero">
                        <div class="hero-dots"></div>
                        <div class="hero-left">
                            <div class="hero-label">🎬 Now Showing &amp; Upcoming</div>
                            <h1>Explore Cinema<br />
                                Near You</h1>
                            <p>Movies, music shows, comedy nights and live performances — all in one place.</p>
                            <div class="hero-counters">
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblMovieCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Movies</div>
                                </div>
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblMusicCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Music Shows</div>
                                </div>
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblComedyCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Comedy Shows</div>
                                </div>
                            </div>
                        </div>
                        <div class="hero-image">🎬</div>
                    </div>

                    <!-- CHIPS -->
                    <div class="chip-row">
                        <asp:LinkButton ID="chipAll" runat="server" CssClass="chip active" CommandArgument="All" OnClick="Chip_Click">🎯 All</asp:LinkButton>
                        <asp:LinkButton ID="chipMovies" runat="server" CssClass="chip" CommandArgument="Movies" OnClick="Chip_Click">🎬 Movies</asp:LinkButton>
                        <asp:LinkButton ID="chipMusic" runat="server" CssClass="chip" CommandArgument="Music" OnClick="Chip_Click">🎵 Music</asp:LinkButton>
                        <asp:LinkButton ID="chipComedy" runat="server" CssClass="chip" CommandArgument="Comedy" OnClick="Chip_Click">🎭 Comedy</asp:LinkButton>
                        <asp:LinkButton ID="chipDrama" runat="server" CssClass="chip" CommandArgument="Drama" OnClick="Chip_Click">🎞️ Drama</asp:LinkButton>
                        <asp:LinkButton ID="chipFree" runat="server" CssClass="chip" CommandArgument="Free" OnClick="Chip_Click">🎁 Free</asp:LinkButton>
                        <div class="chip-divider"></div>
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_Changed">
                            <asp:ListItem Text="Sort: Recommended" Value="recommended" Selected="True" />
                            <asp:ListItem Text="Sort: Price Low–High" Value="price_asc" />
                            <asp:ListItem Text="Sort: Price High–Low" Value="price_desc" />
                            <asp:ListItem Text="Sort: Most Popular" Value="popular" />
                        </asp:DropDownList>
                    </div>

                    <!-- ══ SECTION 1: MOVIES ══ -->
                    <div class="sec-movies">
                        <div class="sec-row">
                            <span class="sec-title">⭐ Best Recommended Movies</span>
                            <a class="see-all" href="Event.aspx?cat=Movie">See All →</a>
                        </div>
                        <div class="show-grid">
                            <asp:Repeater ID="rptMovies" runat="server">
                                <ItemTemplate>
                                    <div class="show-card">
                                        <div class='show-img <%# GetBgClass(Container.ItemIndex) %>'>
                                            <div class="show-img-top">
                                                <span class='show-cat-tag <%# GetTagClass(Eval("EventType")) %>'><%# Eval("EventType") %></span>
                                                <span class="show-heart" onclick="toggleHeart(this)">♡</span>
                                            </div>
                                            <span class="show-emoji"><%# GetEmoji(Eval("EventType")) %></span>
                                            <div class="show-info-bar">
                                                <span class="show-badge">📍 <%# Eval("VenueName") %></span>
                                            </div>
                                        </div>
                                        <div class="show-body">
                                            <div class="show-name"><%# Eval("Title") %></div>
                                            <div class="show-meta">
                                                <%# Eval("Language") != DBNull.Value && !string.IsNullOrEmpty(Eval("Language").ToString()) ? Eval("Language").ToString() + " · " : "" %>
                                                <%# Eval("HallName") %>
                                            </div>
                                            <div class="show-meta">
                                                📅 <%# Eval("ShowDate", "{0:dd MMM yyyy}") %>
                            &nbsp; ⏰ <%# FormatTime(Eval("StartTime")) %>
                                            </div>
                                            <div class="show-footer">
                                                <div class='show-price <%# Convert.ToDecimal(Eval("MinPrice") ?? 0) == 0 ? "free" : "" %>'>
                                                    <%# FormatPrice(Eval("MinPrice")) %>
                                                </div>
                                                <asp:Button ID="btnBook" runat="server" CssClass="show-btn" Text="Book Now"
                                                    OnClick="btnBook_Click"
                                                    CommandArgument='<%# Eval("ShowId") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- Empty State -->
                            <asp:Panel ID="pnlMoviesEmpty" runat="server" CssClass="empty-sec"
                                Visible='<%# ((System.Web.UI.WebControls.Repeater)rptMovies).Items.Count == 0 %>'>
                                <div class="em">🎬</div>
                                <p>No movies available at the moment</p>
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- ══ SECTION 2: MUSIC ══ -->
                    <div class="sec-music">
                        <div class="sec-row">
                            <span class="sec-title">🎵 Music Shows</span>
                            <a class="see-all" href="Event.aspx?cat=Concert">See All →</a>
                        </div>
                        <div class="show-grid">
                            <asp:Repeater ID="rptMusic" runat="server">
                                <ItemTemplate>
                                    <div class="show-card">
                                        <div class='show-img <%# GetBgClass(Container.ItemIndex + 4) %>'>
                                            <div class="show-img-top">
                                                <span class='show-cat-tag <%# GetTagClass(Eval("EventType")) %>'><%# Eval("EventType") %></span>
                                                <span class="show-heart" onclick="toggleHeart(this)">♡</span>
                                            </div>
                                            <span class="show-emoji"><%# GetEmoji(Eval("EventType")) %></span>
                                            <div class="show-info-bar">
                                                <span class="show-badge">📍 <%# Eval("VenueName") %></span>
                                            </div>
                                        </div>
                                        <div class="show-body">
                                            <div class="show-name"><%# Eval("Title") %></div>
                                            <div class="show-meta">
                                                <%# Eval("VenueName") %>
                                                <%# !string.IsNullOrEmpty(Eval("HallName").ToString()) ? ", " + Eval("HallName") : "" %>
                                            </div>
                                            <div class="show-meta">
                                                📅 <%# Eval("ShowDate", "{0:dd MMM yyyy}") %>
                            &nbsp; ⏰ <%# FormatTime(Eval("StartTime")) %>
                                            </div>
                                            <div class="show-footer">
                                                <div class='show-price <%# Convert.ToDecimal(Eval("MinPrice") ?? 0) == 0 ? "free" : "" %>'>
                                                    <%# FormatPrice(Eval("MinPrice")) %>
                                                </div>
                                                <asp:Button ID="btnBook" runat="server" CssClass="show-btn" Text="Book Now"
                                                    OnClick="btnBook_Click"
                                                    CommandArgument='<%# Eval("ShowId") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- Empty State -->
                            <asp:Panel ID="pnlMusicEmpty" runat="server" CssClass="empty-sec"
                                Visible='<%# ((System.Web.UI.WebControls.Repeater)rptMusic).Items.Count == 0 %>'>
                                <div class="em">🎵</div>
                                <p>No music shows available at the moment</p>
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- ══ SECTION 3: COMEDY ══ -->
                    <div class="sec-comedy">
                        <div class="sec-row">
                            <span class="sec-title">🎭 Comedy Shows</span>
                            <a class="see-all" href="Event.aspx?cat=Comedy">See All →</a>
                        </div>
                        <div class="show-grid">
                            <asp:Repeater ID="rptComedy" runat="server">
                                <ItemTemplate>
                                    <div class="show-card">
                                        <div class='show-img <%# GetBgClass(Container.ItemIndex + 2) %>'>
                                            <div class="show-img-top">
                                                <span class='show-cat-tag <%# GetTagClass(Eval("EventType")) %>'><%# Eval("EventType") %></span>
                                                <span class="show-heart" onclick="toggleHeart(this)">♡</span>
                                            </div>
                                            <span class="show-emoji"><%# GetEmoji(Eval("EventType")) %></span>
                                            <div class="show-info-bar">
                                                <span class="show-badge">📍 <%# Eval("VenueName") %></span>
                                            </div>
                                        </div>
                                        <div class="show-body">
                                            <div class="show-name"><%# Eval("Title") %></div>
                                            <div class="show-meta">
                                                <%# Eval("VenueName") %>
                                                <%# !string.IsNullOrEmpty(Eval("HallName").ToString()) ? ", " + Eval("HallName") : "" %>
                                            </div>
                                            <div class="show-meta">
                                                📅 <%# Eval("ShowDate", "{0:dd MMM yyyy}") %>
                            &nbsp; ⏰ <%# FormatTime(Eval("StartTime")) %>
                                            </div>
                                            <div class="show-footer">
                                                <div class='show-price <%# Convert.ToDecimal(Eval("MinPrice") ?? 0) == 0 ? "free" : "" %>'>
                                                    <%# FormatPrice(Eval("MinPrice")) %>
                                                </div>
                                                <asp:Button ID="btnBook" runat="server" CssClass="show-btn" Text="Book Now"
                                                    OnClick="btnBook_Click"
                                                    CommandArgument='<%# Eval("ShowId") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- Empty State -->
                            <asp:Panel ID="pnlComedyEmpty" runat="server" CssClass="empty-sec"
                                Visible='<%# ((System.Web.UI.WebControls.Repeater)rptComedy).Items.Count == 0 %>'>
                                <div class="em">🎤</div>
                                <p>No comedy shows available at the moment</p>
                            </asp:Panel>
                        </div>
                    </div>


                </div>
                <!-- /content -->
            </main>

        </div>
        <!-- /layout -->
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
