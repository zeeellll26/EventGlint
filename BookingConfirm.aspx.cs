using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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

            // Booking + show + event + venue info
            SqlCommand cmd = new SqlCommand(@"
                SELECT b.BookingRef, b.TotalAmount, b.ConvenienceFee, b.DiscountAmount, b.FinalAmount,
                       e.Title AS EventTitle,
                       sh.ShowDate, sh.StartTime,
                       v.Name AS VenueName,
                       h.Name AS HallName
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
            lblShowDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " at " + r["StartTime"];
            lblVenue.Text = r["VenueName"].ToString();
            lblHall.Text = r["HallName"].ToString();
            lblSubtotal.Text = Convert.ToDecimal(r["TotalAmount"]).ToString("N0");
            lblFee.Text = Convert.ToDecimal(r["ConvenienceFee"]).ToString("N0");
            lblDiscount.Text = Convert.ToDecimal(r["DiscountAmount"]).ToString("N0");
            lblTotal.Text = Convert.ToDecimal(r["FinalAmount"]).ToString("N0");

            // Load booked seats
            SqlCommand cmdSeats = new SqlCommand(@"
                SELECT s.RowLabel, s.SeatNumber, sc.Name AS CategoryName
                FROM BookedSeats bs
                JOIN Seats s          ON s.SeatId      = bs.SeatId
                JOIN SeatCategories sc ON sc.CategoryId = s.CategoryId
                JOIN Bookings b        ON b.BookingId   = bs.BookingId
                WHERE b.BookingRef = @ref", con);
            cmdSeats.Parameters.AddWithValue("@ref", bookingRef);

            SqlDataAdapter daSeats = new SqlDataAdapter(cmdSeats);
            DataTable dtSeats = new DataTable();
            daSeats.Fill(dtSeats);

            StringBuilder chips = new StringBuilder();
            foreach (DataRow sr in dtSeats.Rows)
                chips.Append("<span class='seat-chip'>" + sr["RowLabel"].ToString().Trim() + sr["SeatNumber"] + "</span>");

            litSeats.Text = chips.ToString();
        }
    }
}