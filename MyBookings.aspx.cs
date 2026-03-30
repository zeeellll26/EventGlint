using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Bookings : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Log.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadBookingStats();
                LoadBookings("All");
                LoadUpcomingReminders();
            }
        }

        // ── Load user info from DB + Session ────────────────────────────────────
        private void LoadUserInfo()
        {
            try
            {
                string username = Session["Username"].ToString();

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT u.UserId, u.Username,
                               ISNULL(c.Name + ', ' + c.State, 'India') AS Location
                        FROM Users u
                        LEFT JOIN Cities c ON c.CityId = u.CityId
                        WHERE u.Username = @username", con);
                    cmd.Parameters.AddWithValue("@username", username);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        int userId = Convert.ToInt32(r["UserId"]);
                        Session["UserId"] = userId;

                        int bookingCount = GetUserBookingCount(con, userId);
                        string tier = GetMemberTier(bookingCount);

                        lblUserName.Text = username;
                        lblUserRole.Text = tier;
                        lblLocation.Text = r["Location"].ToString();

                        string initial = username.Length > 0 ? username.Substring(0, 1).ToUpper() : "U";
                        lblAvatarInitial.Text = initial;
                        lblTopAvatar.Text = initial;
                    }
                }
            }
            catch (Exception ex)
            {
                string name = Session["Username"]?.ToString() ?? "User";
                lblUserName.Text = name;
                lblUserRole.Text = "Member";
                lblLocation.Text = "India";
                string init = name.Length > 0 ? name[0].ToString().ToUpper() : "U";
                lblAvatarInitial.Text = init;
                lblTopAvatar.Text = init;
                System.Diagnostics.Debug.WriteLine("LoadUserInfo error: " + ex.Message);
            }
        }

        private int GetUserBookingCount(SqlConnection con, int userId)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Bookings WHERE UserId = @uid AND Status != 'Cancelled'", con);
                cmd.Parameters.AddWithValue("@uid", userId);
                object result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
            }
            catch { return 0; }
        }

        private string GetMemberTier(int count)
        {
            if (count >= 20) return "Platinum Member ✦";
            if (count >= 10) return "Gold Member ✦";
            if (count >= 5) return "Pro Member ✦";
            if (count >= 1) return "Silver Member";
            return "New Member";
        }

        // ── Load booking summary stats ────────────────────────────────────────────
        private void LoadBookingStats()
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Total bookings (non-cancelled)
                    int total = GetScalarInt(con,
                        "SELECT COUNT(*) FROM Bookings WHERE UserId=@uid AND Status != 'Cancelled'",
                        new SqlParameter("@uid", userId));
                    lblTotalBookings.Text = total.ToString();
                    lblStatTotal.Text = total.ToString();

                    // Upcoming (confirmed + event in future)
                    int upcoming = GetScalarInt(con, @"
    SELECT COUNT(*)
    FROM Bookings b
    INNER JOIN Shows s ON s.ShowId = b.ShowId
    WHERE b.UserId=@uid AND b.Status='Confirmed'
      AND s.ShowDate >= CAST(GETDATE() AS DATE)",
    new SqlParameter("@uid", userId));
                    lblUpcoming.Text = upcoming.ToString();
                    lblStatUpcoming.Text = upcoming.ToString();

                    // Attended (past events, confirmed)
                    int attended = GetScalarInt(con, @"
    SELECT COUNT(*)
    FROM Bookings b
    INNER JOIN Shows s ON s.ShowId = b.ShowId
    WHERE b.UserId=@uid AND b.Status='Confirmed'
      AND s.ShowDate < CAST(GETDATE() AS DATE)",
    new SqlParameter("@uid", userId));
                    lblStatAttended.Text = attended.ToString();
                    lblStatAttended.Text = attended.ToString();

                    // Cancelled
                    int cancelled = GetScalarInt(con,
                        "SELECT COUNT(*) FROM Bookings WHERE UserId=@uid AND Status='Cancelled'",
                        new SqlParameter("@uid", userId));
                    lblStatCancelled.Text = cancelled.ToString();
                    lblStatCancelled.Text = cancelled.ToString();

                    // Total spent
                    decimal spent = GetScalarDecimal(con, @"
    SELECT ISNULL(SUM(b.FinalAmount), 0)
    FROM Bookings b
    WHERE b.UserId=@uid AND b.Status != 'Cancelled'",
    new SqlParameter("@uid", userId));
                    lblTotalSpent.Text = FormatCurrency(spent);
                }
            }
            catch (Exception ex)
            {
                lblTotalBookings.Text = "0"; lblStatTotal.Text = "0";
                lblUpcoming.Text = "0"; lblStatUpcoming.Text = "0";
                lblStatAttended.Text = "0"; lblStatAttended.Text = "0";
                lblStatCancelled.Text = "0"; lblStatCancelled.Text = "0";
                lblTotalSpent.Text = "₹0";
                System.Diagnostics.Debug.WriteLine("LoadBookingStats error: " + ex.Message);
            }
        }

        // ── Load bookings list with optional filter ───────────────────────────────
        private void LoadBookings(string filter)
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            try
            {
                string searchTerm = txtSearch.Text.Trim();

                string whereClause = "WHERE b.UserId = @uid";

                if (filter == "Upcoming")
                    whereClause += " AND b.Status = 'Confirmed' AND s.ShowDate >= CAST(GETDATE() AS DATE)";
                else if (filter == "Attended")
                    whereClause += " AND b.Status = 'Confirmed' AND s.ShowDate < CAST(GETDATE() AS DATE)";
                else if (filter == "Cancelled")
                    whereClause += " AND b.Status = 'Cancelled'";
                else if (filter == "Pending")
                    whereClause += " AND b.Status = 'Pending'";

                if (!string.IsNullOrEmpty(searchTerm))
                    whereClause += " AND e.Title LIKE @search";

                string query = $@"
    SELECT
        b.BookingId,
        b.BookingDate,
        b.TotalAmount,
        b.FinalAmount,
        b.Status AS BookingStatus,
        b.BookingRef AS BookingReference,

        s.ShowId,
        s.ShowDate,
        s.StartTime,
        s.EndTime,

        e.EventId,
        e.Title AS EventTitle,
        e.EventType,
        e.ReleaseDate,
        e.EndDate,
        e.Language,
        e.Genre,

        v.Name AS VenueName,
        ISNULL(c.Name + ', ' + c.State, 'India') AS CityName,

        1 AS SeatCount

    FROM Bookings b
    INNER JOIN Shows s ON s.ShowId = b.ShowId
    INNER JOIN Events e ON e.EventId = s.EventId
    INNER JOIN Halls h ON h.HallId = s.HallId
    INNER JOIN Venues v ON v.VenueId = h.VenueId
    LEFT JOIN Cities c ON c.CityId = v.CityId
    {whereClause}
    ORDER BY b.BookingDate DESC";


                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    if (!string.IsNullOrEmpty(searchTerm))
                        cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Show/hide empty state
                    pnlBookings.Visible = dt.Rows.Count > 0;
                    pnlEmpty.Visible = dt.Rows.Count == 0;

                    lblResultCount.Text = dt.Rows.Count + " booking" + (dt.Rows.Count != 1 ? "s" : "") + " found";

                    rptBookings.DataSource = dt;
                    rptBookings.DataBind();
                }
            }
            catch (Exception ex)
            {
                pnlBookings.Visible = false;
                pnlEmpty.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadBookings error: " + ex.Message);
            }
        }

        // ── Load upcoming event reminders (next 3 confirmed future bookings) ─────
        private void LoadUpcomingReminders()
        {
            if (Session["UserId"] == null) return;
            int userId = Convert.ToInt32(Session["UserId"]);

            try
            {
                string query = @"
    SELECT TOP 3
        b.BookingId,
        e.Title AS EventTitle,
        e.EventType,
        s.ShowDate,
        DATEDIFF(DAY, GETDATE(), s.ShowDate) AS DaysLeft
    FROM Bookings b
    INNER JOIN Shows s ON s.ShowId = b.ShowId
    INNER JOIN Events e ON e.EventId = s.EventId
    WHERE b.UserId = @uid
      AND b.Status = 'Confirmed'
      AND s.ShowDate >= CAST(GETDATE() AS DATE)
    ORDER BY s.ShowDate ASC";

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@uid", userId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    pnlReminders.Visible = dt.Rows.Count > 0;

                    rptReminders.DataSource = dt;
                    rptReminders.DataBind();
                }
            }
            catch (Exception ex)
            {
                pnlReminders.Visible = false;
                System.Diagnostics.Debug.WriteLine("LoadUpcomingReminders error: " + ex.Message);
            }
        }

        // ── Filter tab clicks ─────────────────────────────────────────────────────
        protected void lnkAll_Click(object sender, EventArgs e) { SetActiveTab("All"); LoadBookings("All"); }
        protected void lnkUpcoming_Click(object sender, EventArgs e) { SetActiveTab("Upcoming"); LoadBookings("Upcoming"); }
        protected void lnkAttended_Click(object sender, EventArgs e) { SetActiveTab("Attended"); LoadBookings("Attended"); }
        protected void lnkCancelled_Click(object sender, EventArgs e) { SetActiveTab("Cancelled"); LoadBookings("Cancelled"); }
        protected void lnkPending_Click(object sender, EventArgs e) { SetActiveTab("Pending"); LoadBookings("Pending"); }

        private void SetActiveTab(string tab)
        {
            // Store active tab in ViewState so we can style it
            ViewState["ActiveTab"] = tab;
        }

        // ── Search ────────────────────────────────────────────────────────────────
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string tab = ViewState["ActiveTab"]?.ToString() ?? "All";
            LoadBookings(tab);
        }

        // ── Browse events ─────────────────────────────────────────────────────────
        protected void btnBrowseEvents_Click(object sender, EventArgs e)
        {
            Response.Redirect("Event.aspx");
        }

        // ── View booking detail ───────────────────────────────────────────────────
        protected void btnViewBooking_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string bookingId = btn.CommandArgument;
            Response.Redirect("BookingDetail.aspx?BookingId=" + bookingId);
        }

        // ── Cancel booking ────────────────────────────────────────────────────────
        protected void btnCancelBooking_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string bookingId = btn.CommandArgument;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Update booking status
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Bookings SET Status = 'Cancelled' WHERE BookingId = @bid AND UserId = @uid;
                        UPDATE BookedSeats SET Status = 'Cancelled' WHERE BookingId = @bid;", con);
                    cmd.Parameters.AddWithValue("@bid", Convert.ToInt32(bookingId));
                    cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));
                    cmd.ExecuteNonQuery();
                }

                // Reload everything
                LoadBookingStats();
                string tab = ViewState["ActiveTab"]?.ToString() ?? "All";
                LoadBookings(tab);
                LoadUpcomingReminders();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CancelBooking error: " + ex.Message);
            }
        }

        // ── Download ticket ───────────────────────────────────────────────────────
        protected void btnDownloadTicket_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string bookingId = btn.CommandArgument;
            Response.Redirect("DownloadTicket.aspx?BookingId=" + bookingId);
        }

        // ── Helper: is event in the future? ──────────────────────────────────────
        protected bool IsUpcomingEvent(object endDate, object releaseDate)
        {
            DateTime now = DateTime.Now;
            if (endDate != null && endDate != DBNull.Value)
                return Convert.ToDateTime(endDate) >= now;
            if (releaseDate != null && releaseDate != DBNull.Value)
                return Convert.ToDateTime(releaseDate) >= now;
            return true;
        }

        // ── Helper: status badge CSS class ───────────────────────────────────────
        protected string GetStatusClass(object status)
        {
            if (status == null || status == DBNull.Value) return "status-pending";
            switch (status.ToString().ToLower())
            {
                case "confirmed": return "status-confirmed";
                case "cancelled": return "status-cancelled";
                case "pending": return "status-pending";
                case "attended": return "status-attended";
                default: return "status-pending";
            }
        }

        protected string GetStatusEmoji(object status)
        {
            if (status == null || status == DBNull.Value) return "⏳";
            switch (status.ToString().ToLower())
            {
                case "confirmed": return "✅";
                case "cancelled": return "❌";
                case "pending": return "⏳";
                case "attended": return "🎉";
                default: return "⏳";
            }
        }

        // ── Helper: event type → emoji ────────────────────────────────────────────
        protected string GetEventEmoji(object eventType)
        {
            if (eventType == null || eventType == DBNull.Value) return "🎪";
            switch (eventType.ToString().ToLower())
            {
                case "music": return "🎵";
                case "film": return "🎬";
                case "arts": return "🎨";
                case "food": return "🍽️";
                case "sports": return "🏅";
                case "comedy": return "🎤";
                case "dance": return "💃";
                case "gaming": return "🎮";
                default: return "🎪";
            }
        }

        // ── Helper: event type → thumb CSS class ─────────────────────────────────
        protected string GetThumbClass(object eventType)
        {
            if (eventType == null || eventType == DBNull.Value) return "other";
            switch (eventType.ToString().ToLower())
            {
                case "music": return "music";
                case "film": return "film";
                case "food": return "food";
                case "sports": return "sports";
                default: return "holi";
            }
        }

        // ── Helper: format date ───────────────────────────────────────────────────
        protected string FormatDate(object date)
        {
            if (date == null || date == DBNull.Value) return "TBA";
            return Convert.ToDateTime(date).ToString("d MMM yyyy");
        }

        protected string FormatBookingDate(object date)
        {
            if (date == null || date == DBNull.Value) return "—";
            return Convert.ToDateTime(date).ToString("d MMM yyyy, hh:mm tt");
        }

        // ── Helper: format currency ───────────────────────────────────────────────
        protected string FormatAmount(object amount)
        {
            if (amount == null || amount == DBNull.Value) return "₹0";
            decimal val = Convert.ToDecimal(amount);
            if (val == 0) return "FREE";
            return "₹" + val.ToString("N0");
        }

        protected string GetAmountClass(object amount)
        {
            if (amount == null || amount == DBNull.Value) return "free-price";
            return Convert.ToDecimal(amount) == 0 ? "free-price" : "";
        }

        private string FormatCurrency(decimal val)
        {
            if (val >= 100000) return "₹" + (val / 100000m).ToString("F1") + "L";
            if (val >= 1000) return "₹" + (val / 1000m).ToString("F1").TrimEnd('0').TrimEnd('.') + "K";
            return "₹" + val.ToString("N0");
        }

        // ── Helper: days left label for reminders ─────────────────────────────────
        protected string GetDaysLeftLabel(object daysLeft)
        {
            if (daysLeft == null || daysLeft == DBNull.Value) return "Soon";
            int d = Convert.ToInt32(daysLeft);
            if (d == 0) return "Today!";
            if (d == 1) return "Tomorrow";
            if (d <= 7) return d + " days left";
            if (d <= 30) return d + " days away";
            return Convert.ToInt32(Math.Ceiling(d / 7.0)) + " weeks away";
        }

        protected string GetDaysLeftClass(object daysLeft)
        {
            if (daysLeft == null || daysLeft == DBNull.Value) return "rb-future";
            int d = Convert.ToInt32(daysLeft);
            if (d <= 1) return "rb-today";
            if (d <= 7) return "rb-soon";
            return "rb-future";
        }

        protected string GetReminderDotClass(object daysLeft)
        {
            if (daysLeft == null || daysLeft == DBNull.Value) return "dot-violet";
            int d = Convert.ToInt32(daysLeft);
            if (d <= 1) return "dot-green";
            if (d <= 7) return "dot-yellow";
            return "dot-violet";
        }

        // ── Check if cancel should be shown (only future confirmed) ──────────────
        protected bool CanCancel(object status, object endDate, object releaseDate)
        {
            if (status == null || status.ToString().ToLower() != "confirmed") return false;
            DateTime now = DateTime.Now;
            if (endDate != null && endDate != DBNull.Value)
                return Convert.ToDateTime(endDate) >= now;
            if (releaseDate != null && releaseDate != DBNull.Value)
                return Convert.ToDateTime(releaseDate) >= now;
            return false;
        }

        // ── Check if download should be shown (only confirmed) ────────────────────
        protected bool CanDownload(object status)
        {
            return status != null && status.ToString().ToLower() == "confirmed";
        }

        // ── Scalar helpers ────────────────────────────────────────────────────────
        private int GetScalarInt(SqlConnection con, string sql, params SqlParameter[] p)
        {
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                if (p != null) cmd.Parameters.AddRange(p);
                object result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
            }
        }

        private decimal GetScalarDecimal(SqlConnection con, string sql, params SqlParameter[] p)
        {
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                if (p != null) cmd.Parameters.AddRange(p);
                object result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value ? Convert.ToDecimal(result) : 0m;
            }
        }
    }
}