<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookHall.aspx.cs" Inherits="EventGlint.BookHall" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Book a Hall</title>
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

        /* ── STEPS ── */
        .steps-bar { display: flex; align-items: center; margin-bottom: 28px; }
        .step { display: flex; align-items: center; gap: 10px; }
        .step-circle { width: 34px; height: 34px; border-radius: 50%; display: grid; place-items: center; font-size: 13px; font-weight: 700; flex-shrink: 0; transition: all .3s; }
        .step.done    .step-circle { background: var(--green); color: #fff; }
        .step.active  .step-circle { background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; box-shadow: 0 4px 12px rgba(124,58,237,.3); }
        .step.pending .step-circle { background: var(--surface); border: 2px solid var(--border-soft); color: var(--muted); }
        .step-label { font-size: 13px; font-weight: 600; }
        .step.done    .step-label { color: var(--green); }
        .step.active  .step-label { color: var(--violet); }
        .step.pending .step-label { color: var(--muted); }
        .step-line { flex: 1; height: 2px; background: var(--border-soft); margin: 0 10px; min-width: 40px; }
        .step-line.done { background: var(--green); }

        /* ── GRID ── */
        .booking-grid { display: grid; grid-template-columns: 1fr 340px; gap: 22px; align-items: start; }

        /* ── PANEL ── */
        .panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-sm); overflow: hidden; margin-bottom: 18px; animation: fadeUp .4s ease both; }
        .panel-head { padding: 18px 22px; border-bottom: 1px solid var(--border-soft); display: flex; align-items: center; gap: 12px; }
        .panel-icon { width: 38px; height: 38px; border-radius: 11px; background: var(--violet-soft); display: grid; place-items: center; font-size: 18px; flex-shrink: 0; }
        .panel-title { font-family: 'Playfair Display', serif; font-size: 16px; font-weight: 800; color: var(--text); }
        .panel-body { padding: 20px 22px; }

        /* ── HALL HERO ── */
        .hall-hero { display: flex; gap: 18px; align-items: flex-start; }
        .hall-poster { width: 90px; height: 90px; border-radius: 14px; background: linear-gradient(135deg, #5B21B6, #7C3AED); display: grid; place-items: center; font-size: 38px; flex-shrink: 0; }
        .hall-title { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 900; color: var(--text); margin-bottom: 6px; }
        .hall-tags { display: flex; gap: 7px; flex-wrap: wrap; margin-bottom: 10px; }
        .tag { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 12px; background: var(--violet-soft); color: var(--violet); }
        .hall-desc { font-size: 13px; color: var(--muted); line-height: 1.6; }

        /* ── BOOKING FORM ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label { font-size: 12px; font-weight: 700; color: var(--text-mid); text-transform: uppercase; letter-spacing: .06em; }
        .form-control { padding: 11px 14px; border: 1.5px solid var(--border-soft); border-radius: 12px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); background: var(--surface); outline: none; transition: border .2s, box-shadow .2s; width: 100%; }
        .form-control:focus { border-color: var(--violet); box-shadow: 0 0 0 3px var(--violet-glow); }
        .form-control[readonly] { background: var(--surface2); color: var(--muted); cursor: not-allowed; }
        textarea.form-control { resize: vertical; min-height: 80px; }

        /* ── AVAILABILITY ── */
        .avail-banner { padding: 12px 16px; border-radius: 12px; font-size: 13px; font-weight: 600; margin-top: 14px; display: flex; align-items: center; gap: 8px; }
        .avail-ok  { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
        .avail-no  { background: #FEE2E2; color: var(--red); border: 1px solid #FECACA; }
        .avail-btn { padding: 10px 22px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 12px; font-weight: 700; font-size: 13px; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; margin-top: 14px; }

        /* ── COUPON ── */
        .coupon-row { display: flex; gap: 10px; }
        .coupon-input { flex: 1; padding: 10px 14px; border: 1.5px solid var(--border-soft); border-radius: 12px; font-size: 14px; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text); background: var(--surface); outline: none; transition: border .2s; }
        .coupon-input:focus { border-color: var(--violet); }
        .coupon-btn { padding: 10px 20px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 12px; font-weight: 700; font-size: 13px; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; white-space: nowrap; }
        .coupon-msg { font-size: 13px; margin-top: 8px; font-weight: 600; display: block; }
        .coupon-ok  { color: var(--green); }
        .coupon-err { color: var(--red); }

        /* ── ORDER SUMMARY ── */
        .summary-sticky { position: sticky; top: 88px; }
        .summary-panel { background: var(--surface); border: 1px solid var(--border-soft); border-radius: var(--radius); box-shadow: var(--shadow-md); overflow: hidden; }
        .summary-head { padding: 18px 20px; background: linear-gradient(135deg, #5B21B6, #7C3AED, #A855F7); }
        .summary-head h3 { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 900; color: #fff; }
        .summary-head p  { font-size: 12px; color: rgba(255,255,255,.7); margin-top: 3px; }
        .summary-body { padding: 18px 20px; }
        .sum-row { display: flex; justify-content: space-between; align-items: flex-start; padding: 9px 0; border-bottom: 1px solid var(--border-soft); font-size: 13px; gap: 12px; }
        .sum-row:last-child { border-bottom: none; }
        .sum-row .lbl { color: var(--muted); font-weight: 500; flex-shrink: 0; }
        .sum-row .val { color: var(--text); font-weight: 600; text-align: right; }
        .summary-total { display: flex; justify-content: space-between; align-items: center; padding: 14px 20px; background: var(--violet-soft); border-top: 2px solid rgba(124,58,237,.15); }
        .summary-total .lbl { font-size: 14px; font-weight: 700; color: var(--text); }
        .summary-total .val { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 900; color: var(--violet); }

        /* ── BOOK BTN ── */
        .book-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, var(--violet), var(--violet-mid)); color: #fff; border: none; border-radius: 14px; font-size: 15px; font-weight: 800; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; margin-top: 16px; transition: all .2s; box-shadow: 0 6px 20px rgba(124,58,237,.3); }
        .book-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(124,58,237,.4); }
        .book-btn:disabled { opacity: .5; cursor: not-allowed; transform: none; }

        /* ── MISC ── */
        .msg-box { padding: 12px 16px; border-radius: 12px; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .msg-success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
        .msg-error   { background: #FEE2E2; color: var(--red); border: 1px solid #FECACA; }

        /* ── PRICE BREAKDOWN ── */
        .price-breakdown { background: var(--surface2); border-radius: 14px; padding: 16px 18px; margin-top: 14px; }
        .pb-row { display: flex; justify-content: space-between; font-size: 13px; padding: 5px 0; }
        .pb-row .lbl { color: var(--muted); font-weight: 500; }
        .pb-row .val { color: var(--text); font-weight: 600; }
        .pb-total { border-top: 1px solid var(--border-soft); margin-top: 8px; padding-top: 10px; }
        .pb-total .lbl { font-weight: 700; color: var(--text); }
        .pb-total .val { font-family: 'Playfair Display', serif; font-size: 18px; font-weight: 900; color: var(--violet); }

        /* ── FACILITY CHIPS ── */
        .fac-chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; }
        .fac-chip  { font-size: 11px; font-weight: 600; color: var(--violet); background: var(--violet-soft); border: 1px solid rgba(124,58,237,.18); padding: 4px 12px; border-radius: 12px; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 900px) {
            .booking-grid { grid-template-columns: 1fr; }
            .summary-sticky { position: static; }
        }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main { margin-left: 0; }
            .content { padding: 20px 16px; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <asp:HiddenField ID="hfHallId"      runat="server" Value="0" />
    <asp:HiddenField ID="hfCouponId"    runat="server" Value="0" />
    <asp:HiddenField ID="hfDiscount"    runat="server" Value="0" />
    <asp:HiddenField ID="hfIsAvailable" runat="server" Value="0" />

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
            <a class="nav-item active" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
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

    <!-- ══════════ MAIN ══════════ -->
    <main class="main">

        <header class="topbar">
            <a class="topbar-back" href="Hall.aspx">← Back to Halls</a>
            <div class="topbar-title">🏛️ Book a Hall</div>
            <div class="topbar-right">
                <div class="icon-btn">🔔</div>
                <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet)">
                    <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
                </div>
            </div>
        </header>

        <div class="content">

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <!-- ── STEPS ── -->
            <div class="steps-bar">
                <div class="step" id="step1div" runat="server">
                    <div class="step-circle">1</div>
                    <div class="step-label">Hall Details</div>
                </div>
                <div class="step-line" id="line1" runat="server"></div>
                <div class="step" id="step2div" runat="server">
                    <div class="step-circle">2</div>
                    <div class="step-label">Pick Date</div>
                </div>
                <div class="step-line" id="line2" runat="server"></div>
                <div class="step" id="step3div" runat="server">
                    <div class="step-circle">3</div>
                    <div class="step-label">Confirm</div>
                </div>
            </div>

            <div class="booking-grid">

                <!-- ══ LEFT ══ -->
                <div>

                    <!-- HALL DETAILS -->
                    <div class="panel">
                        <div class="panel-head">
                            <div class="panel-icon">🏛️</div>
                            <div class="panel-title">Hall Details</div>
                        </div>
                        <div class="panel-body">
                            <div class="hall-hero">
                                <div class="hall-poster">🏛️</div>
                                <div style="flex:1">
                                    <div class="hall-title">
                                        <asp:Label ID="lblHallName" runat="server" Text="Loading..." />
                                    </div>
                                    <div class="hall-tags">
                                        <span class="tag">🏙️ <asp:Label ID="lblVenueName"  runat="server" Text="" /></span>
                                        <span class="tag">📐 <asp:Label ID="lblHallType"   runat="server" Text="" /></span>
                                        <span class="tag">👥 Capacity: <asp:Label ID="lblCapacity" runat="server" Text="" /></span>
                                    </div>
                                    <div class="hall-desc">
                                        <asp:Label ID="lblHallDesc" runat="server" Text="" />
                                    </div>
                                    <div class="fac-chips">
                                        <span class="fac-chip">❄️ Air Conditioning</span>
                                        <span class="fac-chip">🎤 Stage Area</span>
                                        <span class="fac-chip">💡 Lighting System</span>
                                        <span class="fac-chip">🍽️ Catering Support</span>
                                        <span class="fac-chip">🚗 Parking</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- BOOKING FORM -->
                    <div class="panel">
                        <div class="panel-head">
                            <div class="panel-icon">📅</div>
                            <div class="panel-title">Booking Details</div>
                        </div>
                        <div class="panel-body">
                            <div class="form-grid">

                                <div class="form-group">
                                    <label class="form-label">📅 Booking Date *</label>
                                    <asp:TextBox ID="txtBookingDate" runat="server" CssClass="form-control"
                                        TextMode="Date" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">⏱️ Number of Days *</label>
                                    <asp:DropDownList ID="ddlDays" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="1 Day"  Value="1" Selected="True" />
                                        <asp:ListItem Text="2 Days" Value="2" />
                                        <asp:ListItem Text="3 Days" Value="3" />
                                        <asp:ListItem Text="4 Days" Value="4" />
                                        <asp:ListItem Text="5 Days" Value="5" />
                                        <asp:ListItem Text="6 Days" Value="6" />
                                        <asp:ListItem Text="7 Days" Value="7" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">⏰ Start Time *</label>
                                    <asp:DropDownList ID="ddlStartTime" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="08:00 AM" Value="08:00" />
                                        <asp:ListItem Text="09:00 AM" Value="09:00" />
                                        <asp:ListItem Text="10:00 AM" Value="10:00" />
                                        <asp:ListItem Text="11:00 AM" Value="11:00" />
                                        <asp:ListItem Text="12:00 PM" Value="12:00" />
                                        <asp:ListItem Text="01:00 PM" Value="13:00" />
                                        <asp:ListItem Text="02:00 PM" Value="14:00" />
                                        <asp:ListItem Text="03:00 PM" Value="15:00" />
                                        <asp:ListItem Text="04:00 PM" Value="16:00" />
                                        <asp:ListItem Text="05:00 PM" Value="17:00" />
                                        <asp:ListItem Text="06:00 PM" Value="18:00" />
                                        <asp:ListItem Text="07:00 PM" Value="19:00" />
                                        <asp:ListItem Text="08:00 PM" Value="20:00" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">🎉 Event Purpose *</label>
                                    <asp:DropDownList ID="ddlPurpose" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="-- Select Purpose --" Value="" />
                                        <asp:ListItem Text="💍 Wedding"               Value="Wedding" />
                                        <asp:ListItem Text="🎂 Birthday Party"        Value="Birthday" />
                                        <asp:ListItem Text="💼 Corporate Event"       Value="Corporate" />
                                        <asp:ListItem Text="🎓 Seminar / Conference"  Value="Conference" />
                                        <asp:ListItem Text="🎭 Cultural Programme"    Value="Cultural" />
                                        <asp:ListItem Text="🍽️ Banquet / Reception"  Value="Banquet" />
                                        <asp:ListItem Text="🎊 Other Celebration"     Value="Other" />
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">👥 Expected Guests *</label>
                                    <asp:TextBox ID="txtGuests" runat="server" CssClass="form-control"
                                        placeholder="e.g. 150" TextMode="Number" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">📍 Venue Address (Read-only)</label>
                                    <asp:TextBox ID="txtVenueAddress" runat="server" CssClass="form-control"
                                        ReadOnly="true" />
                                </div>

                                <div class="form-group full">
                                    <label class="form-label">📝 Special Requirements</label>
                                    <asp:TextBox ID="txtRequirements" runat="server" CssClass="form-control"
                                        TextMode="MultiLine" placeholder="e.g. stage setup, floral décor, AV equipment, catering notes…" />
                                </div>

                            </div><!-- /form-grid -->

                            <!-- Check Availability -->
                            <asp:Button ID="btnCheckAvailability" runat="server"
                                Text="🔍 Check Availability"
                                CssClass="avail-btn"
                                OnClick="btnCheckAvailability_Click" />

                            <asp:Panel ID="pnlAvailability" runat="server" Visible="false">
                                <asp:Label ID="lblAvailability" runat="server" />
                            </asp:Panel>

                            <!-- Price breakdown (shown after availability confirmed) -->
                            <asp:Panel ID="pnlPriceBreakdown" runat="server" Visible="false">
                                <div class="price-breakdown">
                                    <div class="pb-row">
                                        <span class="lbl">Hall Rent (per day)</span>
                                        <span class="val">₹<asp:Label ID="lblPricePerDay" runat="server" Text="0" /></span>
                                    </div>
                                    <div class="pb-row">
                                        <span class="lbl">× <asp:Label ID="lblDaysCalc" runat="server" Text="1" /> day(s)</span>
                                        <span class="val">₹<asp:Label ID="lblSubtotalCalc" runat="server" Text="0" /></span>
                                    </div>
                                    <div class="pb-row">
                                        <span class="lbl">Convenience Fee (2%)</span>
                                        <span class="val">₹<asp:Label ID="lblFeeCalc" runat="server" Text="0" /></span>
                                    </div>
                                    <div class="pb-row pb-total">
                                        <span class="lbl">Total (before coupon)</span>
                                        <span class="val">₹<asp:Label ID="lblTotalCalc" runat="server" Text="0" /></span>
                                    </div>
                                </div>
                            </asp:Panel>

                        </div>
                    </div>

                    <!-- COUPON (shown only when hall is available) -->
                    <asp:Panel ID="pnlCoupon" runat="server" Visible="false">
                        <div class="panel">
                            <div class="panel-head">
                                <div class="panel-icon">🏷️</div>
                                <div class="panel-title">Apply Coupon</div>
                            </div>
                            <div class="panel-body">
                                <div class="coupon-row">
                                    <asp:TextBox ID="txtCoupon" runat="server" CssClass="coupon-input"
                                        placeholder="Enter coupon code e.g. HALL20" />
                                    <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply"
                                        CssClass="coupon-btn" OnClick="btnApplyCoupon_Click" />
                                </div>
                                <asp:Label ID="lblCouponMsg" runat="server" Visible="false" CssClass="coupon-msg" />
                            </div>
                        </div>
                    </asp:Panel>

                </div><!-- /left -->

                <!-- ══ RIGHT: ORDER SUMMARY ══ -->
                <div class="summary-sticky">
                    <div class="summary-panel">
                        <div class="summary-head">
                            <h3>🧾 Booking Summary</h3>
                            <p>Review before confirming</p>
                        </div>

                        <div class="summary-body">
                            <div class="sum-row">
                                <span class="lbl">Hall</span>
                                <span class="val"><asp:Label ID="lblSumHall"    runat="server" Text="—" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Venue</span>
                                <span class="val"><asp:Label ID="lblSumVenue"   runat="server" Text="—" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Date</span>
                                <span class="val"><asp:Label ID="lblSumDate"    runat="server" Text="—" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Duration</span>
                                <span class="val"><asp:Label ID="lblSumDays"    runat="server" Text="—" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Purpose</span>
                                <span class="val"><asp:Label ID="lblSumPurpose" runat="server" Text="—" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Subtotal</span>
                                <span class="val">₹<asp:Label ID="lblSumSubtotal" runat="server" Text="0" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl">Convenience Fee (2%)</span>
                                <span class="val">₹<asp:Label ID="lblSumFee"      runat="server" Text="0" /></span>
                            </div>
                            <div class="sum-row">
                                <span class="lbl" style="color:var(--green)">Discount</span>
                                <span class="val" style="color:var(--green)">− ₹<asp:Label ID="lblSumDiscount" runat="server" Text="0" /></span>
                            </div>
                        </div>

                        <div class="summary-total">
                            <span class="lbl">Total</span>
                            <span class="val">₹<asp:Label ID="lblSumTotal" runat="server" Text="0" /></span>
                        </div>

                        <div style="padding:16px 20px;">
                            <asp:Button ID="btnBookNow" runat="server"
                                Text="🏛️ Confirm Hall Booking"
                                CssClass="book-btn"
                                Enabled="false"
                                OnClick="btnBookNow_Click" />
                            <div style="text-align:center;margin-top:10px;font-size:11px;color:var(--muted);">
                                🔒 Secure booking Confirmation sent via email
                            </div>
                        </div>
                    </div>
                </div><!-- /right -->

            </div><!-- /booking-grid -->
        </div><!-- /content -->
    </main>
</div><!-- /layout -->
</form>
</body>
</html>
