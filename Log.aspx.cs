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
    public partial class Log : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            
            string user = txt_Username.Text;
            string password = txt_Password.Text;

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string qry = "SELECT COUNT(*) FROM UserLogin WHERE username=@user AND password=@password";

                SqlCommand cmd = new SqlCommand(qry, conn);

                cmd.Parameters.AddWithValue("@user", user);
                cmd.Parameters.AddWithValue ("@password", password);

                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                if(count == 1)
                {
                    Session["username"] = user;
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    lbl_Message.Text = "invalid username or password";
                    lbl_Message.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}