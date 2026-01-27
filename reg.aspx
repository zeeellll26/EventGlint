<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reg.aspx.cs" Inherits="EventGlint.reg" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Register</title>
    <link href="reg.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">

            <div class="login-card">

                <!-- LEFT PANEL -->
                <div class="register-left">
                    <h1>WELCOME!</h1>
                    <p>
                        We're delighted to have you here.
                        If you need any assistance,
                        feel free to reach out.
                    </p>
                </div>

                <!-- RIGHT PANEL -->
                <div class="register-right">
                    <h2>Register</h2>

                    <asp:TextBox ID="txt_Username" runat="server"
                        CssClass="input-box" Placeholder="Username"></asp:TextBox>

                    <asp:TextBox ID="txt_Email" runat="server"
                        CssClass="input-box" Placeholder="Email"></asp:TextBox>

                    <asp:TextBox ID="txt_Password" runat="server"
                        CssClass="input-box" TextMode="Password"
                        Placeholder="Password"></asp:TextBox>

                    <asp:Button ID="btn_Register" runat="server"
                        Text="Register" CssClass="btn-login" OnClick="btn_Register_Click" />

                    <p class="signup-text">
                        Already have an account?
                        <asp:LinkButton ID="lnkSignin" runat="server" PostBackUrl="~/Log.aspx">Sign In</asp:LinkButton>
                    </p>
                </div>

            </div>

        </div>
    </form>
</body>
</html>

