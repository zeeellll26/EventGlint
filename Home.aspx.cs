using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadDashboardStats();
            }
        }

        // ── Populate logged-in user details ─────────────────────────────
        private void LoadUserInfo()
        {
            // TODO: Replace with Session / Membership lookup
            string userName = "Rahul Patel";
            string userRole = "Pro Member ✦";

            lblUserName.Text = userName;
            lblUserRole.Text = userRole;
            lblAvatarInitial.Text = userName.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = userName.Substring(0, 1).ToUpper();
            lblLocation.Text = "Surat, Gujarat";
        }

        // ── Populate KPI stat cards ──────────────────────────────────────
        private void LoadDashboardStats()
        {
            // TODO: Replace with real DB queries
            lblEventsCount.Text = "124";
            lblEventsTrend.Text = "+12%";
            lblTicketsSold.Text = "3,410";
            lblTicketsTrend.Text = "+8%";
            lblRating.Text = "4.9";
            lblRatingTrend.Text = "+0.2";
            lblUsers.Text = "52K";
            lblUsersTrend.Text = "-1%";
        }

        // ── Hero — Get Tickets button ────────────────────────────────────
        protected void btnGetTickets_Click(object sender, EventArgs e)
        {
            Response.Redirect("Event.aspx?id=holi2026");
        }

        // ── Hero — Learn More button ─────────────────────────────────────
        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            Response.Redirect("Event.aspx?detail=holi2026");
        }

        // ── Attend buttons on event cards ───────────────────────────────
        // CommandArgument carries the event ID ("1", "2", "3")
        protected void btnAttend_Click(object sender, EventArgs e)
        {
            var btn = (System.Web.UI.WebControls.Button)sender;
            string eventId = btn.CommandArgument;
            Response.Redirect("Event.aspx?id=" + eventId);
        }

        // ── Promo — Upgrade Now button ───────────────────────────────────
        protected void btnUpgrade_Click(object sender, EventArgs e)
        {
            Response.Redirect("Upgrade.aspx");
        }

        // ── Topbar — Search / Filter button ─────────────────────────────
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