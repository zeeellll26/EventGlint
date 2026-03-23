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

        private const int PageSize = 8; // 8 poster cards per page

        // ── ViewState helpers ─────────────────────────────────────────────
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

        // ── Page Load ─────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadPageCounters();
                ApplyChipUI("All");

                // If arrived from Home.aspx search box
                string searchQuery = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(searchQuery))
                    txtSearch.Text = searchQuery;

                // If arrived from Home.aspx with a category
                string category = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(category))
                {
                    ActiveFilter = category;
                    ApplyChipUI(category);
                }

                LoadEvents(CurrentPage, ActiveFilter);
            }
        }

        // ── Load sidebar user info ─────────────────────────────────────────
        private void LoadUserInfo()
        {
            // TODO: Replace with Session / Membership lookup
            string userName = "Rahul Patel";
            lblUserName.Text = userName;
            lblUserRole.Text = "Pro Member ✦";
            lblAvatarInitial.Text = userName.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = userName.Substring(0, 1).ToUpper();
            lblLocation.Text = "Surat, Gujarat";
        }

        // ── Load hero banner counters ──────────────────────────────────────
        private void LoadPageCounters()
        {
            // TODO: Replace with real DB COUNT queries
            lblTotalCount.Text = "124";
            lblWeekCount.Text = "18";
            lblFreeCount.Text = "32";
        }

        // ── Load event grid based on page + filter ─────────────────────────
        private void LoadEvents(int page, string filter)
        {
            // TODO: Replace with real Entity Framework / ADO.NET query, e.g.:
            //
            // var query = db.Events
            //               .Where(e => e.IsActive && (filter == "All" || e.Category == filter))
            //               .OrderBy(e => e.EventDate);
            //
            // int total   = query.Count();
            // var records = query.Skip((page - 1) * PageSize).Take(PageSize).ToList();
            // rptEvents.DataSource = records;
            // rptEvents.DataBind();

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

        // ── Update pagination button active states ─────────────────────────
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

        // ── Sync category chip CSS classes ────────────────────────────────
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

        // ── Category chip click ────────────────────────────────────────────
        protected void Chip_Click(object sender, EventArgs e)
        {
            var lb = (LinkButton)sender;
            string cat = lb.CommandArgument;

            ActiveFilter = cat;
            CurrentPage = 1;

            ApplyChipUI(cat);
            LoadEvents(1, cat);
        }

        // ── Sort dropdown change ───────────────────────────────────────────
        protected void ddlSort_Changed(object sender, EventArgs e)
        {
            // TODO: Pass ddlSort.SelectedValue to DB ORDER BY clause
            // Options: "upcoming", "price_asc", "price_desc", "popular"
            LoadEvents(CurrentPage, ActiveFilter);
        }

        // ── Search button ──────────────────────────────────────────────────
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            // TODO: Full-text search against event name, venue, description
            ActiveFilter = "All";
            CurrentPage = 1;
            ApplyChipUI("All");
            LoadEvents(1, "All");
        }

        // ── Book / Register buttons on poster cards ────────────────────────
        // CommandArgument = event ID
        protected void btnBook_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            string id = btn.CommandArgument;
            // TODO: Redirect to event detail / booking page
            Response.Redirect("EventDetail.aspx?id=" + id);
        }

        // ── Featured card Book buttons ─────────────────────────────────────
        // (btnFeat1, btnFeat2 also route through btnBook_Click via shared handler)

        // ── Pagination — Previous ──────────────────────────────────────────
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadEvents(CurrentPage, ActiveFilter);
            }
        }

        // ── Pagination — Next ─────────────────────────────────────────────
        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadEvents(CurrentPage, ActiveFilter);
        }

        // ── Pagination — Numbered pages ───────────────────────────────────
        protected void btnPageNum_Click(object sender, EventArgs e)
        {
            var lb = (LinkButton)sender;
            CurrentPage = int.Parse(lb.CommandArgument);
            LoadEvents(CurrentPage, ActiveFilter);
        }
    }
}