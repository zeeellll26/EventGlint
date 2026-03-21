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
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Log.aspx");
                return;
            }
            LoadUserInfo();
        }

        protected void LoadUserInfo()
        {
            string username = Session["Username"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand("SELECT u.Username, c.Name FROM Users u JOIN Cities c ON u.CityId = c.CityId WHERE Username = @Username", con);
            cmd.Parameters.AddWithValue("@Username", username);

            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adpt.Fill(dt);

            if(dt.Rows.Count > 0)
            {
                string name = dt.Rows[0]["Username"].ToString();
                string city = dt.Rows[0]["Name"].ToString();

               
            }
        }
    }
}