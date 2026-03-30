<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowBookingConfirm.aspx.cs" Inherits="EventGlint.ShowBookingConfirm" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Booking Confirmed</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root{--violet:#7C3AED;--violet-mid:#9D5CF8;--violet-soft:#EDE9FE;--bg:#F7F5FF;--surface:#FFFFFF;--surface2:#F1EEF9;--border-soft:rgba(0,0,0,.06);--text:#1A1033;--muted:#8B7BB0;--gold:#E88C1A;--green:#16A34A;--shadow-md:0 4px 20px rgba(124,58,237,.10);--radius:18px;--sidebar:264px;}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--text);}
        a{text-decoration:none;} #form1{display:contents;} .layout{display:flex;min-height:100vh;}
        .sidebar{width:var(--sidebar);min-height:100vh;background:var(--surface);border-right:1px solid var(--border-soft);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;padding:30px 0;}
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
        .main{margin-left:var(--sidebar);flex:1;display:flex;flex-direction:column;}
        .topbar{height:70px;background:rgba(247,245,255,.95);border-bottom:1px solid var(--border-soft);display:flex;align-items:center;padding:0 32px;}
        .topbar-title{font-family:'Playfair Display',serif;font-size:18px;font-weight:800;color:var(--text);}
        .content{padding:40px 32px;flex:1;}
        .confirm-card{max-width:640px;margin:0 auto;}
        .success-banner{background:linear-gradient(135deg,#5B21B6,#7C3AED,#A855F7);border-radius:26px;padding:44px;text-align:center;margin-bottom:24px;box-shadow:0 12px 40px rgba(124,58,237,.2);position:relative;overflow:hidden;}
        .success-banner::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 70% 20%,rgba(255,255,255,.12) 0%,transparent 60%);}
        .checkmark{font-size:64px;margin-bottom:16px;position:relative;z-index:1;}
        .success-title{font-family:'Playfair Display',serif;font-size:28px;font-weight:900;color:#fff;margin-bottom:8px;position:relative;z-index:1;}
        .success-sub{font-size:14px;color:rgba(255,255,255,.8);position:relative;z-index:1;}
        .booking-ref-box{display:inline-block;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.3);padding:10px 24px;border-radius:20px;margin-top:16px;font-size:16px;font-weight:700;color:#fff;letter-spacing:.08em;position:relative;z-index:1;}
        .details-panel{background:var(--surface);border:1px solid var(--border-soft);border-radius:var(--radius);box-shadow:var(--shadow-md);overflow:hidden;margin-bottom:20px;}
        .details-head{padding:16px 22px;border-bottom:1px solid var(--border-soft);font-family:'Playfair Display',serif;font-size:16px;font-weight:800;color:var(--text);}
        .details-body{padding:20px 22px;}
        .detail-row{display:flex;justify-content:space-between;padding:9px 0;border-bottom:1px solid var(--border-soft);font-size:14px;gap:16px;}
        .detail-row:last-child{border-bottom:none;}
        .detail-row .lbl{color:var(--muted);font-weight:500;flex-shrink:0;}
        .detail-row .val{color:var(--text);font-weight:700;text-align:right;}
        .total-row{background:var(--violet-soft);border-radius:10px;padding:14px 16px;display:flex;justify-content:space-between;align-items:center;margin-top:12px;}
        .total-row .lbl{font-size:14px;font-weight:700;color:var(--text);}
        .total-row .val{font-family:'Playfair Display',serif;font-size:22px;font-weight:900;color:var(--violet);}
        .action-btns{display:flex;gap:12px;}
        .btn-primary{flex:1;padding:14px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;text-align:center;text-decoration:none;display:block;}
        .btn-outline{flex:1;padding:14px;background:var(--surface);color:var(--violet);border:2px solid var(--violet);border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;text-align:center;text-decoration:none;display:block;}
        @keyframes fadeUp{from{opacity:0;transform:translateY(16px);}to{opacity:1;transform:translateY(0);}}
        .confirm-card>*{animation:fadeUp .5s ease both;}
        .confirm-card>*:nth-child(2){animation-delay:.1s;}
        .confirm-card>*:nth-child(3){animation-delay:.2s;}
        @media(max-width:768px){.sidebar{display:none;}.main{margin-left:0;}.content{padding:20px 16px;}.action-btns{flex-direction:column;}}
    </style>
</head>
<body>
<form id="form1" runat="server">
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
                <div class="avatar"><asp:Label ID="lblAvatar" runat="server" Text="U" /></div>
                <div>
                    <div style="font-size:13px;font-weight:600;color:var(--text)"><asp:Label ID="lblUserName" runat="server" Text="User" /></div>
                    <div style="font-size:11px;color:var(--muted)">Member</div>
                </div>
            </div>
        </div>
    </aside>
    <main class="main">
        <header class="topbar">
            <div class="topbar-title">🎉 Show Booking Confirmed</div>
        </header>
        <div class="content">
            <div class="confirm-card">
                <div class="success-banner">
                    <div class="checkmark">🎭</div>
                    <div class="success-title">Show Booked Successfully!</div>
                    <div class="success-sub">Your seats are confirmed. Enjoy the show!</div>
                    <div class="booking-ref-box">Ref: <asp:Label ID="lblBookingRef" runat="server" Text="—" /></div>
                </div>
                <div class="details-panel">
                    <div class="details-head">🎟️ Booking Details</div>
                    <div class="details-body">
                        <div class="detail-row"><span class="lbl">Show</span><span class="val"><asp:Label ID="lblShow" runat="server" Text="—" /></span></div>
                        <div class="detail-row"><span class="lbl">Venue</span><span class="val"><asp:Label ID="lblVenue" runat="server" Text="—" /></span></div>
                        <div class="detail-row"><span class="lbl">Date & Time</span><span class="val"><asp:Label ID="lblDateTime" runat="server" Text="—" /></span></div>
                        <div class="detail-row"><span class="lbl">Seats</span><span class="val"><asp:Label ID="lblSeats" runat="server" Text="—" /></span></div>
                        <div class="detail-row"><span class="lbl">Subtotal</span><span class="val">₹<asp:Label ID="lblSubtotal" runat="server" Text="0" /></span></div>
                        <div class="detail-row"><span class="lbl">Convenience Fee</span><span class="val">₹<asp:Label ID="lblFee" runat="server" Text="0" /></span></div>
                        <div class="detail-row"><span class="lbl" style="color:var(--green)">Discount</span><span class="val" style="color:var(--green)">− ₹<asp:Label ID="lblDiscount" runat="server" Text="0" /></span></div>
                        <div class="total-row"><span class="lbl">Total Paid</span><span class="val">₹<asp:Label ID="lblTotal" runat="server" Text="0" /></span></div>
                    </div>
                </div>
                <div class="action-btns">
                    <a href="Shows.aspx" class="btn-primary">🎭 Browse More Shows</a>
                    <a href="Home.aspx"  class="btn-outline">🏠 Back to Home</a>
                </div>
            </div>
        </div>
    </main>
</div>
</form>
</body>
</html>