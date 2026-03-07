<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCoupons.aspx.cs" Inherits="EventGlint.Admin.EditCoupons" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <center>
            <h1 style="color:darkslateblue">Coupon Form</h1>

            <table border="1" cellpadding="8" style="width:500px">

            <tr>
                <td>Coupon Code</td>
                <td>
                    <asp:TextBox ID="txtCode" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                    ControlToValidate="txtCode"
                    ErrorMessage="Required" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td>Discount Type</td>
                <td>
                    <asp:RadioButtonList ID="rblDiscountType" runat="server">
                        <asp:ListItem Text="Percentage" Value="Percentage"></asp:ListItem>
                        <asp:ListItem Text="Flat" Value="Flat"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>

            <tr>
                <td>Discount Value</td>
                <td>
                    <asp:TextBox ID="txtDiscountValue" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Max Discount</td>
                <td>
                    <asp:TextBox ID="txtMaxDiscount" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Min Order Value</td>
                <td>
                    <asp:TextBox ID="txtMinOrderValue" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Valid From</td>
                <td>
                    <asp:TextBox ID="txtValidFrom" runat="server" TextMode="Date"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Valid Till</td>
                <td>
                    <asp:TextBox ID="txtValidTill" runat="server" TextMode="Date"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Usage Limit</td>
                <td>
                    <asp:TextBox ID="txtUsageLimit" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Used Count</td>
                <td>
                    <asp:TextBox ID="txtUsedCount" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Created At</td>
                <td>
                    <asp:TextBox ID="txtCreatedAt" runat="server" TextMode="DateTime"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Active Coupon</td>
                <td>
                    <asp:CheckBox ID="chkActive" runat="server" Text="Active"></asp:CheckBox>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <asp:Button ID="btnSave" runat="server" Text="Save Coupon" />
                </td>
            </tr>

            </table>
            </center>
        </div>
    </form>
</body>
</html>
