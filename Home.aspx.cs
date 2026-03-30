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
                LoadUpcomingEvents();
                LoadTrendingEvents();
                LoadCategoryStats();
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
                    con.Open();

                    // Fetch user + their city name in one query
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT u.UserId, u.Username, u.Email, u.Phone,
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

                        // Store UserId in session for later use
                        Session["UserId"] = userID;

                        // Check how many bookings the user has made
                        int bookingCount = GetUserBookingCount(con, userID);
                        string userRole = GetMemberTier(bookingCount);

                        // Fill all labels
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

                    // ── Tickets sold (platform-wide) ────────────────────────────────
                    int ticketsSold = GetScalarInt(con,
                        "SELECT COUNT(*) FROM BookedSeats WHERE Status = 'Confirmed'");
                    lblTicketsSold.Text = FormatCount(ticketsSold);
                    lblTicketsTrend.Text = GetTicketsTrend(con);

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
                // Safe fallback
                lblEventsCount.Text = "—"; lblEventsTrend.Text = "";
                lblTicketsSold.Text = "—"; lblTicketsTrend.Text = "";
                lblRating.Text = "—"; lblRatingTrend.Text = "";
                lblUsers.Text = "—"; lblUsersTrend.Text = "";

                System.Diagnostics.Debug.WriteLine("LoadDashboardStats error: " + ex.Message);
            }
        }

        // ── Load Upcoming Events (Top 3) ──────────────────────────────────────────
        private void LoadUpcomingEvents()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string query = @"
                        SELECT TOP 3 EventId, Title, EventType, Description, 
                               ReleaseDate, DurationMins, Language, Genre
                        FROM Events 
                        WHERE EndDate IS NULL OR EndDate >= GETDATE()
                        ORDER BY ReleaseDate ASC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptUpcoming.DataSource = dt;
                    rptUpcoming.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUpcomingEvents error: " + ex.Message);
            }
        }

        // ── Load Trending Events (Top 4 by recent bookings) ──────────────────────
        private void LoadTrendingEvents()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Get events with most recent bookings
                    string query = @"
                        SELECT TOP 4 
                            e.EventId, 
                            e.Title, 
                            e.EventType,
                            e.ReleaseDate,
                            COUNT(bs.BookedSeatId) as BookingCount
                        FROM Events e
                        LEFT JOIN Bookings b ON b.EventId = e.EventId
                        LEFT JOIN BookedSeats bs ON bs.BookingId = b.BookingId
                        WHERE (e.EndDate IS NULL OR e.EndDate >= GETDATE())
                        GROUP BY e.EventId, e.Title, e.EventType, e.ReleaseDate
                        ORDER BY BookingCount DESC, e.ReleaseDate ASC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptTrending.DataSource = dt;
                    rptTrending.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadTrendingEvents error: " + ex.Message);
            }
        }

        // ── Load Category Statistics ──────────────────────────────────────────────
        private void LoadCategoryStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string query = @"
                        SELECT TOP 4
                            ISNULL(EventType, 'Other') as Category,
                            COUNT(*) as EventCount
                        FROM Events
                        WHERE EndDate IS NULL OR EndDate >= GETDATE()
                        GROUP BY EventType
                        ORDER BY COUNT(*) DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCategoryStats error: " + ex.Message);
            }
        }

        // ── Trend Calculations ────────────────────────────────────────────────────
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

        private string GetTicketsTrend(SqlConnection con)
        {
            try
            {
                int thisMonth = GetScalarInt(con,
                    @"SELECT COUNT(*) FROM BookedSeats bs
                      JOIN Bookings b ON b.BookingId=bs.BookingId
                      WHERE bs.Status='Confirmed'
                      AND MONTH(b.BookingDate)=MONTH(GETDATE()) 
                      AND YEAR(b.BookingDate)=YEAR(GETDATE())");

                int lastMonth = GetScalarInt(con,
                    @"SELECT COUNT(*) FROM BookedSeats bs
                      JOIN Bookings b ON b.BookingId=bs.BookingId
                      WHERE bs.Status='Confirmed'
                      AND MONTH(b.BookingDate)=MONTH(DATEADD(MONTH,-1,GETDATE())) 
                      AND YEAR(b.BookingDate)=YEAR(DATEADD(MONTH,-1,GETDATE()))");

                if (lastMonth == 0) return thisMonth > 0 ? "+100%" : "0%";
                double pct = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
                return (pct >= 0 ? "+" : "") + Math.Round(pct, 0) + "%";
            }
            catch { return ""; }
        }

        private string GetRatingTrend(SqlConnection con)
        {
            try
            {
                decimal thisMonth = GetScalarDecimal(con,
                    @"SELECT ISNULL(ROUND(AVG(CAST(Rating AS DECIMAL(3,1))),1),0)
                      FROM Reviews WHERE MONTH(CreatedAt)=MONTH(GETDATE()) 
                      AND YEAR(CreatedAt)=YEAR(GETDATE())");

                decimal lastMonth = GetScalarDecimal(con,
                    @"SELECT ISNULL(ROUND(AVG(CAST(Rating AS DECIMAL(3,1))),1),0)
                      FROM Reviews WHERE MONTH(CreatedAt)=MONTH(DATEADD(MONTH,-1,GETDATE())) 
                      AND YEAR(CreatedAt)=YEAR(DATEADD(MONTH,-1,GETDATE()))");

                decimal diff = thisMonth - lastMonth;
                return (diff >= 0 ? "+" : "") + diff.ToString("F1");
            }
            catch { return ""; }
        }

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

        // ── Helper Methods for Repeaters ──────────────────────────────────────────
        protected string GetEventEmoji(object eventType)
        {
            if (eventType == null || eventType == DBNull.Value)
                return "🎪";

            string type = eventType.ToString().ToLower();

            switch (type)
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

        protected string GetEventBackgroundClass(object eventType)
        {
            if (eventType == null || eventType == DBNull.Value)
                return "holi";

            string type = eventType.ToString().ToLower();

            switch (type)
            {
                case "music": return "music";
                case "film": return "film";
                case "food": return "film";
                default: return "holi";
            }
        }

        protected string FormatEventDate(object releaseDate)
        {
            if (releaseDate == null || releaseDate == DBNull.Value)
                return "TBA";

            DateTime date = Convert.ToDateTime(releaseDate);
            return date.ToString("d MMMM, yyyy");
        }

        protected string GetCategoryEmoji(object category)
        {
            if (category == null || category == DBNull.Value)
                return "🎪";

            string cat = category.ToString().ToLower();

            switch (cat)
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

        protected string GetRankClass(int index)
        {
            return index < 2 ? "rank top" : "rank";
        }

        protected string GetPopImageGradient(int index)
        {
            string[] gradients = {
                "linear-gradient(135deg,#fde68a,#fca5a5)",
                "linear-gradient(135deg,#93c5fd,#c084fc)",
                "linear-gradient(135deg,#6ee7b7,#67e8f9)",
                "linear-gradient(135deg,#fde68a,#fb923c)"
            };
            return gradients[index % gradients.Length];
        }

        // ── Button Click Handlers ─────────────────────────────────────────────────
        protected void btnGetTickets_Click(object sender, EventArgs e)
        {
            // Redirect to first upcoming event or events page
            Response.Redirect("Event.aspx");
        }

        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            Response.Redirect("Event.aspx");
        }

        protected void btnAttend_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string eventId = btn.CommandArgument;
            Response.Redirect("BookTicket.aspx?EventId=" + eventId);
        }

        protected void btnUpgrade_Click(object sender, EventArgs e)
        {
            Response.Redirect("Upgrade.aspx");
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
                Response.Redirect("Event.aspx?q=" + Server.UrlEncode(query));
            else
                Response.Redirect("Event.aspx");
        }
    }
}