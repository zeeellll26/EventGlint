<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="regi.aspx.cs" Inherits="EventGlint.regi" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="regi.css" rel="stylesheet" />
</head>
<body>
    

    <div class="main-container">
        <h2 class="animation" style="--li: 17; --s: 0">Register</h2>
        <div class="form-box Register">
            <form runat="server">
                <div class="input-box animation" style="--li: 18; --s: 1">
                    <!-- <label for="">Username</label> -->
                    <asp:Label ID="lbl_user" runat="server" Text="Username" Style="color: navy"></asp:Label>
                    <!-- <input type="text"/> -->
                    <asp:TextBox ID="txt_user" runat="server"></asp:TextBox>

                    <box-icon type='solid' name='user' color="gray"></box-icon>
                </div>

                <div class="input-box animation" style="--li: 19; --s: 2">
                    <!-- <label for="">Email</label> -->
                    <asp:Label ID="lbl_Email" runat="server" Text="Email" Style="color: navy"></asp:Label>
                    <!-- <input type="email"/> -->
                    <asp:TextBox ID="txt_email" runat="server"></asp:TextBox>

                    <box-icon name='envelope' type='solid' color="gray"></box-icon>
                </div>

                <div class="input-box animation" style="--li: 19; --s: 3">
                    <!-- <label for="">Password</label> -->
                    <asp:Label ID="lbl_pass" runat="server" Text="Password" Style="color: navy"></asp:Label>
                    <!-- <input type="password"/> -->
                    <asp:TextBox ID="txt_pass" runat="server"></asp:TextBox>

                    <box-icon name='lock-alt' type='solid' color="gray"></box-icon>
                </div>

                <div class="input-box animation" style="--li: 20; --s: 4">
                    <asp:Button ID="btn_register" runat="server" Text="Register" OnClick="btn_register_Click" />
                    <!-- <button class="btn" type="submit">Register</button> -->
                </div>

                <div class="regi-link animation" style="--li: 21; --s: 5">
                    <p style="color: black">
                        Already have an account?
            <br />
                        <a href="#" class="SignInLink">Sign In</a>
                    </p>
                </div>
            </form>
        </div>

    <div class="info-content Register">
        <h2 class="animation" style="--li: 17; --s: 0">WELCOME!</h2>
        <p class="animation" style="--li: 18; --s: 1">We’re delighted to have you here. If you need any assistance, feel free to reach out.</p>
    </div>
    </div>


</body>
</html>

