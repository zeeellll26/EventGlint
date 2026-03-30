using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Shows : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        // ── ViewState helpers ───────────────────────────────────────────
        private string ActiveFilter
        {
            get { return ViewState["ActiveFilter"] != null ? ViewState["ActiveFilter"].ToString() : "All"; }
            set { ViewState["ActiveFilter"] = value; }
        }

        private string SortBy
        {
            get { return ViewState["SortBy"] != null ? ViewState["SortBy"].ToString() : "recommended"; }
            set { ViewState["SortBy"] = value; }
        }

        // ── Page Load ────────────────────────────────────────────────────
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
                LoadUserLocation();
                LoadHeroCounters();
                LoadAllSections();
                ApplyChipUI("All");
            }
        }

        // ── Fill sidebar and topbar user info from Session/DB ───────────
        private void LoadUserInfo()
        {
            string username = Session["Username"].ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT FirstName, LastName, Email FROM Users WHERE Username = @username", con);
                cmd.Parameters.AddWithValue("@username", username);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    string firstName = dr["FirstName"].ToString();
                    string lastName = dr["LastName"].ToString();
                    string fullName = (firstName + " " + lastName).Trim();

                    if (string.IsNullOrEmpty(fullName))
                        fullName = username;

                    lblUserName.Text = fullName;
                    lblAvatarInitial.Text = firstName.Length > 0 ? firstName.Substring(0, 1).ToUpper() : username.Substring(0, 1).ToUpper();
                    lblTopAvatar.Text = lblAvatarInitial.Text;
                }
                else
                {
                    lblUserName.Text = username;
                    lblAvatarInitial.Text = username.Substring(0, 1).ToUpper();
                    lblTopAvatar.Text = lblAvatarInitial.Text;
                }
                dr.Close();

                // Get user role/membership status
                SqlCommand cmdRole = new SqlCommand(
                    "SELECT MembershipType FROM Users WHERE Username = @username", con);
                cmdRole.Parameters.AddWithValue("@username", username);
                object memberType = cmdRole.ExecuteScalar();

                if (memberType != null && !string.IsNullOrEmpty(memberType.ToString()))
                {
                    lblUserRole.Text = memberType.ToString() + " ✦";
                }
                else
                {
                    lblUserRole.Text = "Member";
                }
            }
        }

        // ── Load user's location from database ──────────────────────────
        private void LoadUserLocation()
        {
            string username = Session["Username"].ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT City, State FROM Users WHERE Username = @username", con);
                cmd.Parameters.AddWithValue("@username", username);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    string city = dr["City"].ToString();
                    string state = dr["State"].ToString();

                    if (!string.IsNullOrEmpty(city) && !string.IsNullOrEmpty(state))
                    {
                        lblLocation.Text = city + ", " + state;
                    }
                    else if (!string.IsNullOrEmpty(city))
                    {
                        lblLocation.Text = city;
                    }
                    else
                    {
                        lblLocation.Text = "Select Location";
                    }
                }
                dr.Close();
            }
        }

        // ── Load hero counter numbers from DB ─────────────────────────────
        private void LoadHeroCounters()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Movie count
                SqlCommand c1 = new SqlCommand(@"
                    SELECT COUNT(DISTINCT sh.ShowId) 
                    FROM Shows sh 
                    JOIN Events e ON e.EventId = sh.EventId 
                    WHERE e.EventType = 'Movie' 
                      AND sh.Status IN ('Upcoming', 'Live') 
                      AND sh.ShowDate >= CAST(GETDATE() AS DATE)", con);
                object movieCount = c1.ExecuteScalar();
                lblMovieCount.Text = movieCount != null ? movieCount.ToString() : "0";

                // Concert/Music count
                SqlCommand c2 = new SqlCommand(@"
                    SELECT COUNT(DISTINCT sh.ShowId) 
                    FROM Shows sh 
                    JOIN Events e ON e.EventId = sh.EventId 
                    WHERE e.EventType = 'Concert' 
                      AND sh.Status IN ('Upcoming', 'Live') 
                      AND sh.ShowDate >= CAST(GETDATE() AS DATE)", con);
                object musicCount = c2.ExecuteScalar();
                lblMusicCount.Text = musicCount != null ? musicCount.ToString() : "0";

                // Comedy count
                SqlCommand c3 = new SqlCommand(@"
                    SELECT COUNT(DISTINCT sh.ShowId) 
                    FROM Shows sh 
                    JOIN Events e ON e.EventId = sh.EventId 
                    WHERE e.EventType = 'Comedy' 
                      AND sh.Status IN ('Upcoming', 'Live') 
                      AND sh.ShowDate >= CAST(GETDATE() AS DATE)", con);
                object comedyCount = c3.ExecuteScalar();
                lblComedyCount.Text = comedyCount != null ? comedyCount.ToString() : "0";
            }
        }

        // ── Load all three sections based on active filter ───────────────
        private void LoadAllSections()
        {
            string filter = ActiveFilter;
            string sort = SortBy;

            if (filter == "All")
            {
                LoadShowSection(rptMovies, "Movie", sort);
                LoadShowSection(rptMusic, "Concert", sort);
                LoadShowSection(rptComedy, "Comedy", sort);
            }
            else if (filter == "Movies")
            {
                LoadShowSection(rptMovies, "Movie", sort);
                rptMusic.DataSource = null;
                rptMusic.DataBind();
                rptComedy.DataSource = null;
                rptComedy.DataBind();
            }
            else if (filter == "Music")
            {
                rptMovies.DataSource = null;
                rptMovies.DataBind();
                LoadShowSection(rptMusic, "Concert", sort);
                rptComedy.DataSource = null;
                rptComedy.DataBind();
            }
            else if (filter == "Comedy")
            {
                rptMovies.DataSource = null;
                rptMovies.DataBind();
                rptMusic.DataSource = null;
                rptMusic.DataBind();
                LoadShowSection(rptComedy, "Comedy", sort);
            }
            else if (filter == "Drama")
            {
                LoadShowSection(rptMovies, "Play", sort);
                rptMusic.DataSource = null;
                rptMusic.DataBind();
                rptComedy.DataSource = null;
                rptComedy.DataBind();
            }
            else if (filter == "Free")
            {
                LoadFreeShows(rptMovies, sort);
                rptMusic.DataSource = null;
                rptMusic.DataBind();
                rptComedy.DataSource = null;
                rptComedy.DataBind();
            }
            else
            {
                LoadShowSection(rptMovies, "Movie", sort);
                LoadShowSection(rptMusic, "Concert", sort);
                LoadShowSection(rptComedy, "Comedy", sort);
            }
        }

        // ── Load shows for a specific event type with sorting ────────────
        private void LoadShowSection(Repeater rpt, string eventType, string sortBy)
        {
            string orderClause = GetOrderClause(sortBy);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 4
                        sh.ShowId,
                        e.Title,
                        e.EventType,
                        e.Language,
                        e.Description,
                        sh.ShowDate,
                        sh.StartTime,
                        sh.EndTime,
                        sh.Status,
                        h.Name AS HallName,
                        h.Capacity,
                        v.Name AS VenueName,
                        v.Address AS VenueAddress,
                        v.City AS VenueCity,
                        (SELECT MIN(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = sh.HallId) AS MinPrice,
                        (SELECT MAX(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = sh.HallId) AS MaxPrice,
                        (SELECT COUNT(*) 
                         FROM Bookings b 
                         WHERE b.ShowId = sh.ShowId 
                           AND b.BookingStatus IN ('Confirmed', 'Pending')) AS BookingCount
                    FROM Shows sh
                    JOIN Events e ON e.EventId = sh.EventId
                    JOIN Halls h ON h.HallId = sh.HallId
                    JOIN Venues v ON v.VenueId = h.VenueId
                    WHERE e.EventType = @type
                      AND sh.Status IN ('Upcoming', 'Live')
                      AND sh.ShowDate >= CAST(GETDATE() AS DATE)
                    " + orderClause;

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@type", eventType);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rpt.DataSource = dt;
                rpt.DataBind();
            }
        }

        // ── Load free shows only ─────────────────────────────────────────
        private void LoadFreeShows(Repeater rpt, string sortBy)
        {
            string orderClause = GetOrderClause(sortBy);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 4
                        sh.ShowId,
                        e.Title,
                        e.EventType,
                        e.Language,
                        e.Description,
                        sh.ShowDate,
                        sh.StartTime,
                        sh.EndTime,
                        sh.Status,
                        h.Name AS HallName,
                        h.Capacity,
                        v.Name AS VenueName,
                        v.Address AS VenueAddress,
                        v.City AS VenueCity,
                        (SELECT MIN(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = sh.HallId) AS MinPrice,
                        (SELECT MAX(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = sh.HallId) AS MaxPrice
                    FROM Shows sh
                    JOIN Events e ON e.EventId = sh.EventId
                    JOIN Halls h ON h.HallId = sh.HallId
                    JOIN Venues v ON v.VenueId = h.VenueId
                    WHERE sh.Status IN ('Upcoming', 'Live')
                      AND sh.ShowDate >= CAST(GETDATE() AS DATE)
                      AND (SELECT MIN(sc.Price) FROM SeatCategories sc WHERE sc.HallId = sh.HallId) = 0
                    " + orderClause;

                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rpt.DataSource = dt;
                rpt.DataBind();
            }
        }

        // ── Get SQL ORDER BY clause based on sort option ─────────────────
        private string GetOrderClause(string sortBy)
        {
            switch (sortBy)
            {
                case "price_asc":
                    return "ORDER BY MinPrice ASC, sh.ShowDate, sh.StartTime";
                case "price_desc":
                    return "ORDER BY MinPrice DESC, sh.ShowDate, sh.StartTime";
                case "popular":
                    return "ORDER BY BookingCount DESC, sh.ShowDate, sh.StartTime";
                case "recommended":
                default:
                    return "ORDER BY sh.ShowDate, sh.StartTime";
            }
        }

        // ── Filter chip click ─────────────────────────────────────────────
        protected void Chip_Click(object sender, EventArgs e)
        {
            string filter = ((LinkButton)sender).CommandArgument;
            ActiveFilter = filter;
            ApplyChipUI(filter);
            LoadAllSections();
        }

        // ── Sort dropdown ─────────────────────────────────────────────────
        protected void ddlSort_Changed(object sender, EventArgs e)
        {
            SortBy = ddlSort.SelectedValue;
            LoadAllSections();
        }

        // ── ALL Book Now buttons → BookShow.aspx?ShowId=X ─────────────────
        protected void btnBook_Click(object sender, EventArgs e)
        {
            string showId = ((Button)sender).CommandArgument;
            Response.Redirect("BookShow.aspx?ShowId=" + showId);
        }

        // ── Sync chip active CSS class ────────────────────────────────────
        private void ApplyChipUI(string filter)
        {
            chipAll.CssClass = "chip" + (filter == "All" ? " active" : "");
            chipMovies.CssClass = "chip" + (filter == "Movies" ? " active" : "");
            chipMusic.CssClass = "chip" + (filter == "Music" ? " active" : "");
            chipComedy.CssClass = "chip" + (filter == "Comedy" ? " active" : "");
            chipDrama.CssClass = "chip" + (filter == "Drama" ? " active" : "");
            chipFree.CssClass = "chip" + (filter == "Free" ? " active" : "");
        }

        // ── Helper: format time for display ──────────────────────────────
        protected string FormatTime(object timeVal)
        {
            if (timeVal == null || timeVal == DBNull.Value) return "";
            if (timeVal is TimeSpan ts)
                return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(timeVal.ToString(), out TimeSpan parsed))
                return DateTime.Today.Add(parsed).ToString("hh:mm tt");
            return timeVal.ToString();
        }

        // ── Helper: format price ──────────────────────────────────────────
        protected string FormatPrice(object price)
        {
            if (price == null || price == DBNull.Value) return "Free";
            decimal p = Convert.ToDecimal(price);
            return p == 0 ? "Free" : "₹" + p.ToString("N0");
        }

        // ── Helper: get background class by index ─────────────────────────
        protected string GetBgClass(int index)
        {
            string[] classes = { "bg1", "bg2", "bg3", "bg4", "bg5", "bg6", "bg7", "bg8" };
            return classes[index % classes.Length];
        }

        // ── Helper: tag CSS class based on event type ─────────────────────
        protected string GetTagClass(object eventType)
        {
            if (eventType == null) return "tag-movie";
            switch (eventType.ToString().ToLower())
            {
                case "movie": return "tag-movie";
                case "concert": return "tag-music";
                case "comedy": return "tag-comedy";
                case "play": return "tag-drama";
                default: return "tag-other";
            }
        }

        // ── Helper: emoji for event type ─────────────────────────────────
        protected string GetEmoji(object eventType)
        {
            if (eventType == null) return "🎪";
            switch (eventType.ToString().ToLower())
            {
                case "movie": return "🎬";
                case "concert": return "🎵";
                case "comedy": return "🎤";
                case "play": return "🎭";
                default: return "🎪";
            }
        }

        // ── Helper: check if repeater has data ───────────────────────────
        protected bool HasData(object dataSource)
        {
            if (dataSource == null) return false;
            if (dataSource is DataTable dt)
                return dt.Rows.Count > 0;
            return false;
        }
    }
}