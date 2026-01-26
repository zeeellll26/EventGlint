<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EventGlint.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <!-- <title>Animated Login &amp; Register Form</title> -->
    <link href="Login.css" rel="stylesheet" />
    <!-- -->
</head>
<body>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Login & Signup Form</title>
        <link rel="stylesheet" href="Login.css" />

    </head>
    <body>
        <form runat="server" >
        <div class="container">
            <div class="curved-shape"></div>
            <div class="curved-shape2"></div>
            <div class="form-box Login">
                <h2 class="animation" style="--D:0; --S:21">Login</h2>
                <form>
                    <div class="input-box animation" style="--D:1; --S:22">
                        <!-- <label for="">Username</label> -->
                        <asp:Label ID="lbl_username" runat="server" Text="Username" Style="color: navy"></asp:Label>
                        <!-- <input type="text"/> -->
                        <asp:TextBox ID="txt_username" runat="server"></asp:TextBox>
                        <box-icon type='solid' name='user' color="gray"></box-icon>
                    </div>

                    <div class="input-box animation" style="--D:2; --S:23">
                        <!-- <label for="">Username</label> -->
                        <asp:Label ID="lbl_password" runat="server" Text="Password" Style="color: navy"></asp:Label>
                        <!-- <input type="text"/> -->
                        <asp:TextBox ID="txt_password" runat="server"></asp:TextBox>
                        <box-icon name='lock-alt' type='solid' color="gray"></box-icon>
                    </div>

                    <div class="input-box animation" style="--D:3; --S:24">
                        <asp:Button ID="btn_Login" runat="server" Text="Login" OnClick="btn_Login_Click" />
                    </div>

                    <div class="regi-link animation" style="--D:4; --S:25">
                        <p style="color:black">Don't have an account? <br /> <a href="#" class="SignUpLink">Sign Up</a>
                        </p>
                    </div>
                </form>
            </div>

            <div class="info-content Login">
                <h2 class="animation" style="--d: 0; --s: 20">WELCOME BACK!</h2>
                <p class="animation" style="--d: 1; --s: 21">We are happy to have you with us again. If you need anything, we are here to help.</p>
            </div>

            <div class="form-box Register">
                <h2 class="animation" style="--li: 17; --s: 0">Register</h2>
                <form>
                    <div class="input-box animation" style="--li: 18; --s: 1">
                        <!-- <label for="">Username</label> -->
                        <asp:Label ID="lbl_user" runat="server" Text="Username" style="color:navy" ></asp:Label>
                        <!-- <input type="text"/> -->
                        <asp:TextBox ID="txt_user" runat="server"></asp:TextBox>
                        
                        <box-icon type='solid' name='user' color="gray"></box-icon>
                    </div>

                    <div class="input-box animation" style="--li: 19; --s: 2">
                        <!-- <label for="">Email</label> -->
                        <asp:Label ID="lbl_Email" runat="server" Text="Email" style="color:navy"></asp:Label>
                        <!-- <input type="email"/> -->
                        <asp:TextBox ID="txt_email" runat="server"></asp:TextBox>                        
                        
                        <box-icon name='envelope' type='solid' color="gray"></box-icon>
                    </div>

                    <div class="input-box animation" style="--li: 19; --s: 3">
                        <!-- <label for="">Password</label> -->
                        <asp:Label ID="lbl_pass" runat="server" Text="Password" style="color:navy"></asp:Label>
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
        </form>

        <script src="index.js"></script>
        <script src="https://unpkg.com/boxicons@2.1.4/dist/boxicons.js"></script>


    </body>
    </html>
    <script src="script.js"></script>
</body>
</html>
