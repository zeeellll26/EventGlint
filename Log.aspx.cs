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

            using (SqlConnection con = new SqlConnection(strcon))
            {
                //Check User Table
                string qry = "SELECT COUNT(*) FROM Users WHERE Username=@user AND Password=@password";
                SqlCommand cmd = new SqlCommand(qry, con);
                cmd.Parameters.AddWithValue("@user", user);
                cmd.Parameters.AddWithValue ("@password", password);
                con.Open();
                int countUser = Convert.ToInt32(cmd.ExecuteScalar());
                if(countUser == 1)
                {
                    Session["Username"] = user;
                    Response.Redirect("Home.aspx");
                    return;
                }

                //Check Admin Table
                string qry2 = "SELECT COUNT(*) FROM Admins WHERE Username=@user AND Password=@password";
                SqlCommand cmd2 = new SqlCommand(qry2, con);
                cmd2.Parameters.AddWithValue("@user", user);
                cmd2.Parameters.AddWithValue("@password", password);
                int countAdmin = Convert.ToInt32(cmd2.ExecuteScalar());
                if(countAdmin == 1)
                {
                    Session["Username"] = user;
                    Response.Redirect("AdminPanel.aspx");
                    return;
                }
                lbl_Message.Text = "Invalid username or password.";
                con.Close();
            }
        }
    }
}