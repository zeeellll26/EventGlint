using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace EventGlint
{
    public partial class AdminPanel : Page
    {
        // ── Connection string from Web.config ──────────────────────────────────
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ── Session Guard ──────────────────────────────────────────────────
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Log.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAdminInfo();
                LoadStats();
            }
        }

        // ── Admin Name & Avatar Initial ────────────────────────────────────────
        private void LoadAdminInfo()
        {
            try
            {
                string adminName = Session["Username"]?.ToString() ?? "Admin";
                lbl_AdminName.Text = adminName;

                // First letter of name for avatar
                lbl_AvatarInitial.Text = adminName.Length > 0
                    ? adminName[0].ToString().ToUpper()
                    : "A";
            }
            catch
            {
                lbl_AdminName.Text = "Admin";
                lbl_AvatarInitial.Text = "A";
            }
        }

        // ── Dashboard Stats ────────────────────────────────────────────────────
        private void LoadStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Total Events
                    lbl_TotalEvents.Text = GetScalar(con, "SELECT COUNT(*) FROM Events").ToString();

                    // Total Bookings
                    lbl_TotalBookings.Text = GetScalar(con, "SELECT COUNT(*) FROM Bookings").ToString();

                    // Total Users
                    lbl_TotalUsers.Text = GetScalar(con, "SELECT COUNT(*) FROM Users").ToString();

                    // Total Revenue  (adjust column/table name to match your schema)
                    object revenue = GetScalar(con, "SELECT ISNULL(SUM(Amount), 0) FROM Payments");
                    decimal rev = Convert.ToDecimal(revenue);
                    lbl_TotalRevenue.Text = "₹" + rev.ToString("N0");
                }
            }
            catch (Exception ex)
            {
                // Silently fall back — stats will show "—" (set in markup)
                // Optionally log: System.Diagnostics.Debug.WriteLine(ex.Message);
                lbl_TotalEvents.Text = "—";
                lbl_TotalBookings.Text = "—";
                lbl_TotalUsers.Text = "—";
                lbl_TotalRevenue.Text = "—";
            }
        }

        // ── Helper: single-value query ─────────────────────────────────────────
        private object GetScalar(SqlConnection con, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                return cmd.ExecuteScalar() ?? 0;
            }
        }
    }
}
