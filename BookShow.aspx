<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookShow.aspx.cs" Inherits="EventGlint.BookShow" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Book Show</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root { --violet:#7C3AED; --violet-mid:#9D5CF8; --violet-soft:#EDE9FE; --violet-glow:rgba(124,58,237,.14); --bg:#F7F5FF; --surface:#FFFFFF; --surface2:#F1EEF9; --border-soft:rgba(0,0,0,.06); --text:#1A1033; --text-mid:#3D2F6B; --muted:#8B7BB0; --gold:#E88C1A; --green:#16A34A; --red:#DC2626; --shadow-sm:0 1px 4px rgba(124,58,237,.07); --shadow-md:0 4px 20px rgba(124,58,237,.10); --shadow-lg:0 12px 40px rgba(124,58,237,.16); --radius:18px; --sidebar:264px; }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--text);}
        a{text-decoration:none;} #form1{display:contents;} .layout{display:flex;min-height:100vh;}
        .sidebar{width:var(--sidebar);min-height:100vh;background:var(--surface);border-right:1px solid var(--border-soft);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;padding:30px 0;box-shadow:2px 0 20px rgba(124,58,237,.06);}
        .sidebar::before{content:'';position:absolute;top:0;left:0;right:0;height:4px;background:linear-gradient(90deg,var(--violet),var(--violet-mid),#C084FC);}
        .sidebar-logo{display:flex;align-items:center;gap:13px;padding:0 24px 30px;border-bottom:1px solid var(--border-soft);}
        .logo-icon{width:44px;height:44px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));border-radius:14px;display:grid;place-items:center;font-size:20px;flex-shrink:0;}
        .logo-text{font-family:'Playfair Display',serif;font-weight:800;font-size:17px;color:var(--text);}
        .logo-text span{font-family:'Plus Jakarta Sans',sans-serif;color:var(--muted);font-size:11px;font-weight:400;display:block;margin-top:2px;}
        .nav{padding:26px 14px;flex:1;display:flex;flex-direction:column;gap:3px;}
        .nav-item{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-size:14px;font-weight:500;color:var(--muted);text-decoration:none;transition:all .2s;}
        .nav-item:hover{background:var(--violet-soft);color:var(--violet);}
        .nav-item.active{background:linear-gradient(135deg,var(--violet-soft),#DDD6FE);color:var(--violet);font-weight:600;}
        .nav-item .icon{font-size:17px;width:22px;text-align:center;}
        .sidebar-bottom{padding:20px;border-top:1px solid var(--border-soft);}
        .user-card{display:flex;align-items:center;gap:12px;padding:12px 14px;border-radius:14px;background:var(--surface2);border:1px solid var(--border-soft);}
        .avatar{width:38px;height:38px;background:linear-gradient(135deg,var(--violet),#C084FC);border-radius:50%;display:grid;place-items:center;font-weight:700;font-size:15px;color:#fff;flex-shrink:0;}
        .user-info .user-name{font-size:13px;font-weight:600;color:var(--text);}
        .user-info .user-role{font-size:11px;color:var(--muted);margin-top:1px;}
        .main{margin-left:var(--sidebar);flex:1;display:flex;flex-direction:column;}
        .topbar{height:70px;background:rgba(247,245,255,.95);backdrop-filter:blur(24px);border-bottom:1px solid var(--border-soft);display:flex;align-items:center;padding:0 32px;gap:16px;position:sticky;top:0;z-index:90;}
        .topbar-back{display:flex;align-items:center;gap:8px;font-size:14px;font-weight:600;color:var(--muted);padding:8px 14px;border-radius:20px;background:var(--surface);border:1px solid var(--border-soft);transition:all .2s;text-decoration:none;}
        .topbar-back:hover{color:var(--violet);border-color:var(--violet);background:var(--violet-soft);}
        .topbar-title{font-family:'Playfair Display',serif;font-size:18px;font-weight:800;color:var(--text);}
        .topbar-right{margin-left:auto;display:flex;align-items:center;gap:10px;}
        .content{padding:28px 32px 50px;flex:1;}
        .booking-grid{display:grid;grid-template-columns:1fr 320px;gap:22px;align-items:start;}
        .panel{background:var(--surface);border:1px solid var(--border-soft);border-radius:var(--radius);box-shadow:var(--shadow-sm);overflow:hidden;margin-bottom:18px;}
        .panel-head{padding:16px 20px;border-bottom:1px solid var(--border-soft);display:flex;align-items:center;gap:12px;}
        .panel-icon{width:36px;height:36px;border-radius:10px;background:var(--violet-soft);display:grid;place-items:center;font-size:17px;flex-shrink:0;}
        .panel-title{font-family:'Playfair Display',serif;font-size:15px;font-weight:800;color:var(--text);}
        .panel-body{padding:20px;}
        /* show info */
        .show-hero{display:flex;gap:18px;}
        .show-poster{width:80px;height:110px;border-radius:12px;background:linear-gradient(135deg,#5B21B6,#7C3AED);display:grid;place-items:center;font-size:32px;flex-shrink:0;}
        .show-title{font-family:'Playfair Display',serif;font-size:20px;font-weight:900;color:var(--text);margin-bottom:6px;}
        .show-tags{display:flex;gap:7px;flex-wrap:wrap;margin-bottom:8px;}
        .tag{font-size:11px;font-weight:600;padding:3px 10px;border-radius:12px;background:var(--violet-soft);color:var(--violet);}
        .show-meta{font-size:13px;color:var(--muted);}
        /* seat grid */
        .screen-bar{background:linear-gradient(90deg,transparent,#C4B5FD,transparent);height:6px;border-radius:4px;margin-bottom:6px;}
        .screen-label{text-align:center;font-size:11px;color:var(--muted);font-weight:600;letter-spacing:.1em;margin-bottom:20px;}
        .seat-legend{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:16px;}
        .leg-item{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--muted);font-weight:500;}
        .leg-box{width:16px;height:16px;border-radius:4px;}
        .leg-available{background:var(--violet-soft);border:1.5px solid var(--violet);}
        .leg-selected{background:var(--violet);}
        .leg-booked{background:#E5E7EB;border:1.5px solid #D1D5DB;}
        .seat-category{margin-bottom:18px;}
        .cat-label{font-size:12px;font-weight:700;color:var(--text-mid);text-transform:uppercase;letter-spacing:.07em;margin-bottom:8px;}
        .seat-row{display:flex;align-items:center;gap:6px;margin-bottom:6px;flex-wrap:wrap;}
        .row-label{font-size:11px;font-weight:700;color:var(--muted);width:20px;text-align:right;flex-shrink:0;}
        .seat{width:32px;height:32px;border-radius:6px;border:1.5px solid rgba(124,58,237,.3);background:var(--violet-soft);cursor:pointer;display:grid;place-items:center;font-size:10px;font-weight:700;color:var(--violet);transition:all .15s;flex-shrink:0;}
        .seat:hover{background:var(--violet);color:#fff;}
        .seat.selected{background:var(--violet);color:#fff;border-color:var(--violet);box-shadow:0 2px 8px rgba(124,58,237,.4);}
        .seat.booked{background:#E5E7EB;border-color:#D1D5DB;color:#9CA3AF;cursor:not-allowed;}
        .seat.booked:hover{background:#E5E7EB;color:#9CA3AF;}
        /* coupon */
        .coupon-row{display:flex;gap:10px;}
        .coupon-input{flex:1;padding:10px 14px;border:1.5px solid var(--border-soft);border-radius:12px;font-size:14px;font-family:'Plus Jakarta Sans',sans-serif;color:var(--text);outline:none;transition:border .2s;}
        .coupon-input:focus{border-color:var(--violet);}
        .coupon-btn{padding:10px 20px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:12px;font-weight:700;font-size:13px;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;}
        .coupon-msg{font-size:13px;margin-top:8px;font-weight:600;display:block;}
        .coupon-ok{color:var(--green);} .coupon-err{color:var(--red);}
        /* summary */
        .order-panel{background:var(--surface);border:1px solid var(--border-soft);border-radius:var(--radius);box-shadow:var(--shadow-md);overflow:hidden;position:sticky;top:88px;}
        .order-head{padding:18px 20px;background:linear-gradient(135deg,#5B21B6,#7C3AED,#A855F7);}
        .order-head h3{font-family:'Playfair Display',serif;font-size:17px;font-weight:900;color:#fff;}
        .order-head p{font-size:12px;color:rgba(255,255,255,.7);margin-top:3px;}
        .order-body{padding:16px 18px;}
        .sum-row{display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid var(--border-soft);font-size:13px;gap:12px;}
        .sum-row:last-child{border-bottom:none;}
        .sum-row .lbl{color:var(--muted);font-weight:500;}
        .sum-row .val{color:var(--text);font-weight:600;text-align:right;}
        .order-total{display:flex;justify-content:space-between;align-items:center;padding:14px 18px;background:var(--violet-soft);border-top:2px solid rgba(124,58,237,.15);}
        .order-total .lbl{font-size:14px;font-weight:700;}
        .order-total .val{font-family:'Playfair Display',serif;font-size:24px;font-weight:900;color:var(--violet);}
        .proceed-btn{width:100%;padding:15px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:14px;font-size:15px;font-weight:800;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;margin-top:16px;transition:all .2s;box-shadow:0 6px 20px rgba(124,58,237,.3);}
        .proceed-btn:hover{transform:translateY(-2px);}
        .proceed-btn:disabled{opacity:.5;cursor:not-allowed;transform:none;}
        .msg-box{padding:12px 16px;border-radius:12px;font-size:13px;font-weight:600;margin-bottom:16px;}
        .msg-error{background:#FEE2E2;color:var(--red);border:1px solid #FECACA;}
        @keyframes fadeUp{from{opacity:0;transform:translateY(12px);}to{opacity:1;transform:translateY(0);}}
        .panel,.order-panel{animation:fadeUp .4s ease both;}
        @media(max-width:900px){.booking-grid{grid-template-columns:1fr;}.order-panel{position:static;}}
        @media(max-width:768px){.sidebar{display:none;}.main{margin-left:0;}.content{padding:20px 16px;}}
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:HiddenField ID="hfShowId"    runat="server" Value="0" />
    <asp:HiddenField ID="hfCouponId"  runat="server" Value="0" />
    <asp:HiddenField ID="hfDiscount"  runat="server" Value="0" />
    <asp:HiddenField ID="hfSelected"  runat="server" Value="" />
<div class="layout">
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-icon">🎯</div>
            <div class="logo-text">EventNearMe<span>Discover Local Events</span></div>
        </div>
        <nav class="nav">
            <a class="nav-item" href="Home.aspx"><span class="icon">🏠</span> Home</a>
            <a class="nav-item" href="Event.aspx"><span class="icon">🎪</span> Event</a>
            <a class="nav-item active" href="Shows.aspx"><span class="icon">🎭</span> Shows</a>
            <a class="nav-item" href="Hall.aspx"><span class="icon">🏛️</span> Hall</a>
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
    <main class="main">
        <header class="topbar">
            <a class="topbar-back" href="Shows.aspx">← Back to Shows</a>
            <div class="topbar-title">🎭 Book Show</div>
            <div class="topbar-right">
                <div class="avatar" style="width:42px;height:42px;border:2.5px solid var(--violet)">
                    <asp:Label ID="lblTopAvatar" runat="server" Text="U" />
                </div>
            </div>
        </header>
        <div class="content">
            <asp:Label ID="lblMessage" runat="server" Visible="false" />
            <div class="booking-grid">
                <!-- LEFT -->
                <div>
                    <!-- SHOW INFO -->
                    <div class="panel">
                        <div class="panel-head"><div class="panel-icon">🎬</div><div class="panel-title">Show Details</div></div>
                        <div class="panel-body">
                            <div class="show-hero">
                                <div class="show-poster">🎬</div>
                                <div style="flex:1">
                                    <div class="show-title"><asp:Label ID="lblEventTitle" runat="server" Text="Loading..." /></div>
                                    <div class="show-tags">
                                        <span class="tag">🎬 <asp:Label ID="lblEventType" runat="server" Text="" /></span>
                                        <span class="tag">🗣️ <asp:Label ID="lblLanguage" runat="server" Text="" /></span>
                                        <span class="tag">⏱️ <asp:Label ID="lblDuration" runat="server" Text="" /></span>
                                    </div>
                                    <div class="show-meta">
                                        📅 <asp:Label ID="lblShowDate" runat="server" Text="" /> &nbsp;|&nbsp;
                                        ⏰ <asp:Label ID="lblShowTime" runat="server" Text="" /> &nbsp;|&nbsp;
                                        🏛️ <asp:Label ID="lblHallName" runat="server" Text="" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- SEAT SELECTION -->
                    <div class="panel">
                        <div class="panel-head"><div class="panel-icon">🪑</div><div class="panel-title">Select Seats</div></div>
                        <div class="panel-body">
                            <div class="screen-bar"></div>
                            <div class="screen-label">SCREEN THIS SIDE</div>
                            <div class="seat-legend">
                                <div class="leg-item"><div class="leg-box leg-available"></div> Available</div>
                                <div class="leg-item"><div class="leg-box leg-selected"></div> Selected</div>
                                <div class="leg-item"><div class="leg-box leg-booked"></div> Booked</div>
                            </div>
                            <asp:PlaceHolder ID="phSeats" runat="server" />
                        </div>
                    </div>
                    <!-- COUPON -->
                    <div class="panel">
                        <div class="panel-head"><div class="panel-icon">🏷️</div><div class="panel-title">Apply Coupon</div></div>
                        <div class="panel-body">
                            <div class="coupon-row">
                                <asp:TextBox ID="txtCoupon" runat="server" CssClass="coupon-input" placeholder="Enter coupon code e.g. SHOW20" />
                                <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" CssClass="coupon-btn" OnClick="btnApplyCoupon_Click" />
                            </div>
                            <asp:Label ID="lblCouponMsg" runat="server" Visible="false" CssClass="coupon-msg" />
                        </div>
                    </div>
                </div>
                <!-- RIGHT -->
                <div>
                    <div class="order-panel">
                        <div class="order-head"><h3>🧾 Booking Summary</h3><p>Review before proceeding</p></div>
                        <div class="order-body">
                            <div class="sum-row"><span class="lbl">Show</span><span class="val"><asp:Label ID="lblSumShow" runat="server" Text="—" /></span></div>
                            <div class="sum-row"><span class="lbl">Date & Time</span><span class="val"><asp:Label ID="lblSumDateTime" runat="server" Text="—" /></span></div>
                            <div class="sum-row"><span class="lbl">Seats</span><span class="val"><asp:Label ID="lblSumSeats" runat="server" Text="—" /></span></div>
                            <div class="sum-row"><span class="lbl">Subtotal</span><span class="val">₹<asp:Label ID="lblSumSubtotal" runat="server" Text="0" /></span></div>
                            <div class="sum-row"><span class="lbl">Convenience Fee (2%)</span><span class="val">₹<asp:Label ID="lblSumFee" runat="server" Text="0" /></span></div>
                            <div class="sum-row"><span class="lbl" style="color:var(--green)">Discount</span><span class="val" style="color:var(--green)">− ₹<asp:Label ID="lblSumDiscount" runat="server" Text="0" /></span></div>
                        </div>
                        <div class="order-total"><span class="lbl">Total</span><span class="val">₹<asp:Label ID="lblSumTotal" runat="server" Text="0" /></span></div>
                        <div style="padding:14px 18px;">
                            <asp:Button ID="btnProceed" runat="server" Text="🎟️ Proceed to Payment" CssClass="proceed-btn" OnClick="btnProceed_Click" style="opacity:0.5;"/>
                            <div style="text-align:center;margin-top:10px;font-size:11px;color:var(--muted);">🔒 Secure booking</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</form>
<script>
    function toggleSeat(el, seatId, price) {
        var hf = document.getElementById('<%= hfSelected.ClientID %>');
        var selected = hf.value ? hf.value.split(',').filter(Boolean) : [];
        var idx = selected.indexOf(seatId.toString());
        if (el.classList.contains('booked')) return;
        if (idx >= 0) {
            selected.splice(idx, 1);
            el.classList.remove('selected');
        } else {
            if (selected.length >= 10) { alert('Max 10 seats per booking.'); return; }
            selected.push(seatId.toString());
            el.classList.add('selected');
        }
        hf.value = selected.join(',');
        updateSummaryUI();
    }

    function updateSummaryUI() {
        var hf = document.getElementById('<%= hfSelected.ClientID %>');
        var btn = document.getElementById('<%= btnProceed.ClientID %>');
        var selected = hf.value ? hf.value.split(',').filter(Boolean) : [];
        if (selected.length > 0) {
            btn.disabled = false;
            btn.style.opacity = '1';
            btn.style.cursor = 'pointer';
        } else {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.cursor = 'not-allowed';
        }
    }
</script>
</body>
</html>