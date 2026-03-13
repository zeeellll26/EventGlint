<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditPayments.aspx.cs" Inherits="EventGlint.Admin.EditPayments" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Payment Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .form-container {
            width: 520px;
            margin: 60px auto 40px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: darkslateblue;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 10px;
            font-size: 14px;
        }

        .input {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 14px;
            box-sizing: border-box;
        }

        .input:focus {
            border-color: darkslateblue;
            outline: none;
        }

        .button {
            padding: 8px 20px;
            border-radius: 5px;
            border: none;
            background-color: darkslateblue;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }

        .button:hover {
            background: white;
            color: darkslateblue;
            border: 1px solid darkslateblue;
        }

        /* ✅ GridView full width outside form */
        .grid-container {
            width: 90%;
            margin: 0 auto 60px auto;
            overflow-x: auto;
        }
    </style>
</head>
<body>

<form id="form1" runat="server">

    <!-- ✅ Centered Form Box -->
    <div class="form-container">
        <h2>Payment Form</h2>
        <table>
            <tr>
                <td>Booking ID</td>
                <td><asp:TextBox CssClass="input" ID="txtBooking" runat="server" /></td>
            </tr>
            <tr>
                <td>Amount</td>
                <td><asp:TextBox CssClass="input" ID="txtAmount" runat="server" /></td>
            </tr>
            <tr>
                <td>Payment Method</td>
                <td>
                    <asp:RadioButtonList ID="rblPaymentMethod" runat="server">
                        <asp:ListItem Text="CreditCard" Value="CreditCard" />
                        <asp:ListItem Text="DebitCard"  Value="DebitCard" />
                        <asp:ListItem Text="UPI"        Value="UPI" />
                        <asp:ListItem Text="COD"        Value="COD" />
                        <asp:ListItem Text="NetBanking" Value="NetBanking" />
                        <asp:ListItem Text="Wallet"     Value="Wallet" />
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td>Gateway</td>
                <td>
                    <asp:RadioButtonList ID="rbt_gate" runat="server">
                        <asp:ListItem Text="Razorpay" Value="Razorpay" />
                        <asp:ListItem Text="Stripe"   Value="Stripe" />
                        <asp:ListItem Text="PayU"     Value="PayU" />
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td>Status</td>
                <td>
                    <asp:DropDownList CssClass="input" ID="ddlStatus" runat="server">
                        <asp:ListItem Text="-- Select Status --" Value="" />
                        <asp:ListItem Text="Initiated" Value="Initiated" />
                        <asp:ListItem Text="Success"   Value="Success" />
                        <asp:ListItem Text="Failed"    Value="Failed" />
                        <asp:ListItem Text="Refunded"  Value="Refunded" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>Paid At</td>
                <td><asp:TextBox CssClass="input" ID="txtPaidAt" runat="server" TextMode="DateTimeLocal" /></td>
            </tr>
            <tr>
                <td>Refunded At</td>
                <td><asp:TextBox CssClass="input" ID="txtRefundedAt" runat="server" TextMode="DateTimeLocal" /></td>
            </tr>
            <tr>
                <td>Refund Amount</td>
                <td><asp:TextBox CssClass="input" ID="txtRefundAmount" runat="server" /></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Button CssClass="button" ID="btnInsert" runat="server" Text="Payment" OnClick="btnInsert_Click" />
                    &nbsp;
                    <asp:Button CssClass="button" ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />
                </td>
            </tr>
        </table>
    </div>

    <!-- ✅ GridView OUTSIDE form box, full width -->
    <div class="grid-container">
        <asp:GridView ID="gvPayments" runat="server"
            AutoGenerateDeleteButton="True"
            AutoGenerateSelectButton="True"
            DataKeyNames="PaymentId"
            OnSelectedIndexChanged="gvPayments_SelectedIndexChanged"
            OnRowDeleting="gvPayments_RowDeleting"
            Width="100%"
            BackColor="White"
            BorderColor="#E7E7FF"
            BorderStyle="None"
            BorderWidth="1px"
            CellPadding="3"
            GridLines="Horizontal">
            <AlternatingRowStyle BackColor="#F7F7F7" />
            <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
            <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
            <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
            <SortedAscendingCellStyle BackColor="#F4F4FD" />
            <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
            <SortedDescendingCellStyle BackColor="#D8D8F0" />
            <SortedDescendingHeaderStyle BackColor="#3E3277" />
        </asp:GridView>
    </div>

</form>

</body>
</html>