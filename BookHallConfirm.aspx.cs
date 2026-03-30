using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace EventGlint
{
    public partial class BookHallConfirm : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(bookingRef)) { Response.Redirect("Hall.aspx"); return; }

            LoadBookingDetails(bookingRef);
        }

        // ─────────────────────────────────────────────────────────────────
        // Reads from Bookings → Shows → Halls → Venues (all existing tables).
        // Extra fields (purpose, days, guests, start time) come from Session
        // because we stored them there right before the redirect.
        // ─────────────────────────────────────────────────────────────────
        private void LoadBookingDetails(string bookingRef)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT
                b.BookingRef,
                b.TotalAmount,
                b.DiscountAmount,
                b.FinalAmount,
                sh.ShowDate,
                sh.StartTime,
                h.Name   AS HallName,
                v.Name   AS VenueName
            FROM  Bookings b
            JOIN  Shows  sh ON sh.ShowId  = b.ShowId
            JOIN  Halls   h ON h.HallId   = sh.HallId
            JOIN  Venues  v ON v.VenueId  = h.VenueId
            WHERE b.BookingRef = @ref", con);

                cmd.Parameters.AddWithValue("@ref", bookingRef);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0) { Response.Redirect("Hall.aspx"); return; }

                DataRow r = dt.Rows[0];

                decimal subtotal = Convert.ToDecimal(r["TotalAmount"]);
                decimal discount = Convert.ToDecimal(r["DiscountAmount"]);
                decimal finalAmt = Convert.ToDecimal(r["FinalAmount"]);
                decimal fee = finalAmt - subtotal + discount;

                lblBookingRef.Text = r["BookingRef"].ToString();
                lblHall.Text = r["HallName"].ToString();
                lblVenue.Text = r["VenueName"].ToString();
                lblDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy");
                lblSubtotal.Text = subtotal.ToString("N0");
                lblFee.Text = fee.ToString("N0");
                lblDiscount.Text = discount.ToString("N0");
                lblTotal.Text = finalAmt.ToString("N0");
            }

            lblStartTime.Text = Session["HallStartTime"] != null ? Session["HallStartTime"].ToString() : "—";
            lblPurpose.Text = Session["HallPurpose"] != null ? Session["HallPurpose"].ToString() : "—";
            lblGuests.Text = Session["HallGuests"] != null ? Session["HallGuests"].ToString() + " guests" : "—";

            int days = Session["HallDays"] != null ? Convert.ToInt32(Session["HallDays"]) : 1;
            lblDuration.Text = days + (days == 1 ? " day" : " days");
        }
    }
}