<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditBookings.aspx.cs" Inherits="EventGlint.Admin.EditBookings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Booking Form</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        .form-container {
            width: 500px;
            margin: 60px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .input {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

            .input:focus {
                border-color: #5f5d5b;
                outline: none;
            }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 10px;
        }

        .button {
            padding: 8px 18px;
            border: 1px;
            border-radius: 5px;
            background-color: darkslateblue;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }

            .button:hover {
                background-color: white;
                color: darkslateblue;
                border: 1px solid darkslateblue;
            }

        h2 {
            text-align: center;
            color: darkslateblue;
            margin-bottom: 20px;
        }
    </style>

</head>

<body>
    <form id="form1" runat="server">
        <div class="form-container">



            <h2>Booking Form</h2>

            <table>

                <tr>
                    <td>BookingId</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtBookingId" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                            ControlToValidate="txtBookingId"
                            ErrorMessage="Required" ForeColor="Red">
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td>UserId</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtUserId" runat="server"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Show Name</td>
                    <td>
                        <asp:DropDownList CssClass="input" ID="ddlShowId" runat="server">
                            <asp:ListItem Value="1">hello</asp:ListItem>
                            <asp:ListItem Value="2">welcome</asp:ListItem>
                            <asp:ListItem Value="3">fun</asp:ListItem>
                            <asp:ListItem Value="4">active</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>BookingDate</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtBookingDate" runat="server" TextMode="Date"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>TotalAmount</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtTotalAmount" runat="server"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>DiscountAmount</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtDiscountAmount" runat="server"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>FinalAmount</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtFinalAmount" runat="server"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Status</td>
                    <td>
                        <asp:RadioButtonList ID="rblStatus" runat="server">
                            <asp:ListItem>Confirmed</asp:ListItem>
                            <asp:ListItem>Pending</asp:ListItem>
                            <asp:ListItem>Cancelled</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>

                <tr>
                    <td>BookingRef</td>
                    <td>
                        <asp:TextBox CssClass="input" ID="txtBookingRef" runat="server"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Coupon Name</td>
                    <td>
                        <asp:DropDownList CssClass="input" ID="ddlCouponId" runat="server">
                            <asp:ListItem Value="1">EVENT10%</asp:ListItem>
                            <asp:ListItem Value="6">EVENT15%</asp:ListItem>
                            <asp:ListItem Value="8">EVENT11!!</asp:ListItem>
                            <asp:ListItem Value="2">HURRYYUPPP</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                        <asp:Button CssClass="button" ID="btnInsert" runat="server" Text="Book" OnClick="btnInsert_Click" />
                        <asp:Button CssClass="button" ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />
                    </td>
                </tr>

            </table>
        </div>

        <asp:GridView ID="GridView11" runat="server"
            AutoGenerateDeleteButton="True"
            AutoGenerateSelectButton="True"
            DataKeyNames="BookingId"
            OnSelectedIndexChanged="GridView11_SelectedIndexChanged"
            OnRowDeleting="GridView11_RowDeleting"
            BackColor="White"
            BorderColor="#E7E7FF"
            BorderStyle="None"
            BorderWidth="1px"
            CellPadding="3"
            GridLines="Horizontal" HorizontalAlign="Center" Width="70%">
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



    </form>


</body>
</html>

