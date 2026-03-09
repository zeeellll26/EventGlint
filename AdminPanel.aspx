<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="EventGlint.AdminPanel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
        }

        /* Top Header */
        .header {
            background-color: darkslateblue;
            font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .header h1 {
                margin: 0;
                font-size: 22px;
            }

            .header a {
                color: darkslateblue;
                text-decoration: none;
                background-color: white;
                padding: 7px 16px;
                border-radius: 5px;
                font-size: 14px;
            }

                .header a:hover {
                    background-color: lightgrey;
                }

        /* Welcome Box */
        .welcome-box {
            background-color: white;
            margin: 25px 30px 10px 30px;
            padding: 20px 25px;
            border-radius: 8px;
            border-left: 5px solid darkslateblue;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

            .welcome-box h2 {
                margin: 0 0 5px 0;
                color: darkslateblue;
                font-size: 22px;
            }

            .welcome-box p {
                margin: 0;
                color: #555;
                font-size: 14px;
            }

        /* Info Row */
        .info-row {
            display: flex;
            gap: 15px;
            margin: 15px 30px;
        }

        .info-card {
            background: white;
            border-radius: 8px;
            padding: 14px 20px;
            flex: 1;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            font-size: 14px;
            color: #333;
        }

            .info-card span {
                font-weight: bold;
                color: #c0392b;
            }

        /* Navigation Links */
        .nav-heading {
            margin: 25px 30px 10px 30px;
            font-size: large;
            font-weight: bold;
            color: #333;
            
        }

        .nav-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin: 0 30px 30px 30px;
            
        }

        .nav-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: #333;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            border-top: 4px solid darkslateblue;
            transition: transform 0.15s, box-shadow 0.15s;
        }

            .nav-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 14px rgba(0,0,0,0.12);
                color: darkslateblue;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>EventGlint - Admin Panel</h1>
            <a href="Log.aspx">Logout</a>
        </div>

        <div class="welcome-box">
            <h2>Welcome,
                <asp:Label ID="lbl_AdminName" runat="server" Text=""></asp:Label></h2>
            <!-- <p>You are logged in as
                <asp:Label ID="lbl_Role" runat="server" Text=""></asp:Label></p> -->
        </div>
        
        <div class="nav-heading">Admin Pages</div>

        <div class="nav-grid">
            <a href="Admin/EditAdmins.aspx" class="nav-card">Admins</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditBookedSeats.aspx" class="nav-card">BookedSeats</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditBookings.aspx" class="nav-card">Bookings</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditCities.aspx" class="nav-card">Cities</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditCoupons.aspx" class="nav-card">Coupons</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditEvents.aspx" class="nav-card">Events</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditHalls.aspx" class="nav-card">Halls</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditPayments.aspx" class="nav-card">Payments</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditReviews.aspx" class="nav-card">Reviews</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditSeatCategories.aspx" class="nav-card">SeatCategories</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditSeats.aspx" class="nav-card">Seats</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditShows.aspx" class="nav-card">Shows</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditUsers.aspx" class="nav-card">Users</a>
        </div>
        <div class="nav-grid">
            <a href="Admin/EditVenue.aspx" class="nav-card">Venues</a>
        </div>
    </form>
</body>
</html>
