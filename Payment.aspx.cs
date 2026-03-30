using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace EventGlint
{
    public partial class Payment : System.Web.UI.Page
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

        // ─────────────────────────────────────────────────────────────────
        private void LoadUserInfo()
        {
            string username = Session["Username"].ToString();
            lblUserName.Text = username;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = username.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = username.Substring(0, 1).ToUpper();
        }

        // ─────────────────────────────────────────────────────────────────
        private void LoadBookingDetails()
        {
            int bookingId = GetBookingId();
            if (bookingId == 0) { Response.Redirect("Home.aspx"); return; }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Booking + Show + Event + Venue
                SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        b.BookingRef,
                        b.TotalAmount,
                        b.DiscountAmount,
                        b.FinalAmount,
                        e.Title     AS EventTitle,
                        sh.ShowDate,
                        sh.StartTime,
                        v.Name      AS VenueName,
                        h.Name      AS HallName
                    FROM Bookings b
                    JOIN Shows  sh ON sh.ShowId  = b.ShowId
                    JOIN Events  e ON e.EventId  = sh.EventId
                    JOIN Halls   h ON h.HallId   = sh.HallId
                    JOIN Venues  v ON v.VenueId  = h.VenueId
                    WHERE b.BookingId = @id", con);
                cmd.Parameters.AddWithValue("@id", bookingId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Home.aspx"); return; }

                DataRow r = dt.Rows[0];

                decimal subtotal = Convert.ToDecimal(r["TotalAmount"]);
                decimal discount = Convert.ToDecimal(r["DiscountAmount"]);
                decimal finalAmt = Convert.ToDecimal(r["FinalAmount"]);
                decimal fee = finalAmt - subtotal + discount;   // back-calculate convenience fee

                lblBookingRef.Text = r["BookingRef"].ToString();
                lblRef.Text = r["BookingRef"].ToString();
                lblEvent.Text = r["EventTitle"].ToString();
                lblShow.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy")
                                     + " at " + FormatTime(r["StartTime"]);
                lblVenue.Text = r["VenueName"].ToString() + " — " + r["HallName"].ToString();
                lblSubtotal.Text = subtotal.ToString("N0");
                lblFee.Text = fee.ToString("N0");
                lblDiscount.Text = discount.ToString("N0");
                lblTotal.Text = finalAmt.ToString("N0");

                // Seat labels
                SqlCommand cmdSeats = new SqlCommand(@"
                    SELECT s.RowLabel + CAST(s.SeatNumber AS NVARCHAR) AS SeatLabel
                    FROM BookedSeats bs
                    JOIN Seats s ON s.SeatId = bs.SeatId
                    WHERE bs.BookingId = @id
                    ORDER BY s.RowLabel, s.SeatNumber", con);
                cmdSeats.Parameters.AddWithValue("@id", bookingId);

                SqlDataAdapter daS = new SqlDataAdapter(cmdSeats);
                DataTable dtS = new DataTable();
                daS.Fill(dtS);

                StringBuilder seats = new StringBuilder();
                foreach (DataRow sr in dtS.Rows)
                {
                    if (seats.Length > 0) seats.Append(", ");
                    seats.Append(sr["SeatLabel"].ToString());
                }
                lblSeats.Text = seats.Length > 0 ? seats.ToString() : "—";
            }
        }

        // ─────────────────────────────────────────────────────────────────
        // "Pay Now" button click
        // ─────────────────────────────────────────────────────────────────
        protected void btnPay_Click(object sender, EventArgs e)
        {
            int bookingId = GetBookingId();
            if (bookingId == 0)
            {
                ShowMessage("Booking not found. Please try again.", false);
                return;
            }

            // Read payment method chosen by user (written by JS into hidden field)
            string payMethod = Request.Form["hdnPayMethod"] ?? "UPI";

            // Map to DB-allowed PaymentMethod values
            // Allowed: 'UPI','CreditCard','DebitCard','NetBanking','Wallet','COD'
            string[] allowed = { "UPI", "CreditCard", "DebitCard", "NetBanking", "Wallet", "COD" };
            bool valid = Array.Exists(allowed, m => m == payMethod);
            if (!valid) payMethod = "UPI";

            // Generate a fake transaction ID (replace with real gateway txn ID later)
            string txnId = "TXN" + DateTime.Now.ToString("yyyyMMddHHmmss")
                           + new Random().Next(1000, 9999).ToString();

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlTransaction tx = con.BeginTransaction();

                    try
                    {
                        // ── 1. Get FinalAmount for this booking ──────────
                        SqlCommand cmdAmt = new SqlCommand(
                            "SELECT FinalAmount FROM Bookings WHERE BookingId = @id AND Status = 'Pending'",
                            con, tx);
                        cmdAmt.Parameters.AddWithValue("@id", bookingId);
                        object amtObj = cmdAmt.ExecuteScalar();

                        if (amtObj == null || amtObj == DBNull.Value)
                        {
                            ShowMessage("Booking is no longer pending. It may have already been paid or expired.", false);
                            tx.Rollback();
                            return;
                        }
                        decimal finalAmount = Convert.ToDecimal(amtObj);

                        // ── 2. Insert Payments row ───────────────────────
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

                        // ── 3. Confirm Booking ───────────────────────────
                        SqlCommand cmdBook = new SqlCommand(@"
                            UPDATE Bookings
                            SET Status = 'Confirmed'
                            WHERE BookingId = @id AND Status = 'Pending'",
                            con, tx);
                        cmdBook.Parameters.AddWithValue("@id", bookingId);
                        cmdBook.ExecuteNonQuery();

                        // ── 4. Confirm BookedSeats — remove hold ─────────
                        SqlCommand cmdSeats = new SqlCommand(@"
                            UPDATE BookedSeats
                            SET Status    = 'Confirmed',
                                HeldUntil = NULL
                            WHERE BookingId = @id",
                            con, tx);
                        cmdSeats.Parameters.AddWithValue("@id", bookingId);
                        cmdSeats.ExecuteNonQuery();

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }

                // Clear session booking data
                Session.Remove("BookingRef");
                Session.Remove("BookingId");
                Session.Remove("FinalAmount");

                string bookingRef = Request.QueryString["ref"] ?? "—";
                Response.Redirect("BookingConfirm.aspx?ref=" + bookingRef + "&paid=1&method=" + payMethod);
            }
            catch (Exception ex)
            {
                ShowMessage("Payment failed: " + ex.Message, false);
            }
        }

        // ─────────────────────────────────────────────────────────────────
        // Helpers
        // ─────────────────────────────────────────────────────────────────
        private int GetBookingId()
        {
            int bookingId = 0;
            if (!int.TryParse(Request.QueryString["BookingId"], out bookingId) || bookingId == 0)
                bookingId = Session["BookingId"] != null ? Convert.ToInt32(Session["BookingId"]) : 0;
            return bookingId;
        }

        private string FormatTime(object timeVal)
        {
            if (timeVal == null || timeVal == DBNull.Value) return "";
            if (timeVal is TimeSpan ts)
                return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(timeVal.ToString(), out TimeSpan parsed))
                return DateTime.Today.Add(parsed).ToString("hh:mm tt");
            return timeVal.ToString();
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = $"<div class='msg-box {(success ? "msg-success" : "msg-error")}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
}