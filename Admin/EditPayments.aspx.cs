using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditPayments : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPayments();
            }
        }

        void LoadPayments()
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Payments", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvPayments.DataSource = dt;
            gvPayments.DataBind();
        }

        // INSERT
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"INSERT INTO Payments
                    (BookingId, Amount, PaymentMethod, Gateway, Status, PaidAt, RefundedAt, RefundAmount)
                    VALUES
                    (@BookingId, @Amount, @PaymentMethod, @Gateway, @Status, @PaidAt, @RefundedAt, @RefundAmount)", con);

                cmd.Parameters.AddWithValue("@BookingId", txtBooking.Text.Trim());
                cmd.Parameters.AddWithValue("@Amount", string.IsNullOrEmpty(txtAmount.Text) ? 0 : Convert.ToDecimal(txtAmount.Text));
                cmd.Parameters.AddWithValue("@PaymentMethod", rblPaymentMethod.SelectedValue);
                cmd.Parameters.AddWithValue("@Gateway", rbt_gate.SelectedValue);
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@PaidAt", string.IsNullOrEmpty(txtPaidAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtPaidAt.Text));
                cmd.Parameters.AddWithValue("@RefundedAt", string.IsNullOrEmpty(txtRefundedAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtRefundedAt.Text));
                cmd.Parameters.AddWithValue("@RefundAmount", string.IsNullOrEmpty(txtRefundAmount.Text) ? 0 : Convert.ToDecimal(txtRefundAmount.Text));

                cmd.ExecuteNonQuery();
            }
            finally
            {
                con.Close();
            }

            LoadPayments();
            ClearForm();
            ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Inserted successfully!');", true);
        }

        // SELECT INTO FORM
        protected void gvPayments_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvPayments.SelectedRow;

            txtBooking.Text = row.Cells[2].Text;
            txtAmount.Text = row.Cells[3].Text;
            rblPaymentMethod.SelectedValue = row.Cells[4].Text;
            rbt_gate.SelectedValue = row.Cells[5].Text;
            ddlStatus.SelectedValue = row.Cells[6].Text;
            txtPaidAt.Text = FormatDateForInput(row.Cells[7].Text);
            txtRefundedAt.Text = FormatDateForInput(row.Cells[8].Text);
            txtRefundAmount.Text = row.Cells[9].Text;

        }
        private string FormatDateForInput(string rawDate)
        {
            if (string.IsNullOrWhiteSpace(rawDate) || rawDate == "&nbsp;")
                return "";

            DateTime dt;
            if (DateTime.TryParse(rawDate, out dt))
                return dt.ToString("yyyy-MM-ddTHH:mm");  // Required format for DateTimeLocal

            return "";
        }

        // UPDATE
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (gvPayments.SelectedIndex == -1)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Please select a row to update.');", true);
                return;
            }

            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"UPDATE Payments SET
                    BookingId       = @BookingId,
                    Amount          = @Amount,
                    PaymentMethod   = @PaymentMethod,
                    Gateway         = @Gateway,
                    Status          = @Status,
                    PaidAt          = @PaidAt,
                    RefundedAt      = @RefundedAt,
                    RefundAmount    = @RefundAmount
                    WHERE PaymentId = @PaymentId", con);

                int payId = Convert.ToInt32(gvPayments.DataKeys[gvPayments.SelectedIndex].Value);

                cmd.Parameters.AddWithValue("@PaymentId", payId);
                cmd.Parameters.AddWithValue("@BookingId", txtBooking.Text.Trim());   // ✅ Fixed: was txtBooking (object)
                cmd.Parameters.AddWithValue("@Amount", string.IsNullOrEmpty(txtAmount.Text) ? 0 : Convert.ToDecimal(txtAmount.Text));
                cmd.Parameters.AddWithValue("@PaymentMethod", rblPaymentMethod.SelectedValue);
                cmd.Parameters.AddWithValue("@Gateway", rbt_gate.SelectedValue);   // ✅ Fixed: was ddlGateway (doesn't exist)
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@PaidAt", string.IsNullOrEmpty(txtPaidAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtPaidAt.Text));
                cmd.Parameters.AddWithValue("@RefundedAt", string.IsNullOrEmpty(txtRefundedAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtRefundedAt.Text));
                cmd.Parameters.AddWithValue("@RefundAmount", string.IsNullOrEmpty(txtRefundAmount.Text) ? 0 : Convert.ToDecimal(txtRefundAmount.Text));

                cmd.ExecuteNonQuery();
            }
            finally
            {
                con.Close();  // ✅ Fixed: now always closes
            }

            LoadPayments();
            ClearForm();
            ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Updated successfully!');", true);
        }

        // DELETE
        protected void gvPayments_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvPayments.DataKeys[e.RowIndex].Value);

            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Payments WHERE PaymentId=@id", con);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                con.Close();  // ✅ Fixed: now always closes
            }

            LoadPayments();
            ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Deleted successfully!');", true);
        }

        // CLEAR FORM
        void ClearForm()
        {
            txtBooking.Text = "";
            txtAmount.Text = "";
            txtPaidAt.Text = "";
            txtRefundedAt.Text = "";
            txtRefundAmount.Text = "";
            rblPaymentMethod.ClearSelection();
            rbt_gate.ClearSelection();
            ddlStatus.SelectedIndex = 0;
        }
    }
}
