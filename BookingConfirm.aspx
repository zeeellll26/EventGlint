<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookingConfirm.aspx.cs" Inherits="EventGlint.BookingConfirm" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint | Booking Confirmed</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --violet:#7C3AED; --violet-mid:#9D5CF8; --violet-soft:#EDE9FE;
            --bg:#F7F5FF; --surface:#FFFFFF; --surface2:#F1EEF9;
            --border-soft:rgba(0,0,0,.06); --text:#1A1033; --muted:#8B7BB0;
            --gold:#E88C1A; --green:#16A34A;
            --shadow-md:0 4px 20px rgba(124,58,237,.10);
            --radius:18px; --sidebar:264px;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--bg);color:var(--text);}
        #form1{display:contents;}
        .layout{display:flex;min-height:100vh;}

        /* SIDEBAR */
        .sidebar{width:var(--sidebar);min-height:100vh;background:var(--surface);border-right:1px solid var(--border-soft);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;padding:30px 0;}
        .sidebar::before{content:'';position:absolute;top:0;left:0;right:0;height:4px;background:linear-gradient(90deg,var(--violet),var(--violet-mid),#C084FC);}
        .sidebar-logo{display:flex;align-items:center;gap:13px;padding:0 24px 30px;border-bottom:1px solid var(--border-soft);}
        .logo-icon{width:44px;height:44px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));border-radius:14px;display:grid;place-items:center;font-size:20px;}
        .logo-text{font-family:'Playfair Display',serif;font-weight:800;font-size:17px;color:var(--text);}
        .logo-text span{font-family:'Plus Jakarta Sans',sans-serif;color:var(--muted);font-size:11px;font-weight:400;display:block;margin-top:2px;}
        .nav{padding:26px 14px;flex:1;display:flex;flex-direction:column;gap:3px;}
        .nav-item{display:flex;align-items:center;gap:12px;padding:11px 14px;border-radius:12px;font-size:14px;font-weight:500;color:var(--muted);text-decoration:none;transition:all .2s;}
        .nav-item:hover{background:var(--violet-soft);color:var(--violet);}
        .sidebar-bottom{padding:20px;border-top:1px solid var(--border-soft);}
        .user-card{display:flex;align-items:center;gap:12px;padding:12px 14px;border-radius:14px;background:var(--surface2);border:1px solid var(--border-soft);}
        .avatar{width:38px;height:38px;background:linear-gradient(135deg,var(--violet),#C084FC);border-radius:50%;display:grid;place-items:center;font-weight:700;font-size:15px;color:#fff;flex-shrink:0;}

        /* MAIN */
        .main{margin-left:var(--sidebar);flex:1;display:flex;flex-direction:column;}
        .topbar{height:70px;background:rgba(247,245,255,.95);border-bottom:1px solid var(--border-soft);display:flex;align-items:center;padding:0 32px;gap:16px;}
        .content{padding:40px 32px;flex:1;}

        /* CONFIRM CARD */
        .confirm-card{max-width:660px;margin:0 auto;}

        /* SUCCESS BANNER */
        .success-banner{background:linear-gradient(135deg,#5B21B6,#7C3AED,#A855F7);border-radius:26px;padding:44px;text-align:center;margin-bottom:24px;box-shadow:0 12px 40px rgba(124,58,237,.2);position:relative;overflow:hidden;}
        .success-banner::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 70% 20%,rgba(255,255,255,.12) 0%,transparent 60%);}
        .checkmark{font-size:64px;margin-bottom:16px;position:relative;z-index:1;}
        .success-title{font-family:'Playfair Display',serif;font-size:28px;font-weight:900;color:#fff;margin-bottom:8px;position:relative;z-index:1;}
        .success-sub{font-size:14px;color:rgba(255,255,255,.8);position:relative;z-index:1;}
        .booking-ref-box{display:inline-block;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.3);padding:10px 24px;border-radius:20px;margin-top:16px;font-size:16px;font-weight:700;color:#fff;letter-spacing:.08em;position:relative;z-index:1;}

        /* STATUS BADGE */
        .status-confirmed{display:inline-block;background:#DCFCE7;color:#15803D;font-size:13px;font-weight:700;padding:5px 14px;border-radius:20px;border:1px solid #BBF7D0;}
        .status-pending  {display:inline-block;background:#FEF3C7;color:#92400E;font-size:13px;font-weight:700;padding:5px 14px;border-radius:20px;border:1px solid #FCD34D;}

        /* DETAILS PANEL */
        .details-panel{background:var(--surface);border:1px solid var(--border-soft);border-radius:var(--radius);box-shadow:var(--shadow-md);overflow:hidden;margin-bottom:20px;}
        .details-head{padding:16px 22px;border-bottom:1px solid var(--border-soft);font-family:'Playfair Display',serif;font-size:16px;font-weight:800;color:var(--text);}
        .details-body{padding:20px 22px;}
        .detail-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border-soft);font-size:14px;}
        .detail-row:last-child{border-bottom:none;}
        .detail-row .lbl{color:var(--muted);font-weight:500;}
        .detail-row .val{color:var(--text);font-weight:700;text-align:right;max-width:60%;}
        .total-row{background:var(--violet-soft);border-radius:10px;padding:14px 16px;display:flex;justify-content:space-between;align-items:center;margin-top:12px;}
        .total-row .lbl{font-size:14px;font-weight:700;color:var(--text);}
        .total-row .val{font-family:'Playfair Display',serif;font-size:22px;font-weight:900;color:var(--violet);}

        /* SEAT CHIPS */
        .seat-chips{display:flex;flex-wrap:wrap;gap:8px;margin-top:4px;}
        .seat-chip{background:var(--violet-soft);color:var(--violet);font-size:12px;font-weight:700;padding:4px 12px;border-radius:12px;}

        /* ACTION BUTTONS */
        .action-btns{display:flex;gap:12px;}
        .btn-primary{flex:1;padding:14px;background:linear-gradient(135deg,var(--violet),var(--violet-mid));color:#fff;border:none;border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;text-align:center;text-decoration:none;display:block;}
        .btn-outline {flex:1;padding:14px;background:var(--surface);color:var(--violet);border:2px solid var(--violet);border-radius:14px;font-size:14px;font-weight:700;cursor:pointer;font-family:'Plus Jakarta Sans',sans-serif;text-align:center;text-decoration:none;display:block;}

        @keyframes fadeUp{from{opacity:0;transform:translateY(16px);}to{opacity:1;transform:translateY(0);}}
        .success-banner{animation:fadeUp .5s ease both;}
        .details-panel{animation:fadeUp .5s .1s ease both;}
        .action-btns{animation:fadeUp .5s .2s ease both;}
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-icon">🎯</div>
            <div class="logo-text">EventNearMe<span>Discover Local Events</span></div>
        </div>
        <nav class="nav">
            <a class="nav-item" href="Home.aspx">🏠 Home</a>
            <a class="nav-item" href="Event.aspx">🎪 Events</a>
            <a class="nav-item" href="shows.aspx">🎭 Shows</a>
            <a class="nav-item" href="Bookings.aspx">🎟️ My Bookings</a>
        </nav>
        <div class="sidebar-bottom">
            <div class="user-card">
                <div class="avatar"><asp:Label ID="lblAvatar" runat="server" Text="U" /></div>
                <div>
                    <div style="font-size:13px;font-weight:600;color:var(--text)">
                        <asp:Label ID="lblUserName" runat="server" Text="User" />
                    </div>
                    <div style="font-size:11px;color:var(--muted)">Member</div>
                </div>
            </div>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main">
        <header class="topbar">
            <div style="font-family:'Playfair Display',serif;font-size:18px;font-weight:800;color:var(--text)">
                🎉 Booking Confirmed
            </div>
        </header>

        <div class="content">
            <div class="confirm-card">

                <!-- SUCCESS BANNER -->
                <div class="success-banner">
                    <div class="checkmark">✅</div>
                    <div class="success-title">Booking Confirmed!</div>
                    <div class="success-sub">Your seats are locked in. Enjoy the show!</div>
                    <div class="booking-ref-box">
                        Ref: <asp:Label ID="lblBookingRef" runat="server" Text="—" />
                    </div>
                </div>

                <!-- BOOKING DETAILS -->
                <div class="details-panel">
                    <div class="details-head">🎬 Booking Details</div>
                    <div class="details-body">

                        <div class="detail-row">
                            <span class="lbl">Status</span>
                            <span class="val"><asp:Label ID="lblStatus" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Event</span>
                            <span class="val"><asp:Label ID="lblEvent" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Date &amp; Time</span>
                            <span class="val"><asp:Label ID="lblShowDate" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Venue</span>
                            <span class="val"><asp:Label ID="lblVenue" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Hall</span>
                            <span class="val"><asp:Label ID="lblHall" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Seats</span>
                            <span class="val">
                                <div class="seat-chips">
                                    <asp:Literal ID="litSeats" runat="server" />
                                </div>
                            </span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Payment Method</span>
                            <span class="val"><asp:Label ID="lblPayMethod" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Paid At</span>
                            <span class="val"><asp:Label ID="lblPaidAt" runat="server" Text="—" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Subtotal</span>
                            <span class="val">₹<asp:Label ID="lblSubtotal" runat="server" Text="0" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl">Convenience Fee</span>
                            <span class="val">₹<asp:Label ID="lblFee" runat="server" Text="0" /></span>
                        </div>
                        <div class="detail-row">
                            <span class="lbl" style="color:var(--green)">Discount</span>
                            <span class="val" style="color:var(--green)">- ₹<asp:Label ID="lblDiscount" runat="server" Text="0" /></span>
                        </div>

                        <div class="total-row">
                            <span class="lbl">Total Paid</span>
                            <span class="val">₹<asp:Label ID="lblTotal" runat="server" Text="0" /></span>
                        </div>

                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="action-btns">
                    <a href="Bookings.aspx" class="btn-primary">📋 View My Bookings</a>
                    <a href="Home.aspx" class="btn-outline">🏠 Back to Home</a>
                </div>

            </div>
        </div>
    </main>

</div>
</form>
</body>
</html>
