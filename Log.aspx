<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Log.aspx.cs" Inherits="EventGlint.Log" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login</title>
    <link href="Log.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">

            <div class="login-card">

                <!-- LEFT SIDE -->
                <div class="login-left">
                    <h2>Login</h2>

                    <asp:Label ID="lbl_Message" runat="server" CssClass="lbl_msg"></asp:Label>


                    <asp:TextBox ID="txt_Username" runat="server" CssClass="input-box"
                        Placeholder="Username"></asp:TextBox>

                    <asp:TextBox ID="txt_Password" runat="server" CssClass="input-box"
                        TextMode="Password" Placeholder="Password"></asp:TextBox>


                    <asp:Button ID="btn_Login" runat="server" Text="Login" CssClass="btn-login" OnClick="btn_Login_Click" />

                    <p class="signup-text">
                        Don't have an account?
                        <asp:LinkButton ID="lnkSignup" runat="server" PostBackUrl="~/reg.aspx">Sign Up</asp:LinkButton>
                    </p>

                </div>

                <!-- RIGHT SIDE -->
                <div class="login-right">
                    <h1>WELCOME<br />
                        BACK!</h1>
                    <p>
                        We are happy to have you with us again.
                        If you need anything, we are here to help.
                    </p>
                </div>

            </div>

        </div>
        
    </form>



</body>
</html>

