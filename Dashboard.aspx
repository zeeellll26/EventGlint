<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EventGlint.Dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EventGlint Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .navbar { background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); }
        .logo-nav { background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .main-card { background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); border-radius: 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.1); margin: 2rem auto; max-width: 1200px; }
        .stat-card { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border-radius: 15px; padding: 1.5rem; text-align: center; margin-bottom: 1rem; }
        .stat-number { font-size: 2.5rem; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Top Navbar -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container">
                <a class="navbar-brand logo-nav fs-3 fw-bold" href="#">EventGlint ✓</a>
                <div class="navbar-nav ms-auto">
                    <asp:Label ID="lblUserName" runat="server" CssClass="nav-link"></asp:Label>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-primary ms-2" OnClick="btnLogout_Click" />
                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="main-card p-4">
                <h2 class="mb-4">Welcome to Your Dashboard</h2>
                
                <!-- Stats Cards -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h5>Bookings</h5>
                            <div class="stat-number">12</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h5>Events</h5>
                            <div class="stat-number">5</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h5>Revenue</h5>
                            <div class="stat-number">₹24,500</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h5>Pending</h5>
                            <div class="stat-number">2</div>
                        </div>
                    </div>
                </div>

                
            </div>
        </div>
    </form>
</body>

</html>
