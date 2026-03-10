<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditEvents.aspx.cs" Inherits="EventGlint.Admin.EditEvents" %>

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
                <h2>Event Form </h2>
                <br />
                <table  border="0" cellpadding="8" style="width:500px; text-align:center">
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_eventid" runat="server" Font-Bold="True" Text="Event ID :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_eventId" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_title" runat="server" Font-Bold="True" Text="Title :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_title" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_eventType" runat="server" Font-Bold="True" Text="Event Type :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_eventType" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_description" runat="server" Font-Bold="True" Text="Description :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_description" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_durationMins" runat="server" Font-Bold="True" Text="Duration Minutes :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_durationMins" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_language" runat="server" Font-Bold="True" Text="Language :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_language" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_genre" runat="server" Font-Bold="True" Text="Genre :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_genre" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_releaseDate" runat="server" Font-Bold="True" Text="Release Date :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_releaseDate" runat="server" TextMode="Date"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_endDate" runat="server" Font-Bold="True" Text="End Date :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_endDate" runat="server" TextMode="Date"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_createdAt" runat="server" Font-Bold="True" Text="Created At :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_createdAt" runat="server" TextMode="DateTime"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_createdBy" runat="server" Font-Bold="True" Text="Created By :"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox CssClass="input" ID="txt_createdBy" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                         <td colspan="2" align="center"> 

                             <asp:Button cssclass="button" ID="btn_bookEvent" runat="server" Font-Bold="True" Text="Book Event" OnClick="btn_bookEvent_Click" />

                        </td>
                    </tr>
                </table>
                

            </center>
        </div>
        <br />
        <br />
        <br />

        <div>

            <asp:GridView ID="gv_event" runat="server" align="center" CellPadding="3" GridLines="Horizontal" AutoGenerateDeleteButton="True" AutoGenerateSelectButton="True" HorizontalAlign="Center" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" OnRowDeleting="gv_event_RowDeleting" OnSelectedIndexChanged="gv_event_SelectedIndexChanged">
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
