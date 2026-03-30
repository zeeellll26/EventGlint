<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Hall.aspx.cs" Inherits="EventGlint.Hall" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Halls — EventGlint</title>
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
            font-size: 38px;
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

        /* SECTION */
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

        /* HALL LIST — horizontal cards like original */
        .hall-list {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .hall-card {
            background: var(--surface);
            border: 1px solid var(--border-soft);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            display: flex;
            cursor: pointer;
            transition: all .22s;
            min-height: 200px;
        }

            .hall-card:hover {
                transform: translateY(-4px);
                box-shadow: var(--shadow-lg);
                border-color: rgba(124,58,237,.2);
            }

        /* Hall image panel */
        .hall-img {
            width: 280px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .hall-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform .5s;
            }

        .hall-card:hover .hall-img img {
            transform: scale(1.06);
        }

        .hall-emoji {
            font-size: 60px;
            position: relative;
            z-index: 1;
        }

        .hall-img::after {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            width: 40px;
            background: linear-gradient(to right,transparent,var(--surface));
            z-index: 2;
        }

        .hall-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            z-index: 3;
            background: rgba(0,0,0,.55);
            backdrop-filter: blur(8px);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,.2);
        }

        /* Backgrounds */
        .hbg1 {
            background: linear-gradient(145deg,#1a0533,#6b21a8,#7c3aed);
        }

        .hbg2 {
            background: linear-gradient(145deg,#0c4a6e,#0369a1,#0ea5e9);
        }

        .hbg3 {
            background: linear-gradient(145deg,#064e3b,#065f46,#059669);
        }

        .hbg4 {
            background: linear-gradient(145deg,#4a1942,#7c3aed,#be185d);
        }

        .hbg5 {
            background: linear-gradient(145deg,#422006,#92400e,#d97706);
        }

        .hbg6 {
            background: linear-gradient(145deg,#0f0c29,#302b63,#24243e);
        }

        /* Hall body */
        .hall-body {
            flex: 1;
            padding: 24px 28px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .hall-cat {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .08em;
            color: var(--violet);
            margin-bottom: 6px;
        }

        .hall-name {
            font-family: 'Playfair Display',serif;
            font-size: 20px;
            font-weight: 800;
            color: var(--text);
            line-height: 1.3;
            margin-bottom: 10px;
        }

        .hall-meta-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .hall-meta-pill {
            font-size: 12px;
            color: var(--muted);
            font-weight: 500;
            background: var(--surface2);
            padding: 4px 12px;
            border-radius: 14px;
            border: 1px solid var(--border-soft);
        }

        .hall-desc {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.65;
            margin-bottom: 14px;
        }

        .hall-facilities {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .hall-fac {
            font-size: 12px;
            font-weight: 600;
            background: var(--violet-soft);
            color: var(--violet);
            padding: 4px 12px;
            border-radius: 12px;
        }

        .hall-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .hall-price {
            font-family: 'Playfair Display',serif;
            font-size: 22px;
            font-weight: 800;
            color: var(--gold);
        }

        .hall-price-label {
            font-size: 11px;
            color: var(--muted);
            font-weight: 500;
            margin-top: 2px;
        }

        .hall-btn {
            background: linear-gradient(135deg,var(--violet),var(--violet-mid));
            color: #fff;
            border: none;
            border-radius: 16px;
            padding: 12px 28px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all .2s;
            box-shadow: 0 4px 14px rgba(124,58,237,.35);
            font-family: 'Plus Jakarta Sans',sans-serif;
        }

            .hall-btn:hover {
                transform: scale(1.05);
                box-shadow: 0 8px 22px rgba(124,58,237,.45);
            }

        /* Empty state */
        .empty-halls {
            text-align: center;
            padding: 60px 20px;
            color: var(--muted);
            font-size: 14px;
        }

            .empty-halls .em {
                font-size: 48px;
                margin-bottom: 12px;
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

        .hall-list {
            animation: fadeUp .5s .16s ease both;
        }

        @media(max-width:900px) {
            .hall-card {
                flex-direction: column;
            }

            .hall-img {
                width: 100%;
                height: 220px;
            }
        }

        @media(max-width:768px) {
            .sidebar {
                display: none;
            }

            .main {
                margin-left: 0;
                width: 100%;
            }

            .content {
                padding: 20px 16px;
            }
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
                    <a class="nav-item" href="shows.aspx"><span class="icon">🎭</span> Shows</a>
                    <a class="nav-item active" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
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
                        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search halls, venues, capacity…"
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
                            <div class="hero-label">🏛️ Premium Venues</div>
                            <h1>Find the Perfect<br />
                                Hall for Your<br />
                                Event</h1>
                            <p>Elegant halls and luxury screens — all ready to make your event unforgettable.</p>
                            <div class="hero-counters">
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblHallCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Premium Halls</div>
                                </div>
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblVenueCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Venues</div>
                                </div>
                                <div>
                                    <div class="hero-counter-num">
                                        <asp:Label ID="lblCapacityCount" runat="server" Text="0" /></div>
                                    <div class="hero-counter-label">Total Capacity</div>
                                </div>
                            </div>
                        </div>
                        <div class="hero-image">🏛️</div>
                    </div>

                    <!-- CHIPS -->
                    <div class="chip-row">
                        <asp:LinkButton ID="chipAll" runat="server" CssClass="chip active" CommandArgument="All" OnClick="Chip_Click">🎯 All</asp:LinkButton>
                        <asp:LinkButton ID="chipWedding" runat="server" CssClass="chip" CommandArgument="Wedding" OnClick="Chip_Click">💍 Wedding</asp:LinkButton>
                        <asp:LinkButton ID="chipCorp" runat="server" CssClass="chip" CommandArgument="Corporate" OnClick="Chip_Click">💼 Corporate</asp:LinkButton>
                        <asp:LinkButton ID="chipOutdoor" runat="server" CssClass="chip" CommandArgument="Outdoor" OnClick="Chip_Click">🌿 Outdoor</asp:LinkButton>
                        <asp:LinkButton ID="chipBanquet" runat="server" CssClass="chip" CommandArgument="Banquet" OnClick="Chip_Click">🍽️ Banquet</asp:LinkButton>
                        <asp:LinkButton ID="chipLuxury" runat="server" CssClass="chip" CommandArgument="Luxury" OnClick="Chip_Click">✨ Luxury</asp:LinkButton>
                        <div class="chip-divider"></div>
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_Changed">
                            <asp:ListItem Text="Sort: Default" Value="default" Selected="True" />
                            <asp:ListItem Text="Sort: Price Low–High" Value="price_asc" />
                            <asp:ListItem Text="Sort: Price High–Low" Value="price_desc" />
                            <asp:ListItem Text="Sort: Capacity ↑" Value="capacity" />
                        </asp:DropDownList>
                    </div>

                    <!-- SECTION HEADER -->
                    <div class="sec-row">
                        <span class="sec-title">🏛️ Available Halls</span>
                    </div>

                    <!-- HALL CARDS — DB-driven Repeater -->
                    <div class="hall-list">
                        <asp:Repeater ID="rptHalls" runat="server">
                            <ItemTemplate>
                                <div class="hall-card">

                                    <!-- Left image panel -->
                                    <div class='hall-img <%# GetBgClass(Container.ItemIndex) %>'>
                                        <span class="hall-emoji"><%# GetHallEmoji(Eval("HallType")) %></span>
                                        <div class="hall-badge">
                                            <%# GetHallEmoji(Eval("HallType")) %> <%# Eval("HallName") %>
                                        </div>
                                    </div>

                                    <!-- Right body -->
                                    <div class="hall-body">
                                        <div>
                                            <div class="hall-cat"><%# GetHallCategory(Eval("HallType")) %> Hall</div>
                                            <div class="hall-name"><%# Eval("VenueName") %></div>

                                            <div class="hall-meta-row">
                                                <span class="hall-meta-pill">📍 <%# !string.IsNullOrEmpty(Eval("VenueAddress").ToString()) ? Eval("VenueAddress") : Eval("VenueCity") %>
                                                </span>
                                                <span class="hall-meta-pill">👥 Up to <%# FormatCapacity(Eval("TotalCapacity")) %> guests
                                                </span>
                                                <%# !string.IsNullOrEmpty(Eval("CityName").ToString()) 
                                ? "<span class='hall-meta-pill'>🏙️ " + Eval("CityName") + "</span>" 
                                : "" %>
                                            </div>

                                            <div class="hall-desc">
                                                <%# GetHallDesc(Eval("HallType"), Eval("HallDescription")) %>
                                            </div>

                                            <div class="hall-facilities">
                                                <%# GetFacilitiesHTML(Eval("HallType")) %>
                                            </div>
                                        </div>

                                        <div class="hall-footer">
                                            <div>
                                                <div class="hall-price"><%# FormatPrice(Eval("MinPrice")) %></div>
                                                <div class="hall-price-label">
                                                    <%# Eval("MinPrice") != DBNull.Value && Convert.ToDecimal(Eval("MinPrice")) > 0 
                                    ? "per seat onwards" 
                                    : "" %>
                                                </div>
                                            </div>
                                            <asp:Button ID="btnHallBook" runat="server" CssClass="hall-btn" Text="Book Now"
                                                OnClick="btnHall_Click"
                                                CommandArgument='<%# Eval("HallId") %>' />
                                        </div>
                                    </div>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <!-- Empty state shown when no halls in DB -->
                        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                            <div class="empty-halls">
                                <div class="em">🏛️</div>
                                <div>No halls available matching your criteria.</div>
                                <div style="margin-top: 8px; font-size: 12px">Try adjusting your filters or check back later.</div>
                            </div>
                        </asp:Panel>
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
