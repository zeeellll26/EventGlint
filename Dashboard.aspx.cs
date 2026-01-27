using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Dashboard : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["username"] == null)
            {
                Response.Redirect("Log.aspx");
            }

            if (!IsPostBack)
            {
                //LoadUserInfo();
            }
        }

        //void LoadUserInfo()
        //{
        //    string user = Session["username"].ToString();

        //    using (SqlConnection conn = new SqlConnection(strcon))
        //    {
        //        conn.Open();
        //        string sql = "SELECT username FROM UserLogin WHERE username = @user";
        //        using (SqlCommand cmd = new SqlCommand(sql, conn))
        //        {
        //            cmd.Parameters.AddWithValue("@", user);
        //            string username = cmd.ExecuteScalar()?.ToString() ?? "User";
        //            lblUserName.Text = $"Hi, {username}!";
        //        }
        //    }
        //}

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Log.aspx");
        }
    }
}