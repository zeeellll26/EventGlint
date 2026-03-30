using System;
using System.Data;
using System.Data.SqlClient;

namespace EventGlint
{
    public partial class ShowPayment : System.Web.UI.Page
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
            int bookingId = 0;
            if (!int.TryParse(Request.QueryString["BookingId"], out bookingId))
                bookingId = Session["ShowBookingId"] != null ? Convert.ToInt32(Session["ShowBookingId"]) : 0;
            if (bookingId == 0) { Response.Redirect("Shows.aspx"); return; }

            string bookingRef = Request.QueryString["ref"] ?? Session["ShowBookingRef"]?.ToString() ?? "—";
            lblBookingRef.Text = bookingRef;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT b.TotalAmount, b.DiscountAmount, b.FinalAmount,
                           e.Title, sh.ShowDate, sh.StartTime,
                           h.Name AS HallName, v.Name AS VenueName
                    FROM   Bookings b
                    JOIN   Shows    sh ON sh.ShowId  = b.ShowId
                    JOIN   Events   e  ON e.EventId  = sh.EventId
                    JOIN   Halls    h  ON h.HallId   = sh.HallId
                    JOIN   Venues   v  ON v.VenueId  = h.VenueId
                    WHERE  b.BookingId = @id", con);
                cmd.Parameters.AddWithValue("@id", bookingId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Shows.aspx"); return; }

                DataRow r = dt.Rows[0];
                decimal subtotal = Convert.ToDecimal(r["TotalAmount"]);
                decimal discount = Convert.ToDecimal(r["DiscountAmount"]);
                decimal finalAmt = Convert.ToDecimal(r["FinalAmount"]);
                decimal fee = finalAmt - subtotal + discount;

                lblShow.Text = r["Title"].ToString();
                lblDateTime.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " " + FormatTime(r["StartTime"]);
                lblVenue.Text = r["VenueName"].ToString() + " — " + r["HallName"].ToString();
                lblSeats.Text = Session["ShowSeats"] != null ? Session["ShowSeats"].ToString() : "—";
                lblSubtotal.Text = subtotal.ToString("N0");
                lblFee.Text = fee.ToString("N0");
                lblDiscount.Text = discount.ToString("N0");
                lblTotal.Text = finalAmt.ToString("N0");

                ViewState["BookingId"] = bookingId;
                ViewState["BookingRef"] = bookingRef;
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            int bookingId = ViewState["BookingId"] != null ? Convert.ToInt32(ViewState["BookingId"]) : 0;
            if (bookingId == 0) { ShowMessage("Booking not found."); return; }

            string payMethod = Request.Form["hdnPayMethod"] ?? "UPI";
            string txnId = "STXN" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlTransaction tx = con.BeginTransaction();
                    try
                    {
                        // Get final amount
                        SqlCommand cmdAmt = new SqlCommand("SELECT FinalAmount FROM Bookings WHERE BookingId=@id AND Status='Pending'", con, tx);
                        cmdAmt.Parameters.AddWithValue("@id", bookingId);
                        object amtObj = cmdAmt.ExecuteScalar();
                        if (amtObj == null || amtObj == DBNull.Value)
                        { ShowMessage("Booking already paid or expired."); tx.Rollback(); return; }
                        decimal finalAmount = Convert.ToDecimal(amtObj);

                        // Insert payment
                        SqlCommand cmdPay = new SqlCommand(@"
                            INSERT INTO Payments (BookingId,Amount,PaymentMethod,Gateway,GatewayTxnId,Status,PaidAt)
                            VALUES (@bid,@amt,@method,'Internal',@txn,'Success',GETDATE())", con, tx);
                        cmdPay.Parameters.AddWithValue("@bid", bookingId);
                        cmdPay.Parameters.AddWithValue("@amt", finalAmount);
                        cmdPay.Parameters.AddWithValue("@method", payMethod);
                        cmdPay.Parameters.AddWithValue("@txn", txnId);
                        cmdPay.ExecuteNonQuery();

                        // Confirm booking
                        new SqlCommand("UPDATE Bookings SET Status='Confirmed' WHERE BookingId=@id AND Status='Pending'", con, tx)
                        { Parameters = { new SqlParameter("@id", bookingId) } }.ExecuteNonQuery();

                        // Confirm seats
                        new SqlCommand("UPDATE BookedSeats SET Status='Confirmed',HeldUntil=NULL WHERE BookingId=@id", con, tx)
                        { Parameters = { new SqlParameter("@id", bookingId) } }.ExecuteNonQuery();

                        tx.Commit();
                    }
                    catch { tx.Rollback(); throw; }
                }

                string bookingRef = ViewState["BookingRef"]?.ToString() ?? "—";
                Response.Redirect("ShowBookingConfirm.aspx?ref=" + bookingRef);
            }
            catch (Exception ex)
            {
                ShowMessage("Payment failed: " + ex.Message);
            }
        }

        private string FormatTime(object timeVal)
        {
            if (timeVal == null || timeVal == DBNull.Value) return "";
            if (timeVal is TimeSpan ts) return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(timeVal.ToString(), out TimeSpan parsed)) return DateTime.Today.Add(parsed).ToString("hh:mm tt");
            return timeVal.ToString();
        }

        private void ShowMessage(string msg)
        {
            lblMessage.Text = $"<div class='msg-box msg-error'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
}