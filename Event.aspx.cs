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
    public partial class Event : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        private const int PageSize = 8;

        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1; }
            set { ViewState["CurrentPage"] = value; }
        }

        private string ActiveFilter
        {
            get { return ViewState["ActiveFilter"] != null ? ViewState["ActiveFilter"].ToString() : "All"; }
            set { ViewState["ActiveFilter"] = value; }
        }

        private string SearchQuery
        {
            get { return ViewState["SearchQuery"] != null ? ViewState["SearchQuery"].ToString() : ""; }
            set { ViewState["SearchQuery"] = value; }
        }

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
                LoadPageCounters();
                ApplyChipUI("All");

                string searchQuery = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(searchQuery))
                {
                    txtSearch.Text = searchQuery;
                    SearchQuery = searchQuery;
                }

                string category = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(category))
                {
                    ActiveFilter = category;
                    ApplyChipUI(category);
                }

                LoadEvents(CurrentPage, ActiveFilter, SearchQuery);
            }
        }

        private void LoadUserInfo()
        {
            string username = Session["Username"].ToString();
            lblUserName.Text = username;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = username.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = username.Substring(0, 1).ToUpper();
        }

        private void LoadPageCounters()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // Total events count
                    string query = "SELECT COUNT(*) FROM Events WHERE EndDate >= GETDATE()";
                    SqlCommand cmd = new SqlCommand(query, con);
                    int totalCount = (int)cmd.ExecuteScalar();
                    lblTotalCount.Text = totalCount.ToString();

                    // This week count
                    query = "SELECT COUNT(*) FROM Events WHERE EndDate >= GETDATE() AND ReleaseDate <= DATEADD(day, 7, GETDATE())";
                    cmd = new SqlCommand(query, con);
                    int weekCount = (int)cmd.ExecuteScalar();
                    lblWeekCount.Text = weekCount.ToString();

                    // Free events count (assuming price = 0 or contains "Free")
                    query = "SELECT COUNT(*) FROM Events WHERE EndDate >= GETDATE() AND (Title LIKE '%Free%' OR Description LIKE '%Free%')";
                    cmd = new SqlCommand(query, con);
                    int freeCount = (int)cmd.ExecuteScalar();
                    lblFreeCount.Text = freeCount.ToString();
                }
            }
            catch (Exception ex)
            {
                // Log error
                lblTotalCount.Text = "0";
                lblWeekCount.Text = "0";
                lblFreeCount.Text = "0";
            }
        }

        private void LoadEvents(int page, string filter, string search = "")
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // Build query with filters
                    string countQuery = "SELECT COUNT(*) FROM Events WHERE EndDate >= GETDATE()";
                    string dataQuery = @"SELECT EventId, Title, EventType, Description, DurationMins, 
                                       Language, Genre, ReleaseDate, EndDate, CreatedAt 
                                       FROM Events 
                                       WHERE EndDate >= GETDATE()";

                    // Apply category filter
                    if (filter != "All")
                    {
                        if (filter == "Free")
                        {
                            countQuery += " AND (Title LIKE '%Free%' OR Description LIKE '%Free%')";
                            dataQuery += " AND (Title LIKE '%Free%' OR Description LIKE '%Free%')";
                        }
                        else
                        {
                            countQuery += " AND (EventType = @Filter OR Genre LIKE '%' + @Filter + '%')";
                            dataQuery += " AND (EventType = @Filter OR Genre LIKE '%' + @Filter + '%')";
                        }
                    }

                    // Apply search filter
                    if (!string.IsNullOrEmpty(search))
                    {
                        countQuery += " AND (Title LIKE '%' + @Search + '%' OR Description LIKE '%' + @Search + '%')";
                        dataQuery += " AND (Title LIKE '%' + @Search + '%' OR Description LIKE '%' + @Search + '%')";
                    }

                    // Apply sorting
                    string sortOrder = ddlSort.SelectedValue;
                    switch (sortOrder)
                    {
                        case "upcoming":
                            dataQuery += " ORDER BY ReleaseDate ASC";
                            break;
                        case "popular":
                            dataQuery += " ORDER BY CreatedAt DESC";
                            break;
                        default:
                            dataQuery += " ORDER BY ReleaseDate ASC";
                            break;
                    }

                    // Get total count
                    SqlCommand countCmd = new SqlCommand(countQuery, con);
                    if (filter != "All" && filter != "Free")
                        countCmd.Parameters.AddWithValue("@Filter", filter);
                    if (!string.IsNullOrEmpty(search))
                        countCmd.Parameters.AddWithValue("@Search", search);

                    int totalRecords = (int)countCmd.ExecuteScalar();

                    // Apply pagination
                    int offset = (page - 1) * PageSize;
                    dataQuery += " OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    SqlCommand dataCmd = new SqlCommand(dataQuery, con);
                    if (filter != "All" && filter != "Free")
                        dataCmd.Parameters.AddWithValue("@Filter", filter);
                    if (!string.IsNullOrEmpty(search))
                        dataCmd.Parameters.AddWithValue("@Search", search);
                    dataCmd.Parameters.AddWithValue("@Offset", offset);
                    dataCmd.Parameters.AddWithValue("@PageSize", PageSize);

                    SqlDataAdapter sda = new SqlDataAdapter(dataCmd);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    // Bind to repeater
                    rptEvents.DataSource = dt;
                    rptEvents.DataBind();

                    // Also bind featured events (top 2)
                    dataCmd.CommandText = dataQuery.Replace("OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY",
                                                           "ORDER BY CreatedAt DESC OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY");
                    DataTable dtFeatured = new DataTable();
                    SqlDataAdapter sdaFeatured = new SqlDataAdapter(dataCmd);
                    sdaFeatured.Fill(dtFeatured);

                    rptFeatured.DataSource = dtFeatured;
                    rptFeatured.DataBind();

                    // Update UI
                    int showing = Math.Min(PageSize, totalRecords - offset);
                    if (showing < 0) showing = 0;

                    lblShowing.Text = showing.ToString();
                    lblTotal.Text = totalRecords.ToString();
                    lblFilterLabel.Text = filter == "All" ? "" : " in " + filter;

                    UpdatePaginationUI(page, totalRecords);
                }
            }
            catch (Exception ex)
            {
                // Log error
                Response.Write("<script>alert('Error loading events: " + ex.Message + "');</script>");
            }
        }

        private void UpdatePaginationUI(int page, int totalRecords)
        {
            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

            btnPage1.CssClass = page == 1 ? "page-btn active" : "page-btn";
            btnPage2.CssClass = page == 2 ? "page-btn active" : "page-btn";
            btnPage3.CssClass = page == 3 ? "page-btn active" : "page-btn";
            btnPage4.CssClass = page == 4 ? "page-btn active" : "page-btn";

            btnPrev.Enabled = page > 1;
            btnNext.Enabled = page < totalPages;

            // Hide page buttons if not needed
            btnPage2.Visible = totalPages >= 2;
            btnPage3.Visible = totalPages >= 3;
            btnPage4.Visible = totalPages >= 4;
        }

        private void ApplyChipUI(string filter)
        {
            chipAll.CssClass = "chip" + (filter == "All" ? " active" : "");
            chipMusic.CssClass = "chip" + (filter == "Music" ? " active" : "");
            chipFilm.CssClass = "chip" + (filter == "Film" ? " active" : "");
            chipArts.CssClass = "chip" + (filter == "Arts" ? " active" : "");
            chipComedy.CssClass = "chip" + (filter == "Comedy" ? " active" : "");
            chipFood.CssClass = "chip" + (filter == "Food" ? " active" : "");
            chipDance.CssClass = "chip" + (filter == "Dance" ? " active" : "");
            chipSports.CssClass = "chip" + (filter == "Sports" ? " active" : "");
            chipFree.CssClass = "chip" + (filter == "Free" ? " active" : "");
        }

        protected void Chip_Click(object sender, EventArgs e)
        {
            var lb = (LinkButton)sender;
            ActiveFilter = lb.CommandArgument;
            CurrentPage = 1;
            ApplyChipUI(ActiveFilter);
            LoadEvents(1, ActiveFilter, SearchQuery);
        }

        protected void ddlSort_Changed(object sender, EventArgs e)
        {
            LoadEvents(CurrentPage, ActiveFilter, SearchQuery);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            SearchQuery = txtSearch.Text.Trim();
            CurrentPage = 1;
            LoadEvents(1, ActiveFilter, SearchQuery);
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            string eventId = ((Button)sender).CommandArgument;
            Response.Redirect("BookTicket.aspx?EventId=" + eventId);
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadEvents(CurrentPage, ActiveFilter, SearchQuery);
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadEvents(CurrentPage, ActiveFilter, SearchQuery);
        }

        protected void btnPageNum_Click(object sender, EventArgs e)
        {
            CurrentPage = int.Parse(((LinkButton)sender).CommandArgument);
            LoadEvents(CurrentPage, ActiveFilter, SearchQuery);
        }

        // Helper method to get emoji based on event type
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
                case "festival": return "🎆";
                default: return "🎪";
            }
        }

        // Helper method to get background class
        protected string GetBackgroundClass(object index)
        {
            int idx = Convert.ToInt32(index) % 8;
            return "bg" + (idx + 1);
        }

        // Helper method to get tag class
        protected string GetTagClass(object eventType)
        {
            if (eventType == null || eventType == DBNull.Value)
                return "tag-fest";

            string type = eventType.ToString().ToLower();
            return "tag-" + type;
        }

        // Helper method to format date
        protected string FormatEventDate(object releaseDate)
        {
            if (releaseDate == null || releaseDate == DBNull.Value)
                return "TBA";

            DateTime date = Convert.ToDateTime(releaseDate);
            return date.ToString("ddd, dd MMM");
        }

        // Helper method to truncate description
        protected string TruncateText(object text, int maxLength)
        {
            if (text == null || text == DBNull.Value)
                return "";

            string str = text.ToString();
            return str.Length <= maxLength ? str : str.Substring(0, maxLength) + "...";
        }
    }
}