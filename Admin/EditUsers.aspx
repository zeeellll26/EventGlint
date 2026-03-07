<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditUsers.aspx.cs" Inherits="EventGlint.Admin.EditUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Users</title>
    
</head>
<body>
    <h1 align="center" style="color: darkslateblue">Edit Users</h1>
    <br />
    <br />
    <form id="form1" runat="server">
        <div>
            <table border="1" cellpadding="8" align="center" style="width:40%">
                <tr>
                    <td>
                        <asp:Label ID="lbl_UserId" runat="server" Text="User ID:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_UserId" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_Username" runat="server" Text="Username:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Username" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_Email" runat="server" Text="Email:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Email" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_Phone" runat="server" Text="Phone:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Phone" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_Password" runat="server" Text="Password:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Password" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_ProfilePic" runat="server" Text="Profile Pic:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_ProfilePic" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_DateOfBirth" runat="server" Text="Date of Birth:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_DateOfBirth" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_City" runat="server" Text="City:"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddl_City" runat="server"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_CreatedAt" runat="server" Text="Created At:"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_CreatedAt" runat="server"></asp:TextBox>
                    </td>
                </tr>

            </table>
        </div>
    </form>
</body>
</html>
