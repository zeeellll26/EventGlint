using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Event : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
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
                    txtSearch.Text = searchQuery;

                string category = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(category))
                {
                    ActiveFilter = category;
                    ApplyChipUI(category);
                }

                LoadEvents(CurrentPage, ActiveFilter);
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
            lblTotalCount.Text = "124";
            lblWeekCount.Text = "18";
            lblFreeCount.Text = "32";
        }

        private void LoadEvents(int page, string filter)
        {
            int totalRecords = filter == "All" ? 124
                             : filter == "Free" ? 32
                             : filter == "Music" ? 48
                             : filter == "Film" ? 22
                             : filter == "Arts" ? 31
                             : filter == "Food" ? 14
                             : filter == "Comedy" ? 18
                             : filter == "Dance" ? 12
                             : filter == "Sports" ? 9
                             : 20;

            int showing = Math.Min(PageSize, totalRecords - (page - 1) * PageSize);
            if (showing < 0) showing = 0;

            lblShowing.Text = showing.ToString();
            lblTotal.Text = totalRecords.ToString();
            lblFilterLabel.Text = filter == "All" ? "" : " in " + filter;

            UpdatePaginationUI(page, totalRecords);
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
            LoadEvents(1, ActiveFilter);
        }

        protected void ddlSort_Changed(object sender, EventArgs e)
        {
            LoadEvents(CurrentPage, ActiveFilter);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ActiveFilter = "All";
            CurrentPage = 1;
            ApplyChipUI("All");
            LoadEvents(1, "All");
        }

        // ── ALL buttons (Book Now / Register / Explore / Featured) ────────
        // Just grab CommandArgument (EventId) and go to BookTicket.aspx
        protected void btnBook_Click(object sender, EventArgs e)
        {
            string eventId = ((Button)sender).CommandArgument;
            Response.Redirect("BookTicket.aspx?EventId=" + eventId);
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1) { CurrentPage--; LoadEvents(CurrentPage, ActiveFilter); }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadEvents(CurrentPage, ActiveFilter);
        }

        protected void btnPageNum_Click(object sender, EventArgs e)
        {
            CurrentPage = int.Parse(((LinkButton)sender).CommandArgument);
            LoadEvents(CurrentPage, ActiveFilter);
        }
    }
}