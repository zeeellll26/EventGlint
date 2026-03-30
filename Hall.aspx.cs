using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Hall : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        // ── ViewState helpers ─────────────────────────────────────────────
        private string ActiveFilter
        {
            get { return ViewState["ActiveFilter"] != null ? ViewState["ActiveFilter"].ToString() : "All"; }
            set { ViewState["ActiveFilter"] = value; }
        }

        private string SortBy
        {
            get { return ViewState["SortBy"] != null ? ViewState["SortBy"].ToString() : "default"; }
            set { ViewState["SortBy"] = value; }
        }

        // ── Page Load ─────────────────────────────────────────────────────
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
                LoadHalls("All", "default");
                ApplyChipUI("All");
            }
        }

        // ── Fill sidebar and topbar user info from Session/DB ────────────
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

        // ── Load user's location from database ───────────────────────────
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

                // Total halls count
                SqlCommand c1 = new SqlCommand("SELECT COUNT(*) FROM Halls", con);
                object hallCount = c1.ExecuteScalar();
                lblHallCount.Text = hallCount != null ? hallCount.ToString() : "0";

                // Unique venues count
                SqlCommand c2 = new SqlCommand("SELECT COUNT(DISTINCT VenueId) FROM Halls", con);
                object venueCount = c2.ExecuteScalar();
                lblVenueCount.Text = venueCount != null ? venueCount.ToString() : "0";

                // Total capacity across all halls
                SqlCommand c3 = new SqlCommand("SELECT ISNULL(SUM(TotalCapacity), 0) FROM Halls", con);
                object totalCapacity = c3.ExecuteScalar();

                if (totalCapacity != null && totalCapacity != DBNull.Value)
                {
                    int total = Convert.ToInt32(totalCapacity);
                    lblCapacityCount.Text = total >= 1000
                        ? (total / 1000.0).ToString("F1") + "K"
                        : total.ToString();
                }
                else
                {
                    lblCapacityCount.Text = "0";
                }
            }
        }

        // ── Load halls from DB with filter and sorting ───────────────────
        private void LoadHalls(string filter, string sortBy)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        h.HallId,
                        h.Name AS HallName,
                        h.HallType,
                        h.TotalCapacity,
                        h.Description AS HallDescription,
                        v.VenueId,
                        v.Name AS VenueName,
                        v.Address AS VenueAddress,
                        v.City AS VenueCity,
                        c.CityId,
                        c.Name AS CityName,
                        (SELECT MIN(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = h.HallId) AS MinPrice,
                        (SELECT MAX(sc.Price)
                         FROM SeatCategories sc
                         WHERE sc.HallId = h.HallId) AS MaxPrice,
                        (SELECT COUNT(DISTINCT sc.CategoryId)
                         FROM SeatCategories sc
                         WHERE sc.HallId = h.HallId) AS CategoryCount
                    FROM Halls h
                    JOIN Venues v ON v.VenueId = h.VenueId
                    LEFT JOIN Cities c ON c.CityId = v.CityId
                    WHERE 1=1";

                // Apply filter
                if (filter != "All")
                {
                    // Map filter names to HallType in database
                    // If your DB has different naming, adjust accordingly
                    query += " AND h.HallType = @filter";
                }

                // Apply sorting
                switch (sortBy)
                {
                    case "price_asc":
                        query += " ORDER BY MinPrice ASC, h.Name";
                        break;
                    case "price_desc":
                        query += " ORDER BY MinPrice DESC, h.Name";
                        break;
                    case "capacity":
                        query += " ORDER BY h.TotalCapacity DESC, h.Name";
                        break;
                    case "default":
                    default:
                        query += " ORDER BY v.CityId, h.Name";
                        break;
                }

                SqlCommand cmd = new SqlCommand(query, con);

                if (filter != "All")
                {
                    cmd.Parameters.AddWithValue("@filter", filter);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptHalls.DataSource = dt;
                rptHalls.DataBind();

                // Show/hide empty state
                pnlEmpty.Visible = (dt.Rows.Count == 0);
            }
        }

        // ── Chip click ────────────────────────────────────────────────────
        protected void Chip_Click(object sender, EventArgs e)
        {
            string filter = ((LinkButton)sender).CommandArgument;
            ActiveFilter = filter;
            ApplyChipUI(filter);
            LoadHalls(filter, SortBy);
        }

        // ── Sort dropdown ─────────────────────────────────────────────────
        protected void ddlSort_Changed(object sender, EventArgs e)
        {
            SortBy = ddlSort.SelectedValue;
            LoadHalls(ActiveFilter, SortBy);
        }

        // ── Book Now button → BookHall.aspx?HallId=X ──────────────────────
        protected void btnHall_Click(object sender, EventArgs e)
        {
            string hallId = ((Button)sender).CommandArgument;
            Response.Redirect("BookHall.aspx?HallId=" + hallId);
        }

        // ── Sync chip CSS ─────────────────────────────────────────────────
        private void ApplyChipUI(string filter)
        {
            chipAll.CssClass = "chip" + (filter == "All" ? " active" : "");
            chipWedding.CssClass = "chip" + (filter == "Wedding" ? " active" : "");
            chipCorp.CssClass = "chip" + (filter == "Corporate" ? " active" : "");
            chipOutdoor.CssClass = "chip" + (filter == "Outdoor" ? " active" : "");
            chipBanquet.CssClass = "chip" + (filter == "Banquet" ? " active" : "");
            chipLuxury.CssClass = "chip" + (filter == "Luxury" ? " active" : "");
        }

        // ── Helper: get hall emoji based on type ─────────────────────────
        protected string GetHallEmoji(object hallType)
        {
            if (hallType == null || hallType == DBNull.Value) return "🏛️";

            string type = hallType.ToString().ToLower();

            // Map hall types to emojis
            if (type.Contains("imax")) return "🎬";
            if (type.Contains("4dx")) return "🎭";
            if (type.Contains("dolby")) return "🎵";
            if (type.Contains("3d")) return "📽️";
            if (type.Contains("wedding")) return "💍";
            if (type.Contains("corporate")) return "💼";
            if (type.Contains("outdoor")) return "🌿";
            if (type.Contains("banquet")) return "🍽️";
            if (type.Contains("luxury")) return "✨";

            return "🏛️";
        }

        // ── Helper: get background class by index ────────────────────────
        protected string GetBgClass(int index)
        {
            string[] classes = { "hbg1", "hbg2", "hbg3", "hbg4", "hbg5", "hbg6" };
            return classes[index % classes.Length];
        }

        // ── Helper: format price ──────────────────────────────────────────
        protected string FormatPrice(object price)
        {
            if (price == null || price == DBNull.Value) return "Price on request";

            decimal p = Convert.ToDecimal(price);

            if (p == 0) return "Contact for pricing";

            return "₹" + p.ToString("N0");
        }

        // ── Helper: get hall description based on type ───────────────────
        protected string GetHallDesc(object hallType, object hallDescription)
        {
            // First, check if there's a custom description in the database
            if (hallDescription != null && hallDescription != DBNull.Value && !string.IsNullOrEmpty(hallDescription.ToString()))
            {
                return hallDescription.ToString();
            }

            // Otherwise, provide default descriptions based on hall type
            if (hallType == null || hallType == DBNull.Value)
                return "Well-equipped hall perfect for events and celebrations.";

            string type = hallType.ToString().ToLower();

            if (type.Contains("imax"))
                return "Premium IMAX hall with the largest screen and immersive surround audio for an unforgettable cinematic experience.";
            if (type.Contains("4dx"))
                return "State-of-the-art 4DX hall with motion seats, environmental effects, and special features for a truly immersive experience.";
            if (type.Contains("dolby"))
                return "Dolby Atmos certified hall with crystal-clear surround sound and advanced audio technology.";
            if (type.Contains("3d"))
                return "Modern 3D hall equipped with the latest projection technology and comfortable seating.";
            if (type.Contains("wedding"))
                return "Elegant wedding hall with beautiful décor, spacious dance floor, and premium amenities for your special day.";
            if (type.Contains("corporate"))
                return "Professional corporate hall equipped with AV systems, projectors, and seating arrangements perfect for meetings and events.";
            if (type.Contains("outdoor"))
                return "Scenic outdoor venue with natural ambiance, perfect for garden parties, ceremonies, and open-air celebrations.";
            if (type.Contains("banquet"))
                return "Spacious banquet hall with elegant interiors, catering facilities, and premium dining arrangements.";
            if (type.Contains("luxury"))
                return "Luxurious premium hall with world-class amenities, sophisticated décor, and exceptional service.";

            return "Well-equipped hall perfect for screenings, events, and celebrations.";
        }

        // ── Helper: get facilities based on hall type ────────────────────
        protected string GetFacilitiesHTML(object hallType)
        {
            string html = "";

            if (hallType == null || hallType == DBNull.Value)
            {
                // Default facilities
                html += "<span class='hall-fac'>❄️ Air Conditioning</span>";
                html += "<span class='hall-fac'>🎤 Stage Area</span>";
                html += "<span class='hall-fac'>💡 Lighting System</span>";
                html += "<span class='hall-fac'>🚗 Parking</span>";
                return html;
            }

            string type = hallType.ToString().ToLower();

            // Common facilities
            html += "<span class='hall-fac'>❄️ Air Conditioning</span>";

            // Type-specific facilities
            if (type.Contains("imax") || type.Contains("dolby") || type.Contains("3d") || type.Contains("4dx"))
            {
                html += "<span class='hall-fac'>🎬 Premium Screen</span>";
                html += "<span class='hall-fac'>🔊 Surround Sound</span>";
                html += "<span class='hall-fac'>🪑 Recliner Seats</span>";
                html += "<span class='hall-fac'>🚗 Parking</span>";
            }
            else if (type.Contains("wedding") || type.Contains("banquet"))
            {
                html += "<span class='hall-fac'>🎤 Stage & Audio</span>";
                html += "<span class='hall-fac'>💡 Lighting System</span>";
                html += "<span class='hall-fac'>🍽️ Catering Support</span>";
                html += "<span class='hall-fac'>💃 Dance Floor</span>";
                html += "<span class='hall-fac'>🚗 Valet Parking</span>";
            }
            else if (type.Contains("corporate"))
            {
                html += "<span class='hall-fac'>📽️ Projector & Screen</span>";
                html += "<span class='hall-fac'>🎤 Audio System</span>";
                html += "<span class='hall-fac'>📶 High-Speed WiFi</span>";
                html += "<span class='hall-fac'>☕ Refreshments</span>";
                html += "<span class='hall-fac'>🚗 Parking</span>";
            }
            else if (type.Contains("outdoor"))
            {
                html += "<span class='hall-fac'>🌳 Garden Setting</span>";
                html += "<span class='hall-fac'>💡 Outdoor Lighting</span>";
                html += "<span class='hall-fac'>🎤 Sound System</span>";
                html += "<span class='hall-fac'>🚗 Parking</span>";
            }
            else
            {
                html += "<span class='hall-fac'>🎤 Stage Area</span>";
                html += "<span class='hall-fac'>💡 Lighting System</span>";
                html += "<span class='hall-fac'>🍽️ Catering Support</span>";
                html += "<span class='hall-fac'>🚗 Parking</span>";
            }

            return html;
        }

        // ── Helper: format capacity ───────────────────────────────────────
        protected string FormatCapacity(object capacity)
        {
            if (capacity == null || capacity == DBNull.Value) return "N/A";

            int cap = Convert.ToInt32(capacity);
            return cap.ToString("N0");
        }

        // ── Helper: get hall category label ──────────────────────────────
        protected string GetHallCategory(object hallType)
        {
            if (hallType == null || hallType == DBNull.Value) return "Standard";

            string type = hallType.ToString();

            // Return the type as-is or format it
            return type.ToUpper();
        }
    }
}