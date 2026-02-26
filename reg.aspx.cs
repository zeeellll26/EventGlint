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
    public partial class reg : System.Web.UI.Page
    {
        String strcon = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Register_Click(object sender, EventArgs e)
        {
            string email = txt_Email.Text;
            string user = txt_Username.Text;
            string password = txt_Password.Text;

            SqlConnection conn = new SqlConnection(strcon);
            if(user.Equals("") || email.Equals("") || password.Equals(""))
            {
                Response.Write("<script>alert('Please fill all the fields!!');</script>");
            }
            else
            {
                string ins = "INSERT INTO UserLogin(email,username,password) VALUES(@email,@user,@password)";

                SqlCommand cmd = new SqlCommand(ins, conn);

                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@user", user);
                cmd.Parameters.AddWithValue("@password", password);

                conn.Open();
                cmd.ExecuteNonQuery();
                Response.Write("<script>alert('You are registered successfully!!!');</script>");
                //Response.Redirect("Dashboard.aspx");
                conn.Close();
            }
        }
    }
}