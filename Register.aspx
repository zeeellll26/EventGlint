<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="EventGlint.Register" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>EventGlint - Sign Up</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="Login.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="logo">
                <div style="font-size: 3rem; background: linear-gradient(135deg, #667eea, #764ba2); line-height: 1;">✓</div>
                <!-- Checkmark icon -->
                <h1>EventGlint</h1>
                <p class="subtext">Sign Up</p>
            </div>
            <div class="mb-3">
                <asp:TextBox ID="txt_Email" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email"></asp:TextBox>
            </div>
            <div class="mb-3">
                <asp:TextBox ID="txt_Password" runat="server" CssClass="form-control" placeholder="Password" TextMode="Password"></asp:TextBox>
            </div>
            <div class="mb-3">
                <asp:TextBox ID="txt_ConfirmPassword" runat="server" CssClass="form-control" placeholder="Confirm Password" TextMode="Password"></asp:TextBox>
            </div>
            <asp:Button ID="btn_Register" runat="server" Text="Register" CssClass="btn btn-primary btn-login mb-3" OnClick="btn_Register_Click" />



            <div class="row g-2 mb-3">
                <div class="col">
                    <button type="button" class="btn social-btn w-100">
                        <img src="https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/facebook.svg" width="20" height="20" alt="Facebook">
                        Sign in with Facebook</button>
                </div>
            </div>
            <div class="row g-2 mb-3">
                <div class="col">
                    <button type="button" class="btn social-btn w-100">
                        <img src="https://cdn.jsdelivr.net/npm/simple-icons@v8/icons/google.svg" width="20" height="20" alt="Google">
                        Sign in with Google</button>
                </div>
            </div>


        </div>
    </form>
</body>
</html>
