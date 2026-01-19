using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class Login : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            string email = txt_Email.Text.Trim();
            string pass = txt_Password.Text;

            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            String count = "SELECT COUNT(*) FROM UserLogin";
            SqlCommand cmd = new SqlCommand(count, con);

            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@pass", pass);

            int usercount = (int)cmd.ExecuteScalar();

            if(usercount > 0)
            {
                Session["UserEmail"] = email;
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                Response.Write("<script>alert('Invalid Email!');</script>");
            }

            //String query = "select email, password from UserLogin where email = 'mail' and password = 'pass' ";

            //SqlDataAdapter adpt = new SqlDataAdapter(query, con);

        }
    }
}