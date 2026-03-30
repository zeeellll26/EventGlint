<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookTicket.aspx.cs" Inherits="EventGlint.BookTicket" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Book Tickets</title>
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
            --gold:        #E88C1A;
            --green:       #16A34A;
            --red:         #DC2626;
            --shadow-sm:   0 1px 4px rgba(124,58,237,.07);
            --shadow-md:   0 4px 20px rgba(124,58,237,.10);
            --shadow-lg:   0 12px 40px rgba(124,58,237,.16);
            --radius:      18px;
            --sidebar:     264px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: var(--text); }
        a { text-decoration: none; }
        #form1 { display: contents; }

        /* ── LAYOUT ── */
        .layout { display: flex; min-height: 100vh; }

        /* ── SIDEBAR ── */
        .sidebar { width: var(--sidebar); min-height: 100vh; background: var(--surface); border-right: 1px solid var(--border-soft); display: flex; flex-direction: column; position: fixed; top: 0; left: 0; z-index: 100; padding: 30px 0; box-shadow: 2px 0 20px rgba(124,58,237,.06); }
        .sidebar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--violet), var(--violet-mid), #C084FC); }
        .sidebar-logo { display: flex; align-items: center; gap: 13px; padding: 0 24px 30px; border-bottom: 1px solid var(--border-soft); }
        .logo-icon { width: 44px; height: 44px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); border-radius: 14px; display: grid; place-items: center; font-size: 20px; flex-shrink: 0; }
        .logo-text { font-family: 'Playfair Display', serif; font-weight: 800; font-size: 17px; line-height: 1.2; color: var(--text); }
        .logo-text span { font-family: 'Plus Jakarta Sans', sans-serif; color: var(--muted); font-size: 11px; font-weight: 400; display: block; margin-top: 2px; }
        .nav { padding: 26px 14px; flex: 1; display: flex; flex-direction: column; gap: 3px; }
        .nav-label { font-size: 10px; text-transform: uppercase; letter-spacing: .14em; color: var(--muted); padding: 0 10px; margin: 14px 0 6px; font-weight: 600; }
        .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 12px; font-size: 14px; font-weight: 500; color: var(--muted); text-decoration: none; transition: all .2s; }
        .nav-item:hover { background: var(--violet-soft); color: var(--violet); }
        .nav-item.active { background: linear-gradient(135deg, var(--violet-soft), #DDD6FE); color: var(--violet); font-weight: 600; box-shadow: inset 0 0 0 1px rgba(124,58,237,.2); }
        .nav-item .icon { font-size: 17px; width: 22px; text-align: center; }
        .sidebar-bottom { padding: 20px; border-top: 1px solid var(--border-soft); }
        .user-card { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border-radius: 14px; background: var(--surface2); border: 1px solid var(--border-soft); }
        .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--violet), #C084FC); border-radius: 50%; display: grid; place-items: center; font-weight: 700; font-size: 15px; color: #fff; flex-shrink: 0; }
        .user-info .user-name { font-size: 13px; font-weight: 600; color: var(--text); }
        .user-info .user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }

        /* ── MAIN ── */
        .main { margin-left: var(--sidebar); flex: 1; display: flex; flex-direction: column; }

        /* ── TOPBAR ── */
        .topbar { height: 70px; background: rgba(247,245,255,.95); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; padding: 0 32px; gap: 16px; position: sticky; top: 0; z-index: 90; }
        .topbar-back { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 600; color: var(--muted); cursor: pointer; padding: 8px 14px; border-radius: 20px; background: var(--surface); border: 1px solid var(--border-soft); transition: all .2s; text-decoration: none; }
        .topbar-back:hover { color: var(--violet); border-color: var(--violet); background: var(--violet-soft); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }
        .icon-btn { width: 42px; height: 42px; border-radius: 50%; background: var(--surface); border: 1px solid var(--border-soft); display: grid; place-items: center; font-size: 18px; cursor: pointer; }

        /* ── CONTENT ── */
        .content { padding: 28px 32px 50px; flex: 1; }

        /* ── STEP INDICATOR ── */
        .steps-bar { display: flex; align-items: center; gap: 0; margin-bottom: 28px; }
        .step { display: flex; align-items: center; gap: 10px; }
        .step-circle { width: 34px; height: 34px; border-radius: 50%; display: grid; place-items: center; font-size: 13px; font-weight: 700; flex-shrink: 0; transition: all .3s; }
        .step.done .step-circle   { background: var(--green); color: #fff; }
        .step.active .step-circle { background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; box-shadow: 0 4px 12px rgba(124,58,237,.3); }
        .step.pending .step-circle { background: var(--surface); border: 2px solid var(--border-soft); color: var(--muted); }
        .step-label { font-size: 13px; font-weight: 600; }
        .step.done .step-label   { color: var(--green); }
        .step.active .step-label { color: var(--violet); }
        .step.pending .step-label { color: var(--muted); }
        .step-line { flex: 1; height: 2px; background: var(--border-soft); margin: 0 10px; min-width: 40px; }
        .step-line.done { background: var(--green); }

        /* ── MAIN GRID ── */
        .booking-grid { display: grid; grid-template-columns: 1fr 340px; gap: 22px; align-items: start; }

        /* ── PANEL CARD ── */
        .panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-sm); overflow: hidden; margin-bottom: 18px; }
        .panel-head { padding: 18px 22px; border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; gap: 12px; }
        .panel-icon { width: 38px; height: 38px; border-radius: 11px; background: var(--violet-soft); display: grid; place-items: center; font-size: 18px; flex-shrink: 0; }
        .panel-title { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 800; color: var(--text); }
        .panel-body { padding: 20px 22px; }

        /* ── EVENT INFO ── */
        .event-hero { display: flex; gap: 18px; align-items: flex-start; }
        .event-poster { width: 90px; height: 90px; border-radius: 14px; background: linear-gradient(135deg, var(--violet-soft), #DDD6FE); display: grid; place-items: center; font-size: 38px; flex-shrink: 0; }
        .event-title { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 900; color: var(--text); margin-bottom: 6px; }
        .event-tags { display: flex; gap: 7px; flex-wrap: wrap; margin-bottom: 10px; }
        .tag { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 12px; background: var(--violet-soft); color: var(--violet); }
        .event-desc { font-size: 13px; color: var(--muted); line-height: 1.6; }

        /* ── SHOWS ── */
        .show-grid { display: flex; flex-direction: column; gap: 10px; }
        .show-card { border: 2px solid var(--border-soft); border-radius: 14px; padding: 14px 18px; cursor: pointer; transition: all .2s; display: flex; align-items: center; gap: 14px; }
        .show-card:hover { border-color: rgba(124,58,237,.3); background: var(--violet-soft); }
        .show-card.selected { border-color: var(--violet); background: var(--violet-soft); box-shadow: 0 0 0 3px var(--violet-glow); }
        .show-date-box { text-align: center; flex-shrink: 0; min-width: 52px; }
        .show-day { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--violet); line-height: 1; }
        .show-mon { font-size: 11px; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }
        .show-info { flex: 1; }
        .show-time { font-size: 15px; font-weight: 700; color: var(--text); }
        .show-venue { font-size: 12px; color: var(--muted); margin-top: 3px; }
        .show-hall-type { font-size: 11px; font-weight: 700; padding: 2px 9px; border-radius: 10px; background: #FEF3C7; color: #92400E; }
        .show-price { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 800; color: var(--gold); flex-shrink: 0; }
        .show-radio { display: none; }

        /* ── SEAT MAP ── */
        .screen-bar { text-align: center; margin-bottom: 22px; }
        .screen-line { display: inline-block; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; font-size: 11px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; padding: 6px 40px; border-radius: 0 0 30px 30px; box-shadow: 0 6px 20px rgba(124,58,237,.25); }

        .seat-legend { display: flex; gap: 18px; justify-content: center; margin-bottom: 18px; flex-wrap: wrap; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--muted); font-weight: 500; }
        .legend-dot { width: 16px; height: 16px; border-radius: 4px; }
        .leg-available { background: var(--surface2); border: 2px solid var(--border-soft); }
        .leg-selected  { background: var(--violet); }
        .leg-booked    { background: #E5E7EB; }
        .leg-silver    { background: #E5E7EB; border: 2px solid #9CA3AF; }
        .leg-gold      { background: #FEF3C7; border: 2px solid #F59E0B; }
        .leg-platinum  { background: #EDE9FE; border: 2px solid var(--violet); }

        .seat-section { margin-bottom: 20px; }
        .seat-section-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .1em; color: var(--muted); margin-bottom: 10px; padding: 5px 12px; background: var(--surface2); border-radius: 8px; display: inline-block; }
        .seat-row { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
        .row-label { width: 20px; font-size: 11px; font-weight: 700; color: var(--muted); text-align: center; flex-shrink: 0; }
        .seats-wrap { display: flex; gap: 5px; flex-wrap: wrap; }
        .seat { width: 32px; height: 28px; border-radius: 6px 6px 3px 3px; display: grid; place-items: center; font-size: 10px; font-weight: 700; cursor: pointer; border: 2px solid transparent; transition: all .15s; user-select: none; }
        .seat.silver   { background: #F3F4F6; border-color: #D1D5DB; color: #6B7280; }
        .seat.gold     { background: #FFFBEB; border-color: #FCD34D; color: #92400E; }
        .seat.platinum { background: var(--violet-soft); border-color: #C4B5FD; color: var(--violet); }
        .seat:hover:not(.booked) { transform: scale(1.1); box-shadow: 0 3px 8px rgba(0,0,0,.15); }
        .seat.selected  { background: var(--violet) !important; border-color: var(--violet-mid) !important; color: #fff !important; box-shadow: 0 3px 10px rgba(124,58,237,.35); }
        .seat.booked    { background: #E5E7EB !important; border-color: #E5E7EB !important; color: #9CA3AF !important; cursor: not-allowed; opacity: .7; }
        .seat.booked:hover { transform: none; box-shadow: none; }

        /* ── COUPON ── */
        .coupon-row { display: flex; gap: 10px; }
        .coupon-input { flex: 1; padding: 10px 14px; border: 1.5px solid var(--border-soft); border-radius: 12px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); background: var(--surface); outline: none; transition: border .2s; }
        .coupon-input:focus { border-color: var(--violet); }
        .coupon-btn { padding: 10px 20px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 12px; font-weight: 700; font-size: 13px; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
        .coupon-btn:hover { opacity: .9; }
        .coupon-msg { font-size: 13px; margin-top: 8px; font-weight: 600; }
        .coupon-ok  { color: var(--green); }
        .coupon-err { color: var(--red); }

        /* ── SUMMARY CARD (right) ── */
        .summary-sticky { position: sticky; top: 88px; }
        .summary-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-md); overflow: hidden; }
        .summary-head { padding: 18px 20px; background: linear-gradient(135deg, #5B21B6, #7C3AED, #A855F7); }
        .summary-head h3 { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 900; color: #fff; }
        .summary-head p { font-size: 12px; color: rgba(255,255,255,.7); margin-top: 3px; }
        .summary-body { padding: 18px 20px; }
        .summary-row-item { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid var(--border-soft); font-size: 13px; }
        .summary-row-item:last-child { border-bottom: none; }
        .summary-row-item .label { color: var(--muted); font-weight: 500; }
        .summary-row-item .value { color: var(--text); font-weight: 600; }
        .summary-total { display: flex; justify-content: space-between; align-items: center; padding: 14px 20px; background: var(--violet-soft); border-top: 2px solid rgba(124,58,237,.15); }
        .summary-total .label { font-size: 14px; font-weight: 700; color: var(--text); }
        .summary-total .value { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--violet); }

        .selected-seats-list { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 8px; }
        .seat-pill { background: var(--violet-soft); color: var(--violet); font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 12px; }

        /* ── BOOK BUTTON ── */
        .book-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 14px; font-size: 15px; font-weight: 800; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; margin-top: 16px; transition: all .2s; box-shadow: 0 6px 20px rgba(124,58,237,.3); }
        .book-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(124,58,237,.4); }
        .book-btn:disabled { background: #D1D5DB; box-shadow: none; cursor: not-allowed; transform: none; }

        /* ── NO SHOW / EMPTY ── */
        .empty-msg { text-align: center; padding: 40px 20px; color: var(--muted); font-size: 14px; }
        .empty-msg .em { font-size: 36px; margin-bottom: 10px; }

        /* ── ALERT ── */
        .msg-box { padding: 12px 16px; border-radius: 12px; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .msg-success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
        .msg-error   { background: #FEE2E2; color: #DC2626; border: 1px solid #FECACA; }

        @keyframes fadeUp { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:translateY(0); } }
        .panel { animation: fadeUp .4s ease both; }
    </style>
</head>
<body>
<form id="form1" runat="server">

<!-- hidden fields to pass data between steps -->
<asp:HiddenField ID="hfSelectedShowId"  runat="server" Value="0" />
<asp:HiddenField ID="hfSelectedSeats"   runat="server" Value="" />
<asp:HiddenField ID="hfCouponId"        runat="server" Value="0" />
<asp:HiddenField ID="hfDiscount"        runat="server" Value="0" />

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
            <a class="nav-item" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
            <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
            <a class="nav-item" href="Bookings.aspx"><span class="icon">🎟️</span> My Bookings</a>
            <a class="nav-item" href="ContactUs.aspx"><span class="icon">📞</span> Contact Us</a>
        </nav>
        <div class="sidebar-bottom">
            <div class="user-card">
                <div class="avatar"><asp:Label ID="lblAvatarInitial" runat="server" Text="U" /></div>
                <div class="user-info">
                    <div class="user-name"><asp:Label ID="lblUserName" runat="server" Text="User" /></div>
                    <div class="user-role"><asp:Label ID="lblUserRole" runat="server" Text="Member" /></div>
                </div>
            </div>
        </div>
    </aside>

    <!-- ══ MAIN ══ -->
    <main class="main">

        <!-- TOPBAR -->
        <header class="topbar">
            <a class="topbar-back" href="Home.aspx">← Back</a>
            <div class="topbar-title">🎟️ Book Tickets</div>
            <div class="topbar-right">
                <div class="icon-btn">🔔</div>
                <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet)">
                    <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
                </div>
            </div>
        </header>

        <!-- CONTENT -->
        <div class="content">

            <!-- Alert message -->
            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <!-- STEP INDICATOR -->
            <div class="steps-bar">
                <div class="step" id="step1div" runat="server">
                    <div class="step-circle">1</div>
                    <div class="step-label">Select Show</div>
                </div>
                <div class="step-line" id="line1" runat="server"></div>
                <div class="step" id="step2div" runat="server">
                    <div class="step-circle">2</div>
                    <div class="step-label">Pick Seats</div>
                </div>
                <div class="step-line" id="line2" runat="server"></div>
                <div class="step" id="step3div" runat="server">
                    <div class="step-circle">3</div>
                    <div class="step-label">Confirm</div>
                </div>
            </div>

            <!-- TWO COLUMN LAYOUT -->
            <div class="booking-grid">

                <!-- LEFT: main flow panels -->
                <div>

                    <!-- ── PANEL 1: EVENT INFO ── -->
                    <div class="panel">
                        <div class="panel-head">
                            <div class="panel-icon">🎪</div>
                            <div class="panel-title">Event Details</div>
                        </div>
                        <div class="panel-body">
                            <div class="event-hero">
                                <div class="event-poster">
                                    <asp:Label ID="lblEventEmoji" runat="server" Text="🎬" />
                                </div>
                                <div>
                                    <div class="event-title"><asp:Label ID="lblEventTitle" runat="server" Text="Loading..." /></div>
                                    <div class="event-tags">
                                        <span class="tag"><asp:Label ID="lblEventType" runat="server" Text="" /></span>
                                        <span class="tag"><asp:Label ID="lblLanguage" runat="server" Text="" /></span>
                                        <span class="tag"><asp:Label ID="lblRating" runat="server" Text="" /></span>
                                        <span class="tag">⏱ <asp:Label ID="lblDuration" runat="server" Text="" /> mins</span>
                                    </div>
                                    <div class="event-desc"><asp:Label ID="lblDescription" runat="server" Text="" /></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── PANEL 2: SELECT SHOW ── -->
                    <asp:Panel ID="pnlSelectShow" runat="server">
                        <div class="panel">
                            <div class="panel-head">
                                <div class="panel-icon">📅</div>
                                <div class="panel-title">Choose a Show</div>
                            </div>
                            <div class="panel-body">
                                <div class="show-grid">
                                    <asp:Repeater ID="rptShows" runat="server" OnItemCommand="rptShows_ItemCommand">
                                        <ItemTemplate>
                                            <div class='show-card <%# hfSelectedShowId.Value == Eval("ShowId").ToString() ? "selected" : "" %>'>
                                                <div class="show-date-box">
                                                    <div class="show-day"><%# Eval("ShowDate", "{0:dd}") %></div>
                                                    <div class="show-mon"><%# Eval("ShowDate", "{0:MMM}") %></div>
                                                </div>
                                                <div class="show-info">
                                                    <div class="show-time">🕐 <%# Eval("StartTime") %></div>
                                                    <div class="show-venue">📍 <%# Eval("VenueName") %> &nbsp;·&nbsp; <%# Eval("HallName") %></div>
                                                    <div style="margin-top:6px">
                                                        <span class="show-hall-type"><%# Eval("HallType") %></span>
                                                        &nbsp;
                                                        <span style="font-size:11px;color:var(--muted)"><%# Eval("AvailableSeats") %> seats left</span>
                                                    </div>
                                                </div>
                                                <div style="display:flex;flex-direction:column;align-items:flex-end;gap:8px;flex-shrink:0">
                                                    <div class="show-price">from ₹<%# Eval("MinPrice") %></div>
                                                    <asp:LinkButton ID="lbSelectShow" runat="server"
                                                        CommandName="SelectShow"
                                                        CommandArgument='<%# Eval("ShowId") %>'
                                                        CssClass="attend-btn"
                                                        style="background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:20px;padding:7px 16px;font-size:12px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;">
                                                        Select →
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                                <asp:Panel ID="pnlNoShows" runat="server" Visible="false">
                                    <div class="empty-msg"><div class="em">📭</div>No upcoming shows available for this event.</div>
                                </asp:Panel>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- ── PANEL 3: SEAT MAP ── -->
                    <asp:Panel ID="pnlSeatMap" runat="server" Visible="false">
                        <div class="panel">
                            <div class="panel-head">
                                <div class="panel-icon">🪑</div>
                                <div class="panel-title">Select Your Seats</div>
                                <div style="margin-left:auto;font-size:12px;color:var(--muted)">Click seats to select / deselect</div>
                            </div>
                            <div class="panel-body">

                                <!-- SCREEN -->
                                <div class="screen-bar">
                                    <div class="screen-line">▼ SCREEN / STAGE ▼</div>
                                </div>

                                <!-- LEGEND -->
                                <div class="seat-legend">
                                    <div class="legend-item"><div class="legend-dot leg-available"></div> Available</div>
                                    <div class="legend-item"><div class="legend-dot leg-selected"></div> Selected</div>
                                    <div class="legend-item"><div class="legend-dot leg-booked"></div> Booked</div>
                                    <div class="legend-item"><div class="legend-dot leg-silver"></div> Silver</div>
                                    <div class="legend-item"><div class="legend-dot leg-gold"></div> Gold</div>
                                    <div class="legend-item"><div class="legend-dot leg-platinum"></div> Platinum</div>
                                </div>

                                <!-- Seat map rendered by code-behind as HTML -->
                                <asp:Literal ID="litSeatMap" runat="server" />

                                <!-- Hidden input: stores comma-separated selected seat IDs (JS updates this) -->
                                <input type="hidden" id="hdnSeats" name="hdnSeats" value="" />

                                <div style="margin-top:18px;display:flex;justify-content:flex-end">
                                    <asp:Button ID="btnConfirmSeats" runat="server" Text="Confirm Seats →"
                                        OnClick="btnConfirmSeats_Click"
                                        style="padding:12px 28px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- ── PANEL 4: COUPON ── -->
                    <asp:Panel ID="pnlCoupon" runat="server" Visible="false">
                        <div class="panel">
                            <div class="panel-head">
                                <div class="panel-icon">🏷️</div>
                                <div class="panel-title">Apply Coupon</div>
                            </div>
                            <div class="panel-body">
                                <div class="coupon-row">
                                    <asp:TextBox ID="txtCoupon" runat="server" CssClass="coupon-input" placeholder="Enter coupon code e.g. WELCOME20" />
                                    <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" CssClass="coupon-btn" OnClick="btnApplyCoupon_Click" />
                                </div>
                                <asp:Label ID="lblCouponMsg" runat="server" Visible="false" CssClass="coupon-msg" />
                            </div>
                        </div>
                    </asp:Panel>

                </div><!-- /left -->

                <!-- RIGHT: order summary -->
                <div class="summary-sticky">
                    <div class="summary-panel">
                        <div class="summary-head">
                            <h3>🧾 Order Summary</h3>
                            <p>Review before confirming</p>
                        </div>
                        <div class="summary-body">
                            <div class="summary-row-item">
                                <span class="label">Event</span>
                                <span class="value"><asp:Label ID="lblSumEvent" runat="server" Text="—" /></span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label">Show</span>
                                <span class="value"><asp:Label ID="lblSumShow" runat="server" Text="—" /></span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label">Venue</span>
                                <span class="value"><asp:Label ID="lblSumVenue" runat="server" Text="—" /></span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label">Seats</span>
                                <span class="value">
                                    <asp:Label ID="lblSumSeats" runat="server" Text="None selected" />
                                </span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label">Subtotal</span>
                                <span class="value">₹<asp:Label ID="lblSumSubtotal" runat="server" Text="0" /></span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label">Convenience Fee</span>
                                <span class="value">₹<asp:Label ID="lblSumFee" runat="server" Text="0" /></span>
                            </div>
                            <div class="summary-row-item">
                                <span class="label" style="color:var(--green)">Discount</span>
                                <span class="value" style="color:var(--green)">- ₹<asp:Label ID="lblSumDiscount" runat="server" Text="0" /></span>
                            </div>
                        </div>
                        <div class="summary-total">
                            <span class="label">Total</span>
                            <span class="value">₹<asp:Label ID="lblSumTotal" runat="server" Text="0" /></span>
                        </div>
                        
                    </div>
                </div><!-- /right -->

            </div><!-- /booking-grid -->
        </div><!-- /content -->
    </main>

</div><!-- /layout -->
</form>

<script>
    // ── Track selected seats in JS ────────────────────────────────────────
    var selectedSeats = [];   // [{seatId, label, price, category}]

    function toggleSeat(el, seatId, label, price, category) {
        if (el.classList.contains('booked')) return;

        var idx = selectedSeats.findIndex(function (s) { return s.seatId == seatId; });

        if (idx >= 0) {
            // Deselect
            selectedSeats.splice(idx, 1);
            el.classList.remove('selected');
        } else {
            // Select (max 10)
            if (selectedSeats.length >= 10) {
                alert('You can select a maximum of 10 seats at once.');
                return;
            }
            selectedSeats.push({ seatId: seatId, label: label, price: parseFloat(price), category: category });
            el.classList.add('selected');
        }

        updateSummary();
        updateHiddenField();
    }

    function updateHiddenField() {
        var ids = selectedSeats.map(function (s) { return s.seatId; }).join(',');
        document.getElementById('hdnSeats').value = ids;
    }

    function updateSummary() {
        // Seat pills
        var pillsEl = document.getElementById('sumSeatsList');
        if (pillsEl) {
            if (selectedSeats.length === 0) {
                pillsEl.innerHTML = '<span style="color:var(--muted);font-size:13px">None selected</span>';
            } else {
                pillsEl.innerHTML = selectedSeats.map(function (s) {
                    return '<span class="seat-pill">' + s.label + '</span>';
                }).join('');
            }
        }

        // Prices
        var subtotal = selectedSeats.reduce(function (a, s) { return a + s.price; }, 0);
        var fee = selectedSeats.length > 0 ? Math.round(subtotal * 0.02) : 0;  // 2% convenience fee
        var discount = parseFloat(document.getElementById('hdnDiscount') ? document.getElementById('hdnDiscount').value : 0) || 0;
        var total = Math.max(0, subtotal + fee - discount);

        setLabel('lblSumSubtotal', subtotal.toFixed(0));
        setLabel('lblSumFee', fee.toFixed(0));
        setLabel('lblSumDiscount', discount.toFixed(0));
        setLabel('lblSumTotal', total.toFixed(0));
        setLabel('lblSumSeats', selectedSeats.length > 0 ? selectedSeats.length + ' seat(s)' : 'None selected');
    }

    function setLabel(id, val) {
        var spans = document.querySelectorAll('[id$="' + id + '"]');
        spans.forEach(function (el) { el.innerText = val; });
    }

    function validateBooking() {
        if (document.getElementById('hdnSeats').value === '') {
            alert('Please select at least one seat before confirming!');
            return false;
        }
        return true;
    }

    // On page load — read discount from server-set hidden field
    window.onload = function () {
        updateSummary();
    };
</script>
</body>
</html>
