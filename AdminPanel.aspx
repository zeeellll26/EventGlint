<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="EventGlint.AdminPanel" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint — Admin Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --bg:           #f4f6fb;
            --surface:      #ffffff;
            --card:         #ffffff;
            --border:       #e4e8f0;
            --accent:       #5b3ff8;
            --accent2:      #c026d3;
            --accent-light: rgba(91,63,248,0.08);
            --gold:         #d97706;
            --text:         #1a1d2e;
            --sub:          #3d4163;
            --muted:        #8b92b8;
            --danger:       #e53935;
            --success:      #059669;
            --shadow-sm:    0 1px 4px rgba(91,63,248,0.06);
            --shadow-md:    0 4px 20px rgba(91,63,248,0.10);
            --shadow-lg:    0 8px 32px rgba(91,63,248,0.14);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: -200px; right: -200px;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(91,63,248,0.07) 0%, transparent 70%);
            pointer-events: none; z-index: 0;
        }
        body::after {
            content: '';
            position: fixed;
            bottom: -150px; left: -150px;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(192,38,211,0.05) 0%, transparent 70%);
            pointer-events: none; z-index: 0;
        }

        /* ════ SIDEBAR ════ */
        .sidebar {
            position: fixed;
            top: 0; left: 0;
            width: 248px; height: 100vh;
            background: var(--surface);
            border-right: 1px solid var(--border);
            display: flex; flex-direction: column;
            z-index: 100;
            box-shadow: 2px 0 16px rgba(91,63,248,0.06);
        }

        .sidebar-logo {
            padding: 26px 22px 20px;
            border-bottom: 1px solid var(--border);
        }
        .sidebar-logo .brand {
            font-family: 'Playfair Display', serif;
            font-size: 21px; font-weight: 700; color: var(--text);
        }
        .sidebar-logo .brand span {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .sidebar-logo .badge {
            display: inline-block;
            margin-top: 7px;
            font-size: 10px; font-weight: 600;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--accent);
            background: var(--accent-light);
            border: 1px solid rgba(91,63,248,0.18);
            padding: 3px 10px; border-radius: 20px;
        }

        .sidebar-nav {
            flex: 1; overflow-y: auto;
            padding: 14px 10px;
        }
        .sidebar-nav::-webkit-scrollbar { width: 3px; }
        .sidebar-nav::-webkit-scrollbar-thumb { background: var(--border); border-radius: 10px; }

        .nav-label {
            font-size: 10px; font-weight: 600;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--muted); padding: 12px 12px 5px;
        }

        .nav-item {
            display: flex; align-items: center; gap: 11px;
            padding: 9px 12px; border-radius: 8px;
            text-decoration: none; color: var(--sub);
            font-size: 13.5px; font-weight: 500;
            transition: all 0.18s; margin-bottom: 1px;
        }
        .nav-item i { width: 17px; font-size: 13px; text-align: center; color: var(--muted); transition: color 0.18s; }
        .nav-item:hover { background: var(--accent-light); color: var(--accent); }
        .nav-item:hover i { color: var(--accent); }
        .nav-item.active {
            background: linear-gradient(135deg, rgba(91,63,248,0.12), rgba(192,38,211,0.06));
            color: var(--accent); font-weight: 600;
        }
        .nav-item.active i { color: var(--accent); }

        .sidebar-footer { padding: 14px 10px; border-top: 1px solid var(--border); }
        .logout-btn {
            display: flex; align-items: center; gap: 10px;
            width: 100%; padding: 10px 14px; border-radius: 8px;
            background: #fff1f1; border: 1px solid #fecaca;
            color: var(--danger); font-size: 13.5px; font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; text-decoration: none; transition: all 0.18s;
        }
        .logout-btn:hover { background: #ffe4e4; border-color: #f87171; }

        /* ════ MAIN ════ */
        .main { margin-left: 248px; min-height: 100vh; position: relative; z-index: 1; }

        .topbar {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 36px;
            background: rgba(255,255,255,0.88);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            position: sticky; top: 0; z-index: 50;
            box-shadow: var(--shadow-sm);
        }
        .topbar-left h2 {
            font-family: 'Playfair Display', serif;
            font-size: 20px; font-weight: 700; color: var(--text);
        }
        .topbar-left p { font-size: 12.5px; color: var(--muted); margin-top: 2px; }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .topbar-time {
            font-size: 12.5px; color: var(--sub);
            background: var(--bg); border: 1px solid var(--border);
            padding: 6px 14px; border-radius: 20px; font-weight: 500;
        }
        .admin-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; font-weight: 700; color: white;
            box-shadow: 0 2px 10px rgba(91,63,248,0.28);
        }

        .content { padding: 30px 36px; }

        /* ── Welcome Banner ── */
        .welcome-banner {
            position: relative; overflow: hidden;
            background: linear-gradient(135deg, #5b3ff8 0%, #c026d3 100%);
            border-radius: 16px; padding: 32px 36px;
            margin-bottom: 28px; box-shadow: var(--shadow-lg);
        }
        .welcome-banner::before {
            content: '';
            position: absolute; top: -60px; right: -60px;
            width: 280px; height: 280px;
            background: rgba(255,255,255,0.07); border-radius: 50%;
        }
        .welcome-banner::after {
            content: '';
            position: absolute; bottom: -80px; right: 120px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.05); border-radius: 50%;
        }
        .welcome-banner .greeting {
            font-size: 12px; font-weight: 600;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: rgba(255,255,255,0.75); margin-bottom: 8px;
        }
        .welcome-banner h1 {
            font-family: 'Playfair Display', serif;
            font-size: 27px; font-weight: 700; color: #fff;
            margin-bottom: 6px; position: relative; z-index: 1;
        }
        .welcome-banner p { font-size: 13.5px; color: rgba(255,255,255,0.72); position: relative; z-index: 1; }

        /* ── Stats ── */
        .stats-row {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 16px; margin-bottom: 30px;
        }
        .stat-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 22px 22px 18px;
            position: relative; overflow: hidden;
            box-shadow: var(--shadow-sm); transition: all 0.22s;
        }
        .stat-card:hover {
            border-color: rgba(91,63,248,0.25);
            box-shadow: var(--shadow-md); transform: translateY(-2px);
        }
        .stat-card .icon {
            width: 42px; height: 42px; border-radius: 11px;
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; margin-bottom: 16px;
        }
        .stat-card .stat-value {
            font-size: 28px; font-weight: 700;
            font-family: 'Playfair Display', serif;
            color: var(--text); margin-bottom: 4px;
        }
        .stat-card .stat-label { font-size: 12px; color: var(--muted); font-weight: 500; }
        .stat-card .trend {
            position: absolute; top: 18px; right: 18px;
            font-size: 11px; font-weight: 600;
            padding: 3px 8px; border-radius: 20px;
        }
        .trend.up   { color: var(--success); background: #d1fae5; }
        .trend.down { color: var(--danger);  background: #fee2e2; }
        .icon.purple { background: rgba(91,63,248,0.10);  color: var(--accent); }
        .icon.pink   { background: rgba(192,38,211,0.10); color: var(--accent2); }
        .icon.gold   { background: rgba(217,119,6,0.10);  color: var(--gold); }
        .icon.green  { background: rgba(5,150,105,0.10);  color: var(--success); }

        /* ── Section Title ── */
        .section-title {
            font-size: 11px; font-weight: 700;
            letter-spacing: 1.6px; text-transform: uppercase;
            color: var(--muted); margin-bottom: 16px;
            display: flex; align-items: center; gap: 12px;
        }
        .section-title::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        /* ── Cards Grid ── */
        .nav-grid {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 14px; margin-bottom: 40px;
        }
        .admin-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 24px 18px 20px;
            text-align: center; text-decoration: none;
            color: var(--sub); font-size: 13px; font-weight: 500;
            transition: all 0.22s cubic-bezier(0.34, 1.56, 0.64, 1);
            display: flex; flex-direction: column;
            align-items: center; gap: 12px;
            box-shadow: var(--shadow-sm);
        }
        .admin-card:hover {
            border-color: rgba(91,63,248,0.3);
            color: var(--accent); transform: translateY(-5px);
            box-shadow: var(--shadow-lg); background: #faf9ff;
        }
        .admin-card .card-icon {
            width: 48px; height: 48px; border-radius: 13px;
            background: var(--accent-light);
            border: 1px solid rgba(91,63,248,0.15);
            display: flex; align-items: center; justify-content: center;
            font-size: 19px; color: var(--accent); transition: all 0.22s;
        }
        .admin-card:hover .card-icon {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-color: transparent; color: white;
            transform: scale(1.1);
            box-shadow: 0 6px 18px rgba(91,63,248,0.28);
        }
        .admin-card .card-label { font-size: 13px; font-weight: 600; }

        /* ── Fade In ── */
        .fade-in {
            opacity: 0; transform: translateY(14px);
            animation: fadeUp 0.45s ease forwards;
        }
        @keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
        .fade-in:nth-child(1)  { animation-delay: 0.04s; }
        .fade-in:nth-child(2)  { animation-delay: 0.08s; }
        .fade-in:nth-child(3)  { animation-delay: 0.12s; }
        .fade-in:nth-child(4)  { animation-delay: 0.16s; }
        .fade-in:nth-child(5)  { animation-delay: 0.20s; }
        .fade-in:nth-child(6)  { animation-delay: 0.24s; }
        .fade-in:nth-child(7)  { animation-delay: 0.28s; }
        .fade-in:nth-child(8)  { animation-delay: 0.32s; }
        .fade-in:nth-child(9)  { animation-delay: 0.36s; }
        .fade-in:nth-child(10) { animation-delay: 0.40s; }
        .fade-in:nth-child(11) { animation-delay: 0.44s; }
        .fade-in:nth-child(12) { animation-delay: 0.48s; }
        .fade-in:nth-child(13) { animation-delay: 0.52s; }
        .fade-in:nth-child(14) { animation-delay: 0.56s; }

        @media (max-width: 1100px) {
            .nav-grid { grid-template-columns: repeat(3, 1fr); }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main { margin-left: 0; }
            .nav-grid { grid-template-columns: repeat(2, 1fr); }
            .content { padding: 20px 16px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- ════════ SIDEBAR ════════ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="brand">Event<span>Glint</span></div>
            <div class="badge">Admin Portal</div>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-label">Dashboard</div>
            <a href="AdminPanel.aspx" class="nav-item active">
                <i class="fas fa-th-large"></i> Overview
            </a>

            <div class="nav-label" style="margin-top:8px">Management</div>
            <a href="Admin/EditEvents.aspx"      class="nav-item"><i class="fas fa-calendar-star"></i> Events</a>
            <a href="Admin/EditShows.aspx"       class="nav-item"><i class="fas fa-film"></i> Shows</a>
            <a href="Admin/EditBookings.aspx"    class="nav-item"><i class="fas fa-ticket"></i> Bookings</a>
            <a href="Admin/EditBookedSeats.aspx" class="nav-item"><i class="fas fa-chair"></i> Booked Seats</a>
            <a href="Admin/EditPayments.aspx"    class="nav-item"><i class="fas fa-credit-card"></i> Payments</a>

            <div class="nav-label" style="margin-top:8px">Venue &amp; Setup</div>
            <a href="Admin/EditVenue.aspx"          class="nav-item"><i class="fas fa-building"></i> Venues</a>
            <a href="Admin/EditHalls.aspx"          class="nav-item"><i class="fas fa-door-open"></i> Halls</a>
            <a href="Admin/EditSeats.aspx"          class="nav-item"><i class="fas fa-couch"></i> Seats</a>
            <a href="Admin/EditSeatCategories.aspx" class="nav-item"><i class="fas fa-tags"></i> Seat Categories</a>
            <a href="Admin/EditCities.aspx"         class="nav-item"><i class="fas fa-city"></i> Cities</a>

            <div class="nav-label" style="margin-top:8px">Users &amp; More</div>
            <a href="Admin/EditUsers.aspx"   class="nav-item"><i class="fas fa-users"></i> Users</a>
            <a href="Admin/EditAdmins.aspx"  class="nav-item"><i class="fas fa-user-shield"></i> Admins</a>
            <a href="Admin/EditCoupons.aspx" class="nav-item"><i class="fas fa-percent"></i> Coupons</a>
            <a href="Admin/EditReviews.aspx" class="nav-item"><i class="fas fa-star"></i> Reviews</a>
        </nav>

        <div class="sidebar-footer">
            <a href="Log.aspx" class="logout-btn">
                <i class="fas fa-arrow-right-from-bracket"></i> Logout
            </a>
        </div>
    </aside>

    <!-- ════════ MAIN ════════ -->
    <div class="main">

        <div class="topbar">
            <div class="topbar-left">
                <h2>Admin Dashboard</h2>
                <p>Manage your events, bookings, venues and more</p>
            </div>
            <div class="topbar-right">
                <div class="topbar-time" id="liveTime"></div>
                <div class="admin-avatar">
                    <asp:Label ID="lbl_AvatarInitial" runat="server" Text="Y"></asp:Label>
                </div>
            </div>
        </div>

        <div class="content">

            <!-- Welcome Banner -->
            <div class="welcome-banner fade-in">
                <div class="greeting">&#x1F44B; Welcome back</div>
                <h1>Hello, <asp:Label ID="lbl_AdminName" runat="server" Text="Admin"></asp:Label></h1>
                <p>You have full control over EventGlint. Here's your management hub.</p>
            </div>

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card fade-in">
                    <div class="icon purple"><i class="fas fa-calendar-check"></i></div>
                    <div class="trend up"><i class="fas fa-arrow-up"></i> 12%</div>
                    <div class="stat-value"><asp:Label ID="lbl_TotalEvents" runat="server" Text="—"></asp:Label></div>
                    <div class="stat-label">Total Events</div>
                </div>
                <div class="stat-card fade-in">
                    <div class="icon pink"><i class="fas fa-ticket"></i></div>
                    <div class="trend up"><i class="fas fa-arrow-up"></i> 8%</div>
                    <div class="stat-value"><asp:Label ID="lbl_TotalBookings" runat="server" Text="—"></asp:Label></div>
                    <div class="stat-label">Total Bookings</div>
                </div>
                <div class="stat-card fade-in">
                    <div class="icon gold"><i class="fas fa-users"></i></div>
                    <div class="trend up"><i class="fas fa-arrow-up"></i> 5%</div>
                    <div class="stat-value"><asp:Label ID="lbl_TotalUsers" runat="server" Text="—"></asp:Label></div>
                    <div class="stat-label">Registered Users</div>
                </div>
                <div class="stat-card fade-in">
                    <div class="icon green"><i class="fas fa-indian-rupee-sign"></i></div>
                    <div class="trend up"><i class="fas fa-arrow-up"></i> 20%</div>
                    <div class="stat-value"><asp:Label ID="lbl_TotalRevenue" runat="server" Text="—"></asp:Label></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>

            <!-- Module Grid -->
            <div class="section-title">Quick Access — All Modules</div>
            <div class="nav-grid">
                <a href="Admin/EditAdmins.aspx"         class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-user-shield"></i></div>
                    <div class="card-label">Admins</div>
                </a>
                <a href="Admin/EditBookedSeats.aspx"    class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-chair"></i></div>
                    <div class="card-label">Booked Seats</div>
                </a>
                <a href="Admin/EditBookings.aspx"       class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-ticket"></i></div>
                    <div class="card-label">Bookings</div>
                </a>
                <a href="Admin/EditCities.aspx"         class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-city"></i></div>
                    <div class="card-label">Cities</div>
                </a>
                <a href="Admin/EditCoupons.aspx"        class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-percent"></i></div>
                    <div class="card-label">Coupons</div>
                </a>
                <a href="Admin/EditEvents.aspx"         class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-calendar-star"></i></div>
                    <div class="card-label">Events</div>
                </a>
                <a href="Admin/EditHalls.aspx"          class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-door-open"></i></div>
                    <div class="card-label">Halls</div>
                </a>
                <a href="Admin/EditPayments.aspx"       class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-credit-card"></i></div>
                    <div class="card-label">Payments</div>
                </a>
                <a href="Admin/EditReviews.aspx"        class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-star"></i></div>
                    <div class="card-label">Reviews</div>
                </a>
                <a href="Admin/EditSeatCategories.aspx" class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-tags"></i></div>
                    <div class="card-label">Seat Categories</div>
                </a>
                <a href="Admin/EditSeats.aspx"          class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-couch"></i></div>
                    <div class="card-label">Seats</div>
                </a>
                <a href="Admin/EditShows.aspx"          class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-film"></i></div>
                    <div class="card-label">Shows</div>
                </a>
                <a href="Admin/EditUsers.aspx"          class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-users"></i></div>
                    <div class="card-label">Users</div>
                </a>
                <a href="Admin/EditVenue.aspx"          class="admin-card fade-in">
                    <div class="card-icon"><i class="fas fa-building"></i></div>
                    <div class="card-label">Venues</div>
                </a>
            </div>

        </div>
    </div>

</form>

<script>
    function updateClock() {
        const now = new Date();
        document.getElementById('liveTime').textContent =
            now.toLocaleTimeString('en-IN', { weekday: 'short', hour: '2-digit', minute: '2-digit', second: '2-digit' });
    }
    updateClock();
    setInterval(updateClock, 1000);
</script>
</body>
</html>
