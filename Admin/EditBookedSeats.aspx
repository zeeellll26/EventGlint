<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditBookedSeats.aspx.cs" Inherits="EventGlint.Admin.EditBookedSeats" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
            text-align:center;
        }

        .input {
/*            width: 100%;*/
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
/*            width: 100%;*/
            border-collapse: collapse;
        }

        td {
            padding: 10px;
            
        }

        .button {
            padding: 8px 18px;
            border: 1px;
            border-radius: 5px;
            background-color:darkslateblue;
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
            <center>
                <h2>Booked Seats</h2>

                <br />
                <table border="0" cellpadding="8" style="width:500px; text-align:center">
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_BookedSeatid" runat="server" Font-Bold="True" Text="Booked Seat ID :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_bookedSeatid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Bookingid" runat="server" Font-Bold="True" Text="Booking ID :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_bookingid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_seatid" runat="server" Font-Bold="True" Text="Seat ID :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_seatid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_showid" runat="server" Font-Bold="True" Text="Show ID : "></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_showid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_pricePaid" runat="server" Font-Bold="True" Text="Price Paid :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_pricePaid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_status" runat="server" Font-Bold="True" Text="Status :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_status" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_heldUnit" runat="server" Font-Bold="True" Text="Held Unit :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_heldUnit" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center"> 

                            <asp:Button CssClass="button" ID="btn_bookSeat" runat="server" BorderStyle="None" Font-Bold="True" Text="BOOK SEAT" OnClick="btn_bookSeat_Click" />

                        </td>
                    </tr>
                </table>
            </center>
        </div>
        <br />
        <br />
        <br />
        <div>

            <asp:GridView ID="gv_bookedSeats" runat="server" align="center" CellPadding="3" GridLines="Horizontal" AutoGenerateDeleteButton="True" AutoGenerateSelectButton="True" HorizontalAlign="Center" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" OnRowDeleting="gv_bookedSeats_RowDeleting" OnSelectedIndexChanged="gv_bookedSeats_SelectedIndexChanged">
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
