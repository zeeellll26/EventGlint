<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="des.aspx.cs" Inherits="EventGlint.des" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="des.css" rel="stylesheet" />
</head>
<body>

    <div class="container">
        <div class="form-box Login">
             <h2 class="animation" style="--D:0; --S:21">Login</h2>
            <form id="form1" runat="server">
                <div class="input-box animation" style="--D:1; --S:22">
                    <asp:Label style="color:black" ID="userlb" runat="server" Font-Bold="False" Text="USERNAME"></asp:Label>
                    <br />
                    <asp:TextBox ID="usertxt" runat="server"></asp:TextBox>
                     <box-icon type='solid' name='user' color="gray"></box-icon>
                </div>

                 <div class="input-box animation" style="--D:2; --S:23">
                     <asp:Label style="color:black" ID="passlb" runat="server" Font-Bold="False" Text="PASSWORD"></asp:Label>
                     <br />
                     <asp:TextBox ID="passtxt" runat="server"></asp:TextBox>
                      <box-icon type='solid' name='user' color="gray"></box-icon>
                 </div>
                <br />
                <br />

                 <div class="input-box animation" style="--D:3; --S:24">
                     <asp:Button class="btn" ID="logbtn" runat="server" Font-Bold="True" Text="LOG IN" />
                 </div>


                 <div class="regi-link animation" style="--D:4; --S:25">
                     <p style="color:black">Don't have an account? <br/> <a href="regi.aspx" class="SignUpLink">Sign Up</a></p>
                 </div>

            </form>
        </div>


        <div class="yashvi">
             <h2 class="animation" style="--D:0; --S:20;color:darkblue">WELCOME BACK!</h2>
             <p class="animation" style="--D:1; --S:21;color:black">We are happy to have you with us again. If
                 <br />
                 you need anything, we are here to help.</p>
        </div>

       
              
</div>
    
</body>
</html>
