using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Xml.Linq;

// ══════════════════════════════════════════════════════════════════
//  EditPayments
// ══════════════════════════════════════════════════════════════════
namespace EventGlint.Admin
{
    public partial class EditPayments : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) { BindDropdowns(); LoadGrid(); }
        }
        private void BindDropdowns()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT BookingId, BookingRef + ' (Rs.' + CAST(FinalAmount AS NVARCHAR) + ')' AS Label FROM Bookings ORDER BY BookingId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlBookingId.DataSource = dt; ddlBookingId.DataValueField = "BookingId"; ddlBookingId.DataTextField = "Label"; ddlBookingId.DataBind();
                    ddlBookingId.Items.Insert(0, new ListItem("-- Select Booking --", ""));
                }
            }
            catch { ddlBookingId.Items.Insert(0, new ListItem("-- Error --", "")); }
        }
        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"SELECT p.PaymentId, b.BookingRef, p.Amount, p.PaymentMethod, p.Gateway, p.Status, p.PaidAt FROM Payments p JOIN Bookings b ON b.BookingId=p.BookingId ORDER BY p.PaymentId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvData.DataSource = dt; gvData.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }
        private string GetPaymentMethod() { if (rbCC.Checked) return "CreditCard"; if (rbDC.Checked) return "DebitCard"; if (rbUPI.Checked) return "UPI"; if (rbNB.Checked) return "NetBanking"; if (rbWallet.Checked) return "Wallet"; if (rbCOD.Checked) return "COD"; return ""; }
        private string GetGateway() { if (rbRazorpay.Checked) return "Razorpay"; if (rbStripe.Checked) return "Stripe"; if (rbPayU.Checked) return "PayU"; return ""; }
        private void SetPaymentMethod(string m) { rbCC.Checked = m == "CreditCard"; rbDC.Checked = m == "DebitCard"; rbUPI.Checked = m == "UPI"; rbNB.Checked = m == "NetBanking"; rbWallet.Checked = m == "Wallet"; rbCOD.Checked = m == "COD"; }
        private void SetGateway(string g) { rbRazorpay.Checked = g == "Razorpay"; rbStripe.Checked = g == "Stripe"; rbPayU.Checked = g == "PayU"; }
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Payments(BookingId,Amount,PaymentMethod,Gateway,GatewayTxnId,Status,PaidAt,RefundedAt,RefundAmount) VALUES(@bid,@amt,@pm,@gw,@txn,@st,@pa,@ra,@raft)", con);
                    SetParams(cmd); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Payment inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtPaymentId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Payments SET BookingId=@bid,Amount=@amt,PaymentMethod=@pm,Gateway=@gw,GatewayTxnId=@txn,Status=@st,PaidAt=@pa,RefundedAt=@ra,RefundAmount=@raft WHERE PaymentId=@id", con);
                    SetParams(cmd); cmd.Parameters.AddWithValue("@id", int.Parse(txtPaymentId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Payment updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }
        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@bid", int.Parse(ddlBookingId.SelectedValue));
            cmd.Parameters.AddWithValue("@amt", decimal.Parse(txtAmount.Text));
            cmd.Parameters.AddWithValue("@pm", GetPaymentMethod());
            cmd.Parameters.AddWithValue("@gw", GetGateway());
            cmd.Parameters.AddWithValue("@txn", txtGatewayTxnId.Text.Trim());
            cmd.Parameters.AddWithValue("@st", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@pa", string.IsNullOrEmpty(txtPaidAt.Text) ? (object)DBNull.Value : DateTime.Parse(txtPaidAt.Text));
            cmd.Parameters.AddWithValue("@ra", string.IsNullOrEmpty(txtRefundedAt.Text) ? (object)DBNull.Value : DateTime.Parse(txtRefundedAt.Text));
            cmd.Parameters.AddWithValue("@raft", string.IsNullOrEmpty(txtRefundAmount.Text) ? (object)DBNull.Value : decimal.Parse(txtRefundAmount.Text));
        }
        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }
        protected void gvData_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Payments WHERE PaymentId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtPaymentId.Text = r["PaymentId"].ToString();
                        ddlBookingId.SelectedValue = r["BookingId"].ToString();
                        txtAmount.Text = r["Amount"].ToString();
                        SetPaymentMethod(r["PaymentMethod"].ToString());
                        SetGateway(r["Gateway"].ToString());
                        txtGatewayTxnId.Text = r["GatewayTxnId"].ToString();
                        ddlStatus.SelectedValue = r["Status"].ToString();
                        if (r["PaidAt"] != DBNull.Value) txtPaidAt.Text = Convert.ToDateTime(r["PaidAt"]).ToString("yyyy-MM-ddTHH:mm");
                        if (r["RefundedAt"] != DBNull.Value) txtRefundedAt.Text = Convert.ToDateTime(r["RefundedAt"]).ToString("yyyy-MM-ddTHH:mm");
                        if (r["RefundAmount"] != DBNull.Value) txtRefundAmount.Text = r["RefundAmount"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM Payments WHERE PaymentId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ Payment deleted!", true); ClearFields(); LoadGrid();
            }
        }
        private void ClearFields() { txtPaymentId.Text = txtAmount.Text = txtGatewayTxnId.Text = txtPaidAt.Text = txtRefundedAt.Text = txtRefundAmount.Text = ""; ddlBookingId.SelectedIndex = 0; ddlStatus.SelectedIndex = 0; rbCC.Checked = rbDC.Checked = rbUPI.Checked = rbNB.Checked = rbWallet.Checked = rbCOD.Checked = rbRazorpay.Checked = rbStripe.Checked = rbPayU.Checked = false; }
        private bool Validate() { if (string.IsNullOrEmpty(ddlBookingId.SelectedValue)) { ShowMessage("⚠️ Select Booking.", false); return false; } if (string.IsNullOrEmpty(txtAmount.Text)) { ShowMessage("⚠️ Amount required.", false); return false; } if (string.IsNullOrEmpty(GetPaymentMethod())) { ShowMessage("⚠️ Select Payment Method.", false); return false; } if (string.IsNullOrEmpty(ddlStatus.SelectedValue)) { ShowMessage("⚠️ Select Status.", false); return false; } return true; }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}