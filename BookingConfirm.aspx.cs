using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace EventGlint
{
    public partial class BookingConfirm : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(bookingRef)) { Response.Redirect("Home.aspx"); return; }

            LoadBookingDetails(bookingRef);
        }

        private void LoadBookingDetails(string bookingRef)
        {
            SqlConnection con = new SqlConnection(connStr);

            // Booking + event + venue details
            SqlCommand cmd = new SqlCommand(@"
                SELECT b.BookingRef, b.TotalAmount, b.ConvenienceFee,
                       b.DiscountAmount, b.FinalAmount, b.Status,
                       e.Title AS EventTitle,
                       sh.ShowDate, sh.StartTime,
                       v.Name AS VenueName, h.Name AS HallName
                FROM Bookings b
                JOIN Shows  sh ON sh.ShowId  = b.ShowId
                JOIN Events e  ON e.EventId  = sh.EventId
                JOIN Halls  h  ON h.HallId   = sh.HallId
                JOIN Venues v  ON v.VenueId  = h.VenueId
                WHERE b.BookingRef = @ref", con);
            cmd.Parameters.AddWithValue("@ref", bookingRef);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count == 0) { Response.Redirect("Home.aspx"); return; }

            DataRow r = dt.Rows[0];
            lblBookingRef.Text = r["BookingRef"].ToString();
            lblEvent.Text = r["EventTitle"].ToString();
            lblShowDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " at " + FormatTime(r["StartTime"]);
            lblVenue.Text = r["VenueName"].ToString();
            lblHall.Text = r["HallName"].ToString();
            lblSubtotal.Text = Convert.ToDecimal(r["TotalAmount"]).ToString("N0");
            lblFee.Text = Convert.ToDecimal(r["ConvenienceFee"]).ToString("N0");
            lblDiscount.Text = Convert.ToDecimal(r["DiscountAmount"]).ToString("N0");
            lblTotal.Text = Convert.ToDecimal(r["FinalAmount"]).ToString("N0");

            string status = r["Status"].ToString();
            lblStatus.Text = status == "Confirmed" ? "✅ Payment Successful" : "⏳ " + status;
            lblStatus.CssClass = status == "Confirmed" ? "status-confirmed" : "status-pending";

            // Booked seats
            SqlCommand cmdSeats = new SqlCommand(@"
                SELECT s.RowLabel, s.SeatNumber
                FROM BookedSeats bs
                JOIN Seats    s ON s.SeatId    = bs.SeatId
                JOIN Bookings b ON b.BookingId = bs.BookingId
                WHERE b.BookingRef = @ref
                ORDER BY s.RowLabel, s.SeatNumber", con);
            cmdSeats.Parameters.AddWithValue("@ref", bookingRef);

            SqlDataAdapter daS = new SqlDataAdapter(cmdSeats);
            DataTable dtS = new DataTable();
            daS.Fill(dtS);

            StringBuilder chips = new StringBuilder();
            foreach (DataRow sr in dtS.Rows)
                chips.Append("<span class='seat-chip'>" + sr["RowLabel"].ToString().Trim() + sr["SeatNumber"] + "</span>");
            litSeats.Text = chips.Length > 0 ? chips.ToString() : "<span style='color:var(--muted)'>—</span>";

            // Payment info
            SqlCommand cmdPay = new SqlCommand(@"
                SELECT p.PaymentMethod, p.PaidAt
                FROM Payments p
                JOIN Bookings b ON b.BookingId = p.BookingId
                WHERE b.BookingRef = @ref AND p.Status = 'Success'", con);
            cmdPay.Parameters.AddWithValue("@ref", bookingRef);

            SqlDataAdapter daP = new SqlDataAdapter(cmdPay);
            DataTable dtP = new DataTable();
            daP.Fill(dtP);

            if (dtP.Rows.Count > 0)
            {
                lblPayMethod.Text = dtP.Rows[0]["PaymentMethod"].ToString();
                lblPaidAt.Text = Convert.ToDateTime(dtP.Rows[0]["PaidAt"]).ToString("dd MMM yyyy hh:mm tt");
            }
            else
            {
                lblPayMethod.Text = "—";
                lblPaidAt.Text = "—";
            }
        }

        private string FormatTime(object val)
        {
            if (val == null || val == DBNull.Value) return "";
            if (val is TimeSpan ts) return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(val.ToString(), out TimeSpan p)) return DateTime.Today.Add(p).ToString("hh:mm tt");
            return val.ToString();
        }
    }
}