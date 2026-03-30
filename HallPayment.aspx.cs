using System;
using System.Data;
using System.Data.SqlClient;

namespace EventGlint
{
    public partial class HallPayment : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager
                                      .ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("Log.aspx"); return; }
            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadBookingDetails();
            }
        }

        private void LoadUserInfo()
        {
            string u = Session["Username"].ToString();
            lblUserName.Text = u;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = u.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = u.Substring(0, 1).ToUpper();
        }

        private void LoadBookingDetails()
        {
            // Load from Session (set in BookHall.aspx.cs)
            lblBookingRef.Text = Session["HallBookingRef"] != null ? Session["HallBookingRef"].ToString() : "—";
            lblPurpose.Text = Session["HallPurpose"] != null ? Session["HallPurpose"].ToString() : "—";
            lblGuests.Text = Session["HallGuests"] != null ? Session["HallGuests"].ToString() + " guests" : "—";

            int days = Session["HallDays"] != null ? Convert.ToInt32(Session["HallDays"]) : 1;
            lblDuration.Text = days + (days == 1 ? " day" : " days");

            int bookingId = Session["HallBookingId"] != null ? Convert.ToInt32(Session["HallBookingId"]) : 0;
            if (bookingId == 0) { Response.Redirect("Hall.aspx"); return; }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        b.TotalAmount, b.DiscountAmount, b.FinalAmount,
                        sh.ShowDate,
                        h.Name  AS HallName,
                        v.Name  AS VenueName
                    FROM  Bookings b
                    JOIN  Shows  sh ON sh.ShowId = b.ShowId
                    JOIN  Halls   h ON h.HallId  = sh.HallId
                    JOIN  Venues  v ON v.VenueId = h.VenueId
                    WHERE b.BookingId = @id", con);
                cmd.Parameters.AddWithValue("@id", bookingId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Hall.aspx"); return; }

                DataRow r = dt.Rows[0];
                decimal subtotal = Convert.ToDecimal(r["TotalAmount"]);
                decimal discount = Convert.ToDecimal(r["DiscountAmount"]);
                decimal finalAmt = Convert.ToDecimal(r["FinalAmount"]);
                decimal fee = finalAmt - subtotal + discount;

                lblHall.Text = r["HallName"].ToString();
                lblVenue.Text = r["VenueName"].ToString();
                lblDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy");
                lblSubtotal.Text = subtotal.ToString("N0");
                lblFee.Text = fee.ToString("N0");
                lblDiscount.Text = discount.ToString("N0");
                lblTotal.Text = finalAmt.ToString("N0");
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            int bookingId = Session["HallBookingId"] != null ? Convert.ToInt32(Session["HallBookingId"]) : 0;
            if (bookingId == 0) { ShowMessage("Booking not found.", false); return; }

            string payMethod = Request.Form["hdnPayMethod"] ?? "UPI";
            string txnId = "HTXN" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlTransaction tx = con.BeginTransaction();
                    try
                    {
                        // Get FinalAmount
                        SqlCommand cmdAmt = new SqlCommand(
                            "SELECT FinalAmount FROM Bookings WHERE BookingId = @id", con, tx);
                        cmdAmt.Parameters.AddWithValue("@id", bookingId);
                        decimal finalAmount = Convert.ToDecimal(cmdAmt.ExecuteScalar());

                        // Insert into Payments
                        SqlCommand cmdPay = new SqlCommand(@"
                            INSERT INTO Payments
                                (BookingId, Amount, PaymentMethod, Gateway, GatewayTxnId, Status, PaidAt)
                            VALUES
                                (@bookingId, @amount, @method, 'Internal', @txnId, 'Success', GETDATE())",
                            con, tx);
                        cmdPay.Parameters.AddWithValue("@bookingId", bookingId);
                        cmdPay.Parameters.AddWithValue("@amount", finalAmount);
                        cmdPay.Parameters.AddWithValue("@method", payMethod);
                        cmdPay.Parameters.AddWithValue("@txnId", txnId);
                        cmdPay.ExecuteNonQuery();

                        tx.Commit();
                    }
                    catch { tx.Rollback(); throw; }
                }

                string bookingRef = Session["HallBookingRef"] != null ? Session["HallBookingRef"].ToString() : "";
                Response.Redirect("BookHallConfirm.aspx?ref=" + bookingRef);
            }
            catch (Exception ex)
            {
                ShowMessage("Payment failed: " + ex.Message, false);
            }
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = $"<div class='msg-box {(success ? "msg-success" : "msg-error")}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
}