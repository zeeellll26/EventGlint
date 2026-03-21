using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace EventGlint
{
    public partial class AdminPanel : Page
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
                LoadAdminInfo();
                LoadStats();
            }
        }

        
        private void LoadAdminInfo()
        {
            try
            {
                string adminName = Session["Username"]?.ToString() ?? "Admin";
                lbl_AdminName.Text = adminName;

                
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

                    // Total Revenu
                    object revenue = GetScalar(con, "SELECT ISNULL(SUM(Amount), 0) FROM Payments");
                    decimal rev = Convert.ToDecimal(revenue);
                    lbl_TotalRevenue.Text = "₹" + rev.ToString("N0");
                }
            }
            catch (Exception ex)
            {
                
                lbl_TotalEvents.Text = "—";
                lbl_TotalBookings.Text = "—";
                lbl_TotalUsers.Text = "—";
                lbl_TotalRevenue.Text = "—";
            }
        }

        
        private object GetScalar(SqlConnection con, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                return cmd.ExecuteScalar() ?? 0;
            }
        }
    }
}
