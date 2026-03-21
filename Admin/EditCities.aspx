<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCities.aspx.cs" Inherits="EventGlint.Admin.EditCities" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Cities — EventGlint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root{--bg:#f4f6fb;--surface:#ffffff;--card:#ffffff;--border:#e4e8f0;--accent:#5b3ff8;--accent2:#c026d3;--accent-light:rgba(91,63,248,0.08);--gold:#d97706;--text:#1a1d2e;--sub:#3d4163;--muted:#8b92b8;--danger:#e53935;--success:#059669;--shadow-sm:0 1px 4px rgba(91,63,248,0.06);--shadow-md:0 4px 20px rgba(91,63,248,0.10);--shadow-lg:0 8px 32px rgba(91,63,248,0.14);}
        *{margin:0;padding:0;box-sizing:border-box;}
        body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;overflow-x:hidden;}
        body::before{content:'';position:fixed;top:-200px;right:-200px;width:600px;height:600px;background:radial-gradient(circle,rgba(91,63,248,0.07) 0%,transparent 70%);pointer-events:none;z-index:0;}
        body::after{content:'';position:fixed;bottom:-150px;left:-150px;width:500px;height:500px;background:radial-gradient(circle,rgba(192,38,211,0.05) 0%,transparent 70%);pointer-events:none;z-index:0;}
        .sidebar{position:fixed;top:0;left:0;width:248px;height:100vh;background:var(--surface);border-right:1px solid var(--border);display:flex;flex-direction:column;z-index:100;box-shadow:2px 0 16px rgba(91,63,248,0.06);}
        .sidebar-logo{padding:26px 22px 20px;border-bottom:1px solid var(--border);}
        .sidebar-logo .brand{font-family:'Playfair Display',serif;font-size:21px;font-weight:700;color:var(--text);}
        .sidebar-logo .brand span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
        .sidebar-logo .badge{display:inline-block;margin-top:7px;font-size:10px;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;color:var(--accent);background:var(--accent-light);border:1px solid rgba(91,63,248,0.18);padding:3px 10px;border-radius:20px;}
        .sidebar-nav{flex:1;overflow-y:auto;padding:14px 10px;}
        .sidebar-nav::-webkit-scrollbar{width:3px;}
        .sidebar-nav::-webkit-scrollbar-thumb{background:var(--border);border-radius:10px;}
        .nav-label{font-size:10px;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;color:var(--muted);padding:12px 12px 5px;}
        .nav-item{display:flex;align-items:center;gap:11px;padding:9px 12px;border-radius:8px;text-decoration:none;color:var(--sub);font-size:13.5px;font-weight:500;transition:all 0.18s;margin-bottom:1px;}
        .nav-item i{width:17px;font-size:13px;text-align:center;color:var(--muted);transition:color 0.18s;}
        .nav-item:hover{background:var(--accent-light);color:var(--accent);}
        .nav-item:hover i{color:var(--accent);}
        .nav-item.active{background:linear-gradient(135deg,rgba(91,63,248,0.12),rgba(192,38,211,0.06));color:var(--accent);font-weight:600;}
        .nav-item.active i{color:var(--accent);}
        .sidebar-footer{padding:14px 10px;border-top:1px solid var(--border);}
        .logout-btn{display:flex;align-items:center;gap:10px;width:100%;padding:10px 14px;border-radius:8px;background:#fff1f1;border:1px solid #fecaca;color:var(--danger);font-size:13.5px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;text-decoration:none;transition:all 0.18s;}
        .logout-btn:hover{background:#ffe4e4;border-color:#f87171;}
        .main{margin-left:248px;min-height:100vh;position:relative;z-index:1;}
        .topbar{display:flex;align-items:center;justify-content:space-between;padding:16px 36px;background:rgba(255,255,255,0.88);backdrop-filter:blur(12px);border-bottom:1px solid var(--border);position:sticky;top:0;z-index:50;box-shadow:var(--shadow-sm);}
        .topbar-left h2{font-family:'Playfair Display',serif;font-size:20px;font-weight:700;color:var(--text);}
        .topbar-left p{font-size:12.5px;color:var(--muted);margin-top:2px;}
        .topbar-right{display:flex;align-items:center;gap:12px;}
        .topbar-time{font-size:12.5px;color:var(--sub);background:var(--bg);border:1px solid var(--border);padding:6px 14px;border-radius:20px;font-weight:500;}
        .admin-avatar{width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:15px;font-weight:700;color:white;box-shadow:0 2px 10px rgba(91,63,248,0.28);}
        .content{padding:30px 36px;}
        .welcome-banner{position:relative;overflow:hidden;background:linear-gradient(135deg,#5b3ff8 0%,#c026d3 100%);border-radius:16px;padding:32px 36px;margin-bottom:28px;box-shadow:var(--shadow-lg);}
        .welcome-banner::before{content:'';position:absolute;top:-60px;right:-60px;width:280px;height:280px;background:rgba(255,255,255,0.07);border-radius:50%;}
        .welcome-banner::after{content:'';position:absolute;bottom:-80px;right:120px;width:200px;height:200px;background:rgba(255,255,255,0.05);border-radius:50%;}
        .welcome-banner .greeting{font-size:12px;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;color:rgba(255,255,255,0.75);margin-bottom:8px;}
        .welcome-banner h1{font-family:'Playfair Display',serif;font-size:27px;font-weight:700;color:#fff;margin-bottom:6px;position:relative;z-index:1;}
        .welcome-banner p{font-size:13.5px;color:rgba(255,255,255,0.72);position:relative;z-index:1;}
        .section-title{font-size:11px;font-weight:700;letter-spacing:1.6px;text-transform:uppercase;color:var(--muted);margin-bottom:16px;display:flex;align-items:center;gap:12px;}
        .section-title::after{content:'';flex:1;height:1px;background:var(--border);}
        .body-grid{display:grid;grid-template-columns:360px 1fr;gap:20px;align-items:start;}
        .form-card{background:var(--card);border:1px solid var(--border);border-radius:14px;box-shadow:var(--shadow-sm);overflow:hidden;transition:box-shadow 0.22s;}
        .form-card:hover{box-shadow:var(--shadow-md);}
        .form-card-head{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:13px;}
        .form-card-icon{width:40px;height:40px;border-radius:11px;background:var(--accent-light);border:1px solid rgba(91,63,248,0.15);display:flex;align-items:center;justify-content:center;font-size:17px;color:var(--accent);}
        .form-card-title{font-size:14px;font-weight:600;color:var(--text);}
        .form-card-sub{font-size:11.5px;color:var(--muted);margin-top:2px;}
        .form-card-body{padding:22px;}
        .field{margin-bottom:15px;}
        .field label{display:block;font-size:11px;font-weight:600;color:var(--sub);text-transform:uppercase;letter-spacing:0.6px;margin-bottom:6px;}
        .req{color:var(--danger);margin-left:2px;}
        .field input,.field select{width:100%;padding:9px 13px;border:1.5px solid var(--border);border-radius:8px;font-size:13.5px;color:var(--text);background:var(--bg);font-family:'DM Sans',sans-serif;transition:all 0.2s;}
        .field input:focus,.field select:focus{outline:none;border-color:var(--accent);background:white;box-shadow:0 0 0 3px rgba(91,63,248,0.10);}
        .field input[readonly]{background:var(--accent-light);color:var(--accent);font-weight:600;cursor:not-allowed;border-color:rgba(91,63,248,0.2);}
        .btn-row{display:flex;gap:9px;margin-top:20px;padding-top:18px;border-top:1px solid var(--border);}
        .btn{flex:1;padding:10px 8px;border:none;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;transition:all 0.2s;font-family:'DM Sans',sans-serif;display:flex;align-items:center;justify-content:center;gap:6px;}
        .btn:hover{transform:translateY(-1px);filter:brightness(1.08);}
        .btn:active{transform:translateY(0);}
        .btn-insert{background:linear-gradient(135deg,var(--accent),var(--accent2));color:white;box-shadow:0 3px 12px rgba(91,63,248,0.25);}
        .btn-save{background:linear-gradient(135deg,#059669,#10b981);color:white;box-shadow:0 3px 12px rgba(5,150,105,0.22);}
        .btn-clear{background:var(--bg);color:var(--sub);border:1.5px solid var(--border);}
        .btn-clear:hover{border-color:var(--accent);color:var(--accent);background:var(--accent-light);}
        .alert{padding:10px 14px;border-radius:9px;font-size:13px;margin-bottom:15px;display:flex;align-items:center;gap:8px;font-weight:500;}
        .msg-success{background:#d1fae5;border:1px solid #6ee7b7;color:#065f46;}
        .msg-error{background:#fee2e2;border:1px solid #fca5a5;color:#991b1b;}
        .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;box-shadow:var(--shadow-sm);overflow:hidden;transition:box-shadow 0.22s;}
        .table-card:hover{box-shadow:var(--shadow-md);}
        .table-card-head{padding:16px 22px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;}
        .table-card-head h3{font-size:14px;font-weight:600;color:var(--text);}
        .count-badge{font-size:11px;font-weight:600;color:var(--accent);background:var(--accent-light);border:1px solid rgba(91,63,248,0.18);padding:3px 11px;border-radius:20px;}
        .tbl-wrap{overflow-x:auto;}
        table{width:100%;border-collapse:collapse;}
        thead tr{background:rgba(91,63,248,0.04);}
        thead th{padding:11px 14px;text-align:left;font-size:11px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;border-bottom:1px solid var(--border);white-space:nowrap;}
        tbody tr{border-bottom:1px solid rgba(228,232,240,0.6);transition:background 0.14s;}
        tbody tr:last-child{border-bottom:none;}
        tbody tr:hover{background:rgba(91,63,248,0.03);}
        tbody td{padding:12px 14px;font-size:13px;color:var(--sub);white-space:nowrap;}
        .tbtn{padding:5px 12px;border-radius:7px;font-size:11.5px;font-weight:600;cursor:pointer;border:none;font-family:'DM Sans',sans-serif;transition:all 0.15s;}
        .tbtn:hover{transform:translateY(-1px);}
        .tbtn-select{background:var(--accent-light);color:var(--accent);border:1px solid rgba(91,63,248,0.2);}
        .tbtn-select:hover{background:rgba(91,63,248,0.15);}
        .tbtn-delete{background:#fff1f1;color:var(--danger);border:1px solid #fecaca;margin-left:4px;}
        .tbtn-delete:hover{background:#fee2e2;}
        .fade-in{opacity:0;transform:translateY(14px);animation:fadeUp 0.45s ease forwards;}
        @keyframes fadeUp{to{opacity:1;transform:translateY(0);}}
        .fade-in:nth-child(1){animation-delay:0.04s;}.fade-in:nth-child(2){animation-delay:0.10s;}.fade-in:nth-child(3){animation-delay:0.16s;}
        @media(max-width:1100px){.body-grid{grid-template-columns:1fr;}}
        @media(max-width:768px){.sidebar{display:none;}.main{margin-left:0;}.content{padding:20px 16px;}}
    </style>
</head>
<body>
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-logo"><div class="brand">Event<span>Glint</span></div><div class="badge">Admin Portal</div></div>
    <nav class="sidebar-nav">
        <div class="nav-label">Dashboard</div>
        <a href="../AdminPanel.aspx" class="nav-item"><i class="fas fa-th-large"></i> Overview</a>
        <div class="nav-label" style="margin-top:8px">Management</div>
        <a href="EditEvents.aspx"      class="nav-item"><i class="fas fa-calendar-star"></i> Events</a>
        <a href="EditShows.aspx"       class="nav-item"><i class="fas fa-film"></i> Shows</a>
        <a href="EditBookings.aspx"    class="nav-item"><i class="fas fa-ticket"></i> Bookings</a>
        <a href="EditBookedSeats.aspx" class="nav-item"><i class="fas fa-chair"></i> Booked Seats</a>
        <a href="EditPayments.aspx"    class="nav-item"><i class="fas fa-credit-card"></i> Payments</a>
        <div class="nav-label" style="margin-top:8px">Venue &amp; Setup</div>
        <a href="EditVenue.aspx"          class="nav-item"><i class="fas fa-building"></i> Venues</a>
        <a href="EditHalls.aspx"          class="nav-item"><i class="fas fa-door-open"></i> Halls</a>
        <a href="EditSeats.aspx"          class="nav-item"><i class="fas fa-couch"></i> Seats</a>
        <a href="EditSeatCategories.aspx" class="nav-item"><i class="fas fa-tags"></i> Seat Categories</a>
        <a href="EditCities.aspx"         class="nav-item active"><i class="fas fa-city"></i> Cities</a>
        <div class="nav-label" style="margin-top:8px">Users &amp; More</div>
        <a href="EditUsers.aspx"   class="nav-item"><i class="fas fa-users"></i> Users</a>
        <a href="EditAdmins.aspx"  class="nav-item"><i class="fas fa-user-shield"></i> Admins</a>
        <a href="EditCoupons.aspx" class="nav-item"><i class="fas fa-percent"></i> Coupons</a>
        <a href="EditReviews.aspx" class="nav-item"><i class="fas fa-star"></i> Reviews</a>
    </nav>
    <div class="sidebar-footer"><a href="../Log.aspx" class="logout-btn"><i class="fas fa-arrow-right-from-bracket"></i> Logout</a></div>
</aside>
<div class="main">
    <div class="topbar">
        <div class="topbar-left"><h2>Edit Cities</h2><p>Manage cities where the platform operates</p></div>
        <div class="topbar-right">
            <div class="topbar-time" id="liveTime"></div>
            <div class="admin-avatar"><asp:Label ID="lbl_AvatarInitial" runat="server" Text="A" /></div>
        </div>
    </div>
    <div class="content">
        <div class="welcome-banner fade-in">
            <div class="greeting">🏙️ City Management</div>
            <h1>Manage Cities</h1>
            <p>Add new cities, update existing details or remove inactive locations.</p>
        </div>
        <div class="section-title">Add / Edit City</div>
        <div class="body-grid">
            <div class="form-card fade-in">
                <div class="form-card-head">
                    <div class="form-card-icon"><i class="fas fa-city"></i></div>
                    <div><div class="form-card-title">City Details</div><div class="form-card-sub">Fill in details and click Insert or Save</div></div>
                </div>
                <div class="form-card-body">
                    <asp:Label ID="lblMessage" runat="server" Visible="false" />
                    <div class="field">
                        <label><i class="fas fa-lock" style="opacity:0.4;margin-right:4px"></i>City ID</label>
                        <asp:TextBox ID="txtCityId" runat="server" ReadOnly="true" placeholder="Auto generated" />
                    </div>
                    <div class="field">
                        <label>City Name <span class="req">*</span></label>
                        <asp:TextBox ID="txtCityName" runat="server" placeholder="e.g. Surat" />
                    </div>
                    <div class="field">
                        <label>State <span class="req">*</span></label>
                        <asp:TextBox ID="txtState" runat="server" placeholder="e.g. Gujarat" />
                    </div>
                    <div class="field">
                        <label>Country <span class="req">*</span></label>
                        <asp:TextBox ID="txtCountry" runat="server" placeholder="e.g. India" />
                    </div>
                    <div class="btn-row">
                        <asp:Button ID="btnInsert" runat="server" Text="Insert" CssClass="btn btn-insert" OnClick="btnInsert_Click" />
                        <asp:Button ID="btnSave"   runat="server" Text="Save"   CssClass="btn btn-save"   OnClick="btnSave_Click" />
                        <asp:Button ID="btnClear"  runat="server" Text="Clear"  CssClass="btn btn-clear"  OnClick="btnClear_Click" />
                    </div>
                </div>
            </div>
            <div class="table-card fade-in">
                <div class="table-card-head">
                    <h3><i class="fas fa-table" style="margin-right:8px;color:var(--accent)"></i>All Cities</h3>
                    <span class="count-badge"><asp:Label ID="lblCount" runat="server" Text="0 records" /></span>
                </div>
                <div class="tbl-wrap">
                    <asp:GridView ID="gvCities" runat="server" AutoGenerateColumns="false" DataKeyNames="CityId" GridLines="None" EmptyDataText="No cities found." OnRowCommand="gvCities_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CityId" HeaderText="ID" />
                            <asp:BoundField DataField="Name"   HeaderText="City Name" />
                            <asp:BoundField DataField="State"   HeaderText="State" />
                            <asp:BoundField DataField="Country" HeaderText="Country" />
                            <asp:BoundField DataField="CreatedAt" HeaderText="Created At" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button CommandName="SelectRow" CommandArgument='<%# Eval("CityId") %>' Text="Edit"   CssClass="tbtn tbtn-select" runat="server" />
                                    <asp:Button CommandName="DeleteRow" CommandArgument='<%# Eval("CityId") %>' Text="Delete" CssClass="tbtn tbtn-delete" runat="server" OnClientClick="return confirm('Delete this city?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
<script>function updateClock(){const now=new Date();document.getElementById('liveTime').textContent=now.toLocaleTimeString('en-IN',{weekday:'short',hour:'2-digit',minute:'2-digit',second:'2-digit'});}updateClock();setInterval(updateClock,1000);</script>
</body>
</html>
