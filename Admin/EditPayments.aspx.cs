using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
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

        // LOAD GRIDVIEW
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
            con.Open();

            SqlCommand cmd = new SqlCommand(@"INSERT INTO Payments
                    (BookingId,Amount,PaymentMethod,Gateway,GatewayTxnId,Status,PaidAt,RefundedAt,RefundAmount)VALUES
                    (@BookingId,@Amount,@PaymentMethod,@Gateway,@GatewayTxnId,@Status,@PaidAt,@RefundedAt,@RefundAmount)", con);

            cmd.Parameters.AddWithValue("@BookingId", ddlBookingId.SelectedValue);
            cmd.Parameters.AddWithValue("@Amount", string.IsNullOrEmpty(txtAmount.Text) ? 0 : Convert.ToDecimal(txtAmount.Text));
            cmd.Parameters.AddWithValue("@PaymentMethod", rblPaymentMethod.SelectedValue);
            cmd.Parameters.AddWithValue("@Gateway", ddlGateway.SelectedValue);
            cmd.Parameters.AddWithValue("@GatewayTxnId", txtGatewayTxnId.Text);
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@PaidAt", string.IsNullOrEmpty(txtPaidAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtPaidAt.Text));
            cmd.Parameters.AddWithValue("@RefundedAt", string.IsNullOrEmpty(txtRefundedAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtRefundedAt.Text));
            cmd.Parameters.AddWithValue("@RefundAmount", string.IsNullOrEmpty(txtRefundAmount.Text) ? 0 : Convert.ToDecimal(txtRefundAmount.Text));

            cmd.ExecuteNonQuery();
            con.Close();
            Response.Write("inserted successfully!!");
            LoadPayments();
        }

        // SELECT FROM GRIDVIEW
        protected void gvPayments_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvPayments.SelectedRow;

            txtPaymentId.Text = row.Cells[1].Text;
            ddlBookingId.SelectedValue = row.Cells[2].Text;
            txtAmount.Text = row.Cells[3].Text;
            rblPaymentMethod.SelectedValue = row.Cells[4].Text;
            ddlGateway.SelectedValue = row.Cells[5].Text;
            txtGatewayTxnId.Text = row.Cells[6].Text;
            ddlStatus.SelectedValue = row.Cells[7].Text;
            txtPaidAt.Text = row.Cells[8].Text;
            txtRefundedAt.Text = row.Cells[9].Text;
            txtRefundAmount.Text = row.Cells[10].Text;
        }

        // UPDATE
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"UPDATE Payments SET
                    BookingId=@BookingId,
                    Amount=@Amount,
                    PaymentMethod=@PaymentMethod,
                    Gateway=@Gateway,
                    GatewayTxnId=@GatewayTxnId,
                    Status=@Status,
                    PaidAt=@PaidAt,
                    RefundedAt=@RefundedAt,
                    RefundAmount=@RefundAmount
                    WHERE PaymentId=@PaymentId", con);

            cmd.Parameters.AddWithValue("@PaymentId", txtPaymentId.Text);
            cmd.Parameters.AddWithValue("@BookingId", ddlBookingId.SelectedValue);
            cmd.Parameters.AddWithValue("@Amount", string.IsNullOrEmpty(txtAmount.Text) ? 0 : Convert.ToDecimal(txtAmount.Text));
            cmd.Parameters.AddWithValue("@PaymentMethod", rblPaymentMethod.SelectedValue);
            cmd.Parameters.AddWithValue("@Gateway", ddlGateway.SelectedValue);
            cmd.Parameters.AddWithValue("@GatewayTxnId", txtGatewayTxnId.Text);
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@PaidAt",
                string.IsNullOrEmpty(txtPaidAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtPaidAt.Text));

            cmd.Parameters.AddWithValue("@RefundedAt",
                string.IsNullOrEmpty(txtRefundedAt.Text) ? DBNull.Value : (object)Convert.ToDateTime(txtRefundedAt.Text));

            cmd.Parameters.AddWithValue("@RefundAmount", string.IsNullOrEmpty(txtRefundAmount.Text) ? 0 : Convert.ToDecimal(txtRefundAmount.Text));

            cmd.ExecuteNonQuery();
            LoadPayments();
            Response.Write("updated successfully!");
            con.Close();

        }

        // DELETE
        protected void gvPayments_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvPayments.DataKeys[e.RowIndex].Value);

            con.Open();

            SqlCommand cmd = new SqlCommand("DELETE FROM Payments WHERE PaymentId=@id", con);
            cmd.Parameters.AddWithValue("@id", id);

            cmd.ExecuteNonQuery();
            LoadPayments();
            Response.Write("deleted successfully!");
            con.Close();

        }

    }
}
