using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace EventGlint
{
    public partial class ShowBookingConfirm : System.Web.UI.Page
    {
        string connStr = System.Configuration.ConfigurationManager
                              .ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("Log.aspx"); return; }

            string username = Session["Username"].ToString();
            lblUserName.Text = username;
            lblAvatar.Text = username.Substring(0, 1).ToUpper();

            string bookingRef = Request.QueryString["ref"];
            if (string.IsNullOrEmpty(bookingRef)) { Response.Redirect("Shows.aspx"); return; }

            LoadBookingDetails(bookingRef);
        }

        private void LoadBookingDetails(string bookingRef)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT b.BookingRef, b.TotalAmount, b.DiscountAmount, b.FinalAmount,
                           e.Title, sh.ShowDate, sh.StartTime,
                           h.Name AS HallName, v.Name AS VenueName
                    FROM   Bookings b
                    JOIN   Shows    sh ON sh.ShowId  = b.ShowId
                    JOIN   Events   e  ON e.EventId  = sh.EventId
                    JOIN   Halls    h  ON h.HallId   = sh.HallId
                    JOIN   Venues   v  ON v.VenueId  = h.VenueId
                    WHERE  b.BookingRef = @ref", con);
                cmd.Parameters.AddWithValue("@ref", bookingRef);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Shows.aspx"); return; }

                DataRow r = dt.Rows[0];
                decimal subtotal = Convert.ToDecimal(r["TotalAmount"]);
                decimal discount = Convert.ToDecimal(r["DiscountAmount"]);
                decimal finalAmt = Convert.ToDecimal(r["FinalAmount"]);
                decimal fee = finalAmt - subtotal + discount;

                lblBookingRef.Text = r["BookingRef"].ToString();
                lblShow.Text = r["Title"].ToString();
                lblVenue.Text = r["VenueName"].ToString() + " — " + r["HallName"].ToString();
                lblDateTime.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " " + FormatTime(r["StartTime"]);
                lblSubtotal.Text = subtotal.ToString("N0");
                lblFee.Text = fee.ToString("N0");
                lblDiscount.Text = discount.ToString("N0");
                lblTotal.Text = finalAmt.ToString("N0");

                // Get seat labels
                SqlCommand cmdSeats = new SqlCommand(@"
                    SELECT s.RowLabel + CAST(s.SeatNumber AS NVARCHAR) AS SeatLabel
                    FROM   BookedSeats bs
                    JOIN   Seats       s  ON s.SeatId    = bs.SeatId
                    JOIN   Bookings    b  ON b.BookingId = bs.BookingId
                    WHERE  b.BookingRef = @ref
                    ORDER  BY s.RowLabel, s.SeatNumber", con);
                cmdSeats.Parameters.AddWithValue("@ref", bookingRef);

                SqlDataAdapter daS = new SqlDataAdapter(cmdSeats);
                DataTable dtS = new DataTable();
                daS.Fill(dtS);

                var seats = new StringBuilder();
                foreach (DataRow sr in dtS.Rows)
                {
                    if (seats.Length > 0) seats.Append(", ");
                    seats.Append(sr["SeatLabel"].ToString().Trim());
                }
                lblSeats.Text = seats.Length > 0 ? seats.ToString() : "—";
            }
        }

        private string FormatTime(object timeVal)
        {
            if (timeVal == null || timeVal == DBNull.Value) return "";
            if (timeVal is TimeSpan ts) return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(timeVal.ToString(), out TimeSpan parsed)) return DateTime.Today.Add(parsed).ToString("hh:mm tt");
            return timeVal.ToString();
        }
    }
}