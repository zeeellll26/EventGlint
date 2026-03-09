<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="EventGlint.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
        }

        /* ── Header ── */
        .header {
            background-color: darkslateblue;
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
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .header-right span {
            font-size: 14px;
        }
        .header a {
            color: white;
            text-decoration: none;
            background-color: #922b21;
            padding: 7px 16px;
            border-radius: 5px;
            font-size: 14px;
        }
        .header a:hover {
            background-color: #7b241c;
        }

        /* ── Welcome Box ── */
        .welcome-box {
            background-color: white;
            margin: 25px 30px 10px 30px;
            padding: 20px 25px;
            border-radius: 8px;
            border-left: 5px solid #c0392b;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }
        .welcome-box h2 {
            margin: 0 0 5px 0;
            color: #c0392b;
            font-size: 22px;
        }
        .welcome-box p {
            margin: 0;
            color: #555;
            font-size: 14px;
        }
        /* Footer */
        .footer {
            background-color: #2c3e50;
            color: #aaa;
            text-align: center;
            padding: 15px;
            font-size: 13px;
            margin-top: 10px;
        }
    </style>
    <title>EventGlint | Home</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>EventGlint</h1>
            <div class="header-right">
                <span>Hello, <b>
                    <asp:Label ID="lbl_Username" runat="server" /></b></span>
                <!-- <a href="MyBookings.aspx">My Bookings</a> -->
                <a href="Login.aspx">Logout</a>
            </div>
        </div>
        <div class="welcome-box">
            <h2>Welcome,
                    <asp:Label ID="lbl_WelcomeName" runat="server" />
            </h2>
            <p>
                Find and book tickets for movies, concerts, sports and more in <b>
                    <asp:Label ID="lbl_City" runat="server" /></b>.
            </p>
        </div>


        <div class="footer">
            © 2026 EventGlide. All rights reserved. Surat, Gujarat
        </div>
    </form>
</body>
</html>
