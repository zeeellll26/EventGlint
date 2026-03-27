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
    public partial class Home : System.Web.UI.Page
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack)
        //    {
        //        LoadUserInfo();
        //        LoadDashboardStats();
        //    }
        //}

        //// ── Populate logged-in user details ─────────────────────────────
        //private void LoadUserInfo()
        //{
        //    // TODO: Replace with Session / Membership lookup
        //    string userName = "Rahul Patel";
        //    string userRole = "Pro Member ✦";

        //    lblUserName.Text = userName;
        //    lblUserRole.Text = userRole;
        //    lblAvatarInitial.Text = userName.Substring(0, 1).ToUpper();
        //    lblTopAvatar.Text = userName.Substring(0, 1).ToUpper();
        //    lblLocation.Text = "Surat, Gujarat";
        //}

        //// ── Populate KPI stat cards ──────────────────────────────────────
        //private void LoadDashboardStats()
        //{
        //    // TODO: Replace with real DB queries
        //    lblEventsCount.Text = "124";
        //    lblEventsTrend.Text = "+12%";
        //    lblTicketsSold.Text = "3,410";
        //    lblTicketsTrend.Text = "+8%";
        //    lblRating.Text = "4.9";
        //    lblRatingTrend.Text = "+0.2";
        //    lblUsers.Text = "52K";
        //    lblUsersTrend.Text = "-1%";
        //}

        //// ── Hero — Get Tickets button ────────────────────────────────────
        //protected void btnGetTickets_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("Event.aspx?id=holi2026");
        //}

        //// ── Hero — Learn More button ─────────────────────────────────────
        //protected void btnLearnMore_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("Event.aspx?detail=holi2026");
        //}

        //// ── Attend buttons on event cards ───────────────────────────────
        //// CommandArgument carries the event ID ("1", "2", "3")
        //protected void btnAttend_Click(object sender, EventArgs e)
        //{
        //    var btn = (System.Web.UI.WebControls.Button)sender;
        //    string eventId = btn.CommandArgument;
        //    Response.Redirect("Event.aspx?id=" + eventId);
        //}

        //// ── Promo — Upgrade Now button ───────────────────────────────────
        //protected void btnUpgrade_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("Upgrade.aspx");
        //}

        //// ── Topbar — Search / Filter button ─────────────────────────────
        //protected void btnFilter_Click(object sender, EventArgs e)
        //{
        //    string query = txtSearch.Text.Trim();
        //    if (!string.IsNullOrEmpty(query))
        //        Response.Redirect("Event.aspx?q=" + Server.UrlEncode(query));
        //    else
        //        Response.Redirect("Event.aspx");
        //}

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
                LoadDashboardStats();
            }
        }

        // ── Load real user info from DB + Session ────────────────────────────────
        private void LoadUserInfo()
        {
            try
            {
                string username = Session["Username"].ToString();

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Fetch user + their city name in one query
                    SqlCommand cmd = new SqlCommand(@"
                    SELECT u.Username, u.Email, u.Phone,
                           ISNULL(c.Name + ', ' + c.State, 'India') AS Location,
                           u.CreatedAt
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

                        int userID = Convert.ToInt32(r["UserId"]);
                        string location = r["Location"].ToString();

                        // ── Check how many bookings the user has made ────────────
                        // Use that to decide member tier
                        int bookingCount = GetUserBookingCount(con, userID);
                        string userRole = GetMemberTier(bookingCount);

                        // ── Fill all labels ──────────────────────────────────────
                        lblUserName.Text = username;
                        lblUserRole.Text = userRole;
                        lblLocation.Text = location;

                        // Avatar initials — both sidebar and topbar
                        string initial = username.Length > 0
                            ? username.Substring(0, 1).ToUpper()
                            : "U";
                        lblAvatarInitial.Text = initial;
                        lblTopAvatar.Text = initial;
                    }
                }
            }
            catch (Exception ex)
            {
                // Fallback to session data if DB fails
                string name = Session["Username"]?.ToString() ?? "User";
                lblUserName.Text = name;
                lblUserRole.Text = "Member";
                lblLocation.Text = "India";
                lblAvatarInitial.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "U";
                lblTopAvatar.Text = lblAvatarInitial.Text;

                System.Diagnostics.Debug.WriteLine("LoadUserInfo error: " + ex.Message);
            }
        }

        // ── Get total bookings count for a user ──────────────────────────────────
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

        // ── Determine member tier based on booking count ─────────────────────────
        private string GetMemberTier(int bookingCount)
        {
            if (bookingCount >= 20) return "Platinum Member ✦";
            if (bookingCount >= 10) return "Gold Member ✦";
            if (bookingCount >= 5) return "Pro Member ✦";
            if (bookingCount >= 1) return "Silver Member";
            return "New Member";
        }

        // ── Populate KPI stat cards from real DB data ─────────────────────────────
        private void LoadDashboardStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // ── Active Events count ──────────────────────────────────────
                    int totalEvents = GetScalarInt(con,
                        "SELECT COUNT(*) FROM Events WHERE EndDate IS NULL OR EndDate >= GETDATE()");
                    lblEventsCount.Text = FormatCount(totalEvents);
                    lblEventsTrend.Text = GetEventsTrend(con);

                    // ── Tickets sold to this user ────────────────────────────────
                    int userId = Convert.ToInt32(Session["UserId"]);
                    int ticketsSold = GetScalarInt(con,
                        @"SELECT ISNULL(SUM(bs.BookedSeatId), 0)
                      FROM BookedSeats bs
                      JOIN Bookings b ON b.BookingId = bs.BookingId
                      WHERE b.UserId = @uid AND bs.Status = 'Confirmed'",
                        new SqlParameter("@uid", userId));

                    // If the view is platform-wide (e.g. admin-style home), use total tickets:
                    // int ticketsSold = GetScalarInt(con,
                    //     "SELECT COUNT(*) FROM BookedSeats WHERE Status = 'Confirmed'");

                    lblTicketsSold.Text = FormatCount(ticketsSold);
                    lblTicketsTrend.Text = GetTicketsTrend(con, userId);

                    // ── Average rating across all events (from Reviews table) ────
                    decimal avgRating = GetScalarDecimal(con,
                        "SELECT ISNULL(ROUND(AVG(CAST(Rating AS DECIMAL(3,1))), 1), 0.0) FROM Reviews");
                    lblRating.Text = avgRating > 0 ? avgRating.ToString("F1") : "—";
                    lblRatingTrend.Text = GetRatingTrend(con);

                    // ── Total registered users ────────────────────────────────────
                    int totalUsers = GetScalarInt(con, "SELECT COUNT(*) FROM Users");
                    lblUsers.Text = FormatCount(totalUsers);
                    lblUsersTrend.Text = GetUsersTrend(con);
                }
            }
            catch (Exception ex)
            {
                // Safe fallback — show dashes so page doesn't break
                lblEventsCount.Text = "—"; lblEventsTrend.Text = "";
                lblTicketsSold.Text = "—"; lblTicketsTrend.Text = "";
                lblRating.Text = "—"; lblRatingTrend.Text = "";
                lblUsers.Text = "—"; lblUsersTrend.Text = "";

                System.Diagnostics.Debug.WriteLine("LoadDashboardStats error: " + ex.Message);
            }
        }

        // ── Trend: events added this month vs last month ──────────────────────────
        private string GetEventsTrend(SqlConnection con)
        {
            try
            {
                int thisMonth = GetScalarInt(con,
                    "SELECT COUNT(*) FROM Events WHERE MONTH(CreatedAt)=MONTH(GETDATE()) AND YEAR(CreatedAt)=YEAR(GETDATE())");
                int lastMonth = GetScalarInt(con,
                    "SELECT COUNT(*) FROM Events WHERE MONTH(CreatedAt)=MONTH(DATEADD(MONTH,-1,GETDATE())) AND YEAR(CreatedAt)=YEAR(DATEADD(MONTH,-1,GETDATE()))");

                if (lastMonth == 0) return thisMonth > 0 ? "+100%" : "0%";
                double pct = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
                return (pct >= 0 ? "+" : "") + Math.Round(pct, 0) + "%";
            }
            catch { return ""; }
        }

        // ── Trend: user's tickets this month vs last month ────────────────────────
        private string GetTicketsTrend(SqlConnection con, int userId)
        {
            try
            {
                int thisMonth = GetScalarInt(con,
                    @"SELECT COUNT(*) FROM BookedSeats bs
                  JOIN Bookings b ON b.BookingId=bs.BookingId
                  WHERE b.UserId=@uid AND bs.Status='Confirmed'
                  AND MONTH(b.BookingDate)=MONTH(GETDATE()) AND YEAR(b.BookingDate)=YEAR(GETDATE())",
                    new SqlParameter("@uid", userId));

                int lastMonth = GetScalarInt(con,
                    @"SELECT COUNT(*) FROM BookedSeats bs
                  JOIN Bookings b ON b.BookingId=bs.BookingId
                  WHERE b.UserId=@uid AND bs.Status='Confirmed'
                  AND MONTH(b.BookingDate)=MONTH(DATEADD(MONTH,-1,GETDATE())) AND YEAR(b.BookingDate)=YEAR(DATEADD(MONTH,-1,GETDATE()))",
                    new SqlParameter("@uid", userId));

                if (lastMonth == 0) return thisMonth > 0 ? "+100%" : "0%";
                double pct = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
                return (pct >= 0 ? "+" : "") + Math.Round(pct, 0) + "%";
            }
            catch { return ""; }
        }

        // ── Trend: avg rating this month vs last month ────────────────────────────
        private string GetRatingTrend(SqlConnection con)
        {
            try
            {
                decimal thisMonth = GetScalarDecimal(con,
                    @"SELECT ISNULL(ROUND(AVG(CAST(Rating AS DECIMAL(3,1))),1),0)
                  FROM Reviews WHERE MONTH(CreatedAt)=MONTH(GETDATE()) AND YEAR(CreatedAt)=YEAR(GETDATE())");

                decimal lastMonth = GetScalarDecimal(con,
                    @"SELECT ISNULL(ROUND(AVG(CAST(Rating AS DECIMAL(3,1))),1),0)
                  FROM Reviews WHERE MONTH(CreatedAt)=MONTH(DATEADD(MONTH,-1,GETDATE())) AND YEAR(CreatedAt)=YEAR(DATEADD(MONTH,-1,GETDATE()))");

                decimal diff = thisMonth - lastMonth;
                return (diff >= 0 ? "+" : "") + diff.ToString("F1");
            }
            catch { return ""; }
        }

        // ── Trend: new users this month vs last month ─────────────────────────────
        private string GetUsersTrend(SqlConnection con)
        {
            try
            {
                int thisMonth = GetScalarInt(con,
                    "SELECT COUNT(*) FROM Users WHERE MONTH(CreatedAt)=MONTH(GETDATE()) AND YEAR(CreatedAt)=YEAR(GETDATE())");
                int lastMonth = GetScalarInt(con,
                    "SELECT COUNT(*) FROM Users WHERE MONTH(CreatedAt)=MONTH(DATEADD(MONTH,-1,GETDATE())) AND YEAR(CreatedAt)=YEAR(DATEADD(MONTH,-1,GETDATE()))");

                if (lastMonth == 0) return thisMonth > 0 ? "+100%" : "0%";
                double pct = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
                return (pct >= 0 ? "+" : "") + Math.Round(pct, 0) + "%";
            }
            catch { return ""; }
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

        // ── Format large numbers nicely (e.g. 52000 → "52K") ────────────────────
        private string FormatCount(int n)
        {
            if (n >= 1_000_000) return (n / 1_000_000.0).ToString("F1") + "M";
            if (n >= 1_000) return (n / 1_000.0).ToString("F1").TrimEnd('0').TrimEnd('.') + "K";
            return n.ToString();
        }

    }
}